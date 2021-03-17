local DialogLoader	= require('DialogLoader')
local Factory		= require('Factory')
local SkinUtils		= require('SkinUtils')
local dxgui			= require('dxgui')

local function alignmentButtons(self)

    local _tmp,y = self.leftBtn:getBounds()

    local leftBtnW, leftBtnH = self.leftBtn:calcSize()
    local middleBtnW, middleBtnH  = self.middleBtn:calcSize()
    local rightBtnW, rightBtnH = self.rightBtn:calcSize()
    
    local middleBtnX    = (self.width - middleBtnW)/2
    local offset		= math.max(leftBtnW,rightBtnW) + middleBtnW / 2 + 20
    local rightBtnX     = self.width/2 + offset - rightBtnW
    local leftBtnX      = self.width/2 - offset
    
    self.middleBtn:setBounds(middleBtnX, y, middleBtnW, middleBtnH)
    self.rightBtn:setBounds(rightBtnX, y, rightBtnW, rightBtnH)
    self.leftBtn:setBounds(leftBtnX, y, leftBtnW, leftBtnH)
end

local function construct(self, localization)
	local templateWindow = DialogLoader.spawnDialogFromFile('MissionEditor/modules/dialogs/me_dialog_template.dlg', localization)
	local width, height = dxgui.GetWindowSize()
	
	templateWindow:setBounds(0, 0, width, height)

	self.clientWidth, self.clientHeight = templateWindow:getClientRectSize()

	local container_top = templateWindow.container_top

	self.staticLogo = container_top.staticLogo
	self.staticText = container_top.staticText

	local container_bottom = templateWindow.container_bottom

	self.leftBtn = container_bottom.leftBtn
	self.middleBtn = container_bottom.middleBtn
	self.rightBtn = container_bottom.rightBtn

	self.templateWindow = templateWindow
    self.width = width
    
    alignmentButtons(self)

	return templateWindow
end

local function setContainerMain(self, dialog)
	local containerMain = dialog.containerMain

	self.templateWindow.containerMain = containerMain
	self.templateWindow.panelCenter:insertWidget(containerMain)

	dialog:removeWidget(containerMain)
end

local function getWindow(self)
	return self.templateWindow
end

local function getContainerMain(self)
	return self.templateWindow.containerMain
end

local function getLeftButton(self)
	return self.leftBtn
end

local function getMiddleButton(self)
	return self.middleBtn
end

local function getRightButton(self)
	return self.rightBtn
end

local function setCaption(self, text)
	self.staticText:setText(text)
end

local function setContainerMainVertOffset(self, offset)
	-- FIXME: исправить диалог дебрифинга, чтобы убрать этот костыль
	local layout = self.templateWindow.panelCenter:getLayout()

	if layout then
		if 'horz' == layout:getType() then
			local vertAlign = layout:getVertAlign()

			vertAlign.offset = offset
			layout:setVertAlign(vertAlign)
		end
	end
end

return Factory.createClass({
	construct			= construct,
	setContainerMain	= setContainerMain,
	getWindow			= getWindow,
	getContainerMain	= getContainerMain,
	getLeftButton		= getLeftButton,
	getMiddleButton		= getMiddleButton,
	getRightButton		= getRightButton,
	setCaption			= setCaption,
    alignmentButtons    = alignmentButtons,
	
	setContainerMainVertOffset = setContainerMainVertOffset,
})