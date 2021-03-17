local Gui					= require('dxgui')
local InputData 			= require('Input.Data')
local ProfileDatabase		= require('Input.ProfileDatabase')
local i18n					= require('i18n')
local lfs					= require('lfs')
local InputUtils			= require('Input.Utils')
local MeSettings			= require('MeSettings')
local MsgWindow				= require('MsgWindow')
local UpdateManager			= require('UpdateManager')

local _ 					= i18n.ptranslate
local userConfigPath_ 		= lfs.writedir() .. 'Config/Input/'
local sysConfigPath_ 		= './Config/Input/'
local savedUnitFilename_ 	= 'unit.lua'
local container_
local controller_
local inputView_
local inputClassicView_
local inputFoldableView_
local popupMenuAnnouncementShown_

local function loadProfiles_()
	InputData.initialize(userConfigPath_, sysConfigPath_)

	local pluginPaths = custom_input_profiles
	local profileInfos = {
		ProfileDatabase.createDefaultAircraftProfileInfo(sysConfigPath_),
		ProfileDatabase.createUiLayerProfileInfo(sysConfigPath_),
	}
	
	ProfileDatabase.createPluginProfileInfos(pluginPaths, profileInfos)

	for i, profileInfo in ipairs(profileInfos) do
		InputData.createProfile(profileInfo)
	end
end

local function getCurrentDeviceName()
	return inputView_:getCurrentDeviceName()
end

local function getCurrentProfileName()
	return inputView_:getCurrentProfileName()
end

-- ���������� ����
local switchToFoldableView
local function switchToClassicView()
	if not inputClassicView_ then
		local InputView 	= require('Input.View')
		
		inputClassicView_	= InputView.new()
		inputClassicView_:setFoldableViewFunc(switchToFoldableView)	
		
		local parentContainer = container_.parentContainer
		local x, y = container_:getPosition()
		local container = inputClassicView_:getContainer()
		
		container:setPosition(x, y)
		parentContainer:insertWidget(container)	
	end
	
	inputClassicView_:setCurrentProfileName(inputView_:getCurrentProfileName())
	
	-- ������� ��������� �� �������, � ������ ������
	inputView_:deactivate()
	container_:setVisible(false)
	
	inputView_ = inputClassicView_
	container_ = inputView_:getContainer()
	
	inputView_:activate()
	container_:setVisible(true)
	
	MeSettings.setShowFoldableView(false)
end

-- ��������� ����
function switchToFoldableView()
	if not inputFoldableView_ then
		local FoldableView	= require('Input.FoldableView')
		
		inputFoldableView_ = FoldableView.new()
		inputFoldableView_:setClassicViewFunc(switchToClassicView)
		
		local parentContainer = container_.parentContainer
		local x, y = container_:getPosition()
		local container = inputFoldableView_:getContainer()
		
		container:setPosition(x, y)
		parentContainer:insertWidget(container)
	end	
	
	inputFoldableView_:setCurrentProfileName(getCurrentProfileName())
	
	-- ������� ��������� �� �������, � ������ ������
	inputView_:deactivate()
	container_:setVisible(false)
	
	inputView_ = inputFoldableView_
	container_ = inputView_:getContainer()
	
	inputView_:activate()
	container_:setVisible(true)
	
	MeSettings.setShowFoldableView(true)
end

local function createInputView_()
	local InputLoader	= require('Input.Loader')
	
	-- �� ����� �� ������� ���� �������� 
	-- ���������� ������������ ��������� ����� ����������
	InputLoader.loadUiLayer(sysConfigPath_)
	
	if MeSettings.getShowFoldableView() then
		local FoldableView	= require('Input.FoldableView')
		
		inputFoldableView_	= FoldableView.new()
		inputView_ 			= inputFoldableView_
		inputFoldableView_:setClassicViewFunc(switchToClassicView)
		
	else
		local InputView 	= require('Input.View')
		
		inputClassicView_	= InputView.new()
		inputView_ 			= inputClassicView_

		inputClassicView_:setFoldableViewFunc(switchToFoldableView)		
	end
	
	local unitName		= MeSettings.getControlsTabUnitName()
	local profileName	= InputData.getProfileNameByUnitName(unitName)
	
	inputView_:setCurrentProfileName(profileName or InputData.getDefaultProfileName())
end

local function create_()
	local hwnd = Gui.GetWindowHandle()
	
	InputUtils.initializeInput(hwnd)
	
	loadProfiles_()
	createInputView_()
end

local function getContainer()
	return container_
end

local function updateCurrentProfile()
	inputView_:setCurrentProfileName(inputView_:getCurrentProfileName())
end

local function showPopupMenuAnnouncement()
	if not popupMenuAnnouncementShown_ then
		popupMenuAnnouncementShown_ = true
		
		local hidePopupMenuAnnouncement = MeSettings.getControlsTabHidePopupMenuAnnouncement()
		
		if not hidePopupMenuAnnouncement then
			UpdateManager.add(function()
				local text		= _('You can assign commands via popup menus using right mouse button.\nYou can handle categories via menu from device column header.')
				local caption	= _('Do you know...')
				local handler	= MsgWindow.info(text, caption, _('OK'))
				
				-- ��������� �������� � ������� �� ��������
				local dialog	= DialogLoader.spawnDialogFromFile('./Scripts/Input/PopupMenuHelp.dlg')
				local checkBox	= dialog.checkBoxShowNextTime
				
				checkBox:setText(_('Show next time'))
				
				handler:addWidget(dialog.staticPicture)
				handler:addWidget(checkBox)
				
				-- ������ �������� ������ �� �����
				dialog:kill()
				
				function handler:onClose()
					MeSettings.setControlsTabHidePopupMenuAnnouncement(not checkBox:getState())
					
					return false
				end
	
				function handler:onChange(text)
					if text == _('OK') then
						MeSettings.setControlsTabHidePopupMenuAnnouncement(not checkBox:getState())
					end	
				end
				
				handler:show()
				
				return true
			end)
		end	
	end
end

local function show()
	if not container_ then
		create_()
		container_ = inputView_:getContainer()
	else
		-- ��������� ����������� ����� ���� �������� � ����������
		if MeSettings.getShowFoldableView() then
			if inputView_ == inputClassicView_ then
				switchToFoldableView()			
			end
		else
			if inputView_ == inputFoldableView_ then
				switchToClassicView()
			end	
		end
		
		updateCurrentProfile()
	end
	
	inputView_:activate()
	showPopupMenuAnnouncement()
	container_:setVisible(true)
end	

local function hide()
	inputView_:deactivate()
	container_:setVisible(false)
end

local function getUiProfileChanged()
	local uiProfileName = ProfileDatabase.getUiProfileName()

	for i, profileName in ipairs(InputData.getProfileNames()) do
		if InputData.getProfileChanged(profileName) then
		
			if profileName == uiProfileName then
				return true
			end
		end
	end
	
	return false
end

local function save()
	if container_ then
		local reloadUiLayer = getUiProfileChanged()
		
		InputData.saveChanges()
		
		if reloadUiLayer then
			local InputLoader = require('Input.Loader')
			
			InputLoader.loadUiLayer(sysConfigPath_)
		end
		
		local profileName = inputView_:getCurrentProfileName()
		local unitName = InputData.getProfileUnitName(profileName)
		
		MeSettings.setControlsTabUnitName(unitName)
	end
end

local function setController(controller)
	controller_ = controller
	
	if container_ then
		InputData.setController(controller)
	end
end

return {
	getContainer 			= getContainer,
	show					= show,
	hide					= hide,
	save					= save,
	updateCurrentProfile	= updateCurrentProfile,
	setController			= setController,
	getCurrentDeviceName	= getCurrentDeviceName, -- ������������ � Utils/Input/CreateDefaultDeviceLayout.lua
	getCurrentProfileName	= getCurrentProfileName,-- ������������ � Utils/Input/CreateDefaultDeviceLayout.lua
}
