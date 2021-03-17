local base = _G

module('me_startEditor') -- окно при запуске редактора без карты

local require = base.require

local DialogLoader 	= require('DialogLoader')
local toolbar 		= require('me_toolbar')

local i18n = require('i18n')
i18n.setup(_M)

cdata = {
	create_new_mission 	= _("create new mission"),	
	open_mission 		= _("open mission"),	
}



function create(x, y, w, h)
	x_ = x
	y_ = y
	w_ = w
	h_ = h
end

local function create_()
base.print("---me_startEditor---",x_, y_, w_, h_)
	window = DialogLoader.spawnDialogFromFile("MissionEditor/modules/dialogs/me_startEditor.dlg", cdata)
	window:setBounds(x_, y_, w_, h_)
	window.panelbg:setBounds(0, 0, w_, h_)
	
	btnNew 	= window.panelbg.btnNew
	btnOpen = window.panelbg.btnOpen

	btnNew.onChange 	= onChange_New
	btnOpen.onChange 	= onChange_Open

end

	
function show(b)
	if not window then
		create_()
	end


	window:setVisible(b)
end

function onChange_New()
	toolbar.createMission("StartEditor", nil)
end

function onChange_Open()
	toolbar.openMissionFileDialog()
end








		