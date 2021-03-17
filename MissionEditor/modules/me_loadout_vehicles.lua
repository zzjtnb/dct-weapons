local base = _G

module('me_loadout_vehicles')

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
local loadfile = base.loadfile

-- ������ LuaGUI
local DialogLoader      = require('DialogLoader')
local GridHeaderCell    = require('GridHeaderCell')
local MsgWindow         = require('MsgWindow')
local U                 = require('me_utilities')
local Size              = require('Size')
local loadoutUtils      = require('me_loadoututils')
local DB                = require('me_db_api')
local panel_payload     = require('me_payload')
local panel_aircraft    = require('me_aircraft')
local MapWindow		    = require('me_map_window')
local vehicle		    = require('me_vehicle')
local ConfigHelper      = require('ConfigHelper')
local UpdateManager     = require('UpdateManager')
local lfs               = require('lfs')
local TableUtils	    = require('TableUtils')
local loadoututilsV     = require('me_loadoututilsVehicles')
local Static            = require('Static')
local Skin				= require('Skin')
local DemoSceneWidget 	= require('DemoSceneWidget')
local Panel             = require('Panel')
local Static            = require('Static')
local Slider            = require('HorzSlider')
local EditBox			= require('EditBox')
local mod_mission       = require('me_mission')
local Terrain           = require('terrain')
local TheatreOfWarData  = require('Mission.TheatreOfWarData')

require('i18n').setup(_M)

local gettext = require("i_18n")

local function _translate(str)
	return gettext.dtranslate("payloads", str)
end

local currentUnitType = nil
local modifiedUnitType_
local lastPreviewType
local ammoDef
local ammoDefByStwID
local curAmmo

local SEASONS = { "summer", "winter", "spring", "autumn" }

widgetsAmmo = {}

cdata = 
{
    title = _('LOADOUTS EDITOR'),
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
}

vdata =
{
    livery_id = 0,
}

local rowHeight = 50

function create(x, y, w, h)
	x_ = x
	y_ = y
	w_ = w
	h_ = h
end

local function create_()
	window = DialogLoader.spawnDialogFromFile('MissionEditor/modules/dialogs/me_loadout_vehicles.dlg', cdata)

    box = window.box
	staticPicture = box.staticPicture
	staticPictureSkin = staticPicture:getSkin()
	picture = staticPictureSkin.skinData.states.released[1].picture
    grid = box.grid
    pNoVisible = box.pNoVisible
    
    grid.onMouseDown = onMouseDownGrid

	local ratio = 1024 / (512 - 100)
	local w, h = staticPicture:getSize()

	picture.size = Size.new(h * ratio, h)

	containerButtons = box.containerButtons
    
    panelAmmo = box.panelAmmo
    
    sAmmoSkin = pNoVisible.sAmmo:getSkin()

	resizeWindow_()
    
    loadoututilsV.init_()

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
end

function resizeWindow_()
	window:setBounds(x_, y_, w_, h_)
    box:setBounds(0, 0, w_, h_)

    local cx, cy = window:getClientRectSize()
	local offset = 8
    
    local staticPictureX, staticPictureY = staticPicture:getPosition()
	local staticPictureWidth, staticPictureHeight = staticPicture:getSize()
    staticPictureHeight = cy*2/3

	staticPicture:setSize(cx - staticPictureX - offset, staticPictureHeight)
    
    containerButtons:setPosition(20,cy-30)
    grid:setBounds(10, staticPictureHeight+30, w_/2, cy-staticPictureHeight-70)
    panelAmmo:setBounds(10+w_/2, staticPictureHeight+30, w_/2-10, cy-staticPictureHeight-70)
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

-- ��������� ���� ��� ������� ������ ���� ������ ������������� ����� ��������
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
	-- ����� �� ���� ������� ���������� ����� �������� ����
end

function getCurrentPayloadId()
    local selectedRowIndex = grid:getSelectedRow()
    --base.print("---selectedRowIndex---", selectedRowIndex)
    if selectedRowIndex ~= -1 then
        return grid:getCell(0, selectedRowIndex).payloadId
    end
    return
end

function deletePayload(payloadName)
    if payloadName == loadoututilsV.getDefaultPresetId() or payloadName == loadoututilsV.getMissionPresetId() then
        return
    end
    
	loadoututilsV.deletePayload(currentUnitType, payloadName)
	
	-- ������� ��������
	local row = grid:getSelectedRow()

	-- ����� ��������
	local newRow

	if grid:getRowCount() - 1 == row then
		-- ���� ������ ���������, �� �������� ���������� ������
		newRow = row - 1
	else
		-- ����� �������� ��������� ��������
		newRow = row
	end

	-- ������� ������ �� �������
	grid:removeRow(row)

	selectPayload(newRow)
end

function renamePayload(newName)
    local row = grid:getSelectedRow()
	local widget = grid:getCell(0, row)
    local payloadId = widget.payloadId

	if newName == payloadId then -- ����� ��� ��������� �� ������
		return true -- ������ �� ������
	end

	local result = isPayloadNameValid(newName)
	
	if result then
		if loadoututilsV.renamePayload(currentUnitType, payloadId, newName) == true then
			vdata.payload = newName
			widget.payloadId = newName
			-- ��������� �������	
			widget.sName:setText(newName)
		else
			result = false
		end
	end
	
	return result
end

function onNew()
	local function onChange_()
		if createPayloadV(newNameWindow.editBoxName:getText()) then
			newNameWindow:setVisible(false)
		end
	end

	-- ���������� ���� ������ ����� ��������
	showNewNameWindow_(cdata.new_payload, onChange_)
end

function onCopy()
	local payloadId = getCurrentPayloadId()
	
	if payloadId then
		local function onChange_()
			local newName = newNameWindow.editBoxName:getText()

			if isPayloadNameValid(newName) then
				if loadoututilsV.copyPayload(currentUnitType, newName, payloadId) then
					newNameWindow:setVisible(false)
				end 
			end
		end

		showNewNameWindow_(cdata.copy_ .. _(payloadId), onChange_)
        updatePresets()
        selectPayload(grid:getRowCount()-1)
	end
end

function onDel()
    local selectedRowIndex = grid:getSelectedRow()
    local payloadId = grid:getCell(0, selectedRowIndex).payloadId
    
    if selectedRowIndex < 0 then
        return
    end
    
    local caption = cdata.delete_payload
    local text = cdata.delete_payload .. payloadId .. '?'

    local handler = MsgWindow.question(text, caption, cdata.yes, cdata.no)

    function handler:onChange(buttonText)
        if buttonText == cdata.yes then
            deletePayload(payloadId)
        end
    end

    handler:show()
end

function onRename()
    local selectedRowIndex = grid:getSelectedRow()
    local payloadId = grid:getCell(0, selectedRowIndex).payloadId
    
    if selectedRowIndex < 0 then
        return
    end
    
    local function onChange_()
        local newName = newNameWindow.editBoxName:getText()
        
        if renamePayload(newName) then
            newNameWindow:setVisible(false)
        end
    end

    showNewNameWindow_(payloadName, onChange_)
end

function addPayloadRow(payloadName)
    local rowIndex = grid:getRowCount()
    grid:insertRow(rowHeight, rowIndex)
    local panel = Panel.new()
    local sName = Static.new(_(payloadName))
    sName:setBounds(0,0,200,20)
    panel:insertWidget(sName)
    panel.payloadId = payloadName
    panel.ammo = loadoututilsV.getAmmo(currentUnitType, panel.payloadId)
    panel.sName = sName
    --print("---panel.ammo---",panel.ammo)
    
    grid:setCell(0, rowIndex, panel)
    
    grid:setRowVisible(rowIndex)
    
	return rowIndex
end


function setAmmoToUnit(a_ammo) 
	loadoututilsV.setAmmoToUnit(a_ammo,vdata.unit)

    vdata.unit.ammo = ammo
    loadoututilsV.setModified(vdata.unit.type)
end

function selectPayload(row)
	local pylons = {}
    base.print("---selectPayload---",row,grid:getCell(0, row))
    local cell = grid:getCell(0, row)
	local ammo = cell.ammo
    curAmmo = ammo
    
    --base.print("---ammo-------",ammo)

    if ammo then
        -- ��������� �� � ����
        setAmmoToUnit(ammo)
        
    end

	grid:selectRow(row)
	grid:setRowVisible(row)
    
    if (cell.payloadId == loadoututilsV.getDefaultPresetId() or cell.payloadId == loadoututilsV.getMissionPresetId()) then
        containerButtons.buttonDelete:setEnabled(false)
        containerButtons.buttonRename:setEnabled(false)
    else
        containerButtons.buttonDelete:setEnabled(true)
        containerButtons.buttonRename:setEnabled(true)
    end
    
    
    updateAmmo()
end

function createPayloadV(payloadName)
	local result = isPayloadNameValid(payloadName)
	
	if result then
		-- ������� ����� ������ ��������
        loadoututilsV.addPayload(currentUnitType, payloadName)
		
		local row = addPayloadRow(payloadName)

		selectPayload(row)
	end

	return result
end

function isPayloadNameValidSymbols(name)
 -- ��� �� ������ ���� ������ ������� � ��������� �������
	return not(('' ~= name) and (nil == string.match(name, '[\'"]')))
end

function isPayloadNameValid(payloadName)
    if loadoututilsV.getPayloadNamePresented(currentUnitType, payloadName) 
	  or payloadName == _(loadoututilsV.getDefaultPresetId()) then
        local text = string.format(cdata.payload_name_is_not_unique, payloadName)        
        MsgWindow.error(text, cdata.error, cdata.ok):show()
        return false
    end

    if isPayloadNameValidSymbols(payloadName) then
		MsgWindow.error(cdata.payload_name_is_not_valid, cdata.error, cdata.ok):show()
		return false
	end
    return true
end

function show(b)
    if not window then
		create_()
	end

    window:setVisible(b)
    if b then
        if DSWidget == nil then
            initLiveryPreview(staticPicture:getBounds())
        end
        update()
    end
end

function createSectionWidgets(a_widgetsAmmo, a_panelAmmo, a_offsetY, a_key, a_v, a_max, a_curAmmo, a_enabled)
    a_curAmmo                                               = a_curAmmo or {}
    a_curAmmo.WS                                            = a_curAmmo.WS or {}
    a_curAmmo.WS[a_v.keyWS]                                 = a_curAmmo.WS[a_v.keyWS] or {}
    a_curAmmo.WS[a_v.keyWS].LN                              = a_curAmmo.WS[a_v.keyWS].LN or {}
    a_curAmmo.WS[a_v.keyWS].LN[a_v.keyLN]                   = a_curAmmo.WS[a_v.keyWS].LN[a_v.keyLN] or {}
    a_curAmmo.WS[a_v.keyWS].LN[a_v.keyLN].PL                = a_curAmmo.WS[a_v.keyWS].LN[a_v.keyLN].PL or {}
    a_curAmmo.WS[a_v.keyWS].LN[a_v.keyLN].PL[a_v.keyPL]     = a_curAmmo.WS[a_v.keyWS].LN[a_v.keyLN].PL[a_v.keyPL]or {}
    
    a_widgetsAmmo.labels = a_widgetsAmmo.labels or {}
    local label = Static.new()
    label:setBounds(10,a_offsetY,100,20)
    label:setText(a_key)
    a_panelAmmo:insertWidget(label)
    a_widgetsAmmo.labels[a_key] = label
    
    a_offsetY = a_offsetY + 20
    
    a_widgetsAmmo.sliders = a_widgetsAmmo.sliders or {}
    local slider = Slider.new()
    slider:setBounds(10,a_offsetY,210,20)
    slider:setRange(0,a_max)
    slider:setValue(a_curAmmo.WS[a_v.keyWS].LN[a_v.keyLN].PL[a_v.keyPL].ammo_capacity or a_v.ammo_capacity)
    a_panelAmmo:insertWidget(slider)
    slider.key = a_key
    a_widgetsAmmo.sliders[a_key] = slider
    slider:setEnabled(a_enabled)
    
    a_widgetsAmmo.editBoxs = a_widgetsAmmo.editBoxs or {}
    local editBox = EditBox.new(a_curAmmo.WS[a_v.keyWS].LN[a_v.keyLN].PL[a_v.keyPL].ammo_capacity or a_v.ammo_capacity)
    editBox:setBounds(230,a_offsetY,30,20)
    a_panelAmmo:insertWidget(editBox)
    editBox.key = a_key
    a_widgetsAmmo.editBoxs[a_key] = editBox
    editBox:setEnabled(a_enabled)
    
    a_offsetY = a_offsetY + 25
    

    
    a_widgetsAmmo.sliders[a_key].onChange = function(self)
        local value = self:getValue()
        local valueOther = 0
        
        for k,v in base.pairs(a_widgetsAmmo.sliders) do
            if k ~= self.key then
                valueOther = valueOther + v:getValue()
            end
        end
        
        if (valueOther+value) > a_max then
            value = a_max - valueOther
        end
        self:setValue(value)
        
        local editBox = a_widgetsAmmo.editBoxs[self.key]
        editBox:setText(value)
        editBox:setSelectionNew(0, editBox:getLineTextLength(0), 0, editBox:getLineTextLength(0))
        updateLabelCount(a_widgetsAmmo)
        --base.U.traverseTable(a_curAmmo)
        --base.print("---gg---",a_v.keyWS,a_v.keyPL,a_v.keyLN)
        a_curAmmo.WS[a_v.keyWS].LN[a_v.keyLN].PL[a_v.keyPL].ammo_capacity = value
        setAmmoToUnit(a_curAmmo)
    end
    
    a_widgetsAmmo.editBoxs[a_key].onChange = function(self)
        local value = base.tonumber(self:getText())
        if value == nil then
            value = 0
        end
        
        local valueOther = 0
        
        for k,v in base.pairs(a_widgetsAmmo.sliders) do
            if k ~= self.key then
                valueOther = valueOther + v:getValue()
            end
        end
        
        if (valueOther+value) > a_max then
            value = a_max - valueOther
        end
        self:setText(value)
        self:setSelectionNew(0, self:getLineTextLength(0), 0, self:getLineTextLength(0))
        
        a_widgetsAmmo.sliders[self.key]:setValue(value)
        updateLabelCount(a_widgetsAmmo)
        a_curAmmo.WS[a_v.keyWS].LN[a_v.keyPL].PL[a_v.keyLN].ammo_capacity = value
        setAmmoToUnit(a_curAmmo)
    end
    
    
    
    return a_offsetY
end

function destroyAmmoWidgets()

end

function updateLabelCount(a_widgetsAmmo)
    local curAmmoCount = 0
    for k,v in base.pairs(a_widgetsAmmo.editBoxs) do
        --base.print("--curAmmoCount---",curAmmoCount,base.tonumber(v:getText()),v:getText())
        curAmmoCount = curAmmoCount + base.tonumber(v:getText())
    end
    a_widgetsAmmo.labelCount:setText(curAmmoCount.."/"..a_widgetsAmmo.ammo_capacity)
end

function updateAmmo()
    destroyAmmoWidgets()
    panelAmmo:clear()
    
    local selectedRowIndex = grid:getSelectedRow()
    if selectedRowIndex < 0 then
        return
    end
        
    local payloadId = grid:getCell(0, selectedRowIndex).payloadId
    local enabled = true
    if (payloadId == loadoututilsV.getDefaultPresetId() or payloadId == loadoututilsV.getMissionPresetId()) then
        enabled = false
    end
    
    --base.U.traverseTable(curAmmo)
    --base.print("---ammoDefByStwID---",ammoDefByStwID)
    if ammoDefByStwID == nil then 
        return
    end
    
    local offsetY = 10
    
    widgetsAmmo = {}
    --main
    if ammoDefByStwID[1] then
        widgetsAmmo[1] = {}
        local caption = Static.new(_("MAIN"))
        caption:setBounds(20,offsetY,100,20)
        caption:setSkin(sAmmoSkin)
        panelAmmo:insertWidget(caption)
        widgetsAmmo[1].caption = caption
        
        local ammo_capacity = 0
        
        for k, v in base.pairs(ammoDefByStwID[1]) do
            ammo_capacity = ammo_capacity + v.ammo_capacity
        end
        widgetsAmmo[1].ammo_capacity = ammo_capacity
        
        local labelCount = Static.new()
        labelCount:setBounds(130,offsetY,60,20)
        labelCount:setText("xx/"..ammo_capacity)
        panelAmmo:insertWidget(labelCount)
        widgetsAmmo[1].labelCount = labelCount

        offsetY = offsetY+20
        
        for k, v in base.pairs(ammoDefByStwID[1]) do
            offsetY = createSectionWidgets(widgetsAmmo[1], panelAmmo, offsetY, k, v, ammo_capacity, curAmmo, enabled)
        end
        updateLabelCount(widgetsAmmo[1])
    end
    offsetY = offsetY+20
    --Secondary
    if ammoDefByStwID[2] then
        widgetsAmmo[2] = {}
        local caption = Static.new(_("SECONDARY"))
        caption:setBounds(20,offsetY,100,20)
        caption:setSkin(sAmmoSkin)
        panelAmmo:insertWidget(caption) 
        widgetsAmmo[2].caption = caption        
        
        local ammo_capacity = 0
        
        for k, v in base.pairs(ammoDefByStwID[2]) do
            ammo_capacity = ammo_capacity + v.ammo_capacity
        end
        widgetsAmmo[2].ammo_capacity = ammo_capacity
        
        local labelCount = Static.new()
        labelCount:setBounds(130,offsetY,60,20)
        labelCount:setText("xx/"..ammo_capacity)
        panelAmmo:insertWidget(labelCount)
        widgetsAmmo[2].labelCount = labelCount

        offsetY = offsetY+20
        
        for k, v in base.pairs(ammoDefByStwID[2]) do
            offsetY = createSectionWidgets(widgetsAmmo[2],panelAmmo, offsetY, k, v, ammo_capacity, curAmmo, enabled)
        end
        updateLabelCount(widgetsAmmo[2])
    end

end

function updatePresets()
    grid:clearRows()

    -- ������ ���������
    addPayloadRow(loadoututilsV.getDefaultPresetId())

    presetId = loadoututilsV.getPresetId(vdata.unit)
    
    if presetId == loadoututilsV.getMissionPresetId() then
        addPayloadRow(presetId)
    end
    
    local payloads = loadoututilsV.getUnitPayloads(vdata.unit.type)
    
    base.U.traverseTable(payloads)
    for k,v in base.pairs(payloads) do
        if v.name ~= loadoututilsV.getDefaultPresetId() and v.name ~= loadoututilsV.getMissionPresetId() then
            addPayloadRow(v.name)
        end        
    end

end

function getSeasonLiveryId()
--���� - ������� - ����
--����� - ������ - ����
--���� - ���� - ������
--����� - �������� - ������

    local Month = mod_mission.mission.date.Month
    local season

    if (Month > 11 or Month < 4) then 
        season = "winter"
    elseif (Month < 7) then
        season = "spring"
    elseif (Month < 9) then
        season = "summer"
    else
        season = "autumn"
    end

   return season
end  

function update()
	if getVisible() then

        if vdata.unit then
            
           -- base.print("----currentUnitType----",currentUnitType)
            --updateImage()

            if ammoDef and base.test_Loadout_vehicles == true then
                --3D � ����������� ����
                local x, y, w, h = staticPicture:getBounds()                      
                DSWidget:setBounds(x, y, w, h)
                DSWidget.aspect = w / h
                
            --    base.U.traverseTable(ammoDef)
                --base.U.traverseTable(base.getmetatable(ammoDef.WS[1].LN[1].PL))
            --    base.print("---ammoDef----")
                
                updatePreview(vdata.livery_id)
                updatePresets()
                updateAmmo()
            else    
                -- 3D �� ��� ����
                DSWidget:setBounds(0, 0, w_, h_)
                DSWidget.aspect = w_ / h_
                updatePreview(vdata.livery_id)
            end
        
            
        end
        
	end
end

function setUnit(a_unit)
    if a_unit then
        vdata.unit = a_unit
        currentUnitType = a_unit.type
        vdata.livery_id = a_unit.livery_id
        loadoututilsV.getPresetId(a_unit)
        ammoDef,ammoDefByStwID = loadoututilsV.getAmmoUnitDef(currentUnitType)
        update()
    end
end

function getUnitImageFilename()
	local unit = DB.unit_by_type[currentUnitType]
	assert(unit, currentUnitType .. "!unit_by_type[]")
	local filename = unit.Picture or ''

	return filename
end

function getVisible()
	return window and window:getVisible()
end

function setLiveryByCountrySeasonTerrain(a_type, country, season, terrain)
	local path = ""
	if country ~= nil then
		path = country
		--base.print("path country:"..path)
	end
	if season ~= nil then
		if path ~= "" then
			path = path .. "_" .. season
		else
			path = season
		end
		--base.print("path season:"..path)
	end
	if terrain ~= nil then
		if path ~= "" then
			path = path .. "_" .. terrain
		else
			path = terrain
		end
		--base.print("path terrain:"..path)
	end
	base.print(path)

	return DSWidget.modelObj:setLivery(path,a_type)
end

function updatePreviewLivery(a_type, country_id)
--base.print("---updatePreviewLivery---",vdata.livery_id)
    if DSWidget and DSWidget.modelObj and DSWidget.modelObj.valid == true then
		local res = false
        local livery_id = vdata.livery_id
        if livery_id ~= nil then
			res = DSWidget.modelObj:setLivery(livery_id,a_type)
		end
		if not res then
			local season = nil
            if Terrain.getTechSkinByDate then
                -- base.print("---getTechSkinByDate---",mod_mission.mission.date.Month, mod_mission.mission.date.Day,Terrain.getTechSkinByDate(mod_mission.mission.date.Day, mod_mission.mission.date.Month))   
                season = Terrain.getTechSkinByDate(mod_mission.mission.date.Day, mod_mission.mission.date.Month) --- getSeasonLiveryId()
            else
                season = getSeasonLiveryId()
            end
			
			local terrain = TheatreOfWarData.getName()
			--base.print("Terrain name: " .. terrain)

			local country = DB.country_by_id[country_id].ShortName
			
			res = setLiveryByCountrySeasonTerrain(a_type, country, season, terrain)
			if not res then
				res = setLiveryByCountrySeasonTerrain(a_type, country, season, nil)
			end
			if not res then
				for k,s in pairs(SEASONS) do
					if s ~= season then
						res = setLiveryByCountrySeasonTerrain(a_type, country, s, nil)
					end
					if res then
						break
					end
				end
			end
			if not res then
				res = setLiveryByCountrySeasonTerrain(a_type, country, nil, terrain)
			end
			if not res then
				res = setLiveryByCountrySeasonTerrain(a_type, nil, season, nil)
			end
			if not res then
				res = DSWidget.modelObj:setLivery("default",a_type) -- default
			end
		end
    end
end

function initLiveryPreview(x, y, w, h)
	DSWidget = DemoSceneWidget.new()
--	local x, y, w, h = staticPicture:getBounds()    
	box:insertWidget(DSWidget)
    DSWidget:setBounds(x, y, w, h)
	DSWidget:loadScript('Scripts/DemoScenes/payloadPreviewV.lua')
	DSWidget.aspect = w / h --������ ��� ���������� ������������� fov
    
    local sceneAPI = DSWidget:getScene()
    
 --   DSWidget.flr        = sceneAPI:addModel("shelter_floor", 0, base.previewV.objectHeight, 0);
 --   DSWidget.sh         = sceneAPI:addModel("ukrytie", 0, base.previewV.objectHeight, 0)
--    DSWidget.sh:drawToEnvironment(true)
 --   DSWidget.sh.transform:scale(10,10,10)
--    DSWidget.sh.transform:setPosition(0, base.previewV.objectHeight, 0)

    
	DSWidget.updateClipDistances = function()
		local dist = base.previewV.cameraDistance*base.math.exp(base.previewV.cameraDistMult)
		--base.scene.cam:setNearClip(base.math.max(dist-DSWidget.modelRadius*1.1, 0.1))
		base.previewV.scene.cam:setFarClip(base.math.max(dist+DSWidget.modelRadius*2.0, 1000))
	end
	
	DSWidget:addMouseDownCallback(function(self, x, y, button)
		DSWidget.bEncMouseDown = true
		DSWidget.mouseX = x
		DSWidget.mouseY = y
		DSWidget.cameraAngH = base.previewV.cameraAngH
		DSWidget.cameraAngV = base.previewV.cameraAngV
		local sceneAPI = DSWidget:getScene()
		sceneAPI:setUpdateFunc('previewV.payloadPreviewUpdateNoRotate')
		
		self:captureMouse()
	end)
	
	DSWidget:addMouseUpCallback(function(self, x, y, button)
		DSWidget.bEncMouseDown = false	
		self:releaseMouse()
	end)
	
  DSWidget:addMouseMoveCallback(function(self, x, y)
		if DSWidget.bEncMouseDown == true then
			base.previewV.cameraAngH = DSWidget.cameraAngH + (DSWidget.mouseX - x) * base.previewV.mouseSensitivity
			base.previewV.cameraAngV = DSWidget.cameraAngV - (DSWidget.mouseY - y) * base.previewV.mouseSensitivity
			
			if base.previewV.cameraAngV > base.math.pi * 0.48 then 
				base.previewV.cameraAngV = base.math.pi * 0.48
			elseif base.previewV.cameraAngV < -base.math.pi * 0.48 then 
				base.previewV.cameraAngV = -base.math.pi * 0.48 
			end
		end
	end)
	
	DSWidget:addMouseWheelCallback(function(self, x, y, clicks)
		base.previewV.cameraDistMult = base.previewV.cameraDistMult - clicks*base.previewV.wheelSensitivity
		local multMax = 2.3 - base.math.mod(2.3, base.previewV.wheelSensitivity)
		if base.previewV.cameraDistMult>multMax then base.previewV.cameraDistMult = multMax end
		DSWidget.updateClipDistances()
		
		return true
	end)
end

function onMouseDownGrid(self,x, y, button)
    if 1 == button then
		local col, row = grid:getMouseCursorColumnRow(x, y)

		if -1 < row then
			selectPayload(row)
		end
	end
end	
 
function updateArguments()
	if vdata.unit == nil then
		return
	end
	
    local AddPropVehicle = vdata.unit.AddPropVehicle
	local unitTypeDesc = DB.unit_by_type[vdata.unit.type]
	if DSWidget and DSWidget.modelObj and AddPropVehicle and unitTypeDesc.AddPropVehicle then
		for k,v in base.pairs(unitTypeDesc.AddPropVehicle) do
			if v.control == 'comboList' then
				if (AddPropVehicle[v.id] ~= nil) then
					for kk,vv in base.pairs(v.values) do
						if vv.id == AddPropVehicle[v.id] then
							DSWidget.modelObj:setArgument(v.arg, vv.value)
						end
					end
				end
			else
				if (AddPropVehicle[v.id] == true and v.boolean_inverted ~= true)
					or (AddPropVehicle[v.id] == false and v.boolean_inverted == true) then
					DSWidget.modelObj:setArgument(v.arg,1)
				else
					DSWidget.modelObj:setArgument(v.arg,0)
				end
			end
		end
	end
end
	
function setPreviewType(a_type, country_id)
    local unitDef = DB.unit_by_type[a_type]
    
    base.print("---setPreviewType---",a_type,DSWidget.aspect)
    local sceneAPI = DSWidget:getScene()	
    if DSWidget.modelObj ~= nil and DSWidget.modelObj.obj ~= nil then
        sceneAPI.remove(DSWidget.modelObj)
        DSWidget.modelObj = nil
    end

	local shape = U.getShape(unitDef)
	
    if shape then  
		DSWidget.modelObj   = sceneAPI:addModel(shape, 0, base.previewV.objectHeight, 0)      
        
        updatePreviewLivery(a_type, country_id)
        
        if DSWidget.modelObj.valid == true then
            DSWidget.modelRadius 	= DSWidget.modelObj:getRadius()
            local x0,y0,z0,x1,y1,z1 = DSWidget.modelObj:getBBox()
            DSWidget.modelObj.transform:setPosition(-(x0+x1)*0.5, base.preview.objectHeight - (y0+y1)*0.5, -(z0+z1)*0.5)
            -- ������� ������� �������� ������������ fov
            -- local vFovTan = base.math.tan(base.math.rad(base.cameraFov*0.5)) / DSWidget.aspect
            -- base.cameraRadius = DSWidget.modelRadius / vFovTan  --base.math.tan(vFov)
            base.previewV.cameraDistMult = 0
            base.previewV.cameraAngV 	= base.previewV.cameraAngVDefault
            base.previewV.cameraDistance = DSWidget.modelRadius / base.math.tan(base.math.rad(base.previewV.cameraFov*0.5))
            DSWidget.updateClipDistances()
            sceneAPI:setUpdateFunc('previewV.payloadPreviewUpdate')
        end
	else
		show(false)
    end
end

function updatePreview(a_livery_id)
    
   -- base.print("---updatePreview--",a_livery_id)
    vdata.livery_id = a_livery_id
    
    if window and window:getVisible() == true
        and (lastPreviewType ~= vdata.unit.type or a_livery_id == nil)  then
        setPreviewType(vdata.unit.type, vdata.unit.boss.boss.id)
        lastPreviewType = vdata.unit.type
    else
        updatePreviewLivery(vdata.unit.type, vdata.unit.boss.boss.id)
    end 
	
	updateArguments()	
end

function uninitialize()
	if DSWidget ~= nil then
        local sceneAPI = DSWidget:getScene()
        if sceneAPI and DSWidget.modelObj then
            sceneAPI.remove(DSWidget.modelObj)
        end
      --  sceneAPI.remove(DSWidget.flr )
     --   sceneAPI.remove(DSWidget.sh)
        
        box:removeWidget(DSWidget)
        DSWidget:destroy()
        DSWidget = nil
        lastPreviewType = nil
	end
end