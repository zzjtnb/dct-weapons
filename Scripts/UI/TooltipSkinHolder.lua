local Gui	= require('dxgui')
local Skin	= require('Skin')

local prevTooltipSkin_
local tooltipSkin_ = Skin.tooltipSkin()

local function saveTooltipSkin()
    -- ������ ������������� ��� ��������� ���� ����
    -- �������� ������� ���� ��� ��������� � ��� ������ ����������� ���
    prevTooltipSkin_ = Gui.GetTooltipSkin()
    Gui.SetTooltipSkin(tooltipSkin_)

    -- ��������� ������ ������� �� ��������
    Gui.SetTooltipText()
end

local function restoreTooltipSkin()
  if prevTooltipSkin_ then
    Gui.SetTooltipSkin(prevTooltipSkin_)
    prevTooltipSkin_ = nil
  end
end

return {
	saveTooltipSkin		= saveTooltipSkin,
	restoreTooltipSkin	= restoreTooltipSkin,
}