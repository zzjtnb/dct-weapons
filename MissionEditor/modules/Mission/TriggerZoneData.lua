local TriggerZone	= require('Mission.TriggerZone')

local controller_
local missionData_
local triggerZones_
local triggerZoneNameCounter_

local function setController(controller)
	controller_ = controller
end

local function setMissionData(missionData)
	missionData_ = missionData
end

local function onNewMission()
	triggerZones_	= {}
	triggerZoneNameCounter_ = 1
end

local function getTriggerZoneNameUnique(name, a_triggerZoneId)
	for i, triggerZone in ipairs(triggerZones_) do
		if triggerZone:getName() == name and a_triggerZoneId ~= triggerZone.id then
			return false
		end
	end
	
	return true
end

local function makeTriggerZoneNameUnique(a_name, a_triggerZoneId)
	local uniqueName = a_name
	local num = 0
	local baseName = uniqueName
  
	local dotIdx = string.find(string.reverse(uniqueName), '-')
	if dotIdx then
		baseName = string.sub(uniqueName, 0,-dotIdx-1)
	end
	
	triggerZoneNameCounter_ = 0
	while not getTriggerZoneNameUnique(uniqueName, a_triggerZoneId) do
		triggerZoneNameCounter_ = triggerZoneNameCounter_ + 1
		uniqueName = baseName ..'-' .. triggerZoneNameCounter_	
	end
	
	return uniqueName
end

local function createTriggerZone(name, x, y, radius, id, properties)
	local triggerZone = TriggerZone.new(makeTriggerZoneNameUnique(name), x, y, radius, id, properties)
	local triggerZoneId = triggerZone:getId()
	
	table.insert(triggerZones_, triggerZone)
	
	missionData_.registerTriggerZone(triggerZoneId)
	
	return triggerZone
end

local function addTriggerZone(name, x, y, radius, properties, color)
	local triggerZone = createTriggerZone(name, x, y, radius, id, properties)
	local triggerZoneId = triggerZone:getId()

	if color then
		triggerZone:setColor(color[1] , color[2], color[3], color[4])
	end
	
	if controller_ then
		controller_.triggerZoneAdded(triggerZoneId)
	end
	
	return triggerZoneId
end

local function removeTriggerZone(triggerZoneId)
	for i, triggerZone in ipairs(triggerZones_) do
		if triggerZone:getId() == triggerZoneId then	
			table.remove(triggerZones_, i)
			
			missionData_.unregisterTriggerZone(triggerZoneId)
			
			if controller_ then
				controller_.triggerZoneRemoved(triggerZoneId)
			end
			
			break
		end
	end
end

local function getTriggerZone(triggerZoneId)
	for i, triggerZone in ipairs(triggerZones_) do
		if triggerZone:getId() == triggerZoneId then	
			return triggerZone
		end
	end
end

local function getTriggerZoneClone(triggerZoneId)
	local triggerZone = getTriggerZone(triggerZoneId)
	
	if triggerZone then
		return triggerZone:clone()
	end
end

local function setTriggerZoneRadius(triggerZoneId, radius)
	local triggerZone = getTriggerZone(triggerZoneId)
	
	triggerZone:setRadius(radius)
	
	if controller_ then
		controller_.triggerZoneRadiusChanged(triggerZoneId)
	end
end

local function getTriggerZoneRadius(triggerZoneId)
	local triggerZone = getTriggerZone(triggerZoneId)
	
	return triggerZone:getRadius()
end

local function setTriggerZoneName(triggerZoneId, name)
	local triggerZone = getTriggerZone(triggerZoneId)
	
	if triggerZone:getName() ~= name then
		triggerZone:setName(makeTriggerZoneNameUnique(name, triggerZoneId))
	end
		
	if controller_ then
		controller_.triggerZoneNameChanged(triggerZoneId)
	end
end

local function getTriggerZoneName(triggerZoneId)
	local triggerZone = getTriggerZone(triggerZoneId)
	
	if triggerZone then
		return triggerZone:getName()
	end	
end

local function setTriggerZoneColor(triggerZoneId, r, g, b, a)
	local triggerZone = getTriggerZone(triggerZoneId)
	
	triggerZone:setColor(r, g, b, a)
	
	if controller_ then
		controller_.triggerZoneColorChanged(triggerZoneId)
	end
end

local function getTriggerZoneColor(triggerZoneId)
	local triggerZone = getTriggerZone(triggerZoneId)
	local r, g, b, a = triggerZone:getColor()

	return r, g, b, a
end

local function getTriggerZoneProperties(triggerZoneId)
	local triggerZone = getTriggerZone(triggerZoneId)
	local properties = triggerZone:getProperties()
	
	return properties
end

local function setTriggerZoneProperties(triggerZoneId, a_properties)
	local triggerZone = getTriggerZone(triggerZoneId)
	triggerZone:setProperties(a_properties)
end



local function setTriggerZoneHidden(triggerZoneId, hidden)
	local triggerZone = getTriggerZone(triggerZoneId)
	
	triggerZone:setHidden(hidden)
	
	if controller_ then
		controller_.triggerZoneHiddenChanged(triggerZoneId)
	end
end

local function getTriggerZoneHidden(triggerZoneId)
	local triggerZone = getTriggerZone(triggerZoneId)
	
	return triggerZone:getHidden()
end

local function setTriggerZonePosition(triggerZoneId, x, y)
	local triggerZone = getTriggerZone(triggerZoneId)
	
	triggerZone:setPosition(x, y)
	
	if controller_ then
		controller_.triggerZonePositionChanged(triggerZoneId)
	end
end

local function getTriggerZonePosition(triggerZoneId)
	local triggerZone = getTriggerZone(triggerZoneId)
	
	return triggerZone:getPosition()
end	

local function getTriggerZoneIds()
	local triggerZoneIds = {}
	
	for i, triggerZone in ipairs(triggerZones_) do
		table.insert(triggerZoneIds, triggerZone:getId())
	end
	
	return triggerZoneIds
end

local function getTriggerZoneExists(triggerZoneId)
	return nil ~= getTriggerZone(triggerZoneId)
end

local function loadTriggerZones(triggerZonesTable)
	if triggerZonesTable then
		for i, triggerZoneTable in ipairs(triggerZonesTable) do
			local triggerZone = createTriggerZone(	triggerZoneTable.name, 
													triggerZoneTable.x, 
													triggerZoneTable.y, 
													triggerZoneTable.radius, 
													triggerZoneTable.zoneId,
													triggerZoneTable.properties)

			triggerZone:setColor(unpack(triggerZoneTable.color))
			triggerZone:setHidden(triggerZoneTable.hidden)
			
			if controller_ then
				controller_.triggerZoneAdded(triggerZone:getId())
			end
		end
	end
end

local function removeAllZones()
	local toRemove = {}
	for i, triggerZone in ipairs(triggerZones_) do
		table.insert(toRemove, triggerZone:getId())
	end
	
	for k,v in ipairs(toRemove) do
		removeTriggerZone(v)
	end
end

local function saveTriggerZones()
	local triggerZonesTable = {}
	
	for i, triggerZone in ipairs(triggerZones_) do
		local x, y = triggerZone:getPosition()
		
		table.insert(triggerZonesTable, {
			zoneId		= triggerZone:getId(),
			name		= triggerZone:getName(),
			radius		= triggerZone:getRadius(),
			color		= {triggerZone:getColor()},
			x			= x,
			y			= y,
			hidden		= triggerZone:getHidden(),
			properties  = triggerZone:getProperties(),
		})
	end
	
	return triggerZonesTable
end

return {
	setController			= setController,
	setMissionData			= setMissionData,
		
	onNewMission			= onNewMission,
	
	addTriggerZone			= addTriggerZone,
	removeTriggerZone		= removeTriggerZone,
	
	setTriggerZoneRadius	= setTriggerZoneRadius,
	getTriggerZoneRadius	= getTriggerZoneRadius,

	setTriggerZoneName		= setTriggerZoneName,
	getTriggerZoneName		= getTriggerZoneName,
	
	setTriggerZoneColor		= setTriggerZoneColor,
	getTriggerZoneColor		= getTriggerZoneColor,
	
	setTriggerZoneProperties	= setTriggerZoneProperties,
	getTriggerZoneProperties	= getTriggerZoneProperties,
	
	setTriggerZoneHidden	= setTriggerZoneHidden,
	getTriggerZoneHidden	= getTriggerZoneHidden,
	
	setTriggerZonePosition	= setTriggerZonePosition,
	getTriggerZonePosition	= getTriggerZonePosition,
	
	getTriggerZone			= getTriggerZoneClone,
	getTriggerZoneIds		= getTriggerZoneIds,
	getTriggerZoneExists	= getTriggerZoneExists,
	
	loadTriggerZones		= loadTriggerZones,
	saveTriggerZones		= saveTriggerZones,
	
	removeAllZones			= removeAllZones,
}