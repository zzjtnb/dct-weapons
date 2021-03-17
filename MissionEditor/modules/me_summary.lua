local base = _G

module('me_summary')

local require = base.require
local tostring = base.tostring
local math = base.math
local ipairs = base.ipairs

-- ������ LuaGUI
local DialogLoader		= require('DialogLoader')
local U					= require('me_utilities')	-- ������� �������� ������� ��������
local OptionsData		= require('Options.Data')
local module_mission	= require('me_mission')

require('i18n').setup(_M)

cdata = 
{
    start_time = _('START TIME'),
    route_time = _('ROUTE TIME'),
    dist = _('ROUTE LENGTH'),
    speed = _('AVERAGE SPEED'),
    range = _('RANGE'),
    m = _('m'),
    km_h = _('km/h'),
}

-- ���������� �����������/����������� ������ 
vdata =
{
    -- ����� ������ ������.
    start_time = 0,
    dd = 1,
    hh = 0,
    mm = 0,
    ss = 0,
    -- ����� �� ����� ������, � ������������ ����������� ��������.
    eta = 0,
    -- ����� ��������.
    dist = 0,
    -- ������� �������� �� ��������.
    speed = 0,
}

local function updateUnitSystem()
	local unitSystem = OptionsData.getUnits()
	
	speedUnitEditBox:setUnitSystem(unitSystem)
    distUnitEditBox:setUnitSystem(unitSystem)
end

local function getTimeString()
    return tostring(vdata.hh)..':'..tostring(vdata.mm)..':'..tostring(vdata.ss)..'/'..tostring(vdata.dd)
end

local function extractTime(timeValue)
    local floor = math.floor
    local fmod = math.fmod
    local seconds = floor(fmod(timeValue, 60))
    local minutes = floor(fmod((timeValue - seconds)/60, 60))
    local hours = floor(fmod((timeValue - minutes * 60 - seconds) / 3600, 24))
    local days = floor((timeValue - hours*3600 - minutes*60 - seconds) / (3600 * 24)) + 1
    
    return seconds, minutes, hours, days
end

function create(x, y, w, h)
    window = DialogLoader.spawnDialogFromFile("MissionEditor/modules/dialogs/me_summary_panel.dlg", cdata)
    window:setBounds(x, y, w, h)
    
    box = window.box

    local t = getTimeString()
    
    w_start_time = box.w_start_time
    w_start_time:setText(t)

    w_time = box.w_time
    w_time:setText(t)

    w_dist = box.w_dist
    w_dist:setText(vdata.dist)
    distUnitEditBox = U.createUnitEditBoxWriteOnly(w_dist, U.distanceUnits)
            
    w_speed = box.w_speed
    w_speed:setText(vdata.speed)
    speedUnitEditBox = U.createUnitEditBoxWriteOnly(w_speed, U.speedUnits)          
        
    -- ���������� �������� ���������� �������� �� ������� vdata
    update()
end

-- ��������/�������� ������
function show(b)
    if b then
        updateUnitSystem()
        update()
    end
    
    window:setVisible(b)
end

-- ���������� �������� ������� ������ ������
function updateStartTime()
	if vdata.group then
		if vdata.group.lateActivation then
			w_start_time:setText('??:??:??:??')
			return;
		else
			vdata.start_time = (not vdata.group.lateActivation) and math.floor(vdata.group.start_time + module_mission.mission.start_time + 0.5) or 0.0
                
			vdata.ss, vdata.mm, vdata.hh, vdata.dd = extractTime(vdata.start_time)
		end
    end
    
    w_start_time:setText(getTimeString())
end

-- ���������� �������� �������� ����� ��������� ������� vdata
function update()
    updateStartTime();
    vdata.eta = math.floor(get_route_time() + 0.5)
    vdata.ss, vdata.mm, vdata.hh, vdata.dd = extractTime(vdata.eta)
    
    w_time:setText(getTimeString())
    vdata.dist = math.floor(get_route_length() + 0.5)
    distUnitEditBox:setValue(vdata.dist)
    vdata.speed = math.floor(get_average_speed() + 0.5)
    speedUnitEditBox:setValue(vdata.speed / 3.6)
end

-- ��������� ����� ��������� �������� ���������� ������������ ��� �� ��������.
function get_route_length()
    if not vdata.group then
        return 0
    end
    if not vdata.group.route.dist then
        vdata.group.route.dist = 0
    end
    return vdata.group.route.dist
end

-- ����� ���������� ����� ����������� ������� �������� � ������� �������.
function get_route_time()
    local t = 0
    
    if vdata.group then
        local groupRoute = vdata.group.route
        local lengths = groupRoute.len
        
        if lengths then
            local points = groupRoute.points
            
            for i, length in ipairs(lengths) do
                if points[i+1] then
                    local speed = points[i+1].speed
                    
                    if speed > 0 then
                        t = t + length/speed
                    end
                end
            end
        end
    end
    
    return t
end

function get_average_speed()
    if vdata.eta > 0 then
        -- �������� ����� ��������� �� �/� � ��/�
        return 3.6*vdata.dist/vdata.eta
    else
        return 0
    end
end

