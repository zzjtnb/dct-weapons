local base = _G

module('me_bullseye')

local require = base.require

-- ������ LuaGUI
local loader				= require('DialogLoader')
local mod_mission			= require('me_mission')
local MapWindow				= require('me_map_window')
local U						= require('me_utilities')	-- ������� �������� ������� ��������
local ListBoxItem			= require('ListBoxItem')
local CoalitionController	= require('Mission.CoalitionController')
local CoalitionUtils		= require('Mission.CoalitionUtils')

base.require('i18n').setup(_M)

-------------------------------------------------------------------------------
--
function initModule()
    -- ���������� �����������/����������� ������ 
    vdata =
    {
		coalition   = 'red',
		coordX = 0,
		coordY = 0,
    }
end;

-------------------------------------------------------------------------------
-- �������� � ���������� ��������
-- �������� �������� ��������: t - text, b - button, c - combo, sp - spin, sl - slider, e - edit, d - dial 
function create(x, y, w, h)
    local localization = {
        title 		= _('BULLSEYE OBJECT'),
		coalition	= _('coalition'),
		coordX		= _('COORD X'),
		coordY		= _('COORD Y'),
		long 		= _('LONG'),
        lat 		= _('LAT'),			
    }
	
	window = loader.spawnDialogFromFile('MissionEditor/modules/dialogs/me_bullseye.dlg', localization)
    window:setBounds(x, y, w, h)
	
	w_ = w
	
	function window:onClose()
        MapWindow.setState(MapWindow.getPanState())
        show(false)
        base.toolbar.setStaticButtonState(false)
        base.panel_units_list.show(false);
        MapWindow.unselectAll();
		MapWindow.expand()	
    end
	
    c_caol = window.c_caol
	
	local coalitionNames = {
		CoalitionController.blueCoalitionName(),
		CoalitionController.redCoalitionName(),
	}
	if base.test_addNeutralCoalition == true then  
		base.table.insert(coalitionNames, CoalitionController.neutralCoalitionName())
	end
	
	CoalitionUtils.fillComboListCoalition(c_caol, coalitionNames, function(coalitionName)
		vdata.coalition = coalitionName
		update()
		
		MapWindow.selectBullseye(coalitionName)		
	end)

	---------------------------------------------------------------------------
	tt_long = window.tt_long
    tt_lat = window.tt_lat	
end


-------------------------------------------------------------------------------
-- ��������/�������� ������
function show(b, a_coal)
	if b then
		if window:getVisible() == false then
			MapWindow.collapse(w_, 0)
		end
		update()  
	elseif window:getVisible() == true then
		MapWindow.expand()
	end

    window:setVisible(b)
end


-------------------------------------------------------------------------------
--
function update()
    if vdata.coalition then
		vdata.coordX = mod_mission.mission.bullseye[vdata.coalition].x
		vdata.coordY = mod_mission.mission.bullseye[vdata.coalition].y
		
		CoalitionUtils.setComboListCoalition(c_caol, vdata.coalition)
	end
	
	if (e_coordX) then
		e_coordX:setText(vdata.coordX)
	end
	if (e_coordX) then
		e_coordY:setText(vdata.coordY)
	end
	
	-- ���������� lat, long � ��������
	local lat, long = MapWindow.convertMetersToLatLon(vdata.coordX, vdata.coordY)

    tt_lat:setText(U.getLatitudeString(U.toRadians(lat)))
    tt_long:setText(U.getLongitudeString(U.toRadians(long)))
end

-------------------------------------------------------------------------------
--
function setCameraToBullseye()
	MapWindow.setCamera(vdata.coordX, vdata.coordY)
end

initModule()
