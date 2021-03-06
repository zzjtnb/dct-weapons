-- Transportpanzaer 1 TPZ Fuchs

GT = {};
GT_t.ws = 0;

set_recursive_metatable(GT, GT_t.generic_wheel_vehicle)
set_recursive_metatable(GT.chassis, GT_t.CH_t.FUCHS);

GT.visual.shape = "tpz"
GT.visual.shape_dstr = "Tpz_p_1"

--chassis
GT.swing_on_run = false

GT.sensor = {}
set_recursive_metatable(GT.sensor, GT_t.SN_visual)

--Burning after hit
GT.visual.fire_size = 0.6 --relative burning size
GT.visual.fire_pos[1] = 0 -- center of burn at long axis shift(meters)
GT.visual.fire_pos[2] = 0 -- center of burn shift at vertical shift(meters)
GT.visual.fire_pos[3] = 0 -- center of burn at transverse axis shift(meters)
GT.visual.fire_time = 900 --burning time (seconds)

GT.driverViewPoint = {2.22, 2.135, -0.3};
GT.driverCockpit = "DriverCockpit/DriverCockpitWithLLTV"

GT.WS = {}
GT.WS.maxTargetDetectionRange = 5000;
local ws = GT_t.inc_ws();
GT.WS[ws] = {}
GT.WS[ws].angles = {
					{math.rad(135), math.rad(-135), math.rad(-9), math.rad(60)},
                    {math.rad(-135), math.rad(135), math.rad(-2.7), math.rad(60)},
					};
GT.WS[ws].omegaY = math.rad(60);
GT.WS[ws].omegaZ = math.rad(60);
GT.WS[ws].pidY = {p=60, i=0.1, d=8, inn=5.5};
GT.WS[ws].pidZ = {p=60, i=0.1, d=8, inn=5.5};
GT.WS[ws].center = "CENTER_TOWER";
GT.WS[ws].drawArgument1 = 0;
GT.WS[ws].drawArgument2 = 1;

local __LN = add_launcher(GT.WS[ws], GT_t.LN_t.machinegun_MG3);
set_recursive_metatable(__LN.sensor, GT_t.WSN_t[2]);
__LN.PL[1].ammo_capacity = 100;
__LN.PL[1].portionAmmoCapacity = 100;
__LN.PL[1].reload_time = 20;
__LN.PL[1].switch_on_delay = 15;
for i = 2, 6 do
    __LN.PL[i] = {};
    set_recursive_metatable(__LN.PL[i], __LN.PL[1]);
end
__LN.BR[1].connector_name = 'POINT_MGUN';
__LN.customViewPoint = { "IronSight/IronSight", {-0.8, 0.07, -0.0015 }, };

GT.Name = "TPZ"
GT.DisplayName = _("TPz Fuchs")
GT.Rate = 8

GT.DetectionRange  = 0;
GT.ThreatRange = GT.WS[1].LN[1].distanceMax;
GT.mapclasskey = "P0091000004";
GT.attribute = {wsType_Ground,wsType_Tank,wsType_Gun,wsType_GenericAPC,
                    "APC",
        };
GT.category = "Armor";
GT.InternalCargo = {
			nominalCapacity = 1000,
			maximalCapacity = 1000, --???????????????????????? ??????????, ?????????????? ?????????? ???????????????? ?? ??????. ????., ???????????????????????? ?????? transportable.size
		}