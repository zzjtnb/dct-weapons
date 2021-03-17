local base = _G

module('me_copy_paste')

local Mission           		= base.require('me_mission')
local MapWindow         		= base.require('me_map_window')
local mod_dictionary    		= base.require('dictionary')
local MsgWindow					= base.require('MsgWindow')
local i18n 						= base.require('i18n')
local crutches 					= base.require('me_crutches')
local panel_fix_points			= base.require('me_fix_points')
local actionDB					= base.require('me_action_db')
local panel_aircraft			= base.require('me_aircraft')
local panel_route 				= base.require('me_route')
local panel_ship        		= base.require('me_ship')
local MapController				= base.require('Mission.MapController')
local TriggerZoneController		= base.require('Mission.TriggerZoneController')
local TriggerZoneData			= base.require('Mission.TriggerZoneData')
local MissionData				= base.require('Mission.Data')
local NavigationPointController	= base.require('Mission.NavigationPointController')

i18n.setup(_M)

local groups_copied = {}
local triggerZones_copied = {}
local navigationPoint_copied = {}
local startPoint = {x=0, y=0}
local typeOfCopiedObjects = "groups" --"triggerZones"

function setupKeyboard(a_window)  
    if firstSetup == nil then
        a_window:addHotKeyCallback('Ctrl+C', onEditCopy)
        a_window:addHotKeyCallback('Ctrl+V', onEditPaste)
        a_window:addHotKeyCallback('Ctrl+X', onEditCut)
        firstSetup = true;
    end
end
    
function onEditCopy()
    
    local groups
    groups, startPoint.x, startPoint.y = MapWindow.getSelectedGroups()  

	triggerZones_copied = {}
	groups_copied = {}	
    if (startPoint.x == nil or startPoint.y == nil) then
		local objectId = MapController.getSelectedObjectId()
		local objectType = MissionData.getObjectType(objectId)

		if MissionData.navigationPointType() == objectType then
			typeOfCopiedObjects = "navigationPoint"			
			base.U.recursiveCopyTable(navigationPoint_copied, NavigationPointController.getNavigationPoint(objectId))
			
			startPoint.x = navigationPoint_copied.x
			startPoint.y = navigationPoint_copied.y
			
		elseif MissionData.triggerZoneType() == objectType then
			typeOfCopiedObjects = "triggerZones"
			base.U.recursiveCopyTable(triggerZones_copied, TriggerZoneController.getTriggerZone(objectId))
			
			startPoint.x = triggerZones_copied.x
			startPoint.y = triggerZones_copied.y		
		end
        return
    end

	typeOfCopiedObjects = "groups"     
    for k,v in base.pairs(groups) do
        groups_copied[k] = {}
		base.U.recursiveCopyTable(groups_copied[k], Mission.getGroup(v))
	end    
end

function clear()
	groups_copied = {}
	triggerZones_copied = {}
	navigationPoint_copied = {}
end

function onEditPaste()
	--base.print("----onEditPaste()-----")
    if (startPoint.x == nil or startPoint.y == nil) then
        return
    end
    mx = MapWindow.MOUSE_STATE.x
	my = MapWindow.MOUSE_STATE.y
    local mapX, mapY = base.me_map_window.getMapPoint(mx,my)
    
    local diffX, diffY
    diffX = mapX - startPoint.x
    diffY = mapY - startPoint.y
	
	if typeOfCopiedObjects == "groups" then
		local newGroups = {}		
		for k, group in base.pairs(groups_copied) do
			newGroups[k] = duplicateGroup(diffX, diffY, group)
			if group.uncontrolled then
				local bBotUnits = false
				for k,v in base.pairs(newGroups[k].units) do
					if v.skill ~= crutches.getPlayerSkill() and v.skill ~= crutches.getClientSkill() then
						bBotUnits = true
					end
				end

				newGroups[k].uncontrolled = (bBotUnits == true and newGroups[k].route.points[1].type.type == panel_route.actions.takeoffParking.type)
			end	

			if newGroups[k] then
				selectGroup(newGroups[k])
			end
		end
	elseif typeOfCopiedObjects == "triggerZones" then
		if triggerZones_copied and triggerZones_copied.radius ~= nil then
			local triggerZoneId = MapController.createTriggerZone(mapX, mapY)
			TriggerZoneController.selectTriggerZone(triggerZoneId)
			
			TriggerZoneData.setTriggerZoneRadius(triggerZoneId, triggerZones_copied.radius)
			TriggerZoneData.setTriggerZoneName(triggerZoneId, triggerZones_copied.name)
			TriggerZoneData.setTriggerZoneColor(triggerZoneId, 
				triggerZones_copied.red, triggerZones_copied.green, 
				triggerZones_copied.blue, triggerZones_copied.alpha)
			TriggerZoneData.setTriggerZoneProperties(triggerZoneId, triggerZones_copied.properties)
		end
	elseif typeOfCopiedObjects == "navigationPoint"	then
		if navigationPoint_copied and navigationPoint_copied.coalitionName then
			
			local navigationPointId = NavigationPointController.addNavigationPoint(navigationPoint_copied.name, navigationPoint_copied.coalitionName, mapX, mapY)

			NavigationPointController.setNavigationPointCallsign(navigationPointId, navigationPoint_copied.callsign)
			NavigationPointController.setNavigationPointDescription(navigationPointId, navigationPoint_copied.description)
			NavigationPointController.setNavigationPointScale(navigationPointId, navigationPoint_copied.scale)
			NavigationPointController.setNavigationPointSteer(navigationPointId, navigationPoint_copied.steer)
			NavigationPointController.setNavigationPointVnav(navigationPointId, navigationPoint_copied.vnav)
			NavigationPointController.setNavigationPointVangle(navigationPointId, navigationPoint_copied.vangle)
			NavigationPointController.setNavigationPointAngle(navigationPointId, navigationPoint_copied.angle)
			
			MapController.selectObject(navigationPointId)
			NavigationPointController.selectNavigationPoint(navigationPointId)
		end	
	end
end

function selectGroup(group, a_unit)
    local mapObject
    
    local selectedUnit = a_unit or group.units[1]
	
    if group.mapObjects.route then
        mapObject = group.mapObjects.route.points[1]
    else
        mapObject = group.mapObjects.units[1].userObject
        mapObject.userObject = group.mapObjects.units[1].userObject
    end
    
    local unit = group.mapObjects.units[selectedUnit.index].userObject
    
    MapWindow.unselectAll()

    MapWindow.respondToSelectedUnit(mapObject, group, selectedUnit)
	if a_unit == nil or a_unit.index == 1 then
		MapWindow.updateSelectedGroup(group)
    end
    panel_route.update()
end

function onEditCut()
    onEditCopy()    
    
	if typeOfCopiedObjects == "groups" then	
		local groups = MapWindow.getSelectedGroups()
		
		for k,v in base.pairs(groups) do		
			MapWindow.setState(MapWindow.getPanState())
			MapWindow.selectedGroup = nil;
			base.panel_units_list.saveSelection();
			Mission.remove_group(Mission.getGroup(v))
			panel_route.setGroup(nil)
			base.toolbar.untoggle_all_except()
		end 
	elseif typeOfCopiedObjects == "navigationPoint" then
		MapController.onDeleteNavigationPoint(navigationPoint_copied.id)
		base.toolbar.untoggle_all_except()
	elseif typeOfCopiedObjects == "triggerZones" then
		MapController.onDeleteTriggerZone(triggerZones_copied.id)
		base.toolbar.untoggle_all_except()
	end
end

function duplicateGroup(a_diffX, a_diffY, a_group)
    local group = {}
    base.U.recursiveCopyTable(group, a_group)
	
	for k,v in base.pairs(group.units) do
		v.dataCartridge = nil
	end
	
	for k,unit in base.pairs(group.units) do
		if not MapWindow.checkSurfaceUnit(unit, unit.x + a_diffX, unit.y + a_diffY) then
			MsgWindow.warning(_('Failed to copy the object: ')..group.name,  _('WARNING'), 'OK'):show()
			return
		end
	end
	   
    local country = Mission.missionCountry[group.boss.name]
    
    for k,v in base.pairs(group.route.points) do
        v.x = v.x + a_diffX
        v.y = v.y + a_diffY       
        
        v.boss = group
        v.targets = {}        
    end  
	
    if (a_group.route.spans) then
        Mission.generateSpans(group.route)
    end 
    
    mod_dictionary.fixDict(group, 'name', group.name, "GroupName")     
    group.name = Mission.check_group_name(group.name)   
    Mission.group_by_name[group.name] = group    
    group.groupId = Mission.getNewGroupId()
    Mission.group_by_id[group.groupId] = group
    
    group.boss = country
    
    group.x = group.x + a_diffX
	group.y = group.y + a_diffY    
        
    for k,v in base.pairs(group.units) do
        v.x = v.x + a_diffX
        v.y = v.y + a_diffY 
        v.boss = group
        mod_dictionary.fixDict(v, 'name', v.name, "UnitName") 
        v.name = Mission.getUnitName(group.name) --Mission.check_unit_name(v.name)
		v.parking = nil
        v.parking_landing = nil
        v.parking_id = nil
        v.parking_landing_id = nil
        Mission.unit_by_name[v.name] = v
        v.unitId = Mission.getNewUnitId()
		v.linkChildren = nil
        Mission.unit_by_id[v.unitId] = v  
        if (v.type == 'plane' or v.type == 'helicopter') then
            v.onboard_num = base.panel_aircraft.getNewOnboard_num(v)
            v.callsign = base.panel_aircraft.getNewCallsign(v);   
        end
		
		if v.skill == crutches.getPlayerSkill() then
			v.skill = crutches.getClientSkill()
		end
    end
	
    for k,v in base.pairs(group.route.points) do
        mod_dictionary.fixDict(v, 'name', v.name, "WptName") 
    end
         
    group.mapObjects = {units = {}, zones = {}, route = {}}

    Mission.create_group_objects(group)
    base.table.insert(country[group.type].group, group)
    Mission.create_group_map_objects(group);
	local tmp_linkOffset = group.linkOffset
	if group.route.points[1].linkUnit then
		local unitP = Mission.unit_by_id[group.route.points[1].linkUnit.unitId]	
		Mission.unlinkWaypoint(group.route.points[1])
		if unitP then
			Mission.linkWaypoint(group.route.points[1], unitP.boss, unitP)
			group.linkOffset = tmp_linkOffset
		end
	end
	
	for k,wpt in base.pairs(group.route.points) do
		if base.panel_route.isAirfieldWaypoint(wpt.type) then
			wpt.airdromeId = nil
			base.panel_route.attractToAirfield(wpt, group)
		end	
	end
		
	if a_group.INUFixPoints then
		group.INUFixPoints = {}
		group.mapObjects.INUFixPoints = {}
		group.mapObjects.INUFixPoints_numbers  = {}

--[[		for k,v in base.pairs(a_group.INUFixPoints) do
			local pt = Mission.insert_INUFixPoint(group, v.x, v.y, group.boss.boss.selectGroupColor)
			panel_fix_points.vdata.selectedPoint = pt
			panel_fix_points.update()
			base.print("---pt--",pt.boss)
		end]]
	end
	
	if a_group.NavTargetPoints then
		group.NavTargetPoints = {}
		group.mapObjects.NavTargetPoints = {}
		group.mapObjects.NavTargetPoints_numbers = {}
		group.mapObjects.NavTargetPoints_comments = {}
	end
	
	-- меняем в задаче 'EPLRS' groupId на новый (groupId - с id группы никак не связан)
	for wptIndex, wpt in base.pairs(group.route.points) do
		if wpt.task then
			for taskIndex, task in base.pairs(wpt.task.params.tasks) do
				if task.id == 'WrappedAction' then
					local action = task.params.action
					if action.id == 'EPLRS' then
						local tblGroupIdForEPLRS = actionDB.getNewTblGroupIdForEPLRS(group)
						action.params.groupId = tblGroupIdForEPLRS.groupId
					end
				end
			end
		end
	end

	if group.type == 'ship' then
		panel_ship.validateWayPoints(group)
	end
	
    Mission.update_group_map_objects(group) 
    base.panel_units_list.update()
	
	return group
end

function getGroupsCopied()
	return groups_copied
end
