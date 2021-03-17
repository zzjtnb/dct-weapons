local MissionGenerator = require('MissionGenerator')
local NodesManager = require('me_nodes_manager')
local TemplatesManager = require('me_templates_manager')
local MissionModule = require('me_mission')
local MapWindow = require('me_map_window')
local Toolbar = require('me_toolbar')
local GDData = require('me_generator_dialog_data')
local Terrain = require('terrain')
local TheatreOfWarData	= require('Mission.TheatreOfWarData')
local localizationMG = require('me_localizationMG')
local U 			= require('me_utilities')

local misPath = userFiles.userMissionPath.."MG.miz"

local function reloadEditorMission()
    local nodesVisible = NodesManager.isVisible()
    Toolbar.untoggle_all_except()
    MapWindow.unselectAll()
    MissionModule.mapObjects = {}
    MapWindow.selectedGroup = nil;
    MapWindow.clearUserObjects()
    MissionModule.load(misPath, false)
    NodesManager.show(nodesVisible)
end

local function reloadMission()
    MapWindow.unselectAll()
    MissionModule.mapObjects = {}
    MapWindow.selectedGroup = nil;
--    MapWindow.clearUserObjects()
    MissionModule.load(misPath, true)
end

local function loadTOW(theatreOfWarName)
    --FIXME как убрать подписи к путевым точкам?
    TheatreOfWarData.selectTheatreOfWar(theatreOfWarName)
    MapWindow.initTerrain(true)
    MissionModule.create_new_mission(true);
end

local function generate(playerParams, runningFromEditor, theatreOfWar, nodesIds, redTemplId, blueTemplId)
	localizationMG.init()
	
    local generatorData = {}
    generatorData.combatTemplates = TemplatesManager.templates()
    generatorData.missionNodes = NodesManager.nodes(theatreOfWar)
	
    MissionGenerator.reloadData(generatorData)
    
    playerParams = playerParams
    local params = {}
    params.redTemplId  = redTemplId or ""
    params.blueTemplId  = blueTemplId or ""
    
    params.misPath = misPath
 
    --TODO назвать параметры одинаково, использовать копирование таблицы
    params.nodesIds = nodesIds 
    params.theatreOfWar = theatreOfWar
    params.playerAircraft = playerParams.aircraft
    params.playerAircraftsType = playerParams.aircraftsType
    params.playerCountry = playerParams.countryId
    params.botsInGroup = playerParams.wingmansCount
    params.difficulty = playerParams.difficulty
    params.forces = playerParams.forces
    params.season = playerParams.season
    params.weather = playerParams.weather
    params.startTime = playerParams.startTime
    params.takeoffFrom = playerParams.takeoffFrom
	params.taskWorldID = playerParams.taskWorldID
	params.playerAltitude = playerParams.playerAltitude
	params.nodeDistance = playerParams.nodeDistance
	params.typeAttack = playerParams.typeAttack

    if not (Terrain.GetTerrainConfig('id') == theatreOfWar) then
        loadTOW(theatreOfWar)
    end
    
    local generated, nodeId, errMsg = MissionGenerator.generate(params)
	--print("---MissionGenerator.generate---",generated, nodeId, errMsg, params.taskWorldID)
    if generated then
        if runningFromEditor then
            reloadEditorMission()
        else
            reloadMission()
        end
    end
    
    return generated, nodeId, errMsg
end

local function saveAll()
    if (NodesManager.isChanged()) then
        NodesManager.saveNodes()
    end
    
    if (TemplatesManager.isChanged()) then
        TemplatesManager.saveTamplates()
    end
    
    GDData.saveGeneratorParams()
end

return {
	generate	    = generate,
	saveAll		    = saveAll,
    reloadMission   =   reloadMission,
}