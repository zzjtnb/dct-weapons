local DialogLoader	= require('DialogLoader')
local Button		= require('Button')
local Skin			= require('Skin')
local SkinUtils		= require('SkinUtils')
local i18n			= require('i18n')
local OptionsData   = require('Options.Data')
local U             = require('me_utilities')
local UpdateManager = require('UpdateManager')

local _ = i18n.ptranslate

local initialBounds_
local window_
local editBoxName_
local spinBoxRadius_
local spinBoxRed_
local spinBoxGreen_
local spinBoxBlue_
local spinBoxAlpha_
local panelColorButtons_
local staticColorView_
local staticColorViewSkin_
local checkBoxHidden_
local controller_
local triggerZoneId_
local properties_

local function setController(controller)
	controller_ = controller
end

local function create(...)
	initialBounds_ = {...}
end

local function bindColorWidgets()
	local onSpinBoxColorChange = function()
		if controller_ then
			controller_.setTriggerZoneColor(triggerZoneId_, 
											spinBoxRed_		:getValue()	/ 255, 
											spinBoxGreen_	:getValue()	/ 255, 
											spinBoxBlue_	:getValue()	/ 255, 
											spinBoxAlpha_	:getValue()	/ 255)
		end
	end
	
	function spinBoxRed_:onChange()
		onSpinBoxColorChange()
	end
	
	function spinBoxGreen_:onChange()
		onSpinBoxColorChange()
	end
	
	function spinBoxBlue_:onChange()
		onSpinBoxColorChange()
	end
	
	function spinBoxAlpha_:onChange()
		onSpinBoxColorChange()
	end
end

local function bindControls()
	function spinBoxRadius_:onChange()
		if controller_ then
			controller_.setTriggerZoneRadius(triggerZoneId_, spinBoxUnitRadius_:getValue())
		end
	end
	
	function editBoxName_:onFocus(focused)
		if not focused then
			if controller_ then
				controller_.setTriggerZoneName(triggerZoneId_, self:getText())
			end
		end
	end
	
	function editBoxName_:onKeyDown(key, unicode)
		if 'return' == key then
			if controller_ then
				controller_.setTriggerZoneName(triggerZoneId_, self:getText())
			end
		end
	end
	
	function checkBoxHidden_:onChange()
		if controller_ then
			controller_.setTriggerZoneHidden(triggerZoneId_, self:getState())
		end		
	end
	
	bindColorWidgets()
end

local function createColorButtons(panel)
	local colors = {
		{{	0,	 0,	  0},	{128, 128, 128},	{128,	0,	 0},	{128, 128,	 0}},
		{{	0, 128,	  0},	{  0, 128, 128},	{  0,	0, 128},	{128,	0, 128}},
		{{128, 128,	 64},	{  0,  64,	64},	{  0, 128, 255},	{  0,  64, 128}},
		{{128,	 0, 255},	{128,  64,	 0},	{255, 255, 255},	{192, 192, 192}},
		{{255,	 0,	  0},	{255, 255,	 0},	{  0, 255,	 0},	{  0, 255, 255}},
		{{	0,	 0, 255},	{255,	0, 255},	{255, 255, 128},	{  0, 255, 128}},
		{{128, 255, 255},	{128, 128, 255},	{255,	0, 128},	{225, 128, 164}},
	}
	local width, height = panel:getSize()
	local buttonHeight	= height / #colors
	local buttonWidth	= width / #colors[1]
	local buttonSkin	= Skin.buttonSkin()
	
	for i, colorRow in ipairs(colors) do
		for j, color in ipairs(colorRow) do
			local button = Button.new()
			local x = buttonWidth * (j - 1)
			local y = buttonHeight * (i - 1)
			
			button:setBounds(x , y, buttonWidth, buttonHeight)
			panel:insertWidget(button)
			
			button:setSkin(SkinUtils.setButtonColor(string.format('0x%.2x%.2x%.2xff', color[1], color[2], color[3]), buttonSkin))
			
			function button:onChange()
				if controller_ then
					controller_.setTriggerZoneColor(triggerZoneId_, color[1] / 255, color[2] / 255, color[3] / 255, spinBoxAlpha_:getValue() / 255)
				end
			end
		end
	end
end

local function getDefaulName(rowIndex)
	local result = "PROPERTY_"..rowIndex 

	return result
end

local hide
local function create_()
	local localization = {
		title	= _('TRIGGER ZONE'),
		name	= _('NAME'),
		radius	= _('RADIUS'),
		color	= _('COLOR'),
		apply	= _('APPLY'),
		undo	= _('UNDO'),
		hidden	= _('HIDDEN'),
		Name	= _('Name'),
		Value	= _('Value'),
		add 	= _('Add'),
		remove	= _('Remove'),
	}
	
	window_ = DialogLoader.spawnDialogFromFile('./MissionEditor/modules/dialogs/me_trigger_zone_panel.dlg', localization)
	
	if initialBounds_ then
		window_:setBounds(unpack(initialBounds_))
		w_=initialBounds_[3]
	end
	
	editBoxName_			= window_.editBoxName
	spinBoxRadius_			= window_.spinBoxRadius
	spinBoxRed_				= window_.spinBoxRed
	spinBoxGreen_			= window_.spinBoxGreen
	spinBoxBlue_			= window_.spinBoxBlue
	spinBoxAlpha_			= window_.spinBoxAlpha
	panelColorButtons_		= window_.panelColorButtons
	staticColorView_		= window_.staticColorView
	staticColorViewSkin_	= staticColorView_:getSkin()
	checkBoxHidden_			= window_.checkBoxHidden
    sTextRadius             = window_.text_radius
	panelCustom 			= window_.panelCustom
	Grid 					= panelCustom.Grid
	btnAdd 					= panelCustom.btnAdd
	buttonUp 				= panelCustom.buttonUp
	buttonDown 				= panelCustom.buttonDown
	
	eItemSkin 				= window_.pNoVisible.eItem:getSkin()
	btnDelSkin				= window_.pNoVisible.btnDel:getSkin()
    
    spinBoxUnitRadius_= U.createUnitSpinBox(sTextRadius, spinBoxRadius_, U.altitudeUnits, 5, 10000000)
    updateUnitSystem()
	
	function window_:onClose()
	   hide()
	   MapWindow.expand()
	end

	createColorButtons(panelColorButtons_)
	bindControls()
	
	

	function btnAdd:onChange(self)
		properties_ = properties_ or {}
		local cell1 = insertRow(getDefaulName(Grid:getRowCount()+1), "")
		Grid:selectRow(Grid:getRowCount()-1)
		Grid:setRowVisible(Grid:getRowCount()-1)
		cell1:setFocused(true)
		cell1:setSelectionNew(0, cell1:getLineTextLength(0), 0, cell1:getLineTextLength(0))
	end
	
	function buttonUp:onChange(self)
		local index = Grid:getSelectedRow()

		if index > 0 then
			UpdateManager.add(function()
				local index = Grid:getSelectedRow()
				local tmp = {}
				U.recursiveCopyTable(tmp, properties_[index+1]) 
				properties_[index+1] = properties_[index]
				properties_[index] = tmp
				if controller_ then
					controller_.setTriggerZoneProperties(triggerZoneId_, properties_)
				end
				updateGrid()
				Grid:selectRow(index-1)
				return true
			end) 
		end
	end

	function buttonDown:onChange(self)
		local index = Grid:getSelectedRow()

		if index >= 0 and index < Grid:getRowCount()-1 then
			UpdateManager.add(function()
				local index = Grid:getSelectedRow()
				local tmp = {}
				U.recursiveCopyTable(tmp, properties_[index+2]) 
				properties_[index+2] = properties_[index+1]
				properties_[index+1] = tmp
				if controller_ then
					controller_.setTriggerZoneProperties(triggerZoneId_, properties_)
				end
				updateGrid()
				Grid:selectRow(index+1)
				return true
			end) 
		end
	end	

	function Grid:onMouseDown(x, y, button)
		if 1 == button then
			local col
			col, rowLast = self:getMouseCursorColumnRow(x, y)
			if -1 < col and -1 < rowLast then
				self:selectRow(rowLast)
			end
		end
	end
end

local function updateEditBoxName()
	editBoxName_:setText(controller_.getTriggerZoneName(triggerZoneId_))
end

local function updateSpinBoxRadius()
	spinBoxUnitRadius_:setValue(controller_.getTriggerZoneRadius(triggerZoneId_))
end

local function updateCheckBoxHidden()
	checkBoxHidden_:setState(controller_.getTriggerZoneHidden(triggerZoneId_))
end

local function updateColorWidgets()
	if window_ == nil or window_:getVisible() == false then
		return
	end

	local r, g, b, a = controller_.getTriggerZoneColor(triggerZoneId_)
	
	r = math.floor(r * 255)
	g = math.floor(g * 255)
	b = math.floor(b * 255)
	a = math.floor(a * 255)
	
	spinBoxRed_		:setValue(r)
	spinBoxGreen_	:setValue(g)
	spinBoxBlue_	:setValue(b)
	spinBoxAlpha_	:setValue(a)
	
	local hexColor = string.format('0x%.2x%.2x%.2x%.2x', r, g, b, a)
	
	staticColorView_:setSkin(SkinUtils.setStaticColor(hexColor, staticColorViewSkin_))
end

local function updateWidgets()
	updateEditBoxName()
	updateSpinBoxRadius()
	updateCheckBoxHidden()
	updateColorWidgets()
	
	updateGrid()
end

local function enableWidgets(enabled)
	editBoxName_		:setEnabled(enabled)
	spinBoxRadius_		:setEnabled(enabled)
	spinBoxRed_			:setEnabled(enabled)
	spinBoxGreen_		:setEnabled(enabled)
	spinBoxBlue_		:setEnabled(enabled)
	spinBoxAlpha_		:setEnabled(enabled)
	panelColorButtons_	:setEnabled(enabled)
	staticColorView_	:setEnabled(enabled)
	checkBoxHidden_		:setEnabled(enabled)
	panelCustom			:setEnabled(enabled)
end

local function needUpdate()
	return window_ and window_:getVisible() and controller_
end

local function setDefaultValue()
	Grid:clearRows()
    editBoxName_:setText("")
    spinBoxUnitRadius_:setValue(3000)
    checkBoxHidden_:setState(false)
    spinBoxRed_		:setValue(255)
    spinBoxGreen_	:setValue(255)
    spinBoxBlue_	:setValue(255)
    spinBoxAlpha_	:setValue(38)
    staticColorView_:setSkin(SkinUtils.setStaticColor('0xffffff26', staticColorViewSkin_))  
end

local function update()
	if needUpdate() then		
		if triggerZoneId_ then
			enableWidgets(true)
			updateWidgets()			
		else
            setDefaultValue()  
			enableWidgets(false)
		end
	end	
	
end

local function setTriggerZoneId(a_triggerZoneId)
	triggerZoneId_ = a_triggerZoneId
	update()
end

local function getTriggerZoneId()
	return triggerZoneId_
end

local function triggerZoneNameChanged()
	if needUpdate() and triggerZoneId_ then
		updateEditBoxName()
	end
end

local function triggerZoneRadiusChanged()
	if needUpdate() and triggerZoneId_ then
		updateSpinBoxRadius()
	end	
end

local function triggerZoneColorChanged()
	if needUpdate() and triggerZoneId_ then
		updateColorWidgets()
	end		
end

local function triggerZoneHiddenChanged()
	if needUpdate() and triggerZoneId_ then
		updateCheckBoxHidden()
	end		
end

local function triggerZonePropertiesChanged()
	if needUpdate() and triggerZoneId_ then
		updateGrid()
	end	
end	

local function show()
	if not window_ then
		create_()
	end
	
	if not window_:getVisible() then
		MapWindow.collapse(w_, 0)
        updateUnitSystem()
		window_:setVisible(true)
		
		update(triggerZoneId_)
		
		if controller_ then
			controller_.onTriggerZonePanelShow()
		end		
	end
end

-- ��������� ����
hide = function()
	if window_ then		
		if window_:getVisible() then
			MapWindow.expand()
			window_:setVisible(false)
			
			if controller_ then
				controller_.onTriggerZonePanelHide()
			end			
		end	
	end	
end

local function getWindowSize()
	if window_ then
		return window_:getSize()
	end
	
	return 0, 0
end

function updateUnitSystem()
	local unitSystem = OptionsData.getUnits()
	
	spinBoxUnitRadius_:setUnitSystem(unitSystem)    
end
	
function insertRow(a_propName, a_value)
	local rowIndex = Grid:getRowCount()
	local optIndex = rowIndex + 1
    Grid:insertRow(20,rowIndex)
	  
    ------1
	local cell_1
    cell_1 = EditBox.new()
	cell_1:setSkin(eItemSkin)   
	cell_1:setText(a_propName)	
	cell_1.propName = a_propName
	cell_1.optIndex = optIndex
	cell_1.onChange = function(self)
		properties_[self.optIndex]["key"] = self:getText()
		if controller_ then
			controller_.setTriggerZoneProperties(triggerZoneId_, properties_)
		end
		self.propName = self:getText()
    end
    Grid:setCell(0, rowIndex, cell_1)
    
    ------2
	local cell_2
    cell_2 = EditBox.new()
	cell_2:setSkin(eItemSkin)
	cell_2.firstCall = cell_1
	cell_2.propName = a_propName	
    cell_2.onChange = function(self)
		properties_[self.firstCall.optIndex]["value"] = self:getText()
		if controller_ then
			controller_.setTriggerZoneProperties(triggerZoneId_, properties_)
		end
    end
    
	cell_2:setText(a_value)
    Grid:setCell(1, rowIndex, cell_2)
	
	------3
	local cell_3
    cell_3 = Button.new()
	cell_3:setSkin(btnDelSkin) 
	cell_3.propName = a_propName	
    cell_3.onChange = function(self)
		UpdateManager.add(function()
			local index = Grid:getSelectedRow()
			table.remove(properties_, index+1)
			if controller_ then
				controller_.setTriggerZoneProperties(triggerZoneId_, properties_)
			end
			updateGrid()
			return true 
		end) 
    end
	cell_3:setText(a_value)
    Grid:setCell(2, rowIndex, cell_3)
	
	properties_[optIndex] = properties_[optIndex] or {}
	properties_[optIndex]["key"] = cell_1:getText()
	properties_[optIndex]["value"] = cell_2:getText()
	
	return cell_1
end


function updateGrid() 
	Grid:clearRows()
	properties_ = {}
	if triggerZoneId_ then
		properties_ = controller_.getTriggerZoneProperties(triggerZoneId_)
	end
	
	if properties_ then
		for k,v in ipairs(properties_) do
			insertRow(v.key, v.value)
		end
	end	
end	



return {
	setController				= setController,
	create						= create,
	show						= show,
	hide						= hide,
	getWindowSize				= getWindowSize,
	setTriggerZoneId			= setTriggerZoneId,
	getTriggerZoneId			= getTriggerZoneId,
	triggerZoneNameChanged		= triggerZoneNameChanged,
	triggerZoneRadiusChanged	= triggerZoneRadiusChanged,
	triggerZoneColorChanged		= triggerZoneColorChanged,
	triggerZoneHiddenChanged	= triggerZoneHiddenChanged,
	triggerZonePropertiesChanged= triggerZonePropertiesChanged,
}