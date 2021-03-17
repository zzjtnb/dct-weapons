local DialogLoader		= require('DialogLoader')
local Factory			= require('Factory')
local TabViewBase		= require('Options.TabViewBase')
local WidgetUtils		= require('Options.WidgetUtils')
local i18n				= require('i18n')
local DbOption			= require('Options.DbOption')

local _ = i18n.ptranslate

local function loadFromResource(self)
	local localization = {
		audio 			= _("Audio"),
		volume 			= _("VOLUME"),
		music 			= _("MUSIC"),
		gui 			= _("GUI"),
		world			= _("WORLD"),
		Helmet			= _("HEADPHONES"),
		inCockpit 		= _("IN-COCKPIT"),
		radioSpeech 	= _("RADIO SPEECH"),
		subtitles 		= _("SUBTITLES"),
		GBreathEffect   = _("G-BREATH EFFECT"),
        hear_in_helmet  = _("HEAR LIKE IN HELMET"),
		headphones_sounds  = _("External View Cockpit Sounds and Radio Messages"),
		MainAudioOut	= _("Main audio out"),
		Headphones		= _("Headphones"),
		VoiceChatOut	= _("Voice Chat output"),
		VoiceChatIn		= _("Voice Chat input"),
		VoiceChat		= _("Voice Chat"),
		FakeAfterburner = _("Loud Cockpit Afterburner Sound"),
		switches		= _('switches', 'Switches'),
		Microphone_use	= _('Microphone use on Multiplayer start', 'Microphone at Multiplayer start'),
		play_audio_while_minimized = _("Play Audio While in Background"),
	}
	local window = DialogLoader.spawnDialogFromFile('./MissionEditor/modules/dialogs/me_options_audio.dlg', localization)
	local container = window.containerMain.containerAudio
	
	window.containerMain:removeWidget(container)
	window:kill()
	
	return container
end

local function bindSlider300P(self, slider, static, optionName, getFunc, setFunc, getDbValuesFunc)
	local dbValues = getDbValuesFunc(optionName)
	local range = dbValues[1]
	local minValue = range.min
	local maxValue = range.max
	
	range.max = 100
	
	WidgetUtils.fillSlider(slider, dbValues)
	
	local getValueUp = function(value)	
		if value <= 50 then
			return math.floor(value*2)
		else
			return math.floor(100+(value-50)*((maxValue-100)/50))
		end	
	end
	
	local getValueDown = function(value)	
		if value <= 100 then
			return math.floor(value/2)
		else
			return math.floor(50+(value-100)/(maxValue-100)*50)
		end	
	end
	
	function slider:onChange()
		local value = self:getValue()
		
	--	print("--onChange--getValueUp--",value,getValueUp(value))
		setFunc(optionName, getValueUp(value))
		
		static:setText(getValueUp(value) .. '%')
	end	
	
	self.restoreFunctions_[optionName] = function()
		local value = getFunc(optionName)
		setFunc(optionName, value)
	end
	
	self.updateFunctions_[optionName] = function()
		local value = getFunc(optionName)
		
	--	print("--updateFunctions_--",value,getValueDown(value))
		slider:setValue(getValueDown(value))
		static:setText(value .. '%')
	end	
end

local function bindSlider(self, slider, static, optionName, getFunc, setFunc, getDbValuesFunc)
	if optionName == 'switches' then
		return bindSlider300P(self, slider, static, optionName, getFunc, setFunc, getDbValuesFunc)
	end
	local dbValues = getDbValuesFunc(optionName)
	local range = dbValues[1]
	local minValue = range.min
	local maxValue = range.max
	
	--FIXME: muteValue ������ ��������������� � me_sound
	local muteValue = range.mute
	
	WidgetUtils.fillSlider(slider, dbValues)
	
	local getPercents = function(value)	
		return math.floor(((value - minValue) / (maxValue - minValue)) * 100)
	end
	
	function slider:onChange()
		local value = self:getValue()
		
		if value == minValue then
			setFunc(optionName, muteValue)
		else
			setFunc(optionName, value)
		end	
		
		static:setText(getPercents(value) .. '%')
	end	
	
	self.restoreFunctions_[optionName] = function()
		local value = getFunc(optionName)
		if value == muteValue then
			value = minValue
		end

		setFunc(optionName, value)
	end
	
	self.updateFunctions_[optionName] = function()
		local value = getFunc(optionName)
		
		if value == muteValue then
			value = minValue
		end
		
		slider:setValue(value)
		static:setText(getPercents(value) .. '%')
	end
end

local function bindControls(self)
	local container	= self:getContainer()
	
	self:bindOptionsContainer(container, 'Sound')
end

local function onOptionsRestored(self)
	local container	= self:getContainer()
	local getOptionsDbFunc = self.controller_['getSoundDb']
	
	for optionName, dbOption in pairs(getOptionsDbFunc()) do
		local widgetType = dbOption.control
		
		if DbOption.sliderName() == widgetType then
			local value = self.controller_.getSound(optionName)
			self.restoreFunctions_[optionName]()
		end
	end
end

return Factory.createClass({
	construct			= construct,
	bindSlider			= bindSlider,
	bindControls		= bindControls,
	loadFromResource	= loadFromResource,
	onOptionsRestored	= onOptionsRestored,
}, TabViewBase)
