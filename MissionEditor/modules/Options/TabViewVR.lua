local base = _G

local require			= base.require
local string			= base.string
local DialogLoader		= require('DialogLoader'		)
local Factory			= require('Factory'				)
local TabViewBase		= require('Options.TabViewBase'	)
local WidgetUtils		= require('Options.WidgetUtils'	)
local SkinUtils			= require('SkinUtils'			)
local i18n				= require('i18n'				)
local HMD               = base.HMD

local _ = i18n.ptranslate

local function loadFromResource(self)
	local localization = {
		enable						= _('ENABLE VIRTUAL REALITY HEADSET'),
		pixel_density				= _('PIXEL DENSITY'),
		use_mouse					= _('USE MOUSE'),
		box_mouse_cursor			= _('CURSOR CONFINED TO GAME WINDOW'),
		custom_IPD_enable   		= _('FORCE IPD DISTANCE'),
		hand_controllers    		= _('USE HAND CONTROLLERS'),
		prefer_built_in_audio 		= _('Use Built-In Audio Device'),
		interaction_with_grip_only 	= _('Hand Interaction Only When Palm Grip is Obtained'),
		bloom						= _('Bloom Effect'),
		msaaMaskSize				= _('MSAA Mask Size'),
	}
	local window = DialogLoader.spawnDialogFromFile('./MissionEditor/modules/dialogs/me_options_VR.dlg', localization)
	local container = window.containerMain.containerVR
	window.containerMain:removeWidget(container)
	window:kill()
	return container
end

local function bindControls(self)
	local container = self:getContainer()
	
	container.use_mouseCheckbox.callbackUpdate = function(self)
		HMD.setUseMouse(self:getState())
	end
	
	container.box_mouse_cursorCheckbox.callbackUpdate = function(self)
		HMD.setUseMouseCursorBounds(self:getState())
	end
	
	container.hand_controllersCheckbox.callbackUpdate = function(self)
		HMD.setUseHandControllers(self:getState())
	end
	
	container.custom_IPD_enableCheckbox.callbackUpdate = function(self)
		HMD.setForceIPDEnable(self:getState())
	end	
	
	container.custom_IPDEditBox.callbackUpdate = function(self)
		HMD.setForcedIPD(self:getText())
	end
	
	container.interaction_with_grip_onlyCheckbox.callbackUpdate = function(self)
		HMD.setInteractionWithGripOnly(self:getState())
	end
	
	self:bindOptionsContainer(container, 'VR')
	
	
	local pict_path = './MissionEditor/themes/main/images/Options/'
	
	local helpInfos = {
		{	file = pict_path..'vr_help_1.png', 
			description = _("Tap controls with your fingertip to activate"),
		},
		{	file = pict_path..'vr_help_2.png', 
			description = _("Hold grip to invoke laser pointer."),
		},
		{	file = pict_path..'vr_help_3.png', 
			description = _("Depressing trigger performs LMB click on selected controls. Use this to push buttons, toggle switches e.t.c."),
		},
		{	file = pict_path..'vr_help_4.png', 
			description = _("Twist hand controller till laser pointer changes into blue. Now trigger will perform RMB clicks on selected controls."),
		},
		{	file = pict_path..'vvr_help_5.png', 
			description = _("Push thumb hat up and down to toggle switches, cycle multi-position switches and rotary selectors; push thumb hat left and right to rotate knobs."),
		},	
		{	file = pict_path..'vr_help_6.png', 
			description = _("Push buttons A, B, X, Y for I really don't know what they do..."),
		},
	}
	
	local count				= #helpInfos
	local counter			= 1
	local containerHelp		= container.containerHelp
	local staticDescription	= containerHelp.staticDescription
	local staticPicture		= containerHelp.staticPicture
	local skin				= staticPicture:getSkin()
	local staticCount		= containerHelp.staticCount
	local setPicture 		= function()
		staticCount:setText(string.format(_("%d of %d"), counter, count))		
		staticPicture:setSkin(SkinUtils.setStaticPicture(helpInfos[counter].file, skin))
		staticDescription:setText(helpInfos[counter].description)
	end
	
	function containerHelp.buttonPrev:onChange()
		if counter > 1 then
			counter = counter - 1
			setPicture()
		end
	end
	
	function containerHelp.buttonNext:onChange()
		if counter < count then
			counter = counter + 1
			setPicture()
		end
	end
	
	setPicture()
end


local function bindSlider(self, slider, static, optionName, getFunc, setFunc, getDbValuesFunc)
	local dbValues 	= getDbValuesFunc(optionName)

	WidgetUtils.fillSlider(slider, dbValues)
	
	local formatText = "%0.1f"
	if slider:getStep() < 0.1 then
		formatText = "%0.2f"
	end
	
	local disp = function (value)
		return string.format(formatText,value)
	end
	function slider:onChange()
		local value = self:getValue()
		setFunc(optionName, value)
		static:setText(disp(value))
	end	
	
	self.updateFunctions_[optionName] = function()
		local value = getFunc(optionName)
		slider:setValue(value)
		static:setText(disp(value))
	end
end



return Factory.createClass({
	construct		 = construct,
	bindControls 	 = bindControls,
	bindSlider		 = bindSlider,
	loadFromResource = loadFromResource,
}, TabViewBase)
