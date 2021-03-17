-- модуль выбора подвесок для ЛА
local base = _G

module('me_loadout')

local require = base.require
local pairs = base.pairs
local ipairs = base.ipairs
local table = base.table
local tostring = base.tostring
local math = base.math
local string = base.string
local print = base.print
local assert = base.assert
local next = base.next

-- Модули LuaGUI
local DialogLoader      = require('DialogLoader')
local MsgWindow         = require('MsgWindow')
local U                 = require('me_utilities')
local Size              = require('Size')
local loadoutUtils      = require('me_loadoututils')
local DB                = require('me_db_api')
local panel_payload     = require('me_payload')
local panel_aircraft    = require('me_aircraft')
local panel_paramFM     = require('me_paramFM')
local ProductType 		= require('me_ProductType') 

require('i18n').setup(_M)

local gettext = require("i_18n")

local function _translate(str)
	return gettext.dtranslate("payloads", str)
end

local currentUnitType = nil
local currentTaskWorldID = nil
local columnIndexByNumbers = {}
local numbersByColumnIndex = {}

cdata = 
{
	title = _('LOADOUT EDITOR'),
	empty = _('Empty'),
	weapon = _('WEAPON'), 
	loadout = _('LOADOUT'),
	ok = _('OK'),
	cancel = _('CANCEL'),
	yes = _('YES'),
	no = _('NO'),
	list = _('LIST'),
	copy = _('COPY'),
	add = _('ADD'),
	pylon = _('PYLON'),
	of = _('OF'),
	new = _('NEW'),
	save = _('SAVE'),
	delete = _('DELETE'),
	reset = _('RESET'),
	export = _('EXPORT'),
	rename = _('RENAME'),
	enter_payload_name = _('Enter payload name:'),
	new_payload = _('New Payload'),
	copy_ = _('Copy '),
	delete_payload = _('Delete payload '),
	delete_payload_from_task = _('Delete payload %s from task %s?'),
	payload_name_is_not_unique = _('Payload name is not unique!\nPayload %s is used in tasks:'),
	payload_name_is_not_valid = _('Payload name is not valid (empty or contains \' or ")!'),
	invalid_mission_payload	= _('Mission payload is not equal to any unit payload. Save mission payload?'), 
	save_payload = _('SAVE PAYLOAD'),
	error = _('ERROR'),
	remove = _('REMOVE'),
	export_payload_to_task = _('Export payload to task:'),
	missionPayload = _('Mission payload'),
}

if ProductType.getType() == "LOFAC" then
    cdata.invalid_mission_payload	= _('Mission payload is not equal to any unit payload. Save mission payload?-LOFAC')
end

vdata =
{
	onboard_num = '101',
	weight = 0,
	empty_weight = 0,
	max_take_off_weight = 0,
	max_fuel_weight = 0,
	fuel = 0
}

local x_
local y_
local w_
local h_

local gridHeaderCell_

function create(x, y, w, h)
	x_ = x
	y_ = y
	w_ = w
	h_ = h
end

local function resizeWindow_()
	window:setBounds(x_, y_, w_, h_)

	local cx, cy = window:getClientRectSize()
	local offset = 8

	local staticPictureX, staticPictureY = staticPicture:getPosition()
	local staticPictureWidth, staticPictureHeight = staticPicture:getSize()

	staticPicture:setSize(cx - staticPictureX - offset, staticPictureHeight)

	local buttonsWidth, buttonsHeight = containerButtons:getSize()
	local containerButtonsX, containerButtonsY = containerButtons:getPosition()

	containerButtonsY = cy - buttonsHeight - offset
	containerButtons:setPosition(containerButtonsX, containerButtonsY)	 

	local gridX, gridY = grid:getPosition()
	local gridWidth = cx - gridX - offset

	gridHeight = containerButtonsY - gridY - offset
	grid:setSize(gridWidth, gridHeight)
	
	gridM:setSize(gridWidth, 70)  -- подвеска миссии
end

local function create_()
	window = DialogLoader.spawnDialogFromFile('MissionEditor/modules/dialogs/me_loadout_panel.dlg', cdata)

	gridHeaderCell_ = window.gridHeaderCell
	loadoutUtils.init(	window.staticPayloadCell:getSkin(), 
						window.staticPylonCaption:getSkin(), 
						window.panelPylonCell:getSkin())

	staticPicture = window.staticPicture
	staticPictureSkin = staticPicture:getSkin()
	picture = staticPictureSkin.skinData.states.released[1].picture

	local ratio = 1024 / (512 - 150)
	local w, h = staticPicture:getSize()

	picture.size = Size.new(h * ratio, h)

	grid = window.grid
	containerButtons = window.containerButtons
	
	gridM = window.gridM

	resizeWindow_()

	function grid:onMouseDown(x, y, button)
		onPylonMouseDown(x, y, button)
	end	 
	
	function gridM:onMouseDown(x, y, button)
		onMisPylonMouseDown(x, y, button)
	end	 

	function containerButtons.buttonNew:onChange()
		onNew()
	end

	function containerButtons.buttonCopy:onChange()
		onCopy()
	end

	function containerButtons.buttonDelete:onChange()
		onDel()
	end

	function containerButtons.buttonRename:onChange()
		onRename()
	end

	function containerButtons.buttonExport:onChange()
		onExport()
	end
end

function getNotFixedPayload(rowIndex)
	return grid:getCell(0, rowIndex).fixed ~= true
end

function getCurrentPayloadName()
	local rowIndex = grid:getSelectedRow()

	if -1 < rowIndex  then 
		local payloadName = grid:getCell(0, rowIndex).payloadName
		return grid:getCell(0, rowIndex).payloadName
	end
	return
end

local function createNewNameWindow_()
	local w = 400
	local h = 100

	local result = DialogLoader.spawnDialogFromFile('MissionEditor/modules/dialogs/me_loadout_payload_name.dlg', cdata)

	function result.buttonCancel:onChange()
		result:close()
	end
	
	return result
end

-- модальное окно для задания нового либо правки существующего имени подвески
local function showNewNameWindow_(name, onOkButtonFunc)
	if not newNameWindow then
		newNameWindow = createNewNameWindow_()
		
		newNameWindow.onReturn = function()
			newNameWindow.buttonOk.onChange()
		end
		
		newNameWindow:addHotKeyCallback('escape', newNameWindow.buttonCancel.onChange)
		newNameWindow:addHotKeyCallback('return', newNameWindow.onReturn)
	end

	newNameWindow.buttonOk.onChange = onOkButtonFunc
	newNameWindow.editBoxName:setText(name)

	newNameWindow:centerWindow()
	newNameWindow:setVisible(true)
	-- выход из этой функции произойдет после закрытия окна
end

local function createExportWindow_()
	local result = DialogLoader.spawnDialogFromFile('MissionEditor/modules/dialogs/me_loadout_payload_export.dlg', cdata)

	function result.buttonOk:onChange()
		local item = result.listBoxTasks:getSelectedItem()

		if item then
			local taskId = loadoutUtils.getTaskWorldID(item:getText())
			local payloadName = getCurrentPayloadName()
			
			loadoutUtils.addTaskToPayload(currentUnitType, payloadName, taskId)
			result:setVisible(false)
		end
	end

	function result.buttonCancel:onChange()
		result:close()
	end

	return result
end

-- окно со списком задач, в которые можно импортировать текущую подвеску
local function showExportWindow_()
	if not exportWindow then
		exportWindow = createExportWindow_()
	end

	-- формируем список задач для текущего юнита
	local taskNames = {}
	local taskIds = loadoutUtils.getUnitTasks(currentUnitType)
	
	for i, taskWorldID in pairs(taskIds) do
		-- текущую задачу не добавляем в список
		if taskWorldID ~= currentTaskWorldID then
			local taskName = loadoutUtils.getTaskName(taskWorldID)
			
			table.insert(taskNames, taskName)
		end
	end
	
	table.sort(taskNames)

	-- заполняем список
	U.update_list(exportWindow.listBoxTasks, taskNames)

	exportWindow:centerWindow()
	exportWindow:setVisible(true)
	-- выход из этой функции произойдет после закрытия окна
end

local function getUnitHasPylons(unitType)
	return loadoutUtils.getPylonsCount(unitType) > 0
end

-- создание новой подвески
function onNew()
	-- если юнит не имеет точек подвески, то ничего не делаем
	if not getUnitHasPylons(currentUnitType) then
		return
	end

	local function onChange_()
		if createPayload(newNameWindow.editBoxName:getText()) then
			newNameWindow:setVisible(false)
		end
	end

	-- показываем окно выбора имени подвески
	showNewNameWindow_(cdata.new_payload, onChange_)
end

function onCopy()
	local payloadName = getCurrentPayloadName()
	
	local function onChange_()
		local newName = newNameWindow.editBoxName:getText()
		
		if copyPayload(newName, payloadName) then
			newNameWindow:setVisible(false)
		end 
	end
	
	showNewNameWindow_(cdata.copy_ .. (payloadName or cdata.missionPayload), onChange_)

end

function onDel()
	local rowIndex = grid:getSelectedRow()

	if -1 < rowIndex and getNotFixedPayload(rowIndex) then
		local payloadName = getCurrentPayloadName()
		local caption = cdata.delete_payload
		local text
		
		if currentTaskWorldID == loadoutUtils.getDefaultTaskWorldID() then
			text = cdata.delete_payload .. payloadName .. '?'
		else
			local taskName = loadoutUtils.getTaskName(currentTaskWorldID)
			
			text = string.format(cdata.delete_payload_from_task, payloadName, taskName)
		end
		
		local handler = MsgWindow.question(text, caption, cdata.yes, cdata.no)

		function handler:onChange(buttonText)
			if buttonText == cdata.yes then
				deletePayload(payloadName)
			end
		end

		handler:show()
	end
end

function onRename()
	local rowIndex = grid:getSelectedRow()

	if -1 < rowIndex and getNotFixedPayload(rowIndex) then
		local payloadName = getCurrentPayloadName()
		local function onChange_()
			local newName = newNameWindow.editBoxName:getText()
			
			if renamePayload(newName) then
				newNameWindow:setVisible(false)
			end
		end
		showNewNameWindow_(payloadName, onChange_)
	end
end

function onExport()
	local rowIndex = grid:getSelectedRow()

	if -1 < rowIndex and getNotFixedPayload(rowIndex) then 
		showExportWindow_()
	end
end

function isPayloadNameValid(payloadName)
	if loadoutUtils.getPayloadNamePresented(currentUnitType, payloadName) then
		local caption = cdata.error
		local text = string.format(cdata.payload_name_is_not_unique, payloadName)
		local payloadTaskIds = loadoutUtils.getPayloadTasks(currentUnitType, payloadName)
		local tasksList
		if payloadTaskIds and #payloadTaskIds > 0 then
			tasksList = ''
			
			for i, taskId in ipairs(payloadTaskIds) do
				local taskName = loadoutUtils.getTaskName(taskId)
				
				tasksList = tasksList .. '\n' .. (taskName or "")
			end
		else
			local defaultTaskName = loadoutUtils.getTaskName(loadoutUtils.getDefaultTaskWorldID())
			
			tasksList = '\n' .. defaultTaskName
		end
		
		MsgWindow.error(text .. tasksList, caption, cdata.ok):show()
		
		return false
	end

	if not loadoutUtils.isPayloadNameValid(payloadName) then
		MsgWindow.error(cdata.payload_name_is_not_valid, cdata.error, cdata.ok):show()
		
		return false
	end

	return true 
end

-- создание новой подвески
function createPayload(payloadName)
	local result = isPayloadNameValid(payloadName)
	
	if result then
		-- создаем новую пустую подвеску
		loadoutUtils.addPayload(currentUnitType, payloadName)
		loadoutUtils.addTaskToPayload(currentUnitType, payloadName, currentTaskWorldID)
		
		local row = addPayloadRow(payloadName)

		selectPayload(row)
	end

	return result
end

function renamePayload(newName)
	local payloadName = getCurrentPayloadName()

	if newName == payloadName then -- новое имя совпадает со старым
		return true -- ничего не делаем
	end

	local result = isPayloadNameValid(newName)
	
	if result then
		loadoutUtils.renamePayload(currentUnitType, payloadName, newName)
		vdata.payload = newName

		-- обновляем таблицу
		local row = grid:getSelectedRow()
		local widget = grid:getCell(0, row)
		
		loadoutUtils.setPayloadCell(newName, widget)
	end
	
	return result
end

function addPayloadRow(payloadName)
	-- обновляем таблицу
	-- добавляем строку в таблицу
	grid:insertRow(loadoutUtils.rowHeight)

	local row = grid:getRowCount() - 1

	-- выделяем строку и делаем ее видимой
	grid:setRowVisible(row)

	-- заполняем имя подвески
	local widget = loadoutUtils.createPayloadCell(payloadName)
	
	grid:setCell(0, row, widget)

	-- заполняем ячейки пилонов
	local pylons = loadoutUtils.getUnitPylons(currentUnitType, payloadName)
	local columnCount = grid:getColumnCount()
	
	for pylonNumber, launcherCLSID in pairs(pylons) do
		local column = columnIndexByNumbers[pylonNumber]
		local widget = loadoutUtils.createPylonCell(launcherCLSID, column, row, grid)

		grid:setCell(column, row, widget)
	end
	
	return row
end

function copyPayload(newName, payloadName)
	local result = isPayloadNameValid(newName)
	
	if result then
		if payloadName then
			if payloadName ~= cdata.empty then
				loadoutUtils.copyPayload(currentUnitType, payloadName, newName)
			else
				loadoutUtils.addPayload(currentUnitType, newName)
				loadoutUtils.addTaskToPayload(currentUnitType, newName, currentTaskWorldID)
			end	
		else		
			local missionPylons = gridM:getCell(0, 0).pylons
			loadoutUtils.copyMissionPayload(currentUnitType, missionPylons, currentTaskWorldID, newName)
		end
		
		local row = addPayloadRow(newName)

		selectPayload(row)
	end

	return result
end

function deletePayload(payloadName)
	-- если задача дефолтная, то удаляем подвеску из списка подвесок юнита
	-- иначе удаляем задачу из списка задач подвески
--	local isDefaulTask = (loadoutUtils.getDefaultTaskWorldID() == currentTaskWorldID)
	
--	if isDefaulTask then		
		loadoutUtils.deletePayload(currentUnitType, payloadName)
--	else
--		loadoutUtils.removeTaskFromPayload(currentUnitType, payloadName, currentTaskWorldID)
--	end	
	
	-- текущая подвеска
	local row = grid:getSelectedRow()

	-- новая подвеска
	local newRow

	if grid:getRowCount() - 1 == row then
		-- если строка последняя, то выделяем предыдущую строку
		newRow = row - 1
	else
		-- иначе выделяем следующую подвеску
		newRow = row
	end

	-- удаляем строку из таблицы
	grid:removeRow(row)

	selectPayload(newRow)
end

-- рассчитывает вес подвески
function updatePayloadWeight(a_pylons, a_unitType)
	vdata.weight, vdata.fuel = loadoutUtils.calcPayloadWeight(a_pylons, a_unitType)
	panel_payload.update()
end

-- устанавливаем подвеску в миссии
function selectPayload(row)
    if not window then
		create_()
        update()
	end
	local pylons = {}
	local payloadName = grid:getCell(0, row).payloadName

	if getNotFixedPayload(row) then -- первая строка таблицы - пустая подвеска
		pylons = loadoutUtils.getUnitPylons(currentUnitType, payloadName)
	end

	if loadoutUtils.isUnitHelicopter() or loadoutUtils.isUnitPlane() then
		panel_aircraft.setUnitPayload(pylons, payloadName)
	end

	grid:selectRow(row)
	grid:setRowVisible(row)
    if row ~= 0 then
        panel_payload.setHardpointRacks(true)
        panel_paramFM.updateCtrlEmptyOnly(true)
    end

	updatePayloadWeight(pylons, currentUnitType)
	updateMissionPayload()
end

-- Открытие/закрытие панели
function show(b)
	if not window then
		create_()
	end

	window:setVisible(b)

	if b then
		update()
	end
end

function getUnitsPayload()
    if not window then
		create_()
	end
    return loadoutUtils.getUnitsPayload()
end

-- удаляет оружие у текущего юнита из текущей подвески с пилона pylonNumber
function removePylonLauncher(pylonNumber)
	local payloadName = vdata.payload	
	
	loadoutUtils.removePylonLauncher(currentUnitType, payloadName, pylonNumber)
	
	-- очищаем ячейку таблицы
	grid:setCell(vdata.col, vdata.row, nil)
	selectPayload(vdata.row)
end

function removePylonLauncher2(pylons,pylonNumber)
	local payloadName = vdata.payload	
	
	loadoutUtils.removePylonLauncher(currentUnitType, payloadName, pylonNumber)
	-- очищаем ячейку таблицы
	if -1 < grid:getSelectedRow() then	
		grid:setCell(columnIndexByNumbers[pylonNumber], vdata.row, nil)	
		pylons[pylonNumber] = nil
		selectPayload(vdata.row)
	else
		gridM:setCell(columnIndexByNumbers[pylonNumber], 0, nil)	
		pylons[pylonNumber] = nil
		panel_aircraft.setUnitPayload(pylons, payloadName)
	end
end

function removeRequired(a_pylons,a_launcherCLSIDold, a_pylonNumber)
	for pylonNumber, launcherCLSID in pairs(a_pylons) do
		local proto	= DB.unit_by_type[currentUnitType].Pylons[pylonNumber]
		local launchers = proto.Launchers
		
		for j, load in pairs(launchers) do			
			if load.required and load.CLSID == a_launcherCLSIDold then				
				if pylonNumber == a_pylonNumber and a_pylons[a_pylonNumber] then
					for k, rule in ipairs(load.required) do
						if rule.station then
							removePylonLauncher2(a_pylons, rule.station)							
						end
					end
				end
			end
		end
	end
end

function setGridCell(weapon,column,row, a_grid)
	if not weapon then
		a_grid:setCell(column, row, nil)
	end
	local container = a_grid:getCell(column, row)

	if container then
		loadoutUtils.setPylonCell(container,weapon, column, row, a_grid)
	else
		container = loadoutUtils.createPylonCell(weapon, column, row, a_grid)
		a_grid:setCell(column, row, container)
	end		
end

-- установить оружие у текущего юнита на пилон pylonNumber
function setPylonLauncher(a_pylonNumber, a_launcherCLSID)
	local payloadName = vdata.payload	
	local pylons
	
	if payloadName == cdata.missionPayload then
		pylons = loadoutUtils.getMissionPayload()
		pylons[a_pylonNumber] = a_launcherCLSID
		panel_aircraft.setUnitPayload(pylons)	
	else
		loadoutUtils.setPylonLauncher(currentUnitType, payloadName, a_pylonNumber, a_launcherCLSID)
		pylons = loadoutUtils.getUnitPylons(currentUnitType, payloadName)
	end
	
	local column = vdata.col
	local row    = vdata.row
	
	applyRulesToPylons(a_launcherCLSID, a_pylonNumber, pylons)
	
	for pylonNumber, clsid in base.pairs(pylons) do
		if pylonNumber ~= a_pylonNumber then
			applyRulesToPylons(clsid, pylonNumber, pylons)
		end
	end
	
	if -1 < grid:getSelectedRow() then	
		setGridCell(pylons[a_pylonNumber],column, row, grid)
		selectPayload(row)
	else
		setGridCell(pylons[a_pylonNumber],column, 0, gridM)
	end

	updatePayloadWeight(pylons, currentUnitType)
	updateMissionPayload()
end

function setPylonLauncher2(pylonNumber, launcherCLSID,pylons)
	local payloadName = vdata.payload	
	loadoutUtils.setPylonLauncher(currentUnitType, payloadName, pylonNumber, launcherCLSID)
	local column = columnIndexByNumbers[pylonNumber]
	local row    = vdata.row
	pylons[pylonNumber] = launcherCLSID

	if -1 < grid:getSelectedRow() then
		setGridCell(pylons[pylonNumber],column, row, grid)
		selectPayload(row)
	else
		setGridCell(pylons[pylonNumber],column, 0, gridM)
		panel_aircraft.setUnitPayload(pylons)	
	end
	
	updateMissionPayload()
end

function applyForbiddenRule(forbiddenRule, pylons)
	local pylonNumber = forbiddenRule.station
	local launcherCLSID = pylons[pylonNumber]
	
	if launcherCLSID then
		local forbiddenLauncherCLSIDs = forbiddenRule.loadout
		
		if forbiddenLauncherCLSIDs then
			for i, forbiddenLauncherCLSID in pairs(forbiddenLauncherCLSIDs) do
				if launcherCLSID == forbiddenLauncherCLSID then
					removePylonLauncher2(pylons,pylonNumber)
					return
				end
			end
		else
			removePylonLauncher2(pylons,pylonNumber)
		end
	end
end

function applyRequiredRule(requiredRule, pylons)
	local pylonNumber    = requiredRule.station
	local launcherCLSID  = pylons[pylonNumber]
	local requiredCLSIDs = requiredRule.loadout

	if requiredRule.loadout then
		local first
		for i, o in ipairs(requiredRule.loadout) do
			if not first then
			   first = o
			end

			if launcherCLSID == o then				
				return true
			end
		end
		if first then			
		    setPylonLauncher2(pylonNumber,first,pylons)
			return true
		end
	end
	return false
end

function applyRulesToPylons(a_launcherCLSID, a_pylonNumber, a_pylons)
	local unitDef = DB.unit_by_type[currentUnitType]
	local proto	= unitDef.Pylons[a_pylonNumber]
	local launchers = proto.Launchers
	
	for j, load in pairs(launchers) do
		if load.required and load.CLSID == a_launcherCLSID then
			for k, rule in ipairs(load.required) do
				applyRequiredRule(rule, a_pylons)
			end
		end
		
		if load.forbidden and load.CLSID == a_launcherCLSID then
			for k, rule in ipairs(load.forbidden) do
				applyForbiddenRule(rule, a_pylons)
			end
		end
	end
end

function menuOnChange(self, item)
	if item.removeLauncher then -- проверяем специальный флаг
		if -1 == grid:getSelectedRow() then
			-- подвеска миссии
			local pylons = loadoutUtils.getMissionPayload()
			local launcherCLSID = pylons[item.pylonNumber]						
			removeRequired(pylons, launcherCLSID, item.pylonNumber)
			pylons[item.pylonNumber] = nil
			panel_aircraft.setUnitPayload(pylons)
			updatePayloadWeight(pylons, currentUnitType)
			updateMissionPayload()			
		else
			-- список подвесок
			local pylons = loadoutUtils.getUnitPylons(currentUnitType, vdata.payload)	
			local launcherCLSID = pylons[item.pylonNumber]
			
			removePylonLauncher(item.pylonNumber)
			removeRequired(pylons, launcherCLSID, item.pylonNumber)
		end		
	end
	if item.clean then 
		setPylonLauncher(item.pylonNumber, item.launcherCLSID)
	end
end

function submenuOnChange(item)
	setPylonLauncher(item.pylonNumber, item.launcherCLSID)
end

function onMisPylonMouseDown(x, y, button)
	if 3 == button then
		local col, row = gridM:getMouseCursorColumnRow(x, y) 
		
		if row < 0 then
			return
		end
		
		if col > 0 then -- первая ячейка - это название подвески
			local columns = gridM:getColumnCount()
			local pylonNumber = numbersByColumnIndex[col]

			vdata.col = col
			vdata.row = -1
			vdata.pylon = pylonNumber
			vdata.payload = gridM:getCell(0, row).payloadName
			-- формируем меню
			local menu = loadoutUtils.createPylonMenu(currentUnitType, pylonNumber, menuOnChange, submenuOnChange, vdata.payload)
			-- позиционируем меню
			local w, h = menu:getSize()
			menu:setBounds(x, y, w, h)
			menu:setVisible(true)
		end			
	end
	gridM:selectRow(0)
	grid:selectRow(-1) -- сбрасываем выделение в списке подвесок
end

function onPylonMouseDown(x, y, button)
	if 1 == button then
		local col, row = grid:getMouseCursorColumnRow(x, y)

		if -1 < row then
			selectPayload(row)
		end
	elseif 3 == button then
		local col, row = grid:getMouseCursorColumnRow(x, y) 
		
		if row < 0 then
			return
		end
		
		if col > 0 then -- первая ячейка - это название подвески
			if getNotFixedPayload(row) then -- первая строка пустая подвеска - редактировать ее нельзя
				local columns = grid:getColumnCount()
				local pylonNumber = numbersByColumnIndex[col]

				vdata.col = col
				vdata.row = row
				vdata.pylon = pylonNumber
				vdata.payload = grid:getCell(0, row).payloadName
				-- формируем меню
				local menu = loadoutUtils.createPylonMenu(currentUnitType, pylonNumber, menuOnChange, submenuOnChange, vdata.payload)
				-- позиционируем меню
				local w, h = menu:getSize()
				menu:setBounds(x, y, w, h)
				menu:setVisible(true)
			end
		end	
		
		selectPayload(row)
	end
	gridM:selectRow(-1) -- сбрасываем выделение в подвеске миссии
end

function getUnitImageFilename()
	local unit = DB.unit_by_type[currentUnitType]
	assert(unit, currentUnitType .. "!unit_by_type[]")
	local filename = unit.Picture or ''

	return filename
end

function updateImage()
	picture.file = getUnitImageFilename()
	staticPicture:setSkin(staticPictureSkin)
end

function createColumns()
	columnIndexByNumbers = {}
	numbersByColumnIndex = {}
	local names = loadoutUtils.getPylonsNames(currentUnitType)
	local count = #names
	local leftColumnWidth = loadoutUtils.nameColumnWidth
	if count > 0 then
		-- выравниваем колонки посередине изображения
		local ix, iy, iw, ih = staticPicture:getBounds()	 
		local gx,gy,gw,gh    = grid:getBounds();
		local center = ix + iw / 2
		 
		leftColumnWidth = math.max(((ix-gx) + iw - (count * loadoutUtils.columnWidth)) / 2, loadoutUtils.nameColumnWidth)
	end
	grid:insertColumn(leftColumnWidth)
	gridM:insertColumn(leftColumnWidth)
	local index = 0
	for i = #names, 1, -1 do
		local pylon = names[i]	
		index = index + 1
		local columnHeader = gridHeaderCell_:clone()
		
		columnHeader:setText(pylon.DisplayName)
		columnHeader:setVisible(true)
		
		columnIndexByNumbers[pylon.Number] = index
		numbersByColumnIndex[index] = pylon.Number
		
		grid:insertColumn(loadoutUtils.columnWidth, columnHeader, index)
		gridM:insertColumn(loadoutUtils.columnWidth, columnHeader:clone(), index)
	end
end

function updateMissionPayload()
	
	local missionPayload = loadoutUtils.getMissionPayload()
	
	-- отдельная таблица подвески миссии
	local widgetM = gridM:getCell(0, 0)
	widgetM.pylons = missionPayload
	
	for i = 1, gridM:getColumnCount() -1 do
		gridM:setCell(i, 0, nil)
	end
	
	for pylonNumber, launcherCLSID in pairs(missionPayload) do
		local column = columnIndexByNumbers[pylonNumber]
		if column then
			widgetM = loadoutUtils.createPylonCell(launcherCLSID, column, 0, gridM)
			gridM:setCell(column, 0, widgetM)
		end
	end
end

function createRows()
	-- первой строкой делаем текущую подвеску 
	local rowHeight = loadoutUtils.rowHeight
	local row = 0
	
	-- текущая подвеска
	local missionPayload = loadoutUtils.getMissionPayload()

	-- отдельная подвеска миссии
	gridM:insertRow(rowHeight, row)
	local widgetM = loadoutUtils.createPayloadCell(cdata.missionPayload)
	widgetM.payloadName = cdata.missionPayload
	widgetM.pylons = missionPayload
	gridM:setCell(0, row, widgetM)
	for pylonNumber, launcherCLSID in pairs(missionPayload) do
		local column = columnIndexByNumbers[pylonNumber]
		if column then
			widgetM = loadoutUtils.createPylonCell(launcherCLSID, column, row, gridM)
			gridM:setCell(column, row, widgetM)
		end
	end
	
	gridM:selectRow(1)
	gridM:setRowVisible(row)
	--
	
	updatePayloadWeight(missionPayload, currentUnitType)

	--  grid подвесок
	grid:insertRow(rowHeight, row)
	local widget = loadoutUtils.createPayloadCell(cdata.empty)
	widget.fixed = true
	grid:setCell(0, row, widget)

	local columnCount = grid:getColumnCount()
	local payloadNames = loadoutUtils.getUnitPayloadNames(currentUnitType, currentTaskWorldID) or {}
	
	local selectPayloadName
	for i, payloadName in ipairs(payloadNames) do
		local pylons = loadoutUtils.getUnitPylons(currentUnitType, payloadName)

		if loadoutUtils.arePylonsEqual(missionPayload, pylons) then
			selectPayloadName = payloadName						
		end
	end	
	
	if selectPayloadName == nil then
		local n = 0
		for k,v in base.pairs(missionPayload) do
			n = n + 1
		end
		if n == 0 then
			selectPayloadName = cdata.empty
		end
	end

	for i, payloadName in ipairs(payloadNames) do
		row = row + 1
		grid:insertRow(rowHeight, row)
		-- имя
		widget = loadoutUtils.createPayloadCell(payloadName)
		grid:setCell(0, row, widget)

		local pylons = loadoutUtils.getUnitPylons(currentUnitType, payloadName)

		for pylonNumber, launcherCLSID in pairs(pylons) do
			local column = columnIndexByNumbers[pylonNumber]
			if column then
				widget = loadoutUtils.createPylonCell(launcherCLSID, column, row, grid)
				grid:setCell(column, row, widget)
			end
		end
		if payloadName == selectPayloadName then
			grid:selectRow(row)
			grid:setRowVisible(row)
			updatePayloadWeight(pylons, currentUnitType)
		end
	end
	
	if selectPayloadName == cdata.empty then
		selectPayload(0)
	end
end

function updateGrid()
	grid:clear()
	gridM:clear()
	createColumns()
	createRows()
end

function update()
    if base.panel_route.vdata.unit and base.panel_route.vdata.unit.type then
        local unitType = base.panel_route.vdata.unit.type
        if (base.me_db.helicopter_by_type[unitType] ~= nil
              or  base.me_db.plane_by_type[unitType] ~= nil) then
            currentUnitType = unitType
            
            local currentTaskName = loadoutUtils.getCurrentTaskName()
            
            currentTaskWorldID = loadoutUtils.getTaskWorldID(currentTaskName)
            
            updateImage()
            updateGrid()
        end
    end
end

function getVisible()
	return window and window:getVisible()
end