local base = _G

module('me_fix_points')

local require = base.require
local pairs = base.pairs
local ipairs = base.ipairs
local tostring = base.tostring

local U = require('me_utilities')	-- ������� �������� ������� ��������
local DialogLoader = require('DialogLoader')
local MapWindow = require('me_map_window')
local i18n = require('i18n')
local module_mission = require('me_mission')

i18n.setup(_M)
 
cdata = {
    add = _('ADD'),
    edit = _('EDIT'),
    del = _('DEL'),
    lat = _('LATITUDE:'),
    lon = _('LONGITUDE:'),
    of = _('OF'),
} 

vdata = {
    selectedPoint = nil,
    coords = {
        x = 0,
        y = 0,
    },
}
 
function create(x, y, w, h)
    window = DialogLoader.spawnDialogFromFile('MissionEditor/modules/dialogs/me_fix_points_dialog.dlg', cdata)
    window:setBounds(x,y,w,h)
	
	local box = window.box

    buttonAdd = box.buttonAdd
    buttonEdit = box.buttonEdit
    buttonDel = box.buttonDel
    editComment = box.editComment
    sp_of = box.sp_of
    editboxNumber = box.editboxNumber
    staticLat = box.staticLat
    staticLon = box.staticLon
    
    buttons = {
        buttonAdd,
        buttonEdit,
    }
    buttonAdd:setState(true)
	
    setupCallbacks()
end

function show(b)
    window:setVisible(b)
    if b then -- ���� ������
        if buttonAdd:getState() then -- ������ ������ ����������
            MapWindow.setState(MapWindow.getCreatingINUFixPointState())
        else -- ������ ���������� �� ������
            if MapWindow.selectedGroup and -- ���� ���������� ������ � � ��� ��� ����� ���������, �� ��������� � ����� ���������� 
                ( not MapWindow.selectedGroup.INUFixPoints or ( #MapWindow.selectedGroup.INUFixPoints < 1) ) 
                then 
                buttonAdd:setState(true)   -- �������� ������ Add
                buttonEdit:setState(false)  -- �������� ������ Edit
                MapWindow.setState(MapWindow.getCreatingINUFixPointState()) -- ����� � ����� �������� ����� ���������
            else
                MapWindow.setState(MapWindow.getPanState()) -- ����� � ������� �����
            end
        end    
        update()
    else --���� ������
        vdata.selectedPoint = nil
        selectPoint(nil)
        MapWindow.setState(MapWindow.getPanState()) -- ����� � ������� �����
    end
end

function setupCallbacks()
    buttonAdd.onChange = onButtonAddChange
    buttonEdit.onChange = onButtonEditChange
    buttonDel.onChange = onButtonDelChange
    sp_of.onChange = onSpinOfChange
end 

function toggle(button)
    for k,v in pairs(buttons) do 
        if button ~= v then
            v:setState(not button:getState())
        end
    end
end  

function onSpinOfChange(self)
    if vdata.selectedPoint then
        local group = vdata.selectedPoint.boss
        local points = group.INUFixPoints
        local listSize = #points

        vdata.selectedPoint = points[self:getValue()]
    end
    update()
end 

function selectPoint(point)
    local group
    if point ~= nil then 
        group = point.boss
    else
        if MapWindow.selectedGroup ~= nil then 
            group = MapWindow.selectedGroup
        else
            return
        end
    end
    
    for i,pnt in ipairs(group.INUFixPoints or {}) do
        pnt.symbol.currColor = group.boss.boss.selectGroupColor
        pnt.text.currColor = group.boss.boss.selectGroupColor    
    end
    
    if point ~= nil then
        point.symbol.currColor = group.boss.boss.selectWaypointColor
        point.text.currColor = group.boss.boss.selectWaypointColor
    end
    module_mission.update_group_map_objects(group) 
end 

-- ���������� ������� ������ ���������� Add
function onButtonAddChange(self)
    toggle(self)
    if self:getState() then -- ���� ������ Add
        MapWindow.setState(MapWindow.getCreatingINUFixPointState()) -- ����� � ����� �������� ����� ���������
    else -- ���� Add �� ������ 
        MapWindow.setState(MapWindow.getPanState()) -- ����� � ������� �����
    end
    update()
end

-- ���������� ������� ������ �������������� Edit
function onButtonEditChange(self)
    toggle(self)
    if self:getState() then -- ���� ������ Edit
        MapWindow.setState(MapWindow.getPanState()) --  ����� � ������� �����
    end
    update()
end

-- ���������� ������� ������ �������� Del
function onButtonDelChange(self)
    if vdata.selectedPoint then
        local group = vdata.selectedPoint.boss
        local points = group.INUFixPoints
        module_mission.remove_INUFixPoint(group, vdata.selectedPoint.index)        
        if #points > 0 then
            vdata.selectedPoint = points[1]
            selectPoint(vdata.selectedPoint)
        end
        update()        
    end
end

-- �������� ������ 
function update()
    if not window:isVisible() then
        return
    end
    
    if vdata.selectedPoint == nil then
        if not MapWindow.selectedGroup then
            vdata.selectedPoint = nil
        else
            if MapWindow.selectedGroup.INUFixPoints then
                if #MapWindow.selectedGroup.INUFixPoints > 0 then
                    vdata.selectedPoint = MapWindow.selectedGroup.INUFixPoints[1]
                else
                    vdata.selectedPoint = nil
                end
            else
                vdata.selectedPoint = nil
            end
        end    
    end
    
    if buttonAdd:getState() then
        MapWindow.setState(MapWindow.getCreatingINUFixPointState())
    else
        MapWindow.setState(MapWindow.getPanState())
    end

    local lat = 0
    local long = 0
    
    if vdata.selectedPoint then -- ���-�� ��������
        -- �������� �����
        vdata.coords.x = vdata.selectedPoint.x
        vdata.coords.y = vdata.selectedPoint.y
        
        -- lat, long � ��������
        lat, long = MapWindow.convertMetersToLatLon(vdata.selectedPoint.x, vdata.selectedPoint.y)

        editboxNumber:setText(tostring(vdata.selectedPoint.index))
        
        local pointCount = #vdata.selectedPoint.boss.INUFixPoints
        
        sp_of:setRange(1, pointCount)
        sp_of:setEnabled(true)
        editboxNumber:setEnabled(true)
        editboxNumber:setText(tostring(pointCount))
        sp_of:setValue(vdata.selectedPoint.index)
        selectPoint(vdata.selectedPoint)
    else -- ������ �� �������� 
        editboxNumber:setText('0')
        editboxNumber:setEnabled(false)
        sp_of:setRange(0,1)
        sp_of:setEnabled(false)
        sp_of:setValue(0)        
        selectPoint(nil)
    end
    
    staticLat:setText(U.getLatitudeString(U.toRadians(lat)))
    staticLon:setText(U.getLongitudeString(U.toRadians(long)))
end

-- ���������� ����� �������������� ����� ���������
function setEditMode(b)
    if b then 
        buttonAdd:setState(false) -- Add 
        buttonEdit:setState(true) -- Edit ������
    else
        buttonEdit:setState(false)    
    end
end
