local base = _G

module('me_simple_generator_dialog')

local require = base.require

local T						= require('tools')
local U						= require('me_utilities')
local S						= require('Serializer')
local DialogLoader			= require('DialogLoader')
local AutoBriefingModule	= require('me_autobriefing')
local waitScreen			= require('me_wait_screen')
local GDData				= require('me_generator_dialog_data')
local MainMenu				= require('MainMenu')
local me_modules_mediator	= require('me_modules_mediator')
local Gui					= require('dxgui')
local MsgWindow			    = require('MsgWindow')
local Analytics				= require("Analytics")  

require('i18n').setup(_M)

local function onButtonFly()
	show(false)
	
	waitScreen.setUpdateFunction(function()
		local MGModule = require('me_generator')
        
        if GDData.verifyCoalition() == false then
            MsgWindow.warning(GDData.cdata.noCountryInCoalition, _("WARNING"), _("OK")):show()
        else
            generated, nodeId, errMsg = MGModule.generate(GDData.genParams(), false, GDData.genParams().theatreOfWar)
		end
        
		if not generated then
			return
		end
		
		AutoBriefingModule.updateAutoBriefing()
		AutoBriefingModule.returnToME = true
		AutoBriefingModule.show(true, 'mainmenu')
	end)
end

local function onButtonExit()
	show(false)
	MainMenu.show(true);
end

local function onButtonAdvanced()
	show(false)
	me_modules_mediator.get_me_generator_dialog().show(true, 'simplegenerator');
end

local function create()	
	gdWindow = DialogLoader.spawnDialogFromFile("MissionEditor/modules/dialogs/me_gen_simple_options.dlg", GDData.cdata)
	
	gdWindow:setBounds(0, 0, base.main_w, base.main_h)
	
	function gdWindow:onClose()
		onButtonExit()
	end
	
	gdWindow:addHotKeyCallback('escape', onButtonExit)
	
	local containerCommon = gdWindow.MainPanel.containerCommon
	
	GDData.initCommonOptions(containerCommon)
	
	function containerCommon.comboboxAircraft:onChange(item)
		GDData.genParams().aircraft = item.itemId
		GDData.genParams().aircraftsType = item.aircraftType
		
		GDData.fillCountryCombobox(containerCommon.comboboxCountry)
		if not U.setComboboxValueById(containerCommon.comboboxCountry, GDData.genParams().countryId) then
			U.setComboboxValueById(containerCommon.comboboxCountry, item.defaultCountry)
			GDData.genParams().countryId = item.defaultCountry 
		end
	end
	
	gdWindow.MainPanel.footerPanel.buttonFly.onChange = onButtonFly
	gdWindow.MainPanel.footerPanel.buttonCancel.onChange = onButtonExit
	gdWindow.MainPanel.btnClose.onChange = onButtonExit
	containerCommon.buttonAdvanced.onChange = onButtonAdvanced
end

function show(b)
	if (b == false) and (not gdWindow) then
		return
	end
	
	if not gdWindow then
		create()
	end
	
	if b then 
		GDData.setWidgetValuesFromParams(gdWindow.MainPanel.containerCommon) 
		Analytics.pageview(Analytics.FastMission)
	end
	
	-- MainMenu.setEnabled(not b)
	
	gdWindow:setVisible(b)
end