--[[
-- wind_sigma = 5, - The value determines the amount of constant
--   acceleration (determined randomly at the moment the submunition is
--   ejected) that will affect it throughout the flight.
-- impulse_sigma = 0, - MSWO along the vector of a random impulse. The mean
--   square value of the three components of the velocity vector with which
--   the velocity vector of the bomb itself is added to obtain the initial
--   velocity of the submunition (In general, it determines how much the
--   velocity vector of the submunition will differ from the velocity
--   vector of the bomb itself)
-- moment_sigma = 0.01, - The value determines how much the vector of the
--   angular velocity of rotation of the submunition will differ from the
--   vector of the angular velocity of rotation of the bomb itself, at the
--   moment of deployment
--]]

weapons_table.weapons.bombs = namespace();
weapons_table.weapons.bombs.targeting = namespace();

function form_bomb(name, user_name, model, level3, scheme, data, targeting_data, class_name, wstype_name)
	local wstype_name = wstype_name
	if  wstype_name == nil then
		wstype_name = _G[name]
	end

    local res = dbtype(class_name or "wAmmunitionFuzeCtrl",
    {
        ws_type = {wsType_Weapon,wsType_Bomb, level3, wstype_name},
        model   = model,
    })

	copy_origin(res,data)

    data.fm.wind_time = 1000;

	data.fm.I = data.fm.I or calcIyz(data.fm.mass, data.fm.L, 0)
	data.fm.Ma = data.fm.Ma or calcMa(data.fm.I, data.fm.L, calcS(data.fm.caliber), 400)
	data.fm.Mw = data.fm.Mw or calcMw(data.fm.I, data.fm.L, calcS(data.fm.caliber))
	if data.warhead ~= nil then
		data.warhead.caliber = data.fm.caliber * 1000 --mm
	end

    if data.launcher ~= nil then
	    if data.launcher.ammunition_name ~= nil then
		   data.launcher.ammunition = weapons_table.weapons.bombs[data.launcher.ammunition_name]
		end
	end

	-- Arming vane activated by incoming air mass. Disabled by default.
	if data.arming_vane == nil then
		data.arming_vane = {enabled = false, velK = 1}
	end

	-- Arming delay timer. Enabled by default.
	if data.arming_delay == nil then
		data.arming_delay = {enabled = true, delay_time = 0.8}
	end

    res.server = {}
    res.client = {}

    copy_recursive_with_metatables(res.server, data)
    copy_recursive_with_metatables(res.client, data)

	res.server.scheme = "schemes/bombs/"..scheme..".sch"
    res.client.scheme = "schemes/bombs/"..scheme..".sch"

    if data.warhead ~= nil then
        res.server.warhead.fantom = 0
        res.client.warhead.fantom = 1
    end

	if data.launcher ~= nil then
        res.server.launcher.server = 1
        res.client.launcher.server = 0
    end

    res.mass 		   = data.fm.mass
    res.name 		   = name
	res.display_name   = user_name
    res.type_name      = "bomb"
	res.targeting_data = targeting_data

	res.skin_arg = data.skin_arg

	if not res.sounderName then
		res.sounderName = "Weapons/Bomb"
	end
    return res;
end

function declare_bomb(name, user_name, model, level3, scheme, data, targeting_data, class_name, wstype_name)

	local res = form_bomb(name, user_name, model, level3, scheme, data, targeting_data, class_name, wstype_name)

	weapons_table.weapons.bombs[res.name] = res
    register_targeting_data(res.name, res.ws_type,res.targeting_data);
	registerResourceName(res,CAT_BOMBS)
    return res;
end

function register_targeting_data(name, wstype, targeting_data)
    local res = dbtype("wBombSightData",
    {
        ws_type = wstype;
    });
    copy_recursive(res, targeting_data);
    weapons_table.weapons.bombs.targeting[name] = res;
end


function declare_cluster(name, level3, data)
    local res = cluster_desc(name, level3, data)

    weapons_table.weapons.bombs[name] = res

    return res;
end

declare_bomb("FAB_100", _("FAB-100"), "fab-100", wsType_Bomb_A, "bomb-common", {

    fm =
    {
        mass        = 100,
        caliber     = 0.3,
        cx_coeff    = {1,0.39,0.38,0.236,1.31},
        L           = 0.9,
        I           = 6.75,
        Ma          = 0.68,
        Mw          = 1.116,

        wind_sigma  = 20,
    },


    warhead = warheads["FAB_100"],
}, {
    char_time = 20.91
});

declare_bomb("FAB_250", _("FAB-250"), "fab-250-n1", wsType_Bomb_A, "bomb-common", {

    fm =
    {
            mass            = 236.000000,
            caliber         = 0.325000,
            cx_coeff        = {1.000000, 0.390000, 0.380000, 0.236000, 1.310000},
            L               = 1.480000,
            I               = 43.077867,
            Ma              = 0.141338,
            Mw              = 2.244756,

            wind_sigma      = 30.000000,
    },

    warhead = warheads["FAB_250"],
}, {
    char_time = 20.56
});

declare_bomb("FAB_500", _("FAB-500"), "fab-500-n3", wsType_Bomb_A, "bomb-common", {

    fm =
    {
            mass            = 500.000000,
            caliber         = 0.400000,
            cx_coeff        = {1.000000, 0.390000, 0.600000, 0.168000, 1.310000},
            L               = 2.430000,
            I               = 246.037500,
            Ma              = 0.324570,
            Mw              = 3.139597,

            wind_sigma      = 100.000000,
    },

    warhead = warheads["FAB_500"],
}, {
    char_time = 20.35
});


declare_bomb("FAB_1500", _("FAB-1500"), "fab-1500", wsType_Bomb_A, "bomb-common", {

    fm =
    {
            mass            = 1347.000000,
            caliber         = 0.622000,
            cx_coeff        = {1.000000, 0.400000, 0.370000, 0.288000, 1.310000},
            L               = 2.800000,
            I               = 880.040000,
            Ma              = 0.416675,
            Mw              = 3.497926,

            wind_sigma      = 100.000000,
    },

    warhead = warheads["FAB_1500"],
}, {
    char_time = 20.46
});



declare_bomb("LUU_2B", _("LUU-2B"), "luu-2", wsType_Bomb_Lighter, "bomb-light",
    {
        fm =
        {
            mass        = 13,
            caliber     = 0.3,
            cx_coeff    = {1.0, 0.39, 0.38, 0.236, 1.31},
            L           = 0.9,
            I           = 6.75,
            Ma          = 0.68,
            Mw          = 5.60,
            cx_factor   = 300,
            wind_sigma  = 0.0,
        },
        light =
        {
            start_time  = 2,
            duration    = 300,
            light_position = {0.45, -0.07, 0.0},
            light_color = {0.53 * 1.0, 0.53 * 1.0, 0.53 * 0.8},
            light_attenuation = 600.0, -- * 3.0 !
            smoke_position = {0.45, -0.07, 0.0},
            smoke_color = {0.952, 0.952, 0.952},
            smoke_transparency = 200.0/255.0,
            smoke_width = 1,
        },
        control =
        {
            delay_par   = 3,
        },
    },
    {
        v0 = 200,
        data =
        {
            {1.000000, 22.341401, 0.012462},
            {10.000000, 23.654340, 0.004693},
            {20.000000, 23.716158, 0.004518},
            {30.000000, 23.725884, 0.004449},
            {40.000000, 23.732343, 0.004403},
            {50.000000, 25.652849, 0.005138},
            {60.000000, 28.211796, -0.007471},
            {70.000000, 30.331842, -0.018103},
            {80.000000, 32.099833, -0.026828},
            {90.000000, 33.604543, -0.034071},
            {100.000000, 34.906022, -0.040211},
            {200.000000, 42.507192, -0.072484},
            {300.000000, 46.094889, -0.083853},
            {400.000000, 48.152369, -0.088149},
            {500.000000, 49.443189, -0.089688},
            {600.000000, 50.312083, -0.090209},
            {700.000000, 50.938257, -0.090435},
            {800.000000, 51.421467, -0.090658},
            {900.000000, 51.819370, -0.090982},
            {1000.000000, 52.166176, -0.091431},
            {1100.000000, 52.482557, -0.091997},
            {1200.000000, 52.781163, -0.092664},
            {1300.000000, 53.069819, -0.093412},
            {1400.000000, 53.353402, -0.094223},
            {1500.000000, 53.634970, -0.095085},
            {1600.000000, 53.916446, -0.095986},
            {1700.000000, 54.199051, -0.096918},
            {1800.000000, 54.483559, -0.097876},
            {1900.000000, 54.770471, -0.098855},
            {2000.000000, 55.060114, -0.099854},
            {3000.000000, 58.135449, -0.110652},
            {4000.000000, 61.578307, -0.122891},
            {5000.000000, 65.441641, -0.136735},
            {6000.000000, 69.785758, -0.152402},
            {7000.000000, 74.680457, -0.170127},
            {8000.000000, 80.206119, -0.190171},
            {9000.000000, 86.456436, -0.212829},
            {10000.000000, 93.539509, -0.164750},
        }
    },
    "wAmmunition_viHeavyObject"
);

declare_bomb("S-8OM_LE", _("S-8OM"), "luu-2", wsType_Bomb_Lighter, "bomb-light",
    {
        fm =
        {
            mass        = 20,
            caliber     = 0.3,
            cx_coeff    = {1.0, 0.39, 0.38, 0.236, 1.31},
            L           = 0.9,
            I           = 6.75,
            Ma          = 0.68,
            Mw          = 5.60,
            cx_factor   = 300,
            wind_sigma  = 0.0,
        },
        light =
        {
            start_time  = 2, -- time after booster separation, sec
            duration    = 35, -- burning time
            light_position = {0.45, -0.07, 0.0}, -- position at shape center, m
            light_color = {0.58 * 1.0, 0.58 * 1.0, 0.58 * 0.8}, -- light RGB
            light_attenuation = 660.0, -- * 3.0 ! -- light attenuation
            smoke_position = {0.45, -0.07, 0.0}, -- smoke position at shape center, m
            smoke_color = {0.952, 0.952, 0.952}, -- color of smoke
            smoke_transparency = 200.0/255.0, -- Transparensy of smoke, first digit 0...255
            smoke_width = 1, -- Width of smoke
        },
        control =
        {
            delay_par   = 1.0, -- Parachute delay, sec
        },
    },
    {
        v0 = 200,
        data =
        {
            {1.000000, 22.341401, 0.012462},
            {10.000000, 23.654340, 0.004693},
            {20.000000, 23.716158, 0.004518},
            {30.000000, 23.725884, 0.004449},
            {40.000000, 23.732343, 0.004403},
            {50.000000, 25.652849, 0.005138},
            {60.000000, 28.211796, -0.007471},
            {70.000000, 30.331842, -0.018103},
            {80.000000, 32.099833, -0.026828},
            {90.000000, 33.604543, -0.034071},
            {100.000000, 34.906022, -0.040211},
            {200.000000, 42.507192, -0.072484},
            {300.000000, 46.094889, -0.083853},
            {400.000000, 48.152369, -0.088149},
            {500.000000, 49.443189, -0.089688},
            {600.000000, 50.312083, -0.090209},
            {700.000000, 50.938257, -0.090435},
            {800.000000, 51.421467, -0.090658},
            {900.000000, 51.819370, -0.090982},
            {1000.000000, 52.166176, -0.091431},
            {1100.000000, 52.482557, -0.091997},
            {1200.000000, 52.781163, -0.092664},
            {1300.000000, 53.069819, -0.093412},
            {1400.000000, 53.353402, -0.094223},
            {1500.000000, 53.634970, -0.095085},
            {1600.000000, 53.916446, -0.095986},
            {1700.000000, 54.199051, -0.096918},
            {1800.000000, 54.483559, -0.097876},
            {1900.000000, 54.770471, -0.098855},
            {2000.000000, 55.060114, -0.099854},
            {3000.000000, 58.135449, -0.110652},
            {4000.000000, 61.578307, -0.122891},
            {5000.000000, 65.441641, -0.136735},
            {6000.000000, 69.785758, -0.152402},
            {7000.000000, 74.680457, -0.170127},
            {8000.000000, 80.206119, -0.190171},
            {9000.000000, 86.456436, -0.212829},
            {10000.000000, 93.539509, -0.164750},
        }
    },
    "wAmmunition_viHeavyObject",
    0
);

declare_bomb("SAB_100_LE", _("SAB-100"), "luu-2", wsType_Bomb_Lighter, "bomb-light",
    {
        fm =
        {
            mass        = 5.8,
            caliber     = 0.3,
            cx_coeff    = {1.0, 0.39, 0.38, 0.236, 1.31},
            L           = 0.9,
            I           = 6.75,
            Ma          = 0.68,
            Mw          = 5.60,
            cx_factor   = 300,
            wind_sigma  = 0.0,
        },
        light =
        {
            start_time  = 2, -- time after booster separation, sec
            duration    = 7.6 * 60.0, -- burning time
            light_position = {0.45, -0.07, 0.0}, -- position at shape center, m
            light_color = {0.25 * 1.0, 0.25 * 1.0, 0.25 * 0.8}, -- light RGB
            light_attenuation = 2000.0, -- * 3.0 ! -- light attenuation
            smoke_position = {0.45, -0.07, 0.0}, -- smoke position at shape center, m
            smoke_color = {0.952, 0.952, 0.952}, -- color of smoke
            smoke_transparency = 200.0/255.0, -- Transparensy of smoke, first digit 0...255
            smoke_width = 1, -- Width of smoke
        },
        control =
        {
            delay_par   = 3, -- Parachute delay, sec
        },
    },
    {
        v0 = 200,
        data =
        {
            {1.000000, 22.341401, 0.012462},
            {10.000000, 23.654340, 0.004693},
            {20.000000, 23.716158, 0.004518},
            {30.000000, 23.725884, 0.004449},
            {40.000000, 23.732343, 0.004403},
            {50.000000, 25.652849, 0.005138},
            {60.000000, 28.211796, -0.007471},
            {70.000000, 30.331842, -0.018103},
            {80.000000, 32.099833, -0.026828},
            {90.000000, 33.604543, -0.034071},
            {100.000000, 34.906022, -0.040211},
            {200.000000, 42.507192, -0.072484},
            {300.000000, 46.094889, -0.083853},
            {400.000000, 48.152369, -0.088149},
            {500.000000, 49.443189, -0.089688},
            {600.000000, 50.312083, -0.090209},
            {700.000000, 50.938257, -0.090435},
            {800.000000, 51.421467, -0.090658},
            {900.000000, 51.819370, -0.090982},
            {1000.000000, 52.166176, -0.091431},
            {1100.000000, 52.482557, -0.091997},
            {1200.000000, 52.781163, -0.092664},
            {1300.000000, 53.069819, -0.093412},
            {1400.000000, 53.353402, -0.094223},
            {1500.000000, 53.634970, -0.095085},
            {1600.000000, 53.916446, -0.095986},
            {1700.000000, 54.199051, -0.096918},
            {1800.000000, 54.483559, -0.097876},
            {1900.000000, 54.770471, -0.098855},
            {2000.000000, 55.060114, -0.099854},
            {3000.000000, 58.135449, -0.110652},
            {4000.000000, 61.578307, -0.122891},
            {5000.000000, 65.441641, -0.136735},
            {6000.000000, 69.785758, -0.152402},
            {7000.000000, 74.680457, -0.170127},
            {8000.000000, 80.206119, -0.190171},
            {9000.000000, 86.456436, -0.212829},
            {10000.000000, 93.539509, -0.164750},
        }
    },
    "wAmmunition_viHeavyObject",
    0
);



declare_bomb("BetAB_500", _("BetAB-500"), "betab-500", wsType_Bomb_BetAB, "bomb-common", {
    fm =
    {
        mass            = 478,
        caliber         = 0.35,
        cx_coeff        = {1.000000, 0.42,0.37, 0.306,1.27},
        L               = 2.2,
        I               = 220.833333,
        Ma              = 0.290638,
        Mw              = 2.769849,
        wind_time       = 1000.000000,
        wind_sigma      = 100.000000,
        cx_factor       = 300,
    },

    warhead = warheads["BetAB_500"],
}, {
    char_time       = 20.420000
});

local BetAB_500ShP = declare_bomb("BetAB_500ShP", _("BetAB-500ShP"), 'betab-500sp', wsType_Bomb_BetAB, "bomb-concrete", {
    fm =
    {
        mass            = 372.200000,
        caliber         = 0.325000,
        cx_coeff        = {1.000000, 0.390000, 0.600000, 0.168000, 1.310000},
        L               = 2.500000,
        I               = 220.833333,
        Ma              = 0.290638,
        Mw              = 2.769849,
        wind_time       = 1000.000000,
        wind_sigma      = 100.000000,

        cx_factor       = 300,
    },

    warhead = warheads["BetAB_500ShP"],

    engine =
    {
        fuel_mass   = 51.8,
        impulse     = 170,
        boost_time  = 0,
        work_time   = 1.3,
        boost_factor= 1,
        nozzle_position =  {{-0.9, -0.167, 0}},
		nozzle_orientationXYZ =  {{0, 0, 0}},
        tail_width  = 0.55,
        boost_tail  = 1,
        work_tail   = 1,

        smoke_color = {0.6, 0.6, 0.6},
        smoke_transparency = 0.3,
    },

    control =
    {
        delay_par   = 1.5,
        delay_eng   = 10,
    },

}, {
    v0 = 200,
    data =
    {
        {1.000000, 20.200000, 0.000000},
        {10.000000, 20.277292, 0.000140},
        {20.000000, 20.974612, -0.001161},
        {30.000000, 22.769170, -0.004716},
        {40.000000, 24.530820, -0.008370},
        {50.000000, 26.006583, -0.011409},
        {60.000000, 27.225948, -0.013867},
        {70.000000, 28.244350, -0.015948},
        {80.000000, 29.104125, -0.017757},
        {90.000000, 29.847648, -0.019331},
        {100.000000, 30.497785, -0.020713},
        {200.000000, 34.417633, -0.029035},
        {300.000000, 36.463728, -0.032998},
        {400.000000, 37.804113, -0.035178},
        {500.000000, 38.757713, -0.036380},
        {600.000000, 39.461708, -0.036995},
        {700.000000, 39.992857, -0.037257},
        {800.000000, 40.400741, -0.037312},
        {900.000000, 40.719782, -0.037253},
        {1000.000000, 40.974474, -0.037137},
        {1100.000000, 41.182447, -0.036998},
        {1200.000000, 41.356427, -0.036855},
        {1300.000000, 41.505608, -0.036721},
        {1400.000000, 41.636693, -0.036598},
        {1500.000000, 41.754532, -0.036490},
        {1600.000000, 41.862668, -0.036396},
        {1700.000000, 41.963673, -0.036315},
        {1800.000000, 42.059437, -0.036246},
        {1900.000000, 42.151341, -0.036187},
        {2000.000000, 42.240399, -0.036136},
        {3000.000000, 43.072382, -0.035844},
        {4000.000000, 43.883330, -0.035602},
        {5000.000000, 44.690588, -0.035290},
        {6000.000000, 45.492075, -0.034901},
        {7000.000000, 46.284544, -0.034433},
        {8000.000000, 47.064678, -0.033892},
        {9000.000000, 47.829238, -0.033280},
        {10000.000000, 48.574960, -0.032601},
    }
})

BetAB_500ShP.sounderName = "Weapons/BetAB_500ShP"

register_targeting_data("PTAB_2_5",    {wsType_Weapon, wsType_Bomb, wsType_Bomb_A, PTAB_2_5KO}, { char_time = 21.5 });
register_targeting_data("AO_2_5_DATA", {wsType_Weapon, wsType_Bomb, wsType_Bomb_A, AO_2_5RT},   { char_time = 21.5 });

declare_cluster("KMGU_2_PTAB_2_5KO", wsType_Container,
    combine_cluster(PTAB_2_5_DATA,
        {
            cluster = {
                count        = 12,
                effect_count = 12,

                wind_sigma  = 5,
                impulse_sigma = 0,
                moment_sigma = 0.0001,
            }

        },
		"cluster"
    )
);

declare_cluster("KMGU_2_AO_2_5RT", wsType_Container,
    combine_cluster(AO_2_5_DATA,
        {
            cluster = {
                count        = 12,
                effect_count = 12,

                wind_sigma  = 5,
                impulse_sigma = 0,
                moment_sigma = 0.1,
            }
        },
		"cluster"
    )
);


-- RBK-250 w/ ptab
declare_bomb("RBK_250", _("RBK-250"), "RBK_250_PTAB_25M_cassette", wsType_Bomb_Cluster, "bomb-cassette", {
    fm =
    {
            mass            = 244.600000,
            caliber         = 0.325000,
            cx_coeff        = {1.000000, 0.390000, 0.600000, 0.168000, 1.310000},
            L               = 2.300000,
            I               = 107.827833,
            Ma              = 0.227651,
            Mw              = 2.326556,
            wind_time       = 1000.000000,
            wind_sigma      = 100.000000,
    },

	launcher =
    {
        cluster = cluster_desc("PTAB_2_5KO", wsType_Bomb_Cluster,
		{
			scheme =
			{
				bomb_nose =
				{
					mass					= 15,
					caliber					= 0.325,
					L						= 2,
					I						= 1,
					Ma						= 0.3,
					Mw						= 1,
					cx_coeff				= {1, 0.39, 0.6, 0.168, 1.31},
					model_name				= "RBK_250_PTAB_25M_nose",
					init_impulse			= {{300,0,0}},
				},
				dispenser =
				{
					mass					= 244,
					caliber					= 0.325,
					L						= 2.3,
					I						= 107.827833,
					Ma						= 0.227651,
					Mw						= 2.326556,
					cx_coeff				= {1, 0.39, 0.6, 0.168, 1.31},
					model_name				= "RBK_250_PTAB_25M_tail",
					set_start_args			= {},
					spawn_time				= {0, 0.5},
					spawn_weight_loss		= {0, 160},
					spawn_args_change		= {},
					op_spawns				= 2,
					use_effects				= 1,
					hide_effect_0			= 1,
				},
				empty_dispenser =
				{
					mass					= 35,
					caliber					= 0.325,
					L						= 1,
					I						= 1,
					Ma						= 0.3,
					Mw						= 1,
					cx_coeff				= {1,1,1,1,2},
					model_name				= "RBK_250_PTAB_25M_tail",
					init_impulse			= {{0,0,0}},
					spawn_options			= {{1,1,1}},
				},
				bomblets =
				{
					wind_sigma				= 8,
					impulse_sigma			= 0.5,
					moment_sigma			= 0.12,
					count					= 42,
					effect_count			= 42,
					mass					= 2.8,
					caliber					= 0.068,
					cx_coeff				= {1,0.39,0.38,0.236,1.31},
					L						= 0.332,
					I						= 0.025719,
					Ma						= 0.137484,
					Mw						= 1.208365,
					model_name				= "RBK_250_PTAB_25M_bomb",
					connectors_model_name	= "RBK_250_PTAB_25M_tail",
					explosion_impulse_coeff	= 3,
					explosion_center		= {{0.16,0,0}},
					spawn_options			= {{0,1,42}},
				},
				warhead = warheads["PTAB-2-5"],
			},

			name    		= _("PTAB-2-5"),
			type_name		= _("cluster"),
			cluster_scheme	= "rbk_simple",
		}
		)
    },

    control =
    {
        open_delay = 3.4,
    },

}, {
    v0 = 200.0,
    data =
    {
        {1.000000, 20.200000, 0.000000},
        {10.000000, 20.355862, 0.000077},
        {20.000000, 20.378514, -0.000090},
        {30.000000, 20.384561, -0.000115},
        {40.000000, 20.385621, -0.000124},
        {50.000000, 20.389593, -0.000166},
        {60.000000, 20.389580, -0.000161},
        {70.000000, 20.390587, -0.000157},
        {80.000000, 20.389651, -0.000151},
        {90.000000, 20.391540, -0.000169},
        {100.000000, 20.392405, -0.000155},
        {200.000000, 20.453696, -0.000083},
        {300.000000, 20.529240, -0.000012},
        {400.000000, 20.594815, 0.000041},
        {500.000000, 20.649695, 0.000076},
        {600.000000, 20.696233, 0.000101},
        {700.000000, 20.736040, 0.000120},
        {800.000000, 20.770731, 0.000134},
        {900.000000, 20.801297, 0.000143},
        {1000.000000, 20.828531, 0.000151},
        {1100.000000, 20.853044, 0.000156},
        {1200.000000, 20.875318, 0.000159},
        {1300.000000, 20.895624, 0.000162},
        {1400.000000, 20.914330, 0.000163},
        {1500.000000, 20.931645, 0.000163},
        {1600.000000, 20.947761, 0.000163},
        {1700.000000, 20.962794, 0.000161},
        {1800.000000, 20.976925, 0.000159},
        {1900.000000, 20.990205, 0.000156},
        {2000.000000, 21.002764, 0.000153},
        {3000.000000, 21.100815, 0.000106},
        {4000.000000, 21.170027, 0.000042},
        {5000.000000, 21.224200, -0.000028},
        {6000.000000, 21.268902, -0.000100},
        {7000.000000, 21.306828, -0.000173},
        {8000.000000, 21.339423, -0.000244},
        {9000.000000, 21.367518, -0.000314},
        {10000.000000, 21.391591, -0.000383},
    }
});

-- РБК-500-255 ПТАБ 10-5
declare_bomb("RBK_500AO", _("RBK-500-255 PTAB-10-5"), "RBK_500_255_PTAB_10_5_cassette", wsType_Bomb_Cluster, "bomb-cassette", {
    fm =
    {
		mass            = 253,
		caliber         = 0.4,
		cx_coeff        = {1, 0.39, 0.6, 0.168, 1.31},
		L               = 2.43,
		I               = 124.494975,
		Ma              = 0.164233,
		Mw              = 1.588636,
		wind_time       = 1000.0,
		wind_sigma      = 100.0,
    },

	launcher =
    {
        cluster = cluster_desc("Bomb_Other", wsType_Bomb_Cluster,
		{
			scheme =
			{
				bomb_nose =
				{
					mass					= 15,
					caliber					= 0.4,
					L						= 2,
					I						= 2,
					Ma						= 0.3,
					Mw						= 1,
					cx_coeff				= {1, 0.39, 0.6, 0.168, 1.31},
					model_name				= "RBK_500_255_PTAB_10_5_nose",
					init_impulse			= {{300,0,0}},
				},
				dispenser =
				{
					mass					= 253,
					caliber					= 0.4,
					L						= 2.43,
					I						= 124.494975,
					Ma						= 0.164233,
					Mw						= 1.588636,
					cx_coeff				= {1, 0.39, 0.6, 0.168, 1.31},
					model_name				= "RBK_500_255_PTAB_10_5_tail",
					set_start_args			= {},
					spawn_time				= {0, 0.5},
					spawn_weight_loss		= {0, 160},
					spawn_args_change		= {},
					op_spawns				= 2,
					use_effects				= 1,
					hide_effect_0			= 1,
				},
				empty_dispenser =
				{
					mass					= 45,
					caliber					= 0.4,
					L						= 2,
					I						= 2,
					Ma						= 0.3,
					Mw						= 1,
					cx_coeff				= {1,1,1,1,2},
					model_name				= "RBK_500_255_PTAB_10_5_tail",
					init_impulse			= {{0,0,0}},
					spawn_options			= {{1,1,1}},
				},
				bomblets =
				{
					wind_sigma					= 6,
					impulse_sigma				= 4,
					moment_sigma				= 0.1,
					count						= 30,
					effect_count				= 30,
					mass						= 4.6,
					caliber						= 0.080000,
					cx_coeff					= {1, 0.39, 0.38, 0.236, 1.31},
					L							= 0.400000,
					I							= 0.061333,
					Ma							= 0.196612,
					Mw							= 0.722107,
					model_name					= "RBK_500_255_PTAB_10_5_bomb",
					connectors_model_name		= "RBK_500_255_PTAB_10_5_tail",
					explosion_impulse_coeff		= 5,
					explosion_dont_use_x_axis	= 1,
					explosion_center			= {{0,0,0}},
					spawn_options				= {{0,1,30}},
				},
				warhead = warheads["PTAB-10-5"],
			},

			name    		= _("PTAB-10-5"),
			type_name		= _("cluster"),
			cluster_scheme	= "rbk_simple",
		}
		)
    },

    control =
    {
        open_delay = 3.5,
    },

}, {
    v0 = 200.0,
    data =
    {
        {1.000000, 20.200000, 0.000000},
        {10.000000, 20.443164, 0.000001},
        {20.000000, 20.467441, -0.000170},
        {30.000000, 20.475234, -0.000199},
        {40.000000, 20.476446, -0.000209},
        {50.000000, 20.479972, -0.000252},
        {60.000000, 20.480324, -0.000249},
        {70.000000, 20.482148, -0.000257},
        {80.000000, 20.481281, -0.000241},
        {90.000000, 20.482720, -0.000259},
        {100.000000, 20.483667, -0.000247},
        {200.000000, 20.529902, -0.000179},
        {300.000000, 20.585581, -0.000106},
        {400.000000, 20.633787, -0.000045},
        {500.000000, 20.674180, -0.000000},
        {600.000000, 20.708441, 0.000036},
        {700.000000, 20.737702, 0.000065},
        {800.000000, 20.763255, 0.000087},
        {900.000000, 20.785809, 0.000106},
        {1000.000000, 20.805897, 0.000121},
        {1100.000000, 20.824022, 0.000133},
        {1200.000000, 20.840452, 0.000143},
        {1300.000000, 20.855518, 0.000151},
        {1400.000000, 20.869384, 0.000158},
        {1500.000000, 20.882217, 0.000163},
        {1600.000000, 20.894175, 0.000167},
        {1700.000000, 20.905367, 0.000170},
        {1800.000000, 20.915877, 0.000172},
        {1900.000000, 20.925774, 0.000174},
        {2000.000000, 20.935142, 0.000174},
        {3000.000000, 21.008637, 0.000156},
        {4000.000000, 21.060971, 0.000112},
        {5000.000000, 21.102148, 0.000058},
        {6000.000000, 21.136144, -0.000000},
        {7000.000000, 21.164866, -0.000060},
        {8000.000000, 21.189321, -0.000120},
        {9000.000000, 21.210072, -0.000178},
        {10000.000000, 21.227430, -0.000236},
    }
});

declare_bomb("RBK_500U", _("RBK-500 PTAB-1M"), "RBK_500_PTAB_1M_cassette", wsType_Bomb_Cluster, "bomb-cassette", {
    fm =
    {
		mass            = 427,
		caliber         = 0.4,
		cx_coeff        = {1, 0.39, 0.6, 0.168, 1.31},
		L               = 2.430000,
		wind_time       = 1000,
		wind_sigma      = 100,
    },

    launcher =
    {
        cluster = cluster_desc("Bomb_Other", wsType_Bomb_Cluster,
		{
			scheme =
			{
				bomb_nose =
				{
					mass					= 20,
					caliber					= 0.4,
					L						= 2,
					I						= 2,
					Ma						= 0.3,
					Mw						= 1,
					cx_coeff				= {1, 0.39, 0.6, 0.168, 1.31},
					model_name				= "RBK_500_PTAB_1M_nose",
					init_impulse			= {{300,0,0}},
				},
				dispenser =
				{
					mass					= 253,
					caliber					= 0.4,
					L						= 2.43,
					I						= 124.494975,
					Ma						= 0.164233,
					Mw						= 1.588636,
					cx_coeff				= {1, 0.39, 0.6, 0.168, 1.31},
					model_name				= "RBK_500_PTAB_1M_tail",
					set_start_args			= {},
					spawn_time				= {0, 0.5},
					spawn_weight_loss		= {0, 250},
					spawn_args_change		= {},
					op_spawns				= 2,
					use_effects				= 1,
					hide_effect_0			= 1,
				},
				empty_dispenser =
				{
					mass					= 35,
					caliber					= 0.4,
					L						= 2,
					I						= 2,
					Ma						= 0.3,
					Mw						= 1,
					cx_coeff				= {1,1,1,1,2},
					model_name				= "RBK_500_PTAB_1M_tail",
					init_impulse			= {{0,0,0}},
					spawn_options			= {{1,1,1}},
				},
				bomblets =
				{
					wind_sigma				= 8,
					impulse_sigma			= 3,
					moment_sigma			= 0.03,
					count					= 268,
					effect_count			= 45,
					mass					= 0.94,
					caliber					= 0.042,
					cx_coeff				= {1, 0.39, 0.38, 0.236, 1.31},
					L						= 0.26,
					I						= 0.061333,
					Ma						= 0.196612,
					Mw						= 0.722107,
					model_name				= "RBK_500_PTAB_1M_bomb",
					connectors_model_name	= "RBK_500_PTAB_1M_tail",
					explosion_impulse_coeff	= 2,
					explosion_center		= {{0,0,0}},
					spawn_options			= {{0,1,268}},
					set_release_args		= {2},
				},
				warhead = warheads["PTAB-1M"],
			},

			name    		= _("PTAB-1M"),
			type_name		= _("cluster"),
			cluster_scheme	= "rbk_simple",
		}
		)
    },

    control =
    {
        open_delay = 3.5,
    },

}, {
    v0 = 200.0,
    data =
    {
        {1.000000, 20.200000, 0.000000},
        {10.000000, 20.443164, 0.000001},
        {20.000000, 20.467441, -0.000170},
        {30.000000, 20.475234, -0.000199},
        {40.000000, 20.476446, -0.000209},
        {50.000000, 20.479972, -0.000252},
        {60.000000, 20.480324, -0.000249},
        {70.000000, 20.482148, -0.000257},
        {80.000000, 20.481281, -0.000241},
        {90.000000, 20.482720, -0.000259},
        {100.000000, 20.483667, -0.000247},
        {200.000000, 20.529902, -0.000179},
        {300.000000, 20.585581, -0.000106},
        {400.000000, 20.633787, -0.000045},
        {500.000000, 20.674180, -0.000000},
        {600.000000, 20.708441, 0.000036},
        {700.000000, 20.737702, 0.000065},
        {800.000000, 20.763255, 0.000087},
        {900.000000, 20.785809, 0.000106},
        {1000.000000, 20.805897, 0.000121},
        {1100.000000, 20.824022, 0.000133},
        {1200.000000, 20.840452, 0.000143},
        {1300.000000, 20.855518, 0.000151},
        {1400.000000, 20.869384, 0.000158},
        {1500.000000, 20.882217, 0.000163},
        {1600.000000, 20.894175, 0.000167},
        {1700.000000, 20.905367, 0.000170},
        {1800.000000, 20.915877, 0.000172},
        {1900.000000, 20.925774, 0.000174},
        {2000.000000, 20.935142, 0.000174},
        {3000.000000, 21.008637, 0.000156},
        {4000.000000, 21.060971, 0.000112},
        {5000.000000, 21.102148, 0.000058},
        {6000.000000, 21.136144, -0.000000},
        {7000.000000, 21.164866, -0.000060},
        {8000.000000, 21.189321, -0.000120},
        {9000.000000, 21.210072, -0.000178},
        {10000.000000, 21.227430, -0.000236},
    }
});

declare_bomb("SAB_100", _("SAB-100"), "sab-100", wsType_Bomb_Lighter, "bomb-sab", {
    fm =
    {
        mass            = 236.000000,
        caliber         = 0.325000,
        cx_coeff        = {1.000000, 0.390000, 0.380000, 0.236000, 1.310000},
        L               = 1.480000,
        I               = 43.077867,
        Ma              = 0.141338,
        Mw              = 2.244756,

        wind_sigma      = 30.000000,
    },

    launcher =
    {
        ammunition = weapons_table.weapons.bombs["SAB_100_LE"],
    },

    control =
    {
        open_delay    = 4.0,
        open_interval = 1.0,
        items_count   = 7,
    },

}, {
    v0 = 200.0,
    data =
    {
        {1.000000, 20.200000, 0.000000},
        {10.000000, 20.509089, 0.000697},
        {20.000000, 20.534085, 0.000543},
        {30.000000, 20.542844, 0.000531},
        {40.000000, 20.543906, 0.000524},
        {50.000000, 20.546878, 0.000480},
        {60.000000, 20.547320, 0.000488},
        {70.000000, 20.549030, 0.000480},
        {80.000000, 20.548636, 0.000505},
        {90.000000, 20.549367, 0.000484},
        {100.000000, 20.549406, 0.000498},
        {200.000000, 20.590584, 0.000542},
        {300.000000, 20.855309, 0.002640},
        {400.000000, 22.496102, -0.006315},
        {500.000000, 23.691362, -0.012398},
        {600.000000, 24.603243, -0.016605},
        {700.000000, 25.329704, -0.019680},
        {800.000000, 25.925878, -0.021986},
        {900.000000, 26.425765, -0.023745},
        {1000.000000, 26.851959, -0.025102},
        {1100.000000, 27.220276, -0.026160},
        {1200.000000, 27.542270, -0.026993},
        {1300.000000, 27.826775, -0.027657},
        {1400.000000, 28.080568, -0.028195},
        {1500.000000, 28.309012, -0.028638},
        {1600.000000, 28.516458, -0.029010},
        {1700.000000, 28.706412, -0.029332},
        {1800.000000, 28.881753, -0.029617},
        {1900.000000, 29.044852, -0.029876},
        {2000.000000, 29.197707, -0.030119},
        {3000.000000, 30.428483, -0.032547},
        {4000.000000, 31.517370, -0.035797},
        {5000.000000, 32.678243, -0.039915},
        {6000.000000, 33.977899, -0.044804},
        {7000.000000, 35.451252, -0.050483},
        {8000.000000, 37.129366, -0.057049},
        {9000.000000, 39.047051, -0.064647},
        {10000.000000, 41.245435, -0.073455},
    }
});

declare_bomb("M_117", _("M117"), "m117", wsType_Bomb_A, "bomb-common", {

    fm =
    {
            mass            = 408.000000,
            caliber         = 0.408000,
            cx_coeff        = {1.000000, 0.290000, 0.710000, 0.130000, 1.280000},
            L               = 2.060000,
            I               = 144.282400,
            Ma              = 2.746331,
            Mw              = 2.146083,
            wind_time       = 1000.000000,
            wind_sigma      = 150.000000,
    },

    warhead = warheads["M_117"],
}, {
    char_time       = 20.33560000
});


declare_bomb("Mk_81", _("Mk-81"), "mk-81", wsType_Bomb_A, "bomb-common", {

    fm =
    {
            mass            = 113.000000,
            caliber         = 0.230000,
            cx_coeff        = {1.000000, 0.320000, 0.710000, 0.150000, 1.280000},
            L               = 1.880000,
            I               = 33.282267,
            Ma              = 2.746331,
            Mw              = 2.146083,
            wind_time       = 1000.000000,
            wind_sigma      = 80.000000,
    },

    warhead = warheads["Mk_81"],
}, {
    char_time       = 20.360000
});

declare_bomb("Mk_82", _("Mk-82"), "mk-82", wsType_Bomb_A, "bomb-common", {
    fm =
    {
            mass            = 232.000000,
            caliber         = 0.273000,
            cx_coeff        = {1.000000, 0.290000, 0.710000, 0.140000, 1.280000},
            L               = 2.210000,
            I               = 94.425933,
            Ma              = 2.746331,
            Mw              = 2.146083,
            wind_time       = 1000.000000,
            wind_sigma      = 80.000000,
    },

    warhead = warheads["Mk_82"],
}, {
    char_time       = 20.320000
});

declare_bomb("AN_M64", _("AN-M64"), "AN-M64", wsType_Bomb_A, "bomb-common", {
    fm =
    {
            mass            = 227.000000,
            caliber         = 0.273000,
            cx_coeff        = {1.000000, 0.290000, 0.710000, 0.140000, 1.280000},
            L               = 1.4478,
            I               = 94.425933,
            Ma              = 2.746331,
            Mw              = 2.146083,
            wind_time       = 1000.000000,
            wind_sigma      = 80.000000,
    },

    warhead = warheads["AN_M64"],
}, {
    char_time       = 20.320000
});

declare_bomb("BDU_50LD", _("BDU-50LD"), "BDU-50LD", wsType_Bomb_A, "bomb-common", {
    fm =
    {
            mass            = 232.000000,
            caliber         = 0.273000,
            cx_coeff        = {1.000000, 0.290000, 0.710000, 0.140000, 1.280000},
            L               = 2.210000,
            I               = 94.425933,
            Ma              = 2.746331,
            Mw              = 2.146083,
            wind_time       = 1000.000000,
            wind_sigma      = 80.000000,
    },

    warhead = warheads["BDU"],
}, {
    char_time       = 20.320000
});

declare_bomb("BDU_50HD", _("BDU-50HD"), "BDU-50HD", wsType_Bomb_A, "bomb-parashute", {
      fm =
    {
			mass            = 232.000000,
            caliber         = 0.273000,
            cx_coeff        = {1.000000, 0.290000, 0.710000, 0.140000, 1.280000},
            L               = 2.210000,
			I				= 94.42593,
			cx_factor   	= 100,

			wind_time 		= 1000,
			wind_sigma      = 8.0,
    },

    warhead = warheads["BDU"],

	control =
    {
        open_delay = 0.2,
    },

},{
	v0 = 200,
	data =
    {
  	{1.000000, 21.147949, 0.002807},
	{10.000000, 28.262668, -0.017193},
	{20.000000, 29.687629, -0.016767},
	{30.000000, 30.394407, -0.015892},
	{40.000000, 30.826322, -0.015080},
	{50.000000, 31.133114, -0.014428},
	{60.000000, 31.361560, -0.013889},
	{70.000000, 31.543970, -0.013440},
	{80.000000, 31.690640, -0.013045},
	{90.000000, 31.814418, -0.012713},
	{100.000000, 31.920050, -0.012425},
	{200.000000, 32.511629, -0.010723},
	{300.000000, 32.789778, -0.009863},
	{400.000000, 32.963413, -0.009307},
	{500.000000, 33.086372, -0.008907},
	{600.000000, 33.179450, -0.008596},
	{700.000000, 33.253103, -0.008346},
	{800.000000, 33.312920, -0.008139},
	{900.000000, 33.362577, -0.007968},
	{1000.000000, 33.404350, -0.007824},
	{1100.000000, 33.439925, -0.007702},
	{1200.000000, 33.470498, -0.007599},
	{1300.000000, 33.496988, -0.007513},
	{1400.000000, 33.520106, -0.007440},
	{1500.000000, 33.540403, -0.007378},
	{1600.000000, 33.558365, -0.007327},
	{1700.000000, 33.574326, -0.007285},
	{1800.000000, 33.588629, -0.007251},
	{1900.000000, 33.601489, -0.007224},
	{2000.000000, 33.613137, -0.007202},
	{3000.000000, 33.690673, -0.007191},
	{4000.000000, 33.737805, -0.007357},
	{5000.000000, 33.773738, -0.007590},
	{6000.000000, 33.802367, -0.007864},
	{7000.000000, 33.824277, -0.008170},
	{8000.000000, 33.839206, -0.008505},
	{9000.000000, 33.846586, -0.008868},
	{10000.000000, 33.845625, -0.009258},
    }
},
"wAmmunitionBallute"
);

declare_bomb("BDU_33", _("BDU-33"), "BDU-33", wsType_Bomb_A, "bomb-smoke", {
    fm =
    {
            mass            = 11.300000,
            caliber         = 0.10,
            cx_coeff        = {1.000000, 0.820000, 0.650000, 0.142000, 2.110000},
            L               = 0.5750000,
            I               = 94.425933,
            Ma              = 2.746331,
            Mw              = 2.146083,
            wind_time       = 1000.000000,
            wind_sigma      = 80.000000,
    },

    warhead = warheads["HYDRA_70_SMOKE"],
}, {
    char_time       = 20.540000
});

declare_bomb("Mk_83", _("Mk-83"), "mk-83", wsType_Bomb_A, "bomb-common", {
    fm =
    {
            mass            = 454.000000,
            caliber         = 0.356000,
            cx_coeff        = {1.000000, 0.290000, 0.710000, 0.130000, 1.280000},
            L               = 3.000000,
            I               = 340.500000,
            Ma              = 2.746331,
            Mw              = 2.146083,
            wind_time       = 1000.000000,
            wind_sigma      = 150.000000,
    },
    warhead = warheads["Mk_83"],
}, {
    char_time       = 20.280000
});

declare_bomb("Mk_84", _("Mk-84"), "mk-84", wsType_Bomb_A, "bomb-common", {
    fm =
    {
            mass            = 908.000000,
            caliber         = 0.457000,
            cx_coeff        = {1.000000, 0.390000, 0.60000, 0.1680000, 1.310000},
            L               = 2.5,
            I               = 864.446267,
            Ma              = 2.746331,
            Mw              = 2.146083,
            wind_time       = 1000.000000,
            wind_sigma      = 220.000000,
    },
    warhead = warheads["Mk_84"],
}, {
    char_time       = 20.318
});


declare_bomb("ROCKEYE", _("ROCKEYE"), "rockeye", wsType_Bomb_Cluster, "bomb-cassette-2", {
    fm =
    {
        mass            = 222.000000,
        caliber         = 0.335000,
        cx_coeff        = {1.000000, 0.390000, 0.600000, 0.168000, 1.310000},
        L               = 2.340000,
        I               = 101.298600,
        Ma              = 0.197848,
        Mw              = 1.987409,
        wind_time       = 1000.000000,
        wind_sigma      = 100.000000,
    },

    launcher =
    {
        cluster = cluster_desc("Bomb_Other", wsType_Bomb_Cluster, combine_cluster(MK118_DATA,
        {
            cluster = {
                count        = 247,
                effect_count = 20,

                wind_sigma  = 50,
                impulse_sigma = 2,
                moment_sigma = 0.0001,
            }
        },
		"cluster"
		)
		)
    },

    control =
    {
        default_delay		= 1.2,
		default_open_height = 457,
    },

}, {
    char_time				= 20.43,
	bomblet_char_time		= 23.8,
});

declare_bomb("CBU_52B", _("CBU-52B"), "cbu-24b", wsType_Bomb_Cluster, "bomb-cassette", {
    fm =
    {
        mass            = 244.600000,
        caliber         = 0.325000,
		cx_coeff        = {1.000000, 0.390000, 0.600000, 0.168000, 1.310000},
		L               = 2.300000,
		I               = 107.827833,
		Ma              = 0.227651,
		Mw              = 2.326556,
		wind_time       = 1000.000000,
		wind_sigma      = 100.000000,
    },

    launcher =
    {
        cluster = cluster_desc("Bomb_Other", wsType_Bomb_Cluster, combine_cluster(BLU61_DATA,
        {
            cluster = {
                count        = 220,
                effect_count = 50,

                wind_sigma  = 5,
                impulse_sigma = 2, -- было 20
                moment_sigma = 0.0001,
            }
        },
		"cluster"
		)
		)
    },

    control =
    {
        open_delay = 4.0,
    },

}, {
    v0 = 200.0,
    data =
    {
		{1.000000, 20.200000, 0.000000},
        {10.000000, 20.355862, 0.000077},
        {20.000000, 20.378514, -0.000090},
        {30.000000, 20.384561, -0.000115},
        {40.000000, 20.385621, -0.000124},
        {50.000000, 20.389593, -0.000166},
        {60.000000, 20.389580, -0.000161},
        {70.000000, 20.390587, -0.000157},
        {80.000000, 20.389651, -0.000151},
        {90.000000, 20.391540, -0.000169},
        {100.000000, 20.392405, -0.000155},
        {200.000000, 20.453696, -0.000083},
        {300.000000, 20.529240, -0.000012},
        {400.000000, 20.594815, 0.000041},
        {500.000000, 20.649695, 0.000076},
        {600.000000, 20.696233, 0.000101},
        {700.000000, 20.736040, 0.000120},
        {800.000000, 20.770731, 0.000134},
        {900.000000, 20.801297, 0.000143},
        {1000.000000, 20.828531, 0.000151},
        {1100.000000, 20.853044, 0.000156},
        {1200.000000, 20.875318, 0.000159},
        {1300.000000, 20.895624, 0.000162},
        {1400.000000, 20.914330, 0.000163},
        {1500.000000, 20.931645, 0.000163},
        {1600.000000, 20.947761, 0.000163},
        {1700.000000, 20.962794, 0.000161},
        {1800.000000, 20.976925, 0.000159},
        {1900.000000, 20.990205, 0.000156},
        {2000.000000, 21.002764, 0.000153},
        {3000.000000, 21.100815, 0.000106},
        {4000.000000, 21.170027, 0.000042},
        {5000.000000, 21.224200, -0.000028},
        {6000.000000, 21.268902, -0.000100},
        {7000.000000, 21.306828, -0.000173},
        {8000.000000, 21.339423, -0.000244},
        {9000.000000, 21.367518, -0.000314},
        {10000.000000, 21.391591, -0.000383},
   }
});

local function make_CBU_87_103_DATA()
	t = {
		count        	= 202,
		effect_count 	= 30,

		wind_sigma  	= 5,
		impulse_sigma 	= 2, -- было 20
		moment_sigma 	= 0.0001,
	}

	return t
end

declare_bomb("CBU_87", _("CBU-87"), "CBU-97", wsType_Bomb_Cluster, "bomb-cassette_new", {
    fm =
    {
        mass            = 420.000000,
        caliber         = 0.39624,
        cx_coeff        = {1.000000, 0.390000, 0.600000, 0.168000, 1.310000},
        L               = 2.3552,
        wind_time       = 1000.000000,
        wind_sigma      = 30.0,
    },

    launcher =
    {
        cluster = cluster_desc("Bomb_Other",
			wsType_Bomb_Cluster,
			combine_cluster(BLU97B_DATA, {cluster = make_CBU_87_103_DATA()}, "cluster"))
    },

}, {
	char_time = 20.42,
	bomblet_char_time = 22.16,
},
"wAmmunitionCbu"
);

declare_bomb("CBU_103", _("CBU-103"), "CBU-97", wsType_Bomb_Cluster, "bomb-cassette-wcmd", {
    fm =
    {
            mass            = 420.00,
            caliber         = 0.39624,
            cx_coeff        = {1.000000, 0.390000, 0.600000, 0.168000, 1.310000},
            L               = 2.3552,
            wind_time       = 1000.000000,
			wind_sigma      = 30.0,
			Sw				= 0.6,
			dCydA			= {0.095, 0.036},
			A				= 0.6,
			maxAoa			= 0.26,
			finsTau			= 0.1,
    },
	WCMD_guidence =
	{
		PID_koef   = 12.0,
		PID_integr = 0.0,
		PID_differ = 0.5,
		char_time  = 20.34,
		bomblet_char_time = 20.34,
	},

    launcher =
    {
		cluster = cluster_desc("Bomb_Other",
			wsType_Bomb_Cluster,
			combine_cluster(BLU97B_DATA, {cluster = make_CBU_87_103_DATA()}, "cluster"))
    },
}, {
   char_time = 20.34
},
"wAmmunitionCbu"
);

declare_bomb("CBU_97", _("CBU-97"), "CBU-97", wsType_Bomb_Cluster, "bomb-cassette_new",
{
    fm =
    {
        mass            = 420.000000,
        caliber         = 0.41,
        cx_coeff        = {1.000000, 0.390000, 0.600000, 0.168000, 1.310000},
        L               = 2.3552,
        wind_time       = 1000.000000,
        wind_sigma      = 30.0,
    },

    launcher =
    {
        cluster = cluster_desc("Bomb_Other", wsType_Bomb_Cluster,
		{
			scheme = CBU97_CLUSTER_SCHEME_DATA,
			name    		= _("BLU-108"),
			type_name		= _("cluster"),
			cluster_scheme	= "CBU_97",
		})
    },
},
{
    char_time = 20.40,
	bomblet_char_time = 99.14,
},
"wAmmunitionCbu"
);

declare_bomb("CBU_105", _("CBU-105"), "CBU-97", wsType_Bomb_Cluster, "bomb-cassette-wcmd", {
	fm =
    {
            mass            = 420.000000,
            caliber         = 0.39624,
			L               = 2.3552,
            cx_coeff        = {1.000000, 0.390000, 0.600000, 0.168000, 1.310000},
            wind_time       = 1000.000000,
			wind_sigma      = 30.0,
			dCydA			= {0.095, 0.036},
			A				= 0.6,
			maxAoa			= 0.26,
			finsTau			= 0.1,
			Sw				= 0.6,
    },

    launcher =
    {
        cluster = cluster_desc("Bomb_Other", wsType_Bomb_Cluster,
		{
			scheme = CBU97_CLUSTER_SCHEME_DATA,
			name    		= _("BLU-108"),
			type_name		= _("cluster"),
			cluster_scheme	= "CBU_97",
		})
    },

	WCMD_guidence =
	{
		PID_koef   		  = 12.0,
		PID_integr 		  = 0.0,
		PID_differ 		  = 0.5,
		char_time  		  = 20.34,
		bomblet_char_time = 99.24,
	},

},
{
	char_time = 20.34,
	bomblet_char_time = 99.24,
},
"wAmmunitionCbu"
);


declare_bomb("BL_755", _("BL-755"), "t-bl-755", wsType_Bomb_Cluster, "bomb-cassette", {
    fm =
    {
        mass            = 277.000000,
        caliber         = 0.410000,
        cx_coeff        = {1.000000, 0.390000, 0.600000, 0.168000, 1.310000},
        L               = 2.450000,
        I               = 138.557708,
        Ma              = 0.172556,
        Mw              = 1.655525,
        wind_time       = 1000.000000,
        wind_sigma      = 100.000000,
    },

    launcher =
    {
        cluster = cluster_desc("Bomb_Other", wsType_Bomb_Cluster, combine_cluster(HEAT_DATA,
        {
            cluster = {
                count        = 147,
                effect_count = 50,

                wind_sigma  = 5,
                impulse_sigma = 2, -- было 20
                moment_sigma = 0.0001,
            }
        },
		"cluster"
		)
		)
    },

    control =
    {
        open_delay = 4.0,
    },

}, {
    v0 = 200.0,
    data =
    {
		{1.000000, 20.200000, 0.000000},
		{10.000000, 20.431997, 0.000011},
		{20.000000, 20.456066, -0.000160},
		{30.000000, 20.463633, -0.000188},
		{40.000000, 20.464823, -0.000198},
		{50.000000, 20.468404, -0.000240},
		{60.000000, 20.468708, -0.000237},
		{70.000000, 20.470523, -0.000244},
		{80.000000, 20.469560, -0.000229},
		{90.000000, 20.472084, -0.000244},
		{100.000000, 20.476740, -0.000225},
		{200.000000, 20.667933, -0.000098},
		{300.000000, 20.899296, -0.000087},
		{400.000000, 21.096938, -0.000138},
		{500.000000, 21.260492, -0.000207},
		{600.000000, 21.397560, -0.000275},
		{700.000000, 21.514264, -0.000336},
		{800.000000, 21.615084, -0.000393},
		{900.000000, 21.703399, -0.000442},
		{1000.000000, 21.781666, -0.000487},
		{1100.000000, 21.851669, -0.000527},
		{1200.000000, 21.914853, -0.000563},
		{1300.000000, 21.972351, -0.000595},
		{1400.000000, 22.024987, -0.000624},
		{1500.000000, 22.073439, -0.000650},
		{1600.000000, 22.118278, -0.000673},
		{1700.000000, 22.159983, -0.000693},
		{1800.000000, 22.198933, -0.000712},
		{1900.000000, 22.235428, -0.000728},
		{2000.000000, 22.269748, -0.000742},
		{3000.000000, 22.531870, -0.000809},
		{4000.000000, 22.711249, -0.000819},
		{5000.000000, 22.850385, -0.000830},
		{6000.000000, 22.966924, -0.000859},
		{7000.000000, 23.069585, -0.000910},
		{8000.000000, 23.163086, -0.000982},
		{9000.000000, 23.250093, -0.001067},
		{10000.000000, 23.332063, -0.001168},
   }
});


declare_bomb("MK_82AIR", _("Mk-82AIR"), "Mk-82AIR", wsType_Bomb_A, "bomb-parashute", {
    fm =
    {
			mass            = 232.000000,
            caliber         = 0.273000,
            cx_coeff        = {1.000000, 0.290000, 0.710000, 0.140000, 1.280000},
            L               = 2.210000,
			I				= 94.42593,
			cx_factor   	= 100,

			wind_time 		= 1000,
			wind_sigma      = 8.0,
    },

    warhead = warheads["Mk_82"],

	control =
    {
        open_delay = 0.2,
    },

},{
	v0 = 200,
	data =
    {
  	{1.000000, 21.147949, 0.002807},
	{10.000000, 28.262668, -0.017193},
	{20.000000, 29.687629, -0.016767},
	{30.000000, 30.394407, -0.015892},
	{40.000000, 30.826322, -0.015080},
	{50.000000, 31.133114, -0.014428},
	{60.000000, 31.361560, -0.013889},
	{70.000000, 31.543970, -0.013440},
	{80.000000, 31.690640, -0.013045},
	{90.000000, 31.814418, -0.012713},
	{100.000000, 31.920050, -0.012425},
	{200.000000, 32.511629, -0.010723},
	{300.000000, 32.789778, -0.009863},
	{400.000000, 32.963413, -0.009307},
	{500.000000, 33.086372, -0.008907},
	{600.000000, 33.179450, -0.008596},
	{700.000000, 33.253103, -0.008346},
	{800.000000, 33.312920, -0.008139},
	{900.000000, 33.362577, -0.007968},
	{1000.000000, 33.404350, -0.007824},
	{1100.000000, 33.439925, -0.007702},
	{1200.000000, 33.470498, -0.007599},
	{1300.000000, 33.496988, -0.007513},
	{1400.000000, 33.520106, -0.007440},
	{1500.000000, 33.540403, -0.007378},
	{1600.000000, 33.558365, -0.007327},
	{1700.000000, 33.574326, -0.007285},
	{1800.000000, 33.588629, -0.007251},
	{1900.000000, 33.601489, -0.007224},
	{2000.000000, 33.613137, -0.007202},
	{3000.000000, 33.690673, -0.007191},
	{4000.000000, 33.737805, -0.007357},
	{5000.000000, 33.773738, -0.007590},
	{6000.000000, 33.802367, -0.007864},
	{7000.000000, 33.824277, -0.008170},
	{8000.000000, 33.839206, -0.008505},
	{9000.000000, 33.846586, -0.008868},
	{10000.000000, 33.845625, -0.009258},
    }
},
"wAmmunitionBallute"
);

declare_bomb("MK_82SNAKEYE", _("Mk-82 SnakeEye"), "MK-82_Snakeye", wsType_Bomb_A, "bomb-parashute", {
    fm =
    {
			mass            = 232.000000,
            caliber         = 0.273000,
            cx_coeff        = {1.000000, 0.290000, 0.710000, 0.140000, 1.280000},
            L               = 2.210000,
			I				= 94.42593,
			cx_factor   	= 100,

			wind_time 		= 1000,
			wind_sigma      = 8.0,
    },

    warhead = warheads["Mk_82"],

	control =
    {
        open_delay = 0.2,
    },

},{
	v0 = 200,
	data =
    {
  	{1.000000, 21.147949, 0.002807},
	{10.000000, 28.262668, -0.017193},
	{20.000000, 29.687629, -0.016767},
	{30.000000, 30.394407, -0.015892},
	{40.000000, 30.826322, -0.015080},
	{50.000000, 31.133114, -0.014428},
	{60.000000, 31.361560, -0.013889},
	{70.000000, 31.543970, -0.013440},
	{80.000000, 31.690640, -0.013045},
	{90.000000, 31.814418, -0.012713},
	{100.000000, 31.920050, -0.012425},
	{200.000000, 32.511629, -0.010723},
	{300.000000, 32.789778, -0.009863},
	{400.000000, 32.963413, -0.009307},
	{500.000000, 33.086372, -0.008907},
	{600.000000, 33.179450, -0.008596},
	{700.000000, 33.253103, -0.008346},
	{800.000000, 33.312920, -0.008139},
	{900.000000, 33.362577, -0.007968},
	{1000.000000, 33.404350, -0.007824},
	{1100.000000, 33.439925, -0.007702},
	{1200.000000, 33.470498, -0.007599},
	{1300.000000, 33.496988, -0.007513},
	{1400.000000, 33.520106, -0.007440},
	{1500.000000, 33.540403, -0.007378},
	{1600.000000, 33.558365, -0.007327},
	{1700.000000, 33.574326, -0.007285},
	{1800.000000, 33.588629, -0.007251},
	{1900.000000, 33.601489, -0.007224},
	{2000.000000, 33.613137, -0.007202},
	{3000.000000, 33.690673, -0.007191},
	{4000.000000, 33.737805, -0.007357},
	{5000.000000, 33.773738, -0.007590},
	{6000.000000, 33.802367, -0.007864},
	{7000.000000, 33.824277, -0.008170},
	{8000.000000, 33.839206, -0.008505},
	{9000.000000, 33.846586, -0.008868},
	{10000.000000, 33.845625, -0.009258},
    }
},
"wAmmunitionBallute"
);


local newGBU = true

function declare_paveway_2(name, user_name, model, level3, scheme, data, targeting_data, class_name, no_wstype)
	local dCydA0 = calcCy(500 * 1.85 / 3.6, 0, data.fm.mass, 2.8, data.fm.Sw) / math.deg(data.fm.maxAoa)
	data.fm.dCydA = {dCydA0, 0.036}
	return declare_bomb(name, user_name, model, level3, scheme, data, targeting_data, class_name, no_wstype)
end

if newGBU then

local windCoeff = 0

declare_paveway_2("GBU_10", _("GBU-10"), "GBU-10", wsType_Bomb_Guided, "bomb-paveway-II-afm", {
	fm =
	{
			mass            = 934.0,
			caliber         = 0.457000,
			cx_coeff        = {1.037, 0.91, 0.6, 0.382, 1.34},
			L               = 4.368,
			wind_sigma      = windCoeff * 220.0,
			Sw				= 2 * 1.75 * math.pow(24 * 2.45 * 0.01 / math.sin(2 * math.pi / 6), 2) / 2.5,
			A				= 0.36,
			Ma_x			= 0.1,
			Mw_x			= 1.0,
			maxAoa			= math.rad(7),
			finsTau			= 0.1
	},
	bang_bang_autopilot = {
		omegaDumpingK = 0.30
	},
	warhead = warheads["Mk_84"],
}, {
	char_time       = 20.34
},
"wAmmunitionLaserHoming"
);

declare_paveway_2("GBU_12", _("GBU-12"), "GBU-12", wsType_Bomb_Guided, "bomb-paveway-II-afm", {
    fm =
    {
            mass            = 275.0,
            caliber         = 0.279000,
            cx_coeff        = {1.037, 0.74, 0.6, 0.382, 1.34},
            L               = 3.276000,
            wind_time       = 1000.000000,
            wind_sigma      = windCoeff * 80.000000,
			Sw				= 0.4,
			A				= 0.36,
			Ma_x			= 0.1,
			Mw_x			= 1.0,
			maxAoa			= math.rad(7),
			finsTau			= 0.1
    },
	bang_bang_autopilot = {
		omegaDumpingK = 0.8
	},
    warhead = warheads["Mk_82"],
}, {
    char_time       = 20.380000
},
"wAmmunitionLaserHoming"
);

declare_paveway_2("GBU_16", _("GBU-16"), "GBU-16", wsType_Bomb_Guided, "bomb-paveway-II-afm", {
    fm =
    {
            mass            = 454.000000,
            caliber         = 0.356000,
            cx_coeff        = {1.000000, 0.290000, 0.710000, 0.130000, 1.280000},
            L               = 4.050000,
            wind_time       = 1000.000000,
            wind_sigma      = windCoeff * 150.000000,
			Sw				= 0.6,
			A				= 0.36,
			Ma_x			= 0.1,
			Mw_x			= 1.0,
			maxAoa			= math.rad(7),
			finsTau			= 0.1
    },
	bang_bang_autopilot = {
		omegaDumpingK = 0.36
	},
    warhead = warheads["Mk_83"],
}, {
    char_time       =  20.280000
},
"wAmmunitionLaserHoming"
);

declare_paveway_2("BDU_50LGB", _("BDU-50LGB"), "BDU-50LGB", wsType_Bomb_Guided, "bomb-paveway-II-afm", {
    fm =
    {
            mass            = 363.000000,
            caliber         = 0.279000,
            cx_coeff        = {1.037, 0.74, 0.6, 0.382, 1.34},
            L               = 3.276000,
            wind_time       = 1000.000000,
            wind_sigma      = windCoeff * 80.000000,
			Sw				= 2 * 1.87 * math.pow(20.5 * 2.45 * 0.01 / math.sin(2 * math.pi / 6), 2) / 4.5,
			A				= 0.36,
			Ma_x			= 0.1,
			Mw_x			= 1.0,
			maxAoa			= math.rad(7),
			finsTau			= 0.1
    },
	bang_bang_autopilot = {
		omegaDumpingK = 0.36
	},
    warhead = warheads["BDU"],
}, {
    char_time       = 20.420000
},
"wAmmunitionLaserHoming"
);

declare_paveway_2("KAB_1500Kr", _("KAB-1500L-Pr"), "kab-1500", wsType_Bomb_Guided, "bomb-paveway-II-afm", {
    fm =
    {
            mass            = 1500.0,
            caliber         = 0.580,
            --cx_coeff        = {1.0, 0.8, 0.6, 0.6, 1.3},
			cx_coeff        = {1.000000, 0.400000, 0.370000, 0.288000, 1.310000},
            L               = 4.60,
            wind_time       = 1000.000000,
            wind_sigma      = windCoeff * 80.000000,
			Sw				= 3.2,
			A				= 0.36,
			Ma_x			= 0.1,
			Mw_x			= 1.0,
			maxAoa			= math.rad(7),
			finsTau			= 0.1
    },
	bang_bang_autopilot = {
		omegaDumpingK = 0.5
	},
    warhead = warheads["KAB_1500Kr"],
}, {
    char_time = 20.3
},
"wAmmunitionLaserHoming"
);

declare_paveway_2("KAB_500Kr", _("KAB-500Kr"), "kab-500t", wsType_Bomb_Guided, "bomb_guided_pn", {
    fm =
    {
		mass            = 500.0,
		caliber         = 0.350,
		cx_coeff        = {1.000000, 0.390000, 0.600000, 0.168000, 1.310000},
		L               = 3.05,
		wind_time       = 1000.000000,
		wind_sigma      = windCoeff * 80.000000,
		Sw				= 2.2,
		A				= 0.6,
		maxAoa			= math.rad(7),
		finsTau			= 0.1
    },
	bang_bang_autopilot =
	{
		Kg			= 0.25,
		Ki			= 0.0,
		finsLimit	= 0.25,
		delay		= 2.0
	},
    warhead = warheads["KAB_500Kr"],
},
{
    char_time = 20.7
},
"wAmmunitionSelfHoming"
);


declare_paveway_2("KAB_500", _("KAB-500"), "kab-500", wsType_Bomb_Guided, "bomb-paveway-II-afm", {
    fm =
    {
            mass            = 500.0,
            caliber         = 0.350,
            cx_coeff        = {1.000000, 0.390000, 0.600000, 0.168000, 1.310000},
            L               = 3.05,
            wind_time       = 1000.000000,
            wind_sigma      = windCoeff * 80.000000,
			Sw				= 2.2,
			A				= 0.36,
			Ma_x			= 0.1,
			Mw_x			= 1.0,
			maxAoa			= math.rad(7),
			finsTau			= 0.1
    },
	bang_bang_autopilot = {
		omegaDumpingK = 0.5
	},
    warhead = warheads["KAB_500"],
}, {
    char_time = 20.4
},
"wAmmunitionLaserHoming"
);

end


declare_bomb("GBU_31", _("GBU-31(V)1/B"), "GBU-31", wsType_Bomb_Guided, "bomb_jdam", {

    fm =
    {
		mass			= 925.0,
		caliber			= 0.457,
		cx_coeff		= {1, 0.45, 0.8, 0.15, 1.55},
		L				= 0.457,
		I				= 515.2,
		I_x				= 24.8,
		wind_time		= 0.0,
		wind_sigma		= 0.0,
		dCydA			= {0.066, 0.036},
		A				= 0.6,
		maxAoa			= math.rad(25),
		finsTau			= 0.1,
		fins_gain		= 100,
		ideal_fins 		= 1,
		Sw				= 0.164*3,
		Ma				= 6.3,
		Mw				= 3.0,
		Ma_x			= 1.5,
		Mw_x			= 4.5,
		model_roll 		= math.rad(-45),
    },

	seeker = {
		CEP 					= 5.0,
		coalition				= 2,
		coalition_rnd_coeff		= 5.0,
	},

	autopilot = {
		delay				= 1.0,
		op_time				= 9000,
		Tf					= 0.05,
		Knav				= 3.0,
		Kd					= 890.0,
		Ka					= 12.0,
		Tc					= 0.1,
		Kx					= 0.4,
		Krx					= 4.0,
		gload_limit			= 3.0,
		fins_limit			= math.rad(35),
		fins_limit_x		= math.rad(5),
		null_roll			= math.rad(0),
		KD0					= 0.164 / 925,
		KDI					= 0.6 * 925 / 0.5,
		KLM					= 1.3 * 0.164 * 3 / 925,
	},

    warhead = warheads["Mk_84"],
},
{
    char_time       = 20.55
},
"wAmmunitionChangeableTrajectory");

declare_bomb("GBU_31_V_3B", _("GBU-31(V)3/B"), "GBU31_V_3B_BLU109", wsType_Bomb_Guided, "bomb_jdam", {

	fm =
    {
		mass			= 961.0,
		caliber			= 0.368,
		cx_coeff		= {1, 0.45, 0.8, 0.15, 1.55},
		L				= 0.368,
		I				= 592.5,
		I_x				= 32.5,
		wind_time		= 0.0,
		wind_sigma		= 0.0,
		dCydA			= {0.066, 0.036},
		A				= 0.6,
		maxAoa			= math.rad(25),
		finsTau			= 0.1,
		fins_gain		= 100,
		ideal_fins 		= 1,
		finsTau			= 0.1,
		Sw				= 0.1*5,
		Ma				= 6.3,
		Mw				= 3.0,
		Ma_x			= 1.5,
		Mw_x			= 6.5,
		model_roll 		= math.rad(-45),
    },

	seeker = {
		CEP 					= 5.0,
		coalition				= 2,
		coalition_rnd_coeff		= 5.0,
	},

	autopilot = {
		delay				= 1.0,
		op_time				= 9000,
		Tf					= 0.05,
		Knav				= 3.0,
		Kd					= 890.0,
		Ka					= 12.0,
		Tc					= 0.1,
		Kx					= 0.4,
		Krx					= 4.0,
		gload_limit			= 3.0,
		fins_limit			= math.rad(35),
		fins_limit_x		= math.rad(5),
		null_roll			= math.rad(-45),
		KD0					= 0.1 / 961,
		KDI					= 0.6 * 961 / 0.5,
		KLM					= 1.3 * 0.1 * 5 / 961,
	},

    warhead = warheads["BLU_109"],
},
{
    char_time       = 20.55
},
"wAmmunitionChangeableTrajectory");

declare_bomb("GBU_38", _("GBU-38"), "GBU-38", wsType_Bomb_Guided, "bomb_jdam", {

	fm = {
		mass			= 253.1,
		caliber			= 0.274,
		cx_coeff		= {1, 0.45, 0.8, 0.15, 1.55},
		L				= 0.274/5,
		I				= 65.1,
		I_x				= 2.85,
		wind_time		= 0.0,
		wind_sigma		= 0.0,
		dCydA			= {0.04, 0.022},
		A				= 0.6,
		maxAoa			= math.rad(25),
		finsTau			= 0.1,
		fins_gain		= 100,
		ideal_fins 		= 1,
		Sw				= 0.059*5,
		Ma				= 6.3,
		Mw				= 3.0,
		Ma_x			= 9.5,
		Mw_x			= 3.5,
		model_roll 		= math.rad(-45),
    },

	seeker = {
		CEP 					= 5.0,
		coalition				= 2,
		coalition_rnd_coeff		= 5.0,
	},

	autopilot = {
		delay				= 1.0,
		op_time				= 9000,
		Tf					= 0.05,
		Knav				= 3.0,
		Kd					= 390.0,
		Ka					= 6.0,
		Tc					= 0.1,
		Kx					= 0.1,
		Krx					= 4.0,
		gload_limit			= 2.5,
		fins_limit			= math.rad(30),
		fins_limit_x		= math.rad(5),
		null_roll			= math.rad(-45),
		KD0					= 0.059 / 253,
		KDI					= 0.6 * 253 / 0.3,
		KLM					= 0.7 * 0.059 * 5 / 253,
	},

    warhead = warheads["Mk_82"],
},
{
    char_time       = 20.45
},
"wAmmunitionChangeableTrajectory");


declare_bomb("AGM_62", _("AGM-62 Walleye II"), "agm-62", wsType_Bomb_Guided, "AGM-62", {
    fm = {
		mass        = 1061,
		caliber     = 0.457,
		cx_coeff    = {1,0.39,0.38,0.236,1.31},
		L           = 4.04,
		I           = 1 / 12 * 1061 * 4.04 * 4.04,
		Ma          = 0.68,
		Mw          = 1.116,
		wind_sigma	= 0.0,
		wind_time	= 0.0,
		Sw			= 0.72,
		dCydA		= {0.07, 0.036},
		A			= 0.36,
		maxAoa		= 0.23,
		finsTau		= 0.1,
		Ma_x		= 3,
		Mw_x		= 1.5,
		I_x			= 40,
	},

	seeker = {
		delay			= 0.0,
		op_time			= 200,
		FOV				= math.rad(60),
		max_w_LOS		= 0.06,
		max_w_LOS_surf	= 0.03,

		max_target_speed			= 33,
		max_target_speed_rnd_coeff	= 10,
	},

	PN_autopilot = {
		K			= 0.024,
		Ki			= 0.001,
		Kg			= 2.4,
		Kx			= 0.02,
		fins_limit	= 0.5,
		K_GBias		= 0.5,
	},

	march = {
		smoke_color			= {0.9, 0.9, 0.9},
		smoke_transparency	= 0.5,
	},

    warhead		= warheads["AGM_62"],
},
{
    char_time       = 20.3
},
"wAmmunitionSelfHoming");

declare_bomb("GBU_24", _("GBU-24 Paveway III"), "GBU-24", wsType_Bomb_Guided, "bomb-paveway-III", {

	seeker = {
		delay	= 0,
		FOV		= math.rad(30),
	},

	fm =
    {
        mass			= 934.0,
		wind_time		= 1000.0,
		wind_sigma		= 0,
		A				= 0.6,
		maxAoa			= math.rad(25),
		finsTau			= 0.1,
		dCydA			= {0.066, 0.036},
		caliber			= 0.457,
		cx_coeff        = {1.037, 0.91, 0.9, 0.382, 1.34},
		L               = 4.368,
		I				= 1 / 12 * 934.0 * 4.368 * 4.368,
		Sm				= 0.164,
		Sw				= 0.85,
		Ma				= 0.85,
		Mw				= 4.55,
		Ma_x			= 0.9,
		Ma_z			= 0.5,
		Mw_x			= 2.0,
    },

	autopilot = {
		delay				= 1.0,
		Kw					= 1.0,
		Ks					= 4.0,
		K					= 5.0,
		Kd 					= 0.0,
		Ki 					= 0.0,
		Kx					= 0.0,
		Kix					= 0.0,
		w_limit				= math.rad(5),
		fins_limit			= math.rad(25),
		rotated_WLOS_input	= 0,
		conv_input			= 0,
		PN_dist_data 		= {	2000,	1,
								500,	1},
	},

    warhead = warheads["Mk_84"],
},
{
    char_time       = 20.33
},
"wAmmunitionLaserHoming");
