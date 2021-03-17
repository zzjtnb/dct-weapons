local base = _G

module('me_payload')

local require = base.require
local tostring = base.tostring
local math = base.math
local pairs = base.pairs
local tonumber = base.tonumber

-- ������ LuaGUI
local DialogLoader			= require('DialogLoader')
local ListBoxItem			= require('ListBoxItem')
local S						= require('Serializer')
local U						= require('me_utilities')	
local loadLiveries			= require('loadLiveries')
local panel_loadout			= require('me_loadout')
local DB					= require('me_db_api')
local panel_paramFM			= require('me_paramFM')
local actionParamPanels 	= require('me_action_param_panels')
local OptionsData			= require('Options.Data')
local DemoSceneWidget 	    = require('DemoSceneWidget')


require('i18n').setup(_M)

local WeightWeaponP51D = 260 -- ��� ������ P-51D

local DSWidget
local lastPreviewType

-- ���������� ������������ ������ (��� �������������, �� ����� ����� ������� � ��������� ����,
-- �� IMHO ������� ������ �� ����� �����, ����� ������������ ���� ��������� ������)
cdata = 
{
    fuelTitle = _('INTERNAL FUEL'), 
    percents = '%',
    fuel_weight = _('FUEL WEIGHT'), 
    kg = _('kg'),
    empty = _('EQUIPPED EMPTY WEIGHT'),
    weapons = _('WEAPONS'),
    max = _('MAX'), 
    total = _('TOTAL'),
    chaff = _('CHAFF'),
    flare = _('FLARE'),
    gun = _('GUN'),
    ammo_type = _('AMMO_TYPE'),
    color_schemes = {'Standard', 'European1',},
    color_scheme = _('PAINT SCHEME'),
    standard = _('Standard'),
    civil = _('CIVIL PLANE'),
    bd = _('EXTERNAL HARDPOINTS'),    
    m           = _('m'),
    ropelength  = _('ROPE LENGTH'),
}

-- ���������� �����������/����������� ������ (���� � ����� - cdata.vdata_file)
vdata =
{
    balance = 50,
    fuel = 50,
    fuel_weight = 2500,
    fuel_weight_max = 5000,
    ammo_weight_max = 0,
    empty = 18000,
	weightDependent = 0,
    weapons = 0,
    max = 33000,
    total = 20500,
    -- ��������
    chaff = 150,
    flare = 120,
    gun = 100,
    livery_id = 0,
}

local range = {5, 10, 15, 20, 25, 30}

function getAmmoWeight()
    if nil == vdata.ammo_weight_max then
        vdata.ammo_weight_max = 0
    end
    return vdata.ammo_weight_max * (vdata.gun / 100.0)
end

function updateTotalWeight()
    vdata.total = vdata.empty+vdata.fuel_weight + vdata.weapons + vdata.weightDependent + getAmmoWeight()
	
    total_unitEditBox:setValue(math.floor(0.5 + vdata.total))
    sl_total:setValue(math.min(math.floor(0.5 + 100 * vdata.total / 
                vdata.max), 100))
    e_total_prec:setText(tostring(math.floor(
                0.5 + 100 * vdata.total / vdata.max)))
end

-- �������� � ���������� ��������
-- �������� �������� ��������: t - text, b - button, c - combo, sp - spin, sl - slider, e - edit, d - dial 
function create(x, y, w, h)
    window = DialogLoader.spawnDialogFromFile("MissionEditor/modules/dialogs/me_payload_panel.dlg", cdata)
    window:setBounds(x, y, w, h)
    
    box = window.box
    box:setBounds(0, 0, w, h)

	cb_civil = box.cb_civil
	cb_civil.onChange = function(self)
		if self:getState() then
			vdata.unit.civil_plane = true
		else
			vdata.unit.civil_plane = nil
		end
		vdata.unit.payload.gun = 0
		update()
	end
    
    cb_bd = box.cb_bd
    cb_bd.onChange = function(self)
        if self:getState() then
            vdata.unit.hardpoint_racks = true
        else
            vdata.unit.hardpoint_racks = false 
            panel_loadout.selectPayload(0)
        end    
        update()    
	end
  
    -- Fuel ----------------------------------------------    
    sl_fuel = box.sl_fuel
    sl_fuel:setValue(vdata.fuel)
    
    function updateFuelWeight()
        vdata.fuel_weight = math.floor(0.5 + vdata.fuel_weight_max * vdata.fuel /100) + panel_loadout.vdata.fuel
        fuel_weightEditBox:setValue(vdata.fuel_weight)
        vdata.unit.payload.fuel = vdata.fuel_weight - panel_loadout.vdata.fuel
        updateData()
		--base.print("---updateFuelWeight---",vdata.weightDependent)
        fuel_weightEditBox:setValue(vdata.fuel_weight + vdata.weightDependent)
        empty_unitEditBox:setValue(vdata.empty)
        weapons_unitEditBox:setValue(math.floor(0.5 + vdata.weapons + getAmmoWeight()))
        maxEditBox:setValue(vdata.max)
    end
    
    function sl_fuel:onChange()
        vdata.fuel = math.floor(self:getValue())
        local s = tostring(vdata.fuel)
        if s ~= e_fuel:getText() then
            e_fuel:setText(tostring(vdata.fuel))
        end
        updateFuelWeight()
    end
    
    e_fuel = box.e_fuel
    e_fuel:setText(tostring(vdata.fuel))

    function e_fuel:onChange()
        local i = U.editBoxNumericRestriction(self, 0, 100)
        sl_fuel:setValue(i)
        
        vdata.fuel = i
        updateFuelWeight()
    end
    
    -- Fuel weight ---------------------------------------
    local t_fuel_weight_unit = box.t_fuel_weight_unit
    
    e_fuel_weight = box.e_fuel_weight
    e_fuel_weight:setText(tostring(vdata.fuel_weight))
    
    fuel_weightEditBox = U.createUnitEditBox(t_fuel_weight_unit, e_fuel_weight, U.weightUnits, 1)
    function e_fuel_weight:onChange(text)
        vdata.fuel_weight = U.unitEditBoxRestriction(fuel_weightEditBox, panel_loadout.vdata.fuel, vdata.fuel_weight_max+ panel_loadout.vdata.fuel)
        vdata.unit.payload.fuel = vdata.fuel_weight - panel_loadout.vdata.fuel
        
        vdata.fuel = math.floor(0.5 + 100 * (vdata.fuel_weight - panel_loadout.vdata.fuel) / vdata.fuel_weight_max)
        sl_fuel:setValue(vdata.fuel)
        e_fuel:setText(tostring(vdata.fuel))
        updateTotalWeight()
    end    

    -- Empty ---------------------------------------------
    e_empty = box.e_empty
    e_empty:setText(tostring(vdata.empty))
  
    local t_empty_unit = box.t_empty_unit
    empty_unitEditBox = U.createUnitEditBox(t_empty_unit, e_empty, U.weightUnits, 1)

    -- Weapons -------------------------------------------
    vdata.weapons = panel_loadout.vdata.weight
    e_weapons = box.e_weapons
    e_weapons:setText(tostring(vdata.weapons))
   
    local t_weapons_unit = box.t_weapons_unit

    weapons_unitEditBox = U.createUnitEditBox(t_weapons_unit, e_weapons, U.weightUnits, 1)
	
    -- Max-Total -----------------------------------------
    e_max = box.e_max
    e_max:setText(tostring(vdata.max),2)
    
    maxEditBox = U.createUnitEditBox(nil, e_max, U.weightUnits, 1)

    e_total = box.e_total
    e_total:setText(tostring(vdata.total))

    local t_total_unit = box.t_total_unit
    
    total_unitEditBox = U.createUnitEditBox(t_total_unit, e_total, U.weightUnits, 1)

    sl_total = box.sl_total
    sl_total:setValue(math.min(math.floor(0.5 + 100 * vdata.total / vdata.max), 100))
            
    e_total_prec = box.e_total_prec
    e_total_prec_skin = e_total_prec:getSkin()
    e_total_prec_skin_text = e_total_prec_skin.skinData.states.released[2].text
    e_total_prec_skin_text_color_default = e_total_prec_skin_text.color
    e_total_prec:setText(tostring(math.floor(0.5 + 100 * vdata.total / vdata.max)))
  
    local colorRed = '0xff0000ff'
    
	old_et_setText = e_total_prec.setText    
    
	function e_total_prec:setText(a_text)       	
		if (tonumber(a_text) > 100) then
            e_total_prec_skin_text.color = colorRed
		else
			e_total_prec_skin_text.color = e_total_prec_skin_text_color_default
		end
        
		e_total_prec:setSkin(e_total_prec_skin)
        old_et_setText(e_total_prec,a_text)
    end

    -- ������ ������ ��������������� ���� �����, �� � �� ����� ������ ���.
    sp_chaff = box.sp_chaff
    function sp_chaff:onChange()
        local unitDef = DB.unit_by_type[vdata.unit.type]
        local chaff = self:getValue()
        vdata.unit.payload.chaff = chaff

		if unitDef.passivCounterm ~= nil then
			local chaffSlots = chaff * unitDef.passivCounterm.chaff.chargeSz
			local flareSlots = vdata.unit.payload.flare * unitDef.passivCounterm.flare.chargeSz
			if unitDef.passivCounterm.SingleChargeTotal < chaffSlots + flareSlots then
				local flare = math.floor((unitDef.passivCounterm.SingleChargeTotal - chaffSlots) / 
					unitDef.passivCounterm.flare.chargeSz)
                flare = math.floor(flare/unitDef.passivCounterm.flare.increment)*unitDef.passivCounterm.flare.increment    
				sp_flare:setValue(flare)
				vdata.unit.payload.flare = flare
			end
		end
    end
    
    function sp_chaff_onFocus(self, focused, prevFocusedWidget)
        if not focused then
            local unitDef = DB.unit_by_type[vdata.unit.type]
            if unitDef.passivCounterm ~= nil then
                local chaff = self:getValue()
                chaff = math.floor(chaff/unitDef.passivCounterm.chaff.increment)*unitDef.passivCounterm.chaff.increment
                vdata.unit.payload.chaff = chaff
                self:setValue(chaff)
            end
        end
    end    
    sp_chaff:addFocusCallback(sp_chaff_onFocus)
	
    -- ������ ������ ��������������� ���� �����, �� � �� ����� ������ ���.
    sp_flare = box.sp_flare
    function sp_flare:onChange()
        local unitDef = DB.unit_by_type[vdata.unit.type]
        local flare = self:getValue()
        vdata.unit.payload.flare = flare
		
		if unitDef.passivCounterm ~= nil then
			local flareSlots = flare * unitDef.passivCounterm.flare.chargeSz
			local chaffSlots = vdata.unit.payload.chaff * unitDef.passivCounterm.chaff.chargeSz
			if unitDef.passivCounterm.SingleChargeTotal < chaffSlots + flareSlots then
				local chaff = math.floor((unitDef.passivCounterm.SingleChargeTotal - flareSlots) / 
					unitDef.passivCounterm.chaff.chargeSz)
                chaff = math.floor(chaff/unitDef.passivCounterm.chaff.increment)*unitDef.passivCounterm.chaff.increment    
				sp_chaff:setValue(chaff)
				vdata.unit.payload.chaff = chaff
			end
		end
    end
    
    function sp_flare_onFocus(self, focused, prevFocusedWidget)
        if not focused then
            local unitDef = DB.unit_by_type[vdata.unit.type]
            if unitDef.passivCounterm ~= nil then
                local flare = self:getValue()
                flare = math.floor(flare/unitDef.passivCounterm.flare.increment)*unitDef.passivCounterm.flare.increment
                vdata.unit.payload.flare = flare
                self:setValue(flare)
            end
        end
    end    
    sp_flare:addFocusCallback(sp_flare_onFocus)
    
    t_gun = box.t_gun
    
    -- ������ ������ ��������������� ���� �����, �� � �� ����� ������ ���.
    sp_gun = box.sp_gun
    function sp_gun:onChange()
        vdata.gun = self:getValue()
        vdata.unit.payload.gun = vdata.gun
        updateTotalWeight()
        weapons_unitEditBox:setValue(math.floor(0.5 + vdata.weapons + getAmmoWeight()))
    end
    
    t_gun_perc = box.t_gun_perc
	
	t_ammo_type = box.t_ammo_type
	
	c_ammo_type = box.c_ammo_type
    
    function c_ammo_type:onChange(self)
		vdata.unit.payload.ammo_type = getIndexAmmoType(self:getText())
    end
    
    c_color_scheme = box.c_color_scheme
    function c_color_scheme:onChange(item)
        vdata.unit.livery_id = item.itemId
        vdata.livery_id = item.itemId
        updateLiveries()
    end
    
    pSetRope = box.pSetRope	 
    eRopeLength = pSetRope.eRopeLength
    sUnitRopeLength = pSetRope.sUnitRopeLength
    hsRopeLength = pSetRope.hsRopeLength
    
    eRopeLengthUnit = U.createUnitEditBox(sUnitRopeLength, eRopeLength, U.altitudeUnits, 0.1)

    initLiveryPreview()
    
    -- ���������� �������� ���������� �������� �� ������� vdata
    update()
end

function initLiveryPreview()
	DSWidget = DemoSceneWidget.new()
	local x, y, w, h = box.sLiveryPreview:getBounds()    
	box:insertWidget(DSWidget)
    DSWidget:setBounds(x, y, w, h)
    box:updateWidgetsBounds()
	DSWidget:loadScript('Scripts/DemoScenes/payloadPreview.lua')
	DSWidget.aspect = w / h --������ ��� ���������� ������������� fov
  
	DSWidget.updateClipDistances = function()
		local dist = base.preview.cameraDistance*base.math.exp(base.preview.cameraDistMult)
		--base.scene.cam:setNearClip(base.math.max(dist-DSWidget.modelRadius*1.1, 0.1))
		--base.scene.cam:setFarClip(base.math.max(dist+DSWidget.modelRadius*1.2,1))
	end
	
	DSWidget:addMouseDownCallback(function(self, x, y, button)
		DSWidget.bEncMouseDown = true
		DSWidget.mouseX = x
		DSWidget.mouseY = y
		DSWidget.cameraAngH = base.preview.cameraAngH
		DSWidget.cameraAngV = base.preview.cameraAngV
		local sceneAPI = DSWidget:getScene()
		sceneAPI:setUpdateFunc('preview.payloadPreviewUpdateNoRotate')
		
		self:captureMouse()
	end)
	
	DSWidget:addMouseUpCallback(function(self, x, y, button)
		DSWidget.bEncMouseDown = false	
		self:releaseMouse()
	end)
	
  DSWidget:addMouseMoveCallback(function(self, x, y)
		if DSWidget.bEncMouseDown == true then
			base.preview.cameraAngH = DSWidget.cameraAngH + (DSWidget.mouseX - x) * base.preview.mouseSensitivity
			base.preview.cameraAngV = DSWidget.cameraAngV - (DSWidget.mouseY - y) * base.preview.mouseSensitivity
			
			if base.preview.cameraAngV > base.math.pi * 0.48 then 
				base.preview.cameraAngV = base.math.pi * 0.48
			elseif base.preview.cameraAngV < -base.math.pi * 0.48 then 
				base.preview.cameraAngV = -base.math.pi * 0.48 
			end
		end
	end)
	
	DSWidget:addMouseWheelCallback(function(self, x, y, clicks)
		base.preview.cameraDistMult = base.preview.cameraDistMult - clicks*base.preview.wheelSensitivity
		local multMax = 2.3 - base.math.mod(2.3, base.preview.wheelSensitivity)
		if base.preview.cameraDistMult>multMax then base.preview.cameraDistMult = multMax end
		DSWidget.updateClipDistances()
		
		return true
	end)
end

function uninitialize()
	if DSWidget ~= nil then
        box:removeWidget(DSWidget)
        DSWidget:destroy()
        DSWidget = nil
        lastPreviewType = nil
	end
end

function setHardpointRacks(a_flag)
    cb_bd:setState(a_flag)
    vdata.unit.hardpoint_racks = a_flag
    update()
end

local function updateUnitSystem()
	local unitSystem = OptionsData.getUnits()
	
	fuel_weightEditBox:setUnitSystem(unitSystem)
    empty_unitEditBox:setUnitSystem(unitSystem)
    weapons_unitEditBox:setUnitSystem(unitSystem)
    total_unitEditBox:setUnitSystem(unitSystem)
    maxEditBox:setUnitSystem(unitSystem)
    eRopeLengthUnit:setUnitSystem(unitSystem)
end

-- ��������/�������� ������
function show(b)
    window:setVisible(b)
    if b then
        if DSWidget == nil then
            initLiveryPreview()
        end
        updateUnitSystem()
        update()        
    end
    panel_loadout.show(b)
end

-- ���������� ������ � �����
function save(fName)
    local f = base.io.open(fName, 'w')
    if f then
        local s = S.new(f)
        s:serialize_simple('vdata', vdata)
        f:close()
    end
end

-- find and set default livery
function setDefaultLivery(unit)
    local oldLivery = unit.livery_id

    local group   = unit.boss
    local country = DB.country_by_id[group.boss.id]
	local schemes = loadLiveries.loadSchemes(DB.liveryEntryPoint(unit.type),country.ShortName)
    if not schemes then
        return
    end
    
    if #schemes > 0 then
        unit.livery_id = schemes[1].itemId
    else
        unit.livery_id = nil
    end

end

-------------------------------------------------------------------------------
-- build liveries list
function updateLiveries()
    c_color_scheme:clear()

    if not vdata.unit then
        return
    end

    local group = vdata.unit.boss
    local country = DB.country_by_id[group.boss.id]

	local selectedItem, firstItem
	
	local liveryEntryPoint = DB.liveryEntryPoint(vdata.unit.type)

    local schemes = loadLiveries.loadSchemes(liveryEntryPoint,country.ShortName)
 
    for k, scheme in pairs(schemes) do
        local item = ListBoxItem.new(scheme.name)
		
        item.itemId = scheme.itemId
        c_color_scheme:insertItem(item) 
    end
    
    local itemCount = c_color_scheme:getItemCount()
	local itemCounter = itemCount - 1
	
    if itemCount > 0 then			
        firstItem = c_color_scheme:getItem(0)
    end

    if vdata.unit then
        for i = 0, itemCounter do
			local item = c_color_scheme:getItem(i)
			           
            if vdata.unit.livery_id == item.itemId then
                selectedItem = item
				
				break
            end
        end
    end
    
    if not firstItem then
        c_color_scheme:setText(cdata.standard)
        vdata.color_scheme = cdata.standard
        vdata.livery_id = nil
    elseif not selectedItem then
        c_color_scheme:selectItem(firstItem)
        vdata.livery_id = firstItem.itemId
    else
        c_color_scheme:selectItem(selectedItem)
        vdata.livery_id = selectedItem.itemId
    end
    
    if (vdata.unit) and (vdata.unit.livery_id == nil)  then
        vdata.unit.livery_id = vdata.livery_id
    end
    
    if window and window:getVisible() == true
        and lastPreviewType ~= vdata.unit.type then
        setPreviewType(vdata.unit.type, vdata.unit.AddPropAircraft)
        lastPreviewType = vdata.unit.type
    else
        updatePreviewLivery(liveryEntryPoint)        
    end
    updateArguments()
        
end

function updateOnboardNumber(a_OnboardNumber)
    if DSWidget and DSWidget.modelObj and DSWidget.modelObj.valid == true then
        DSWidget.modelObj:setAircraftBoardNumber(a_OnboardNumber)    
    end
end

function updatePreviewLivery(a_type)
    if DSWidget and DSWidget.modelObj and DSWidget.modelObj.valid == true then
        if vdata.livery_id then
            DSWidget.modelObj:setLivery(vdata.livery_id,a_type)
        end
    end
end

function updateArguments()
    local AddPropAircraft = vdata.unit.AddPropAircraft
    if DSWidget and DSWidget.modelObj and AddPropAircraft then
        if vdata.unit.type == "Mi-8MT" then
            if AddPropAircraft.CargoHalfdoor == true then
                DSWidget.modelObj:setArgument(250,0) -- �����
            else
                DSWidget.modelObj:setArgument(250,1) -- �����
            end
            
            if AddPropAircraft.AdditionalArmor == true then
                DSWidget.modelObj:setArgument(80,1) -- �����
            else
                DSWidget.modelObj:setArgument(80,0) -- �����
            end
        end
    end
end

function setPreviewType(a_type)
    local unitDef 			= DB.unit_by_type[a_type]
	local liveryEntryPoint  = unitDef.livery_entry or a_type
	
    
    local sceneAPI = DSWidget:getScene()	
    if DSWidget.modelObj ~= nil and DSWidget.modelObj.obj ~= nil then
        sceneAPI.remove(DSWidget.modelObj)
        DSWidget.modelObj = nil
    end

	local shape = U.getShape(unitDef)
	
    if shape then  
		DSWidget.modelObj = sceneAPI:addModel(shape, 0, base.preview.objectHeight, 0)
               
        if vdata.livery_id then
            DSWidget.modelObj:setLivery(vdata.livery_id,liveryEntryPoint)
        end       
        
        if DSWidget.modelObj.valid == true then
            DSWidget.modelObj:setAircraftBoardNumber(base.panel_aircraft.getCurOnboardNumber())
            DSWidget.modelRadius 	= DSWidget.modelObj:getRadius()
            local x0,y0,z0,x1,y1,z1 = DSWidget.modelObj:getBBox()
            DSWidget.modelObj.transform:setPosition(-(x0+x1)*0.5, base.preview.objectHeight - (y0+y1)*0.5, -(z0+z1)*0.5) --����������� �� ������ �������� �����
            -- ������� ������� �������� ������������ fov
            -- local vFovTan = base.math.tan(base.math.rad(base.cameraFov*0.5)) / DSWidget.aspect
            -- base.cameraRadius = DSWidget.modelRadius / vFovTan  --base.math.tan(vFov)
            base.preview.cameraDistMult = 0
            base.preview.cameraAngV 	= base.preview.cameraAngVDefault
            base.preview.cameraDistance = DSWidget.modelRadius / base.math.tan(base.math.rad(base.preview.cameraFov*0.5))
            DSWidget.updateClipDistances()
            sceneAPI:setUpdateFunc('preview.payloadPreviewUpdate')
        end
    end
end


function updateData()
    vdata.weapons = panel_loadout.vdata.weight

    if vdata.unit then
		-- ������� ��� ������������ 'P-51D'--------------------------
		if (vdata.unit.type == 'P-51D') then  
			cb_civil:setVisible(true)						
		else
			cb_civil:setVisible(false)			
		end	
		
		if  (vdata.unit.type == 'P-51D') and (vdata.unit.civil_plane == true) then
			cb_civil:setState(true)
		else
			cb_civil:setState(false)
			vdata.unit.civil_plane = nil
		end		
        
        local unitDef = DB.unit_by_type[vdata.unit.type]
        
        if unitDef.HardpointRacks_Edit == true then
            cb_bd:setVisible(true)
        else
            cb_bd:setVisible(false)
        end
        
        if unitDef.HardpointRacks_Edit == true then
            if vdata.unit.hardpoint_racks == nil then
                vdata.unit.hardpoint_racks = true
                cb_bd:setState(true)
            else
                cb_bd:setState(vdata.unit.hardpoint_racks)
            end                
        end
        
		local fuelWeight = panel_loadout.vdata.fuel
		
        vdata.fuel_weight = vdata.unit.payload.fuel + fuelWeight        
        vdata.fuel_weight_max = tonumber(unitDef.MaxFuelWeight)
        vdata.ammo_weight_max = tonumber(unitDef.AmmoWeight)
        
        t_gun:setVisible((not cb_civil:getState()) and (unitDef.Guns ~= nil))
		sp_gun:setVisible((not cb_civil:getState()) and (unitDef.Guns ~= nil))
		t_gun_perc:setVisible((not cb_civil:getState()) and (unitDef.Guns ~= nil))
        
        if nil == vdata.ammo_weight_max then
            vdata.ammo_weight_max = 0
        end
        
        vdata.max = unitDef.MaxTakeOffWeight
        if (vdata.fuel_weight - fuelWeight) > vdata.fuel_weight_max then
            vdata.fuel_weight = vdata.fuel_weight_max + fuelWeight
            vdata.unit.payload.fuel = math.floor(0.5 + vdata.fuel_weight_max * vdata.fuel /100)
        end
        vdata.fuel = math.floor(0.5 + 100 * (vdata.fuel_weight - fuelWeight) / vdata.fuel_weight_max)
        
        local weightDependent = panel_paramFM.getWeightDependentOfFuel(vdata.unit)  
        vdata.weightDependent = weightDependent * base.math.min(1.0, 0.1 + (vdata.fuel/100))  
        vdata.empty = unitDef.EmptyWeight + panel_paramFM.getWeight()
        
        if vdata.unit.hardpoint_racks == false then
            vdata.empty = vdata.empty - (unitDef.HardpointRacksWeight or 0)
        end
        
		if (vdata.unit.civil_plane == true) then  -- ������� ��� ������������ 'P-51D'
			vdata.empty = unitDef.EmptyWeight - WeightWeaponP51D
		end
        
		
		sp_gun:setValue(vdata.unit.payload.gun)
        vdata.livery_id = vdata.unit.livery_id
        vdata.gun = vdata.unit.payload.gun
		
        sp_chaff:setValue(vdata.unit.payload.chaff)
        sp_flare:setValue(vdata.unit.payload.flare)
		
		local chaffFlareEnabled = false
		local ChaffEnabled = true
		if unitDef.passivCounterm ~= nil then
			chaffFlareEnabled = unitDef.passivCounterm.CMDS_Edit == true 
			sp_chaff:setStep(unitDef.passivCounterm.chaff.increment)
			sp_flare:setStep(unitDef.passivCounterm.flare.increment)
			
			local maxChaff = unitDef.passivCounterm.SingleChargeTotal / unitDef.passivCounterm.chaff.chargeSz
			if unitDef.passivCounterm.chaff.maxCharges ~= nil and unitDef.passivCounterm.chaff.maxCharges < maxChaff then
				maxChaff = math.floor(unitDef.passivCounterm.chaff.maxCharges / unitDef.passivCounterm.chaff.increment) * unitDef.passivCounterm.chaff.increment
			end
			sp_chaff:setRange(0, maxChaff)
			local maxFlare = unitDef.passivCounterm.SingleChargeTotal / unitDef.passivCounterm.flare.chargeSz
			if unitDef.passivCounterm.flare.maxCharges ~= nil and unitDef.passivCounterm.flare.maxCharges < maxFlare then
				maxFlare = math.floor(unitDef.passivCounterm.flare.maxCharges / unitDef.passivCounterm.flare.increment) * unitDef.passivCounterm.flare.increment
			end
			sp_flare:setRange(0, maxFlare)
			
			if unitDef.passivCounterm.ChaffNoEdit ~= nil then
				ChaffEnabled = not (unitDef.passivCounterm.ChaffNoEdit == true)
			end
		end
		
        sp_flare:setEnabled(chaffFlareEnabled)
        sp_chaff:setEnabled(chaffFlareEnabled and ChaffEnabled)
		
		local unit = DB.unit_by_type[vdata.unit.type]
		if (unit.ammo_type ~= nil) then
			vdata.ammo_type = unit.ammo_type
			U.fill_combo(c_ammo_type, unit.ammo_type)
			
			if (vdata.unit.payload.ammo_type ~= nil) then				
				c_ammo_type:setText(unit.ammo_type[vdata.unit.payload.ammo_type])
			else
				c_ammo_type:setText(unit.ammo_type[1])
				vdata.unit.payload.ammo_type = unit.ammo_type_default or 1
			end
			
			c_ammo_type:setVisible(true)
			t_ammo_type:setVisible(true)
		else
			vdata.unit.payload.ammo_type = nil
			c_ammo_type:setVisible(false)
			t_ammo_type:setVisible(false)
		end
    else
        sp_flare:setEnabled(false)
        sp_chaff:setEnabled(false)
    end
    if nil == vdata.gun then
        vdata.gun = 0
    end
    updateTotalWeight()
end

-- ���������� �������� �������� ����� ��������� ������� vdata
function update()
    updateData()
    
    sl_fuel:setValue(vdata.fuel)
    e_fuel:setText(tostring(vdata.fuel))
    
    fuel_weightEditBox:setValue(vdata.fuel_weight + vdata.weightDependent)
    empty_unitEditBox:setValue(vdata.empty)
    weapons_unitEditBox:setValue(math.floor(0.5 + vdata.weapons + getAmmoWeight()))
    maxEditBox:setValue(vdata.max)
	
	updateVisibleRope()
    updateLiveries()
    setPositionWidgets()
end

function setPositionWidgets()
    local offsetY = 299    
    if not vdata.unit then
        return
    end
    local unitDef = DB.unit_by_type[vdata.unit.type]
    
    if unitDef.Guns ~= nil then
        -- ���������� �����
        offsetY = 324     
    end
    
    if (unitDef.ammo_type ~= nil) then
        -- ���������� ��� ��������
        offsetY = 349  
    end

    if (vdata.group and vdata.group.type == 'helicopter') then
        -- ���������� ����
        pSetRope:setPosition(14,offsetY)
        box.sColorScheme:setPosition(14,offsetY+57)
        box.c_color_scheme:setPosition(117,offsetY+55)   
        if DSWidget then          
            DSWidget:setPosition(14,offsetY+92) 
        end    
    else
        box.sColorScheme:setPosition(14,349)
        box.c_color_scheme:setPosition(117,347)
        if DSWidget then    
            DSWidget:setPosition(14,384)  
        end    
    end
end

function updateVisibleRope()           
    if (vdata.group and vdata.group.type == 'helicopter') then --�������� �� ��������
     --   eRopeLengthUnit = U.createUnitEditBox(sUnitRopeLength, eRopeLength, U.altitudeUnits, 1, 100)
        updateUnitSystem()
    
      --  function eRopeLength:onChange(text)        
      --      local ropeLength = eRopeLengthUnit:getValue()
         --   hsRopeLength:setValue(ropeLength)
      --      vdata.unit.ropeLength = ropeLength
       -- end
        
        function hsRopeLength:onChange()
            local ropeLength = self:getValue()            
            eRopeLengthUnit:setValue(range[ropeLength] or 5)
            vdata.unit.ropeLength = range[ropeLength]
        end
        
        pSetRope:setVisible(true)
        local ropeLength = vdata.unit.ropeLength or 15
        vdata.unit.ropeLength = ropeLength
        eRopeLengthUnit:setValue(ropeLength)
        hsRopeLength:setRange(1, 6, 1)
        
        hsRopeLength:setValue(1)
        for k,v in base.ipairs(range) do
            if v == ropeLength then
                hsRopeLength:setValue(k)
            end
        end
    else
        pSetRope:setVisible(false)
    end

end

-- ���������� ���� �� ��� �����
function getUnitByName(unitName)
  local result = nil
  -- ������� ���� � ���������
  for _tmp, unit in pairs(DB.db.Units.Planes.Plane) do
    if unitName == unit.Name then
      result = unit
      break
    end
  end
  
  if not result then
    -- ���� �� ����� � ���������, ���� � ����������
    for _tmp, unit in pairs(DB.db.Units.Helicopters.Helicopter) do
      if unitName == unit.Name then
        result = unit
        break
      end
    end    
  end
  
  return result
end

function getIndexAmmoType(type)
	if (vdata.ammo_type == nil) then
		base.print("ASSERT vdata.ammo_type == nil")
		return
	end
	for k, v in pairs(vdata.ammo_type) do
		if (type == v) then		
			return k
		end
	end
	return 1
end
