local base = _G

module('me_openfile')

local print = base.print
local assert = base.assert
local tostring = base.tostring
local ipairs = base.ipairs
local string = base.string
local pairs = base.pairs
local require = base.require
local unpack = base.unpack
local table = base.table

local ListBoxItem		= require('ListBoxItem')
local lfs				= require('lfs')
local U					= require('me_utilities')
local Mission			= require('me_mission')
local minizip			= require('minizip')
local i18n				= require('i18n')
local MenuBar			= require('me_menubar')
local MapWindow			= require('me_map_window')
local Skin				= require('Skin')
local FileGrid			= require('FileGrid')
local textutil			= require('textutil')
local MeSettings		= require('MeSettings')
local mod_dictionary    = require('dictionary')
local music				= require('me_music')
local MsgWindow 		= require('MsgWindow')
local TheatreOfWarData	= require('Mission.TheatreOfWarData')
local waitScreen		= require('me_wait_screen')
local DialogLoader		= require('DialogLoader')
local SkinUtils			= require('SkinUtils')
local Gui               = require('dxgui')
local Button			= require('Button')
local modulesInfo       = require('me_modulesInfo')
local Grid          	= require('Grid')
local GridHeaderCell	= require('GridHeaderCell')
local Panel         	= require('Panel')
local Static        	= require('Static')
local UC			    = require('utils_common')
local progressBar 		= require('ProgressBarDialog')
local Analytics			= require("Analytics") 
local ProductType 		= require('me_ProductType') 

i18n.setup(_M)

local folderItemSkin = Skin.listBoxItemOpenMissionFolderSkin()
local fileItemSkin = Skin.listBoxItemOpenMissionFileSkin()

local style = "mission"
local offsetY = 0
local tblTrainingDataById = {}
local misPanels = {}
local curGrid
local LocalizationTbl = {}	
local sortColumn, sortReverse, sortColumnMy, sortReverseMy

cdata = {
	mission = _('MISSION'),
	replay = _('REPLAY'),
	leftBtn = _('CANCEL'),
	rightBtn = _('OPEN'),
    nextBtn = _('NEXT'),

	missionDescription = _('Mission Description'),
	selectMission = _('SELECT MISSION'),
	selectRecord = _('SELECT RECORD'),
	drive = _('DRIVE:'),
	typeOfFile = _('TYPE OF FILE:'),

    Requirements = _('Requirements'),
	open = _('OPEN FILE'),
	OK = _('OK'),
	CANCEL = _('CANCEL'),
	del = _('DEL'),
	file = _('File'),
	map  = _('Map_fileGrid', 'Map'),  
	path = _('PATH'),
	type = _('TYPE'),
	types = { '*.miz' },
    Modules = _('Modules'),
    Missions = _('Missions'),
    Tracks = _('Tracks'),
    Description = _('Description'),
    
    -- хоть использования не видно, но они нужны:
    My_Tracks = _('My Tracks'),
    My_Missions = _('My Missions'),
    
    nameColumnFile = _('Name'),
    nameColumnData = _('Modified'),
    nameColumnMap  = _('Map_fileGrid', 'Map'),
    warning = _('WARNING'),
    messageNoTerrain = _('Need terrain for load this mission: '),
    delFile = _('Are you sure you want to delete the file?'), 
	yes = _('YES'),
	no = _('NO'),
}

if ProductType.getType() == "LOFAC" then
    cdata.missionDescription = _('Mission Description-LOFAC')
    cdata.My_Missions = _('My Missions-LOFAC')
end

vdata = {
  selection = 'FileName.miz',
  file = 'FileName.miz',
  path = nil,
  mission = {}, -- ссылка на текущую миссию
  type = '*.miz', 
  last_path = {},
}
local window
local requiredModulesButton = {}

local function create_()
	window = DialogLoader.spawnDialogFromFile("MissionEditor/modules/dialogs/open_mission_dialog.dlg", cdata)

    containerMain = window.containerMain
    middlePanel = containerMain.middlePanel
    pNoVisible = window.pNoVisible
    
    btnCancel   = containerMain.footerPanel.btnCancel
    btnOk       = containerMain.footerPanel.btnOk
    btnClose    = containerMain.headPanel.btnClose
    sCaption    = containerMain.headPanel.sCaption
	
	panelMissions 		= middlePanel.panelMissions   
    spRequirements      = middlePanel.spRequirements
    sRequirements       = middlePanel.sRequirements
    sDescriptionHeader  = middlePanel.sDescriptionHeader
    pnlDescription      = middlePanel.pnlDescription
	listDrive 			= middlePanel.listDrive  
	
	nameCellSkin = pNoVisible.staticFileCell:getSkin()
    nameHoverCellSkin = pNoVisible.staticFileHoverCell:getSkin()
    nameSelectedCellSkin = pNoVisible.staticFileSelectedCell:getSkin()
	headerSkin = pNoVisible.gridHeader:getSkin()
	gridAddMissionSkin = pNoVisible.gridAddMission:getSkin()
	sHeaderAddMissionsSkin = pNoVisible.sHeaderAddMissions:getSkin()
	widgetAddMSkin = pNoVisible.widgetAddM:getSkin()
	widgetModuleSkin = pNoVisible.widgetModule:getSkin()
	grid = middlePanel.grid	
    
    pictureOpenFilename = SkinUtils.getStaticPictureFilename(pNoVisible.staticPictureOpen:getSkin())
	pictureReplyFilename = SkinUtils.getStaticPictureFilename(pNoVisible.staticPictureReply:getSkin())
    
    listBoxDriveItemSkin = pNoVisible.listBoxDriveItem:getSkin()
    
	fileGrid = FileGrid.new(grid, cdata.nameColumnFile, cdata.nameColumnData, cdata.nameColumnMap)
	fileGrid:setCellSkins(pNoVisible.staticFolderCell:getSkin(), pNoVisible.staticFileCell:getSkin(), pNoVisible.staticDateCell:getSkin(), pNoVisible.staticMapCell:getSkin())
	fileGrid:setColumnHeaderSkins(pNoVisible.gridHeaderCellNoSort:getSkin(), pNoVisible.gridHeaderCellSortUp:getSkin(), pNoVisible.gridHeaderCellSortDown:getSkin())
    fileGrid:setSelectedCellSkins(pNoVisible.staticFileSelectedCell:getSkin(), pNoVisible.staticDateSelectedCell:getSkin(), pNoVisible.staticFolderSelectedCell:getSkin(), pNoVisible.staticMapSelectedCell:getSkin())
    fileGrid:setHoverCellSkins(pNoVisible.staticFileHoverCell:getSkin(), pNoVisible.staticDateHoverCell:getSkin(), pNoVisible.staticFolderHoverCell:getSkin(), pNoVisible.staticMapHoverCell:getSkin())
    fileGrid:setHideExtension(true)
	curGrid = fileGrid
    
    bRequiredTextSkin = pNoVisible.bRequiredText:getSkin()
    
	skinSortUp      = pNoVisible.gridHeaderCellSortUp:getSkin()
    skinSortDown    = pNoVisible.gridHeaderCellSortDown:getSkin()
    skinNoSort      = pNoVisible.gridHeaderCellNoSort:getSkin()
    
    spDescription = middlePanel.spDescription
	sDescription = spDescription.sDescription
    
    local w, h = Gui.GetWindowSize()
    window:setBounds(0,0,w,h)
    containerMain:setBounds((w-1280)/2, (h-768)/2, 1280, 768)
--	local gridX, gridY, gridW, gridH = grid:getBounds()
--	panelMissions:setBounds(gridX, gridY, gridW, gridH)

    for i = 0, 20 do
        local widgetNew = Button.new()
        widgetNew:setSkin(bRequiredTextSkin) 
        base.table.insert(requiredModulesButton, widgetNew)      
    end

    loadPathFromFile()	
	setupCallbacks()
end

function setupCallbacks()
    btnCancel.onChange = onButtonCancel -- обработчик кнопки Exit
    btnOk.onChange = onButtonOpen -- обработчик кнопки Next
    btnClose.onChange = onButtonCancel
	
    middlePanel.listDrive.onChange = onListDriveChange
	
    window:addHotKeyCallback('escape', onButtonCancel)
    window:addHotKeyCallback('return', onButtonOpen)  
	window:addHotKeyCallback('delete', deleteFile)	
	
	function fileGrid:onFolderClick(folderName, dblClick)
		onListFilesChange(folderName, dblClick)
	end
	
	function fileGrid:onFileClick(fileName, dblClick)
		onListFilesChange(fileName, dblClick)
	end
end

function getColumnHeaderSkin(a_columnIndex)
	if sortColumn == a_columnIndex then
		if sortReverse then
			return skinSortDown
		else
			return skinSortUp
		end
	else
		return skinNoSort
	end
end

function updateColumnHeaders()
	for k,v in base.pairs(misPanels) do		
		for i = 0, 2 do
			local gridHeaderCell = v.grid:getColumnHeader(i)
			
			if gridHeaderCell then
				local skin = getColumnHeaderSkin(i)
				if skin then
					gridHeaderCell:setSkin(skin)
				end
			end
		end
	end		
end

function selectModulItem(path)
	local listDrive = middlePanel.listDrive
	
	listDrive:selectItem(nil)
	if path == nil or path == '' then 
		listDrive:selectItem(listDrive:getItem(0))
		return 
	end
	local spath = string.gsub(path, '/', '\\')
	local count = listDrive:getItemCount()
	for i = 0, count-1 do
		local item = listDrive:getItem(i)
		local str1 = string.gsub(spath, '-', '')
		local str2 = string.gsub(item.path, '-', '')
        if string.find(str1, str2) ~= nil or str1 == str2 then
            listDrive:setItemVisible(item)
			listDrive:selectItem(item)
			return
		end
		
		if tblTrainingAttachDataById[item.id] then
			for k,v in base.pairs(tblTrainingAttachDataById[item.id]) do
				if string.find(string.gsub(spath, '-', ''), string.gsub(string.gsub(v.dir, '/', '\\'), '-', '')) ~= nil then
					listDrive:setItemVisible(item)
					listDrive:selectItem(item)
					return
				end				
			end
		end
	end
	
	listDrive:selectItem(listDrive:getItem(0))
end

function selectLocationForPath(path)
	if path == nil then
		if (style == "track") then
			local pathT = base.userFiles.userTrackPath.."/"
            local a, err = lfs.attributes(pathT)
			if a and (a.mode == 'directory') then
				setPath(pathT)
				path = pathT
			end
		else
			local pathU = base.userFiles.userMissionPath.."Single/"
            local a, err = lfs.attributes(pathU)
			if a and (a.mode == 'directory') then
				setPath(pathU)
				path = pathU
			end
		end
	end
	local listDrive = middlePanel.listDrive
	
	selectModulItem(path)
	
	local item = listDrive:getSelectedItem()
	local desc, requiredModules
	if item then
		if item.enableFileGrid == true then
			updataFilesGrids(vdata.path or item.path,item.id,item.enableFileGrid)
			if  vdata.selection then
				fileGrid:selectRowText(vdata.selection)	
				desc, requiredModules = getMissionDescription(path .. '/' .. vdata.selection)
				updateDescription(desc, requiredModules)
			end
		else	
			updateModGrids()	
		end	
		
		updateDescription(desc, requiredModules)
	end
end

function updateModGrids()
	local item = listDrive:getSelectedItem()
	updataFilesGrids(item.path, item.id, false)
end

function addAttachModulMissionsData(plugin)
	local result
	local attachMissionsToMods = plugin.attachMissionsToMods

	if attachMissionsToMods then
		for k,v in base.pairs(attachMissionsToMods) do
			tblTrainingAttachDataById[k] = {}
			tblTrainingAttachDataById[k][plugin.id] = {}
			tblTrainingAttachDataById[k][plugin.id].dir = plugin.dirName.."/"..v.MissionsDir.."/Single/"
			tblTrainingAttachDataById[k][plugin.id].name = v.name
		end
	
	end
end

function updateDrivesCombo()	     
    listDrive:clear()
	
	tblTrainingAttachDataById = {}
	
	local locations = lfs.locations()
--    base.U.traverseTable(locations)
	local pathPl 
    
    for i, location in ipairs(locations) do
        --pathPl = U.extractDirNameLevelUp(location.path,2)
        if --[[pathPl ~= nil or]] location.name == 'My Missions' then
            local path = location.path
        
            if (style == "track") then
                location.name = 'My Tracks'
                path = U.extractDirNameLevelUp(path,1).."/Tracks/"
            end
            local listItem = ListBoxItem.new(_(location.name))
            listItem.name = location.name
            listItem.path = string.gsub(path, '/', '\\')
            listItem:setSkin(listBoxDriveItemSkin)
			listItem.enableFileGrid = true
            listDrive:insertItem(listItem)            
        end
    end
    
    local locale = i18n.getLocale()
	
	local tmpPlugins 
	for index, plugin in pairs(base.plugins) do		
		tmpPlugins = tmpPlugins or {}
		base.table.insert(tmpPlugins,plugin) 
	end
	
	if tmpPlugins then
		base.table.sort(tmpPlugins, base.U.compTableShortName)
		for pluginName, plugin in ipairs(tmpPlugins) do
			if plugin.Skins ~= nil and plugin.applied == true then
				local misPath 

				local folder
				if (style == "mission") then
					folder = "Single/"
				elseif (style == "track") then
					folder = "Tracks/"
				end
				
				misPath = plugin.dirName.."/Missions/"..folder
				local a, err = lfs.attributes(misPath)
				if a and (a.mode == 'directory') then 
				
				else      
					misPath = get_missions(plugin.dirName.."/Missions/",locale)  
				end

				if misPath then
					pathPl = nil
					for pluginSkinName, pluginSkin in pairs(plugin.Skins) do	
							pathPl = plugin.dirName.."/"..pluginSkin.dir                    
					end 
					local listItem = ListBoxItem.new(_(plugin.shortName))            
					listItem.path = string.gsub(misPath, '/', '\\')
					listItem.id = plugin.id
					listItem:setSkin(listBoxDriveItemSkin)
					if pathPl then
						local SkinItem = listItem:getSkin()
						local filename = pathPl..'\\icon-38x38.png'
						if lfs.attributes(filename)	== nil then
							filename = 'dxgui\\skins\\skinME\\images\\default-38x38.png'
						end
						SkinItem.skinData.states.released[1].picture.file = filename
						SkinItem.skinData.states.released[2].picture.file = filename
						SkinItem.skinData.states.hover[1].picture.file = filename
						SkinItem.skinData.states.hover[2].picture.file = filename
						listItem:setSkin(SkinItem)
					end
					listDrive:insertItem(listItem)
				end            
			end 
			addAttachModulMissionsData(plugin)	
		end        
	end
	
	selectLocationForPath(vdata.path)
end

function get_missions(missions_root,locale)
    local folder
    if (style == "mission") then
        folder = "Single/"
    elseif (style == "track") then
        folder = "Tracks/"
    end

	local locale_dir = missions_root..locale.."/"..folder
	local a, err = lfs.attributes(locale_dir)
	if a and (a.mode == 'directory') then
		return locale_dir
	end
	local en_dir = missions_root.."EN/"..folder
	a, err 		 = lfs.attributes(en_dir)
	if a and (a.mode == 'directory') then
		return en_dir
	end
--	a, err 		 = lfs.attributes(missions_root)
--	if a and (a.mode == 'directory') then
--		return missions_root
--	end
	return nil
end

function onButtonCancel()
    if (returnScreen == 'editor') then    
     --   local path = base.module_mission.mission.path or base.MISSION_PATH
      --  if path and ('' ~= path) then
      --      base.module_mission.load(path)
     --   end
		MapWindow.show(true)
    else                
        base.mmw.show(true)
    end
    show(false)
end


function updateDescription(text, requiredModules)  
    for k,btn in base.pairs(requiredModulesButton) do
        btn:setVisible(false)
    end
 
    local offsetY = 0
    
    if requiredModules and #requiredModules > 0 then
        for k,v in base.ipairs(requiredModules) do
            requiredModulesButton[k]:setText(modulesInfo.getModulDisplayNameByModulId(v))
            requiredModulesButton[k]:setBounds(1,offsetY, 300, 20)
            requiredModulesButton[k]:setVisible(true) 
            requiredModulesButton[k].blink = modulesInfo.getBlink(v)
            requiredModulesButton[k].onChange = function(self)
                if self.blink then
                    local url = DcsWeb.make_auth_url(self.blink)
                    os.execute("start ".."\"\" \""..url.."\"")
                end
            end
            spRequirements:insertWidget(requiredModulesButton[k])
            offsetY = offsetY + 20       
        end
        spRequirements:updateWidgetsBounds()
        
        spRequirements:setVisible(true)
        sRequirements:setVisible(true)        
        pnlDescription:setVisible(true)
        sDescriptionHeader:setPosition(965, 232)
        spDescription:setBounds(965, 265, 315, 635)
    else
        spRequirements:setVisible(false)
        sRequirements:setVisible(false)        
        pnlDescription:setVisible(false)
        sDescriptionHeader:setPosition(965, 1)
        spDescription:setBounds(965, 33, 315, 635)
    end
        
    if text then
        text = text.."\n"
    end
	sDescription:setText(text)
    local nw, nh = sDescription:calcSize() 
    sDescription:setSize(299, nh+20)
    
    spDescription:updateWidgetsBounds()
end

function onListFilesChange(itemText, dblClick)
    updateDescription()
    vdata.selection = itemText
    
    local path = makePath(vdata.path, vdata.selection)
    local a = lfs.attributes(path)
	if a == nil then
		print("---onListFilesChange---path=",path,vdata.path,vdata.selection)
	end
	a = assert(a)
    if (a.mode == 'directory') and dblClick then
        setPath(path..'/')
        vdata.file = ''
        updateFilesList()
    elseif a.mode == 'file' then
        vdata.file = vdata.path .. '/' .. vdata.selection
        local desc, requiredModules = getMissionDescription(vdata.file)
		updateDescription(desc, requiredModules)
		
        if dblClick then 
            onButtonOpen()
        end
    end
	savePath()
end

function savePath()
	if vdata.type ~= nil then
		vdata.last_path[vdata.type] = {}	
		vdata.last_path[vdata.type].path = vdata.path
		vdata.last_path[vdata.type].selection = vdata.selection
	end
end

function loadPathFromFile()	
	local tbl 
	
    if (style == "track") then
        tbl, sortColumnMy, sortReverseMy = MeSettings.getOpenFileDialogTrackParams()            
    else
        tbl, sortColumnMy, sortReverseMy = MeSettings.getOpenFileDialogParamsMy()
		sortColumn, sortReverse = MeSettings.getOpenFileDialogParams()
    end
            
	if tbl then
		vdata.last_path = tbl
		fileGrid:setSortColumnReverse(sortColumnMy, sortReverseMy)
	end
end

function savePathInFile()
    if (style == "track") then
		sortColumnMy, sortReverseMy = fileGrid:getSortColumnReverse()
        MeSettings.setOpenFileDialogTrackParams(vdata.last_path, sortColumnMy, sortReverseMy)          
    else
		sortColumnMy, sortReverseMy = fileGrid:getSortColumnReverse()
        MeSettings.setOpenFileDialogParams(sortColumn, sortReverse)
		MeSettings.setOpenFileDialogParamsMy(vdata.last_path, sortColumnMy, sortReverseMy)
    end
end

function deleteFile()
	if curGrid == fileGrid then
		local fullName = fileGrid:getFullName()
		
		if fullName then
			msgWindowHandler_ = MsgWindow.warning(cdata.delFile, cdata.warning, cdata.yes, cdata.no)
			
			function msgWindowHandler_:onChange(buttonText)
				if (buttonText == cdata.yes) then
					base.os.remove(fullName)
					fileGrid:setPath(fileGrid:getPath())
				end
			end

			msgWindowHandler_:show()
			msgWindowHandler_ = nil
		end
	end
end

function onButtonOpen()
	if curGrid == nil then
		return
	end
	
	if curGrid == fileGrid then
		local itemText = fileGrid:getSelectedRowText()
			
		if itemText	then
			local path = U.fixSlash(vdata.path .. '/' .. itemText)
			if #path <= 2 then
				path = path .. [[/]]
			end

			local a = lfs.attributes(path)
			if not a then
				return
			end       
			
			if (a.mode == 'directory') then
				vdata.file = ''
				setPath(path)
				updateFilesList()
				return
			else
				vdata.file = vdata.path .. '/' .. itemText
			end        
		else
			vdata.file = ''
		end	
	else
		local item = curGrid:getCell(0, curGrid:getSelectedRow())
		if (item == nil) then
			base.print("item == nil")
			return
		end
		vdata.file = item.data.path..item.data.file
	end	

    if vdata.file == '' then 
        return
    end

    if vdata.type == '*.miz' or (vdata.type == '*.*' and string.sub(vdata.file, -4, -1) == '.miz') then
        show(false)
        base.mmw.show(false)        
        base.toolbar.setOpenButtonState(false)
        base.statusbar.setFileName(U.extractFileName(vdata.file))
        progressBar.setUpdateFunction(function()

			base.panel_autobriefing.missionFileName = vdata.file
			base.panel_autobriefing.returnToME = false
				-- грузим миссию без редактора
			print('Loading mission ', vdata.file)
			local result, err, theatre = Mission.load(vdata.file, true)
		   -- print("----result onButtonOpen=",result, err, theatre)
			if result == true then
				base.panel_autobriefing.setDoSave(true)
				base.panel_autobriefing.show(true, 'openmission')
			else
				base.mmw.show(true) 
				show(true)
				if err == "no terrain" then
					MsgWindow.warning(cdata.messageNoTerrain..theatre, cdata.warning, cdata.ok):show()
				end
			end
			
        end)
    elseif vdata.type == '*.avi' or (vdata.type == '*.*' and string.sub(vdata.file, -4, -1) == '.avi')then
        -- Запуск медиаплейера Windows
        show(false)
        base.mmw.show(false)
        base.os.execute('start '..cdata.mediaplayer..cdata.mediaplayer_options..'"'..vdata.file..'"')  
    elseif vdata.type == '*.trk' or (vdata.type == '*.*' and string.sub(vdata.file, -4, -1) == '.trk')then
        local fileName = vdata.file
        local params = { file = fileName, command = "--track"}
        show(false)
        base.mmw.show(false)
		
        progressBar.setUpdateFunction(function()
			print('playing track',fileName)
			
			local result, err, theatre = Mission.load(vdata.file, true)
			if result == true then
				music.stop()
				if (returnScreen == 'editor') then
					Mission.play(params, 'editor', fileName, true)
				else
					Mission.play(params, 'track', fileName, true)
				end 
			else
				base.mmw.show(true) 
				show(true)
				if err == "no terrain" then
					MsgWindow.warning(cdata.messageNoTerrain..theatre, cdata.warning, cdata.ok):show()
				end
			end
        end)
           
    end
end

function updateFilesList()
    local filter
	
    if vdata.type ~= '*.*' then	
        filter = { string.sub(vdata.type, 3) }
    end
	
    fileGrid:setVerifyTheatresFun(TheatreOfWarData.isEnableTheatre)
	fileGrid:setFilter(filter)
	fileGrid:setPath(vdata.path)
end


function update()
  updateDescription()
  updateFilesList()
  updateDrivesCombo()
end

function show(b, a_returnScreen, track)
    if b then          
        returnScreen = a_returnScreen or base.defaultReturnScreen
        if not window then    
            create_()
        end

        if track then
            setReplayStyle(true)
            style = "track"
        else
            setReplayStyle(false)
            style = "mission"
			Analytics.pageview(Analytics.Mission)
        end
		loadPathFromFile()	
		setLastPath()		
        updateDrivesCombo()
		savePath()
    else
		if window and window:getVisible() == true then
			savePathInFile()
		end
	end	

    if window then 
        window:setVisible(b)
    end

end

function getCurGrid(a_selection)
	for k,v in base.pairs(misPanels) do
		for rIndex = 0, v.grid:getRowCount() - 1 do 
			local cell = v.grid:getCell(0, rIndex) 	
			if cell.data.file == a_selection then
				return v.grid, rIndex
			end
		end	
	end
	if misPanels[1] and misPanels[1].grid and misPanels[1].grid:getRowCount() > 0 then
		return misPanels[1].grid, 0
	end
end

function setLastPath()
	if vdata.last_path then
		local lastPath = vdata.last_path[vdata.type]

		if lastPath then
			local path = lastPath.path
			if path then
				local dir_attr = lfs.attributes(path)
				if dir_attr and dir_attr.mode == 'directory' then
					setPath(path)
					vdata.selection = lastPath.selection
				end
			end
		end
	end
end

function getMissionDescription(missionFileName)    
    local desc, requiredModules
	if missionFileName then
		desc, requiredModules = mod_dictionary.getMissionDescription(missionFileName,i18n.getLocale())		
		
		local listRequiredModules = {}
		
		if requiredModules then
			for k,v in base.pairs(requiredModules) do
				if (base.enableModules[v] ~= true) then
					base.table.insert(listRequiredModules, v)
				end
			end
		end
	end

   return desc, listRequiredModules
end

-- объединение пути и выделения
function makePath(pathString, selection)
  local str = ''
  if selection == '..' then
    rev_str = string.reverse(pathString)
    local pos = string.find(rev_str, '/', 2)
    if pos then 
        local subStr = string.sub(rev_str, pos + 1)
        str = string.reverse(subStr)
    else
        str =  pathString
    end
  else
    str =  pathString .. '/'.. selection
  end
  str = U.fixSlash(str)
  return str
end

function onListDriveChange(self, item)
    if item then
		updataFilesGrids(item.path,item.id,item.enableFileGrid)
    end
end

function updataFilesGrids(path, id, enableFileGrid)	
	local desc, requiredModules
	if enableFileGrid then
		fileGrid:clearSelectRow(self)
		setPath(path)
		grid:setVisible(true)	
		panelMissions:setVisible(false)	
		curGrid = fileGrid
		updateFilesList()
	else
		for k,v in base.pairs(misPanels) do
			panelMissions:removeWidget(v)
		end
		misPanels = {}
		
		fillMissionsGrids(path)
		fillAttachModulMissions(id)
		updateColumnHeaders()
		grid:setVisible(false)
		panelMissions:setVisible(true)
				
		curGrid, iRow = getCurGrid(vdata.selection)
		if curGrid then 
			curGrid:selectRow(iRow)
			local row = curGrid:getSelectedRow()
			if row > -1 then 
				local cell = curGrid:getCell(0, row) 
				if cell then
					desc, requiredModules = getMissionDescription(cell.data.path..cell.data.file)
				end
			end
		end
	end
	updateDescription(desc, requiredModules)
	vdata.file = ''
end


function setPath(path)
    path = U.fixSlash(path)
    vdata.path = path
end

local function updateWindowPicture(reply)
    if reply then
		window:setSkin(SkinUtils.setWindowPicture(window:getSkin(), pictureReplyFilename))
	else
		window:setSkin(SkinUtils.setWindowPicture(window:getSkin(), pictureOpenFilename))
	end
end

function setReplayStyle(b)
    if b then
        vdata.type = '*.trk'
        sCaption:setText(cdata.replay)
        middlePanel.widgetMid:setText(cdata.Tracks)
        updateWindowPicture(true)
		setPath(base.userFiles.userTrackPath)
	else
        vdata.type = '*.miz'    
        sCaption:setText(cdata.mission)
        middlePanel.widgetMid:setText(cdata.Missions)       
		updateWindowPicture(false)
		--base.print("---base.userFiles.userMissionPath---",base.userFiles.userMissionPath)
		setPath(base.userFiles.userMissionPath)
    end
	
	updateFilesList()
end

function fillMissionsGrids(a_path)
	offsetY = 0
	panelMissions:clear()
	
	base.table.insert(misPanels,addGrid(a_path,"",true))	
end

function initLocalizationTbl(a_dir)
	LocalizationTbl = {}	
	
	local f = base.loadfile(a_dir.."Localization.lua")
	local env = {_ = _}	
    if f then
        base.setfenv(f, env)
        f()
        LocalizationTbl = env.LocalizationTbl
    end  
end

function localizationFileName(a_name, a_sortie)
	return LocalizationTbl[a_name] or a_sortie or a_name
end

function addGrid(dir, shortName, noHeader)
	local panel =  Panel.new()

	--	offsetY = offsetY + 34	
	panel:setPosition(0,offsetY)
	local offseGrid = 0
	
	if noHeader ~= true then
		local sHeaderAddMissions = Static.new()
		sHeaderAddMissions:setSkin(sHeaderAddMissionsSkin)
		sHeaderAddMissions:setBounds(0,0,640,34)
		panel:insertWidget(sHeaderAddMissions)
		
		local sAddM = Static.new()
		sAddM:setSkin(widgetAddMSkin)	
		sAddM:setText(cdata.AddMission)
		panel:insertWidget(sAddM)
		local widthAddM, tmp = sAddM:calcSize()
		sAddM:setBounds(0,0,widthAddM,34)
		
		
		local sModule = Static.new()
		sModule:setSkin(widgetModuleSkin)
		sModule:setBounds(widthAddM+10,0,154,34)
		sModule:setText(shortName)
		panel:insertWidget(sModule)
		offsetY = offsetY + 29
		offseGrid = 34
	end	
	
	local grid = Grid.new() 
	panel.grid = grid
	grid:setSkin(gridAddMissionSkin)
	
	local gridHeaderName = GridHeaderCell.new()
    gridHeaderName:setSkin(headerSkin) 
	gridHeaderName:setText(cdata.file)	
	gridHeaderName:addChangeCallback(headerCellChangeCallback)
	gridHeaderName.index = 0
    grid:insertColumn(489,gridHeaderName)
	
	local gridHeaderMap = GridHeaderCell.new()
    gridHeaderMap:setSkin(headerSkin) 
	gridHeaderMap:setText(cdata.map)
	gridHeaderMap.index = 1
	gridHeaderMap:addChangeCallback(headerCellChangeCallback)	
    grid:insertColumn(151, gridHeaderMap)
	
	panel:insertWidget(grid)
	grid:setPosition(0,offseGrid)
	local sizeGridY = fillMissions(grid, dir)
	grid:setSize(640,sizeGridY)
	panel:setSize(640,sizeGridY+34)
	offsetY = offsetY + sizeGridY+34
	
	panelMissions:insertWidget(panel)
	setupCallbacksAddGrid(grid) 
	
	return panel
end

function headerCellChangeCallback(self)   
	if sortColumn ~= self.index then
		sortColumn = self.index
	else
		sortReverse = not sortReverse
	end

	updateModGrids()	
end		

function selectRowMove(grid, rowIndex)
	local nameCell = grid:getCell(0, rowIndex)    
	if (nameCell and grid:getSelectedRow() ~= rowIndex) or (curGrid ~= grid) then
		nameCell:setSkin(nameHoverCellSkin)

		local statusCell = grid:getCell(1, rowIndex)
		statusCell:setSkin(nameHoverCellSkin)
	end
end 

function unSelectRow(grid, rowIndex)
    local nameCellLast = grid:getCell(0, rowIndex)
    
    if nameCellLast then
		nameCellLast:setSkin(nameCellSkin)
        grid:getCell(1, rowIndex):setSkin(nameCellSkin)
	end
end

local function onSelectRow(grid, row)
	local cell = grid:getCell(0, row)

	if cell then
		local desc, requiredModules = getMissionDescription(cell.data.path..cell.data.file)
		
		updateDescription(desc, requiredModules)
		curGrid = grid
		setPath(cell.data.path)
		vdata.selection = cell.data.file
		savePath()
	end
end

function setupCallbacksAddGrid(a_grid) 
	a_grid:addMouseDoubleDownCallback(onButtonOpen)
	
	function a_grid:onMouseDown(x, y, button)
		if 1 == button then
			local col, row = self:getMouseCursorColumnRow(x, y)
			if -1 < col and -1 < row then
				self:selectRow(row)
			end
            
           onSelectRow(self, row)
		end
    end
	
	a_grid:addHoverRowCallback(function(grid, currHoveredRow, prevHoveredRow)
		if -1 < prevHoveredRow then
			unSelectRow(grid, prevHoveredRow)
		end
		
		if -1 < currHoveredRow then
			selectRowMove(grid, currHoveredRow)
		end	
	end)	
	
	a_grid:addSelectRowCallback(function(grid, currSelectedRow, prevSelectedRow)
		unSelectRow(grid, prevSelectedRow)
		onSelectRow(grid, currSelectedRow)
	end)
end

function compareStrings(tab1, tab2)
	if sortColumn == 0 then
		if sortReverse == false then
			local res = textutil.Utf8CompareOrigin(tab1.description, tab2.description)
			if res == 0 then
				return textutil.Utf8Compare(tab1.theatreName, tab2.theatreName)
			else
				return res < 0
			end
		else
			local res = textutil.Utf8CompareOrigin(tab2.description, tab1.description)
			if  res == 0  then
				return textutil.Utf8Compare(tab1.theatreName, tab2.theatreName)
			else
				return res < 0
			end
		end	
	else
		if sortReverse == false then
			local res = textutil.Utf8CompareOrigin(tab1.theatreName, tab2.theatreName)
			if res == 0  then
				return textutil.Utf8Compare(tab1.description, tab2.description)
			else
				return res < 0
			end
		else
			local res =  textutil.Utf8CompareOrigin(tab2.theatreName, tab1.theatreName)
			if res == 0  then
				return textutil.Utf8Compare(tab1.description, tab2.description)
			else
				return res < 0
			end
		end	
	end	
end

function fillMissions(a_grid, a_path)
	a_grid:clearRows()  
	initLocalizationTbl(a_path)

	local sizeY = 0
	local rowHeight = 18
    local rowIndex = 0 
	local listFiles = {}
	
	for fileName in lfs.dir(a_path) do
		if fileName ~= '.' and fileName ~= '..' then
			
			local ext = UC.getExtension(fileName)
			if ext == "miz" then			
				local data = UC.getMissionData(a_path.."\\"..fileName, i18n.getLocale())
				local theatreName, sortie = data.theatreName, data.sortie
				if sortie == "" then
					sortie = fileName
				end
				
				if TheatreOfWarData.isEnableTheatre(theatreName) == true then						
					base.table.insert(listFiles, {fileName = fileName, description = localizationFileName(fileName, sortie), theatreName = TheatreOfWarData.getLocalizedName(theatreName)})
				end
			end	
		end
	end
	
	table.sort(listFiles, compareStrings)
	
	for k,v in base.ipairs(listFiles) do
		a_grid:insertRow(rowHeight)
		local cell = Static.new(v.description)
		cell:setSkin(nameCellSkin)
		a_grid:setCell(0, rowIndex, cell)
		cell.data = {row = rowIndex, description = v.description, file = v.fileName, path = a_path} 
		local cell2 = Static.new(v.theatreName)
		cell2:setSkin(nameCellSkin)
		a_grid:setCell(1, rowIndex, cell2)            
		rowIndex = rowIndex + 1
	end
	
	sizeY = rowIndex*(rowHeight+1) + 30
	a_grid:setSize(640,rowIndex*(rowHeight+1) + 30)
	return sizeY
end

function fillAttachModulMissions(id)
	local attachModulMissions = tblTrainingAttachDataById[id]
	
	if attachModulMissions then
		for k,v in base.pairs(attachModulMissions) do
			initLocalizationTbl(v.dir)
			base.table.insert(misPanels,addGrid(v.dir, v.name))	
		end
	end
	
	panelMissions:updateWidgetsBounds()
end

