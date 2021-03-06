local base = _G

module('utils_common')

local type          = base.type
local require       = base.require
local print         = base.print
local assert        = base.assert
local tostring      = base.tostring
local pairs         = base.pairs
local ipairs        = base.ipairs
local tonumber      = base.tonumber
local table         = base.table
local math          = base.math
local string        = base.string
local clock         = base.os.clock

local gettext       = require('i_18n')
local dllWeather 	= require('Weather')
local minizip       = require('minizip')
local lfs       	= require('lfs')
local mod_dictionary= require('dictionary')

local mdcVersion = 1

local function _(text) 
	return gettext.translate(text) 
end

local cdata =
{
    speed_unit = _('m/s'),
    wind_at_ground = _('At GRND'),
    wind_at_2000 = _('At 2000m'),
    wind_at_8000 = _('At 8000m'),
}

local missionTheatreCache
local missionTheatreCacheChanged = false
local missionTheatreCacheFilename = 'MissionEditor/MissionTheatreCache.lua'

local missionDataCache
local missionDataCacheChanged = false
local missionDataCacheFilename = 'MissionEditor/MissionDataCache.lua'

function sleep(n)  -- mseconds только для небольших интервалов
  local t0 = clock()*1000
  while clock()*1000 - t0 <= n do end
end

function toDegrees(radians, raw)
  local degrees = radians * 180 / math.pi
  
  if not raw then
    degrees = math.floor(degrees + 0.5)
  end
  
  return degrees
end

function toRadians(degrees, raw)
  local radians = degrees * math.pi / 180  
  
  if not raw then
    radians = math.floor(radians + 0.5)
  end
  
  return radians
end

function toPositiveDegrees(radians, raw)
  local degrees = toDegrees(radians, raw)
  
  if degrees < 0 then
    degrees = degrees + 360
  end
  
  return degrees
end

-------------------------------------------------------------------------------
-- convert wind structure to wind string
function windToStr(wind)
    local str = string.format("%0.1d %s", wind.speed, cdata.speed_unit)
    if 0 < wind.speed then
        str = string.format("%s, %0.2d°", str, wind.dir)
    end
    return str
end

-------------------------------------------------------------------------------
-- формирование массива строк с данными о турбулентности
function composeTurbulenceString(a_weather)
	if not a_weather then 
		return {'0'}
	end
    if  a_weather.turbulence then
        local t = a_weather.turbulence
        local turbulence = {}
        turbulence[1] = math.floor(t.atGround + 0.5)/10 .. ' ' .. cdata.speed_unit 
        return turbulence
    else
        local turbulence = {}
        turbulence[1] = math.floor(a_weather.groundTurbulence + 0.5)/10 .. ' ' .. cdata.speed_unit 
        return turbulence
    end    
end

-------------------------------------------------------------------------------
-- формирование массива строк с данными о ветре
function composeWindString(a_weather, a_humanPosition)
    if not a_weather then 
		return {'0','0','0'}
	end
	
	local wind = {}
	dllWeather.initAtmospere(a_weather)		
 
    if a_weather.atmosphere_type == 0 then
        local w = a_weather.wind        
        wind[1] = cdata.wind_at_ground .. ' ' .. windToStr(w.atGround)
        wind[2] = cdata.wind_at_2000 .. ' ' .. windToStr(w.at2000)
        wind[3] = cdata.wind_at_8000 .. ' ' .. windToStr(w.at8000)
    else
       local res = dllWeather.getGroundWindAtPoint({position = a_humanPosition or {x=0, y=0, z=0}})    
        wind[1] = cdata.wind_at_ground .. ' ' ..windToStr({speed=res.v, dir = toPositiveDegrees(res.a+math.pi)}) 
    end
    return wind
end

function loadMissionTheatreCache()
	if not missionTheatreCache then
		local f, err = base.loadfile(lfs.writedir() .. missionTheatreCacheFilename)

		if f then
			missionTheatreCache = f()
		else
			missionTheatreCache = {}
		end		
	end
	
	if not missionDataCache then
		local f, err = base.loadfile(lfs.writedir() .. missionDataCacheFilename)

		if f then
			missionDataCache = f()
			if missionDataCache.version == nil or missionDataCache.version < mdcVersion then
				missionDataCache = {}
			end
		else
			missionDataCache = {}
		end		
	end
end

function saveMissionTheatreCache()
	if missionTheatreCacheChanged then
		local Serializer = require('Serializer')
		local file, err = base.io.open(lfs.writedir() .. missionTheatreCacheFilename, 'w')
		
		if file then
			local serializer = Serializer.new(file)
			
			file:write('local ')
			serializer:serialize_sorted('missionTheatreCache', missionTheatreCache)
			file:write('return missionTheatreCache\n')
			
			file:close()
		else
			print(err)
		end
	end
	
	if missionDataCacheChanged then
		local Serializer = require('Serializer')
		local file, err = base.io.open(lfs.writedir() .. missionDataCacheFilename, 'w')
		missionDataCache.version = mdcVersion
		
		if file then
			local serializer = Serializer.new(file)
			
			file:write('local ')
			serializer:serialize_sorted('missionDataCache', missionDataCache)
			file:write('return missionDataCache\n')
			
			file:close()
		else
			print(err)
		end
	end
end

local function addToMissionTheatreCache(filename, theatre, modification)
	missionTheatreCache[filename] = {theatre = theatre, modification = modification}
	missionTheatreCacheChanged		= true
end

local function addToMissionDataCache(filename, data, modification, a_locale)
	missionDataCache[filename] = missionDataCache[filename] or {}
	missionDataCache[filename][a_locale] = {data = data, modification = modification}
	missionDataCacheChanged		= true
end


-------------------------------------------------------------------------------
-- получение театра из миссии
function getNameTheatre(a_fileName)
--print("---getNameTheatre--",a_fileName)	
	local data			= missionTheatreCache[a_fileName]
	local attributes	= lfs.attributes(a_fileName)
	
	if data then	
		if data.modification == attributes.modification then
			return data.theatre
		end		
	end
    
    local zipFile = minizip.unzOpen(a_fileName, 'rb')
	
    if not zipFile then
        return ''
    end
	
    local misStr
	
    if zipFile:unzLocateFile('theatre') then
        misStr = zipFile:unzReadAllCurrentFile(true) -- true- чтобы не вызывало падения при битом файле
		
		if misStr then
			zipFile:unzClose()
			
			addToMissionTheatreCache(a_fileName, misStr, attributes.modification)
			 
			return misStr
		end
    end	

    if zipFile:unzLocateFile('mission') then
        misStr = zipFile:unzReadAllCurrentFile(true) -- true- чтобы не вызывало падения при битом файле
		
		if misStr == nil then
			print("--ERROR getNameTheatre, zipFile:unzReadAllCurrentFile:", a_fileName)
			return ''
		end
    end

    local funD = base.loadstring(misStr or "")
    local envD = { }
    if funD then
        base.setfenv(funD, envD)
    else
        print("--ERROR getNameTheatre, funD==nil",a_fileName)
        return " "
    end
    
    status, err = base.pcall(funD)
	
    if not status then 
        print("--ERROR getNameTheatre, err=",status, err)
        return " "
    end

    local mission = envD.mission
    local theatre
    
    if mission then
        theatre = mission.theatre
    end    
    
    zipFile:unzClose()
	
	addToMissionTheatreCache(a_fileName, theatre or 'Caucasus', attributes.modification)
	
    return theatre or 'Caucasus'
end

-------------------------------------------------------------------------------
-- получение данных из миссии
function getMissionData(a_fileName, a_locale)
	local missionData	= missionDataCache[a_fileName] and missionDataCache[a_fileName][a_locale]
	local attributes	= lfs.attributes(a_fileName)
	
	if attributes == nil then
		return nil
	end
	
	if missionData then	
		if missionData.modification == attributes.modification then
			return missionData.data
		end	
	else
		missionData = {}
	end
    
	local desc, requiredModules, task, theatreName, unitType, sortie = mod_dictionary.getMissionDescription(a_fileName, a_locale, false, true)
	missionData.data = {desc = desc, requiredModules = requiredModules, task = task, theatreName = theatreName, unitType = unitType, sortie = sortie}

	addToMissionDataCache(a_fileName, missionData.data, attributes.modification, a_locale)

    return missionData.data
end

function getExtension(a_fileName)
    local ext = nil
    local dotIdx = string.find(string.reverse(a_fileName), '%.')
    if dotIdx then
        ext = string.sub(a_fileName, -dotIdx+1)
    end
    return ext
end

function getNumDayInMounts()
	local NumDayInMounts =
	{
		31, --Январь
		28, --Февраль
		31,	--Март
		30,	--Апрель
		31,	--Май
		30,	--Июнь
		31,	--Июль
		31,	--Август
		30,	--Сентябрь
		31,	--Октябрь
		30,	--Ноябрь
		31	--Декабрь
	}
	return NumDayInMounts
end	