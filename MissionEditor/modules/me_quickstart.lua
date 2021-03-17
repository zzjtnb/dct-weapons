local base = _G

module('me_quickstart')

local require = base.require
local pairs = base.pairs
local ipairs = base.ipairs
local print = base.print

local ListBoxItem	    = require('ListBoxItem')
local Mission		    = require('me_mission')
local DialogLoader	    = require('DialogLoader')
local lfs			    = require('lfs')
local MsgWindow		    = require('MsgWindow')
local MeSettings	    = require('MeSettings')
local i18n			    = require('i18n')
local music			    = require('me_music')
local Gui			    = require('dxgui')
local SkinUtils		    = require('SkinUtils')
local UC			    = require('utils_common')
local TheatreOfWarData  = require('Mission.TheatreOfWarData')
local waitScreen		= require('me_wait_screen')
local CoalitionController = require('Mission.CoalitionController')
local progressBar 		= require('ProgressBarDialog')
local Analytics			= require("Analytics")  
local log      			= require('log')
local textutil 			= require('textutil')

i18n.setup(_M)

cdata = {
	quickStart = _('QUICK START'),
    warning = _('WARNING'),
    messageNoTerrain = _('Need terrain for load this mission: '),
    ok = _("OK"),
}



local curTerrain =  nil
local curDir = nil
local curDirMulty = nil
local curCLSID = nil
local presentModulesById = {}

local function loadMissions(a_fileName)
	planes = nil
	local env = {}
	env._ = _
	local f, err = base.loadfile(a_fileName)
	if f == nil then
		print(err)
	else
		base.setfenv(f, env)
		local ok, res = base.pcall(f)
		if not ok then
			log.error('ERROR: loadMissions() failed to pcall "'..a_fileName..'": '..res)
			return
		end

		if env == nil then
			print('Error loading ' .. a_fileName)
		else
			planes = env.planes
		end
	end
end

function fillTerrainList()	
    listboxTerrain:clear()
    
    for i, theatreOfWar in ipairs(CoalitionController.getTheatresOfWar()) do       
        local item = ListBoxItem.new(theatreOfWar.localizedName)
		item.theatreOfWar = theatreOfWar
		item.name = theatreOfWar.name
        item:setSkin(listBoxModulItemSkin)
		listboxTerrain:insertItem(item)
        
        local plugin
        for k, pl in pairs(base.plugins) do
            if pl.id == theatreOfWar.name then
                plugin = pl
            end
        end
        
        if plugin then
            pathPl = nil
            if plugin.Skins then
                for pluginSkinName, pluginSkin in pairs(plugin.Skins) do	
                    pathPl = plugin.dirName.."/"..pluginSkin.dir                    
                end 
            end
            
            if pathPl then
                local listBoxItemSkin = item:getSkin()
                local filename = pathPl..'\\icon-38x38.png'
                
                if lfs.attributes(filename)	== nil then
                    filename = 'dxgui\\skins\\skinME\\images\\default-38x38.png'
                end
                
                SkinUtils.setListBoxItemPicture(filename, listBoxItemSkin)
                item:setSkin(listBoxItemSkin)
            end
        end
	end
end

function fillModulesList()	
    listModuls:clear()
	presentModulesById = {}
	
	local pathPl 
    
    local locale = i18n.getLocale()

	local tmpPlugins 
	for index, plugin in pairs(base.plugins) do		
		tmpPlugins = tmpPlugins or {}
		base.table.insert(tmpPlugins,plugin) 
	end
	
	if tmpPlugins then
		base.table.sort(tmpPlugins, base.U.compTableShortName)
		for index, plugin in ipairs(tmpPlugins) do
			if plugin.Skins ~= nil and plugin.applied == true then
				local misPath = nil
				----------------
				local pluginMissions = plugin.Missions
				if pluginMissions and base.type(pluginMissions) == "table" then
					for missionName, mission in pairs(pluginMissions) do
						local name = plugin.order .. missionName
						local dirMulty = plugin.dirName.."/Missions/quickStart"
						local misPathMulty = nil
						local a, err = lfs.attributes(dirMulty)
						if a and (a.mode == 'directory') then
							misPathMulty = dirMulty
						end
						
						local dir = plugin.dirName.."/Missions/"..locale.."/quickStart"
						local dirEN = plugin.dirName.."/Missions/EN/quickStart"
						local a, err 		= lfs.attributes(dir)
						local aEN, errEN 	= lfs.attributes(dirEN)
						if a and (a.mode == 'directory') then
							misPath = dir
						else
							if aEN and (aEN.mode == 'directory') then
								misPath = dirEN
							end
						end  

						if misPath or misPathMulty then
							pathPl = nil
							for pluginSkinName, pluginSkin in pairs(plugin.Skins) do	
									pathPl = plugin.dirName.."/"..pluginSkin.dir                    
							end 
							local listBoxItem = ListBoxItem.new(_(plugin.shortName))  
							if misPath then    
								listBoxItem.dir = base.string.gsub(misPath, '/', '\\')
							end    
							if misPathMulty then
								listBoxItem.dirMulty = base.string.gsub(misPathMulty, '/', '\\')
							end
							listBoxItem.CLSID = name
							listBoxItem:setSkin(listBoxModulItemSkin)
							if pathPl then
								local listBoxItemSkin = listBoxItem:getSkin()
								local filename = pathPl..'\\icon-38x38.png'
								
								if lfs.attributes(filename)	== nil then
									filename = 'dxgui\\skins\\skinME\\images\\default-38x38.png'
								end
								
								SkinUtils.setListBoxItemPicture(filename, listBoxItemSkin)
								listBoxItem:setSkin(listBoxItemSkin)
							end
							
							presentModulesById[plugin.id] = listBoxItem.CLSID
							listModuls:insertItem(listBoxItem)
							listModuls:setItemVisible(listBoxItem)
						end 
					end
				end          
			end    
		end  
	end	
end

function onChange_listboxTerrain(self, item)
    if item then
        curTerrain = item.name      
        updateList()
    end
end

function onChange_ListModuls(self, item)
    if item then
        curDir = item.dir 
        curDirMulty = item.dirMulty
        curCLSID = item.CLSID
        updateList()
    end
end

function create()
	window = DialogLoader.spawnDialogFromFile("MissionEditor/modules/dialogs/me_quickstart_dialog.dlg", cdata)
	window:addHotKeyCallback('escape', onChangeClose)

    pCenter = window.pBox.pCenter
	listboxQMissions = pCenter.listboxQMissions
	listboxQMissions.onItemMouseUp = onChangelistboxQMissions
    
    listboxTerrain = pCenter.listboxTerrain
    listboxTerrain.onChange = onChange_listboxTerrain
    
    bClose = window.pBox.bClose
    bClose.onChange = onChangeClose
    
    listBoxModulItemSkin = pCenter.listBoxModulItem:getSkin()
    listModuls = pCenter.listModuls
    listModuls.onChange = onChange_ListModuls
    
    local w, h = Gui.GetWindowSize()
    window:setBounds(0, 0, w, h)
    boxW, boxH = window.pBox:getSize()
    window.pBox:setBounds((w - boxW)/2, (h - boxH)/2, boxW, boxH)

    fillModulesList()
    fillTerrainList()
end


function updateList()
    listboxQMissions:clear()
    planeIndex = 1
    
    if curDir then
        local fileName 	= curDir..'/quickstart.lua'
        loadMissions(fileName)       
        fillPlanes(curDir, planeIndex)
    end
    if curDirMulty then
        local fileName 	= curDirMulty..'/quickstart.lua'
        loadMissions(fileName)        
        fillPlanes(curDirMulty, planeIndex)
    end
end

function onChangeClose(self)
    window:setVisible(false)
	base.mmw.show(true) -- ������ ��� ����������
end

function onChangelistboxQMissions(self)
	local item = listboxQMissions:getSelectedItem()

	if (item == nil) then
		return
	end

	local id = item.planeIndex
	local localeDir = item.dir

	local missionName = localeDir..'/' .. item.file
	local params = { file = missionName, command = "--mission" }
    
	local attr = lfs.attributes(params.file)
	if attr and attr.mode == 'file' then
		window:setVisible(false)
		progressBar.setUpdateFunction(function()
			MeSettings.setQuickStartClsid(curCLSID)
			Mission.mission = Mission.mission or {}

			local result, err, theatre = Mission.load(params.file, true)
			--print("----result onButtonOpen=",result, err, theatre)
			if result == true then
				Mission.mission.path = params.file
				music.stop() 
				Mission.play(params, 'quickstart', params.file, nil, true)
			else
				window:setVisible(true)
				-- �� ����������� ������������� ����������� ��������� ����
				if err == "no terrain" then
					MsgWindow.warning(cdata.messageNoTerrain..theatre, cdata.warning, cdata.ok):show()
				else
					MsgWindow.warning(err, cdata.warning, cdata.ok):show()
				end    
			end
		end)
	else
		MsgWindow.warning(_("Mission file not found "..params.file), _('WARNING'), 'OK'):show()
	end
end

function show(a_selectModId)
	if a_selectModId then
		curCLSID = presentModulesById[a_selectModId]
	end
	
	Analytics.pageview(Analytics.InstantAction)
	
	selectQuickstart()
	window:centerWindow()
	window:setVisible(true)
end

function isPresentModule(a_selectModId)
	return presentModulesById[a_selectModId] ~= nil
end

function selectQuickstart()
	if curCLSID == nil then
		curCLSID = MeSettings.getQuickStartClsid()
	end
    
    if curTerrain == nil then
		curTerrain = MeSettings.getQuickStartTerrain()
	end

	local firstQuickstartData = nil
	local data = {}
    
    local firstModulItem = nil
    local curModulItem = nil
    local firstTerrainItem = nil
    local curTerrainItem = nil

    for i=0,listModuls:getItemCount()-1 do
        local item = listModuls:getItem(i)
        if item then
            if firstModulItem == nil then
                firstModulItem = item
            end

            if (item.CLSID == curCLSID) then
                curModulItem = item
            end
        end
	end
    
    for i=0,listboxTerrain:getItemCount()-1 do
        local item = listboxTerrain:getItem(i)
        if item then
            if firstTerrainItem == nil then
                firstTerrainItem = item
            end

            if (item.name == curTerrain) then
                curTerrainItem = item
            end
        end
	end

    if curModulItem == nil then
        curModulItem = firstModulItem
    end

    if curTerrainItem == nil then
        curTerrainItem = firstTerrainItem
    end

    if curModulItem then
        listModuls:selectItem(curModulItem)
        listModuls:setItemVisible(curModulItem)
        curDir = curModulItem.dir
        curDirMulty = curModulItem.dirMulty
    end
    
    if curTerrainItem then
        listboxTerrain:selectItem(curTerrainItem)
        listboxTerrain:setItemVisible(curTerrainItem)
        curTerrain = curTerrainItem.name
    end
    
	updateList()
end

function fillPlanes(a_dir,planeIndex)
	if planes then
		for i,planeInfo in ipairs(planes) do   
			local data = UC.getMissionData(a_dir.."\\"..planeInfo.file, i18n.getLocale())
			if data ~= nil then 
				local theatreName, sortie = data.theatreName, data.sortie

				if sortie == "" then
					sortie = planeInfo.file
				end
		
				if TheatreOfWarData.isEnableTheatre(theatreName) == true
					and theatreName == curTerrain then                
					local item = ListBoxItem.new(planeInfo.name)
					planeInfo.item = item
					item.planeIndex = planeIndex
					item.dir = a_dir
					item.data = data
					item.file = planeInfo.file
					item:setText(planeInfo.name or sortie)
					listboxQMissions:insertItem(item)
					planeIndex = planeIndex + 1
				end
			end	
		end
	end
end
