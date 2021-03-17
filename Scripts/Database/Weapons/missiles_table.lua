weapons_table.weapons.missiles = namespace();

function form_missile(name, user_name, model, class, level3, scheme, data, add_data,wstype_name)

	local wstype_name = wstype_name
	if  wstype_name == nil then
		wstype_name = _G[name]
	end

	local res = dbtype(class or "wAmmunition",
	{
		ws_type = {wsType_Weapon,wsType_Missile, level3, wstype_name},
		
		model = model,
	})
	
	copy_origin(res,data)

	res.server = 	{}
	res.client = 	{}

	if data.launcher ~= nil then
	    if data.launcher.ammunition_name ~= nil then
		   data.launcher.ammunition = weapons_table.weapons.missiles[data.launcher.ammunition_name]
		end 
	end
	
	-- ��� �����, ������ ��� ��� ���������, ����� �������� ����� ���� ������
	-- ����� � �����
	if data.warhead == nil then data.warhead = {} end
	if data.warhead_air == nil then data.warhead_air = {} end
	
	copy_recursive_with_metatables(res.server, data);
	copy_recursive_with_metatables(res.client, data);

	res.server.scheme = "schemes/missiles/"..scheme..".sch";	
	res.client.scheme = "schemes/missiles/"..scheme..".sch";	
	
	res.server.warhead.fantom = 0;
	res.client.warhead.fantom = 1;
	res.server.warhead_air.fantom = 0;
	res.client.warhead_air.fantom = 1;
	
	res.name 		 = name;
	res.display_name = user_name;
	res.type_name = _("missile");

	if data.launcher ~= nil then
        res.server.launcher.server = 1
        res.client.launcher.server = 0
    end
	
	if not res.caliber then
		res.caliber = data.fm.caliber;
	end
	
	if not res.sounderName then 
		res.sounderName = "Weapons/Missile"
	end
	
	if add_data then
	   copy_recursive(res, add_data);
    end
	
	if not res.add_attributes then
		res.add_attributes = data.add_attributes;
	end
	
	if not res.mass then
		res.mass = data.mass or data.fm.mass
	end
	
	if not res.Reflection then
		res.Reflection = data.Reflection;
	end
	
	if not res.skin_arg then
		res.skin_arg = data.skin_arg
	end
	
	return res;
end

function declare_missile(name, user_name, model, class, level3, scheme, data, add_data,wstype_name)
	local res = form_missile(name, user_name, model, class, level3, scheme, data, add_data,wstype_name)
	weapons_table.weapons.missiles[res.name] = res
	registerResourceName(res,CAT_MISSILES)
	return res
end
	

declare_missile("P_9M133", _("AT-14 Spriggan"), "9M133", "wAmmunitionVikhr", wsType_SS_Missile, "command_guided_spin_missile", 
{
	controller = {
		boost_start = 0.001,
		march_start = 0.200,
	},
	
	booster = {
		impulse								= 210,
		fuel_mass							= 2.6,
		work_time							= 0.15,
		nozzle_position						= {{-0.5, 0.0, 0.0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.05,
		smoke_color							= {0.8, 0.8, 0.8},
		smoke_transparency					= 0.8,
		custom_smoke_dissipation_factor		= 0.0,				
	},
	
	march = {
		impulse								= 240,
		fuel_mass							= 5,
		work_time							= 13,
		nozzle_position						= {{-0.12, 0.071, 0.0},{-0.12, -0.071, 0.0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.15},{0.0, 0.0, -0.15}},
		tail_width							= 0.05,
		smoke_color							= {0.7, 0.7, 0.7},
		smoke_transparency					= 0.08,
		custom_smoke_dissipation_factor		= 0.08,				
	},
	
	spiral_nav = {
		t_cone_near_rad			= 1000,
		def_cone_max_dist		= 5700,
		def_cone_near_rad		= 1000,
		def_cone_near_rad_st	= 0,
		def_cone_time_stab_rad	= 0,
		gb_angle				= 0.005,
		gb_min_dist				= 1.0,
		gb_use_time				= 0.70,
		gb_max_retW				= 0.6,
		gb_ret_Kp				= 1.2,
	},
	
	autopilot = {
		Kp					= 0.24,
		Ki					= 0.038,
		Kd					= 0.06,
		max_ctrl_angle		= 1.35,
		delay				= 0.3,
		op_time				= 23.0,
		fins_discreet		= 0.03,
		no_ctrl_center_ang	= 0.00008,
	},

	fm  = {
		mass        = 26,  
		caliber     = 0.152,
		L           = 1.2,
		I           = 1 / 12 * 26 * 1.2 * 1.2,
		Ma          = 0.85,
		Mw          = 2.75,		
		cx_coeff    = {1,0.29,0.45,0.15,1.12},
		Sw			= 0.125,
		dCydA		= {0.024, 0.018},
		A			= 0.6,
		maxAoa		= 0.2,
		finsTau		= 0.1,
		freq		= 4.0,
	},
	
	eng_err = {
		y_error = 0.0,
		z_error = 0.26,
		min_time_interval = 0.2,
		max_time_interval = 1.1,
	},
	
	warhead		= warheads["P_9M133"], 
	warhead_air	= warheads["P_9M133"],
}, 
{	
	mass		= 26,
	Reflection	= 0.04,
});


declare_missile("REFLEX", _("AT-11 Sniper"), "9m119m", "wAmmunitionVikhr", wsType_SS_Missile, "command_guided_spin_missile", 
{
controller = {
		boost_start = 0.001,
		march_start = 0.200,
	},
	
	booster = {
		impulse								= 170,
		fuel_mass							= 2.2,
		work_time							= 0.1,
		nozzle_position						= {{-0.26, 0.0, 0.0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.04,
		smoke_color							= {0.8, 0.8, 0.8},
		smoke_transparency					= 0.05,
		custom_smoke_dissipation_factor		= 0.0,				
	},
	
	march = {
		impulse								= 200,
		fuel_mass							= 1.5,
		work_time							= 9,
		nozzle_position						= {{0.18, 0.068, 0.0},{0.18, -0.068, 0.0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.18},{0.0, 0.0, -0.18}},
		tail_width							= 0.04,
		smoke_color							= {0.7, 0.7, 0.7},
		smoke_transparency					= 0.01,
		custom_smoke_dissipation_factor		= 0.01,
	},
	
	spiral_nav = {
		t_cone_near_rad			= 1000,
		def_cone_max_dist		= 5200,
		def_cone_near_rad		= 10,
		def_cone_near_rad_st	= 100,
		def_cone_time_stab_rad	= 5,
		gb_angle				= 0.005,
		gb_min_dist				= 1,
		gb_use_time				= 0.3,
		gb_max_retW				= 0.55,
		gb_ret_Kp				= 1.4,
	},
	
	
	fm = {
		mass        = 17.2,  
		caliber     = 0.125,  
		cx_coeff    = {1,0.22,0.6,0.15,1.28},
		L           = 0.69,
		I           = 1 / 12 * 17.2 * 0.69 * 0.69,
		Ma          = 3.0,
		Mw          = 6.0,
		Sw			= 0.075,
		dCydA		= {0.024, 0.017},
		A			= 0.6,
		maxAoa		= 0.2,
		finsTau		= 0.05,
		freq		= 5.0,
	},
	
	autopilot = {
		Kp					= 0.42,
		Ki					= 0.06,
		Kd					= 0.044,
		max_ctrl_angle		= 1.0,
		delay				= 0.23,
		op_time				= 20.0,
		fins_discreet		= 0.01,
		no_ctrl_center_ang	= 0.00002,
	},
	
	eng_err = {
		y_error = 0.0,
		z_error = 0.1,
		min_time_interval = 0.1,
		max_time_interval = 1.0,
	},

	warhead = warheads["P_9M119"], 
	warhead_air = warheads["P_9M119"],
}, 
{
	mass		= 17.2,
	Reflection	= 0.032,
});


declare_missile("SVIR", _("AT-11 Sniper"), "9m119m", "wAmmunitionVikhr", wsType_SS_Missile, "command_guided_spin_missile", 
{
	controller = {
		boost_start = 0.001,
		march_start = 0.250,
	},
	
	booster = {
		impulse								= 170,
		fuel_mass							= 1.8,
		work_time							= 0.1,
		nozzle_position						= {{-0.26, 0.0, 0.0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.04,
		smoke_color							= {0.6, 0.6, 0.6},
		smoke_transparency					= 0.05,
		custom_smoke_dissipation_factor		= 0.0,				
	},
	
	march = {
		impulse								= 200,
		fuel_mass							= 1.5,
		work_time							= 9,
		nozzle_position						= {{0.18, 0.068, 0.0},{0.18, -0.068, 0.0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.18},{0.0, 0.0, -0.18}},
		tail_width							= 0.04,
		smoke_color							= {0.7, 0.7, 0.7},
		smoke_transparency					= 0.01,
		custom_smoke_dissipation_factor		= 0.01,				
	},
	
	spiral_nav = {
		t_cone_near_rad			= 1000,
		def_cone_max_dist		= 4200,
		def_cone_near_rad		= 10,
		def_cone_near_rad_st	= 100,
		def_cone_time_stab_rad	= 5,
		gb_angle				= 0.01,
		gb_min_dist				= 1,
		gb_use_time				= 0.3,
		gb_max_retW				= 0.55,
		gb_ret_Kp				= 1.2,
	},
	
	
	autopilot = {
		Kp					= 0.45,
		Ki					= 0.05,
		Kd					= 0.055,
		max_ctrl_angle		= 1.0,
		delay				= 0.23,
		op_time				= 20.0,
		fins_discreet		= 0.01,
		no_ctrl_center_ang	= 0.00003,
	},

	fm = {
		mass        = 17.2,  
		caliber     = 0.125,  
		cx_coeff    = {1,0.22,0.6,0.15,1.28},
		L           = 0.69,
		I           = 1 / 12 * 17.2 * 0.69 * 0.69,
		Ma          = 2.0,
		Mw          = 5.0,
		Sw			= 0.07,
		dCydA		= {0.024, 0.017},
		A			= 0.6,
		maxAoa		= 0.2,
		finsTau		= 0.05,
		freq		= 5.0,
	},
	
	eng_err = {
		y_error = 0.0,
		z_error = 0.1,
		min_time_interval = 0.1,
		max_time_interval = 1.0,
	},

	warhead = warheads["P_9M119"], 
	warhead_air = warheads["P_9M119"],
}, 
{
	mass		= 17.2,
	Reflection	= 0.032,
});


declare_missile("P_9M117", _("AT-10 Stabber"), "9m117", "wAmmunitionVikhr", wsType_SS_Missile, "command_guided_spin_missile", 
{
		controller = {
		boost_start = 0.001,
		march_start = 0.200,
	},
	
	booster = {
		impulse								= 190,
		fuel_mass							= 2.4,
		work_time							= 0.2,
		nozzle_position						= {{-0.26, 0.0, 0.0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.04,
		smoke_color							= {0.7, 0.7, 0.7},
		smoke_transparency					= 0.05,
		custom_smoke_dissipation_factor		= 0.0,				
	},
	
	march = {
		impulse								= 190,
		fuel_mass							= 1.7,
		work_time							= 6,
		nozzle_position						= {{-0.02, 0.066, 0.0},{-0.02, -0.066, 0.0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.18},{0.0, 0.0, -0.18}},
		tail_width							= 0.04,
		smoke_color							= {0.7, 0.7, 0.7},
		smoke_transparency					= 0.01,
		custom_smoke_dissipation_factor		= 0.01,
	},
	
	spiral_nav = {
		t_cone_near_rad			= 1000,
		def_cone_max_dist		= 4200,
		def_cone_near_rad		= 10,
		def_cone_near_rad_st	= 100,
		def_cone_time_stab_rad	= 5,
		gb_angle				= 0.003,
		gb_min_dist				= 1,
		gb_use_time				= 0.6,
		gb_max_retW				= 0.6,
		gb_ret_Kp				= 1.15,
	},
		
	fm = {
		mass        = 17.6,  
		caliber     = 0.100,  
		cx_coeff    = {1,0.3,0.56,0.13,1.2},
		L           = 1.048,
		I           = 1 / 12 * 17.2 * 1.048 * 1.048,
		Ma          = 2.0,
		Mw          = 5.0,
		Sw			= 0.11,
		dCydA		= {0.024, 0.016},
		A			= 0.6,
		maxAoa		= 0.2,
		finsTau		= 0.05,
		freq		= 6,
	},

	autopilot = {
		Kp					= 0.2,
		Ki					= 0.05,
		Kd					= 0.05,
		max_ctrl_angle		= 1.0,
		delay				= 0.23,
		op_time				= 17.0,
		fins_discreet		= 0.04,
		no_ctrl_center_ang	= 0.00003,
	},
	
	eng_err = {
		y_error = 0.0,
		z_error = 0.2,
		min_time_interval = 0.1,
		max_time_interval = 0.8,
	},

	warhead = warheads["P_9M117"], 
	warhead_air = warheads["P_9M117"],
}, 
{
	mass		= 17.6,
	Reflection	= 0.032,
}); 


declare_missile("KONKURS", _("AT-5 Spandrel"), "9m113", "wAmmunitionVikhr", wsType_SS_Missile, "command_guided_spin_missile", 
{
	controller = {
		boost_start = 0.001,
		march_start = 0.300,
	},
	
	booster = {
		impulse								= 130,
		fuel_mass							= 2.5,
		work_time							= 0.04,
		nozzle_position						= {{-0.5, 0.0, 0.0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.035,
		smoke_color							= {0.8, 0.8, 0.8},
		smoke_transparency					= 0.05,
		custom_smoke_dissipation_factor		= 0.0,				
	},
	
	march = {
		impulse								= 140,
		fuel_mass							= 2.0,
		work_time							= 20,
		nozzle_position						= {{-0.22, 0.0, 0.062},{-0.22, 0.0, -0.062}},
		nozzle_orientationXYZ				= {{0.0, -0.15, 0.0},{0.0, 0.15, 0.0}},
		tail_width							= 0.045,
		smoke_color							= {0.7, 0.7, 0.7},
		smoke_transparency					= 0.013,
		custom_smoke_dissipation_factor		= 0.013,				
	},
	
	spiral_nav = {
		t_cone_near_rad			= 1000,
		def_cone_max_dist		= 4000,
		def_cone_near_rad		= 1000,
		def_cone_near_rad_st	= 0,
		def_cone_time_stab_rad	= 0,
		gb_angle				= 0.003,
		gb_min_dist				= 1,
		gb_use_time				= 0.7,
		gb_max_retW				= 0.4,
		gb_ret_Kp				= 1,
	},
	
		
	fm  = {
		mass        = 14,  
		caliber     = 0.135,
		L           = 1.0,
		I           = 1 / 12 * 14.0 * 1.0 * 1.0,
		Ma          = 2.0,
		Mw          = 5.0,		
		cx_coeff    = {1,0.5,0.4,0.3,1.15},
		dCydA		= {0.024, 0.017},
		rail_open	= 0,
		A			= 0.6,
		Sw			= 0.3,
		maxAoa		= 0.25,
		finsTau		= 0.05,
		freq		= 7,
	},
	
	autopilot = {
		Kp					= 0.12,
		Ki					= 0.038,
		Kd					= 0.023,
		max_ctrl_angle		= 1.0,
		delay				= 0.2,
		op_time				= 22.0,
		fins_discreet		= 0.04,
		no_ctrl_center_ang	= 0.00011,
	},	
	
	eng_err = {
		y_error = 0.0,
		z_error = 0.3,
		min_time_interval = 0.1,
		max_time_interval = 0.9,
	},
	
	warhead = warheads["KONKURS"], 
	warhead_air = warheads["KONKURS"],
}, 
{	
	mass		= 14.6,
	Reflection	= 0.035,
});


declare_missile("MALUTKA", _("AT-3 Sagger"), "malutka", "wAmmunitionVikhr", wsType_SS_Missile, "command_guided_spin_missile", 
{
	controller = {
		boost_start = 0.001,
		march_start = 0.100,
	},
	
	booster = {
		impulse								= 110,
		fuel_mass							= 1,
		work_time							= 0.1,
		nozzle_position						= {{-0.4, 0.0, 0.0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.06,
		smoke_color							= {0.8, 0.8, 0.8},
		smoke_transparency					= 0.1,
		custom_smoke_dissipation_factor		= 0.0,				
	},
	
	march = {
		impulse								= 110,
		fuel_mass							= 1.4,
		work_time							= 26.5,
		nozzle_position						= {{-0.14, 0.065, 0.0},{-0.14, -0.065, 0.0},{-0.14, 0.0, 0.065},{-0.14, 0.0, -0.065}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.15},{0.0, 0.0, -0.15},{0.0, -0.15, 0.0},{0.0, 0.15, 0.0}},
		tail_width							= 0.06,
		smoke_color							= {0.8, 0.8, 0.8},
		smoke_transparency					= 0.013,
		custom_smoke_dissipation_factor		= 0.013,
	},
	
	spiral_nav = {
		t_cone_near_rad			= 1000,
		def_cone_max_dist		= 3000,
		def_cone_near_rad		= 1000,
		def_cone_near_rad_st	= 0,
		def_cone_time_stab_rad	= 0,
		gb_angle				= 0.018,
		gb_min_dist				= 1,
		gb_use_time				= 1.4,
		gb_max_retW				= 0.44,
		gb_ret_Kp				= 0.95,
	},
	
	fm  = {
		mass        = 11,  
		caliber     = 0.125,
		L           = 0.87,
		I           = 1 / 12 * 11 * 0.87 * 0.87,
		Ma          = 4.0,
		Mw          = 5.0,	
		cx_coeff    = {1,0.6,0.35,0.4,1.05},
		rail_open	= 0,
		Sw			= 0.35,
		dCydA		= {0.032, 0.024},
		maxAoa		= 0.2,
		finsTau		= 0.05,
		A			= 0.6,
		freq		= 8.5,
	},

	autopilot = {
		Kp					= 0.18,
		Ki					= 0.026,
		Kd					= 0.046,
		max_ctrl_angle		= 1.0,
		delay				= 0.5,
		op_time				= 33.0,
		fins_discreet		= 0.01,
		no_ctrl_center_ang	= 0.0002,
	},
	
	eng_err = {
		y_error = 0.28,
		z_error = 0.36,
		min_time_interval = 0.1,
		max_time_interval = 0.36,
	},
	
	warhead = warheads["MALUTKA"], 
	warhead_air = warheads["MALUTKA"], 
}, 
{
	mass		= 11,
	Reflection	= 0.02,
});


declare_missile("TOW2", _("BGM-71 TOW"), "bgm-71e", "wAmmunitionVikhr", wsType_SS_Missile, "command_guided_missile_sfe", 
{
	controller = {
		boost_start = 0.001,
		march_start = 0.13,
	},
	
	booster = {
		impulse								= 160,
		fuel_mass							= 0.8,
		work_time							= 0.04,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-0.8, 0.0, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.045,
		smoke_color							= {0.8, 0.8, 0.8},
		smoke_transparency					= 0.2,
		custom_smoke_dissipation_factor		= 0.0,				
	},
	
	march = {
		impulse								= 200,
		fuel_mass							= 2.6,
		work_time							= 1.5,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-0.23, 0.0, 0.062},{-0.23, 0.0, -0.062}},
		nozzle_orientationXYZ				= {{0.0, -0.9, 0.0},{0.0, 0.9, 0.0}},
		tail_width							= 0.045,
		smoke_color							= {0.7, 0.7, 0.7},
		smoke_transparency					= 0.013,
		custom_smoke_dissipation_factor		= 0.013,
	},
	
	spiral_nav = {
		t_cone_near_rad			= 1000,
		def_cone_max_dist		= 3800,
		def_cone_near_rad		= 1000,
		def_cone_near_rad_st	= 0,
		def_cone_time_stab_rad	= 0,
		gb_angle				= 0.026,
		gb_min_dist				= 1,
		gb_use_time				= 0.28,
		gb_max_retW				= 0.5,
		gb_ret_Kp				= 2.5,
	},
	
	
	autopilot = {
		Kp					= 0.3,
		Ki					= 0.03,
		Kd					= 0.03,
		max_ctrl_angle		= 1.1,
		delay				= 0.2,
		op_time				= 23.0,
		fins_discreet		= 0.01,
		no_ctrl_center_ang	= 0.000035,
	},

	fm = {
		mass        = 21.5,  
		caliber     = 0.152,  
		cx_coeff    = {1,0.28,0.43,0.18,1.12},
		L           = 1.17,
		I           = 1 / 12 * 21.5 * 1.17 * 1.17,
		Ma          = 2.0,
		Mw          = 5.0,
		wind_sigma	= 0.0,
		wind_time	= 0.0,
		Sw			= 0.085,
		dCydA		= {0.024, 0.018},
		A			= 0.6,
		maxAoa		= 0.28,
		finsTau		= 0.05,
		lockRoll	= 1,
	},

	err = {
		y_error = 0.08,
		z_error = 0.02,
		min_time_interval = 0.1,
		max_time_interval = 0.9,
	},
	
	warhead = warheads["TOW"],
	warhead_air = warheads["TOW"],
}, 
{
	mass		= 21.5,
	Reflection	= 0.033,
});

declare_missile("AT_6", _("AT-6"), "9m114", "wAmmunitionVikhr", wsType_AS_Missile, "shturm_new", 
{
	booster = {
		impulse								= 220,
		fuel_mass							= 1,
		work_time							= 0.05,
		nozzle_position						= {{-1.0, 0.0, 0.0}},
		tail_width							= 0.3,
		smoke_color							= {0.8, 0.8, 0.8},
		smoke_transparency					= 0.8,
		custom_smoke_dissipation_factor		= 0.0,				
	},
	
	march = {
		impulse								= 240,
		fuel_mass							= 5.0,
		work_time							= 2,
		nozzle_position						= {{-0.45, 0.0, 0.07},{-0.45, 0.0,-0.07}},
		nozzle_orientationXYZ				= {{0.0, -0.2, 0.0},{0.0, 0.2, 0.0}},
		tail_width							= 0.06,
		smoke_color							= {0.8, 0.8, 0.8},
		smoke_transparency					= 0.1,
		custom_smoke_dissipation_factor		= 0.3,				
	},
	
	march2 = {
		impulse								= 250,
		fuel_mass							= 3.6,
		work_time							= 2.5,
		nozzle_position						= {{-0.45, 0.0, 0.07},{-0.45, 0.0, -0.07}},
		nozzle_orientationXYZ				= {{0.0, -0.2, 0.0},{0.0, 0.2, 0.0}},
		tail_width							= 0.06,
		smoke_color							= {0.8, 0.8, 0.8},
		smoke_transparency					= 0.1,
		custom_smoke_dissipation_factor		= 0.3,				
	},
	
	march_smoke = {
		impulse								= 240,
		fuel_mass							= 0.6,
		work_time							= 0.5,
		nozzle_position						= {{-0.45, 0.0, 0.1},{-0.45, 0.0, -0.1}},
		nozzle_orientationXYZ				= {{0.0, -0.2, 0.15},{0.0, 0.2, 0.0}},
		tail_width							= 0.4,
		smoke_color							= {0.1, 0.1, 0.1},
		smoke_transparency					= 0.1,
		custom_smoke_dissipation_factor		= 0.4,				
	},
	
	spiral_nav = {
		t_cone_near_rad			= 1000,
		def_cone_max_dist		= 6500,
		def_cone_near_rad		= 1000,
		def_cone_near_rad_st	= 0,
		def_cone_time_stab_rad	= 0,
		gb_angle				= 0.0036,
		gb_min_dist				= 3200,
		gb_use_time				= 5.3,
		gb_max_retW				= 0.4,
		gb_ret_Kp				= 1.1,
	},
	
	autopilot = {
		Kp					= 0.062,
		Ki					= 0.056,
		Kd					= 0.036,
		max_ctrl_angle		= 1.15,
		delay				= 0.7,
		op_time				= 18.0,
		fins_discreet		= 0.08,
		no_ctrl_center_ang	= 0.00002,
	},
	

	fm  = {
		mass				= 31,  
		caliber    			= 0.3,
		L           		= 1.630,
		I           		= 1 / 12 * 31 * 1.63 * 1.63,
		Ma         			= 2,
		Mw         			= 5,		
		cx_coeff    		= {1,0.36,1.20,0.15,1.6},
		Sw					= 0.12,
		dCydA				= {0.024, 0.018},
		A					= 0.6,
		maxAoa				= 0.2,
		finsTau				= 0.05,
		freq				= 4.0,
	},
	
	eng_err = {
		y_error				= 0.0,
		z_error				= 0.1,
		min_time_interval	= 0.1,
		max_time_interval	= 1.0,
	},
	
	warhead		= warheads["AT_6"], 
	warhead_air = warheads["AT_6"], 
}, 
{
	mass		= 31,
	Reflection	= 0.0495,
});


declare_missile("Vikhr_M", _("Vikhr M"), "vichr", "wAmmunitionVikhr", wsType_AS_Missile, "command_guided_spin_missile", 
{
	controller = {
		boost_start = 0.001,
		march_start = 0.500,
	},
	
	booster = {
		impulse								= 220,
		fuel_mass							= 5.1,
		work_time							= 0.5,
		nozzle_position						= {{-1.2, 0.0, 0.0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.2,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.8,
		custom_smoke_dissipation_factor		= 0.0,				
	},
	
	march = {
		impulse								= 240,
		fuel_mass							= 8.1,
		work_time							= 6.3,
		nozzle_position						= {{0.2, 0.08, 0.0},{0.2, -0.086, 0.0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.15},{0.0, 0.0, -0.15}},
		tail_width							= 0.05,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.1,
		custom_smoke_dissipation_factor		= 0.2,				
	},
	
	spiral_nav = {
		def_cone_max_dist		= 8500,
		t_cone_near_rad			= 1000,
		def_cone_near_rad		= 15,
		def_cone_near_rad_st	= 500,
		def_cone_time_stab_rad	= 5,
		gb_angle				= 0.0,
		gb_min_dist				= 0.0,
		gb_use_time				= 0.0,
		gb_max_retW				= 0.0,
		gb_ret_Kp				= 0.0,
	},
	
	autopilot = {
		Kp					= 0.078,
		Ki					= 0.058,
		Kd					= 0.038,
		max_ctrl_angle		= 1.35,
		delay				= 0.2,
		op_time				= 24.0,
		fins_discreet		= 0.04,
		no_ctrl_center_ang	= 0.00004,
	},

	fm  = {
		mass        = 45,  
		caliber     = 0.13,
		L           = 2.75,
		I           = 1 / 12 * 45 * 2.75 * 2.75,
		Ma          = 2,
		Mw          = 5,		
		cx_coeff    = {1,0.65,0.85,0.85,1.4},
		Sw			= 0.1,
		dCydA		= {0.024, 0.018},
		A			= 0.6,
		maxAoa		= 0.2,
		finsTau		= 0.1,
		freq		= 2.0,
	},
	
	eng_err = {
		y_error = 0.0,
		z_error = 0.0,
		min_time_interval = 0.1,
		max_time_interval = 1.0,
	},
	
	warhead = warheads["Vikhr_M"], 
	warhead_air = warheads["Vikhr_M"], 
}, 
{
	mass		= 45,
	Reflection	= 0.015,
});

--[[]]
declare_missile("Igla_1E", _("Igla-S"), "9M39", "wAmmunitionSelfHoming", wsType_SA_Missile, "self_homing_spin_missile2", 
{
	controller = {
		boost_start = 0.001,
		march_start = 0.40,
		march2_start = 2.0,
	},
	
	booster = {
		impulse								= 170,
		fuel_mass							= 0.22,
		work_time							= 0.048,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-0.8, 0.0, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.4,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.9,
		custom_smoke_dissipation_factor		= 0.3,				
	},
		
	march = {
		impulse								= 225,
		fuel_mass							= 2.25,
		work_time							= 1.9,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-0.8, 0.0, 0.0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.2,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.9,
		custom_smoke_dissipation_factor		= 0.3,	
	},
	
	march2 = {
		impulse								= 207,
		fuel_mass							= 2.23,
		work_time							= 6.6,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-0.8, 0.0, 0.0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.2,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.7,
		custom_smoke_dissipation_factor		= 0.3,	
	},

	fm = {
		mass        = 10.6,  
		caliber     = 0.072,  
		cx_coeff    = {1,1.15,0.6,0.4,1.5},
		L           = 1.68,
		I           = 1 / 12 * 10.6 * 1.68 * 1.68,
		Ma          = 0.6,
		Mw          = 1.2,
		Sw			= 0.2,
		dCydA		= {0.07, 0.036},
		A			= 0.6,
		maxAoa		= 0.3,
		finsTau		= 0.1,
		freq		= 20,
	},
	
	simple_IR_seeker = {
		sensitivity		= 10500,
		cooled			= true,
		delay			= 0.0,
		GimbLim			= math.rad(30),
		FOV				= math.rad(2);
		opTime			= 14.0,
		target_H_min	= 0.0,
		flag_dist		= 150.0,
		abs_err_val		= 4,
		ground_err_k	= 3,
	},
	
	simple_gyrostab_seeker = {
		omega_max	= math.rad(8)
	},
	
	fuze_proximity = {
		ignore_inp_armed	= 1,
		radius				= 3,
	},
	
	autopilot = {
		K				= 1.4,
		Kg				= 0.2,
		Ki				= 0.0,
		finsLimit		= 0.05,
		delay			= 0.5,
		fin2_coeff		= 0.5,
	},
	
	warhead = warheads["Igla_1E"],
	warhead_air = warheads["Igla_1E"]
}, 
{
	mass		= 10.6,
	Reflection	= 0.0044,
});


declare_missile("FIM_92C", _("FIM-92B"), "fim-92", "wAmmunitionSelfHoming", wsType_SA_Missile, "self_homing_spin_missile2", 
{
	controller = {
		boost_start = 0.001,
		march_start = 0.40,
		march2_start = 1.8,
	},
	
	booster = {
		impulse								= 170,
		fuel_mass							= 0.22,
		work_time							= 0.048,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-0.8, 0.0, 0.0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.4,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.9,
		custom_smoke_dissipation_factor		= 0.3,				
	},
		
	march = {
		impulse								= 250,
		fuel_mass							= 2.52,
		work_time							= 1.4,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-0.8, 0.0, 0.0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.2,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.9,
		custom_smoke_dissipation_factor		= 0.3,	
	},
	
	march2 = {
		impulse								= 225,
		fuel_mass							= 2.04,
		work_time							= 5.1,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-0.8, 0.0, 0.0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.2,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.7,
		custom_smoke_dissipation_factor		= 0.3,	
	},

	fm = {
		mass        = 10.1,  
		caliber     = 0.072,  
		cx_coeff    = {1,1.15,0.8,0.4,1.5},
		L           = 1.52,
		I           = 1 / 12 * 10.6 * 1.52 * 1.52,
		Ma          = 0.6,
		Mw          = 1.2,
		Sw			= 0.2,
		dCydA		= {0.07, 0.036},
		A			= 0.6,
		maxAoa		= 0.3,
		finsTau		= 0.1,
		freq		= 20,
	},
	
	simple_IR_seeker = {
		sensitivity		= 9500,
		cooled			= true,
		delay			= 0.0,
		GimbLim			= math.rad(30),
		FOV				= math.rad(2);
		opTime			= 15.0,
		target_H_min	= 0.0,
		flag_dist		= 150.0,
		abs_err_val		= 4,
		ground_err_k	= 3,
	},
	
	simple_gyrostab_seeker = {
		omega_max	= math.rad(8)
	},
	
	fuze_proximity = {
		ignore_inp_armed	= 0,
		radius				= 0,
	},
	
	autopilot = {
		K				= 2.0,
		Kg				= 0.1,
		Ki				= 0.0,
		finsLimit		= 0.2,
		delay 			= 0.5,
		fin2_coeff		= 0.5,
	},
	
	warhead = warheads["FIM_92C"],
	warhead_air = warheads["FIM_92C"],

}, 
{
	mass		= 10.1,
	Reflection	= 0.0044,
});


declare_missile("MIM_72G", _("MIM-72G"), "mim-72", "wAmmunitionSelfHoming", wsType_SA_Missile, "IR_seeker_stab_missile", 
{
	controller = {
		boost_start = 0.001,
		march_start = 0.501,
	},
	
	booster = {
		impulse								= 160,
		fuel_mass							= 2.0,
		work_time							= 0.5,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-1.6, 0.0, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.4,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.9,
		custom_smoke_dissipation_factor		= 0.3,				
	},
		
	march = {
		impulse								= 160,
		fuel_mass							= 27,
		work_time							= 9,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-1.6, 0.0, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.2,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.9,
		custom_smoke_dissipation_factor		= 0.3,	
	},

	fm = {
		mass        = 86,  
		caliber     = 0.127,  
		cx_coeff    = {1,0.45,1.0,0.65,1.3},
		L           = 2.9,
		I           = 1 / 12 * 86 * 2.9 * 2.9,
		Ma          = 0.6,
		Mw          = 1.2,
		Sw			= 0.2,
		dCydA		= {0.07, 0.036},
		A			= 0.6,
		maxAoa		= 0.25,
		finsTau		= 0.1,
		Ma_x		= 0.001,
		Mw_x		= 0.11,
		I_x			= 40,
	},
	
	simple_IR_seeker = {
		sensitivity		= 9500,
		cooled			= true,
		delay			= 0.0,
		GimbLim			= math.rad(30),
		FOV				= math.rad(7)*2;
		opTime			= 15.0,
		target_H_min	= 0.0,
		flag_dist		= 150.0,
		abs_err_val		= 4,
		ground_err_k	= 3,
	},
	
	simple_gyrostab_seeker = {
		omega_max	= math.rad(8)
	},
	
	fuze_proximity = {
		ignore_inp_armed	= 0,
		radius				= 0,
	},
	
	autopilot = {
		delay 			= 1.5,
		K				= 2.6,
		Kg				= 0.15,
		Ki				= 0.0001,
		finsLimit		= 0.44,
		fin2_coeff		= 0.5,
	},
	
	warhead = warheads["MIM_72G"],
	warhead_air = warheads["MIM_72G"],
	
}, 
{
	mass		= 86,
	Reflection	= 0.0182,
});


declare_missile("AGM_122", _("AGM-122"), "agm-122", "wAmmunitionSelfHoming", wsType_AS_Missile, "anti_radiation_missile2", 
{
	controller = {
		march_start = 0.1,
	},

	march = {
		impulse								= 140,
		fuel_mass							= 27.2,
		work_time							= 5,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-1.45, 0.0, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.1,
		smoke_color							= {0.8, 0.8, 0.8},
		smoke_transparency					= 0.9,
		custom_smoke_dissipation_factor		= 0.2,	
	},
	
	
	fm = {
		mass        = 88,  
		caliber     = 0.127,  
		cx_coeff    = {1,1.5,0.56,0.28,1.8},
		L           = 3.02,
		I           = 1 / 12 * 127 * 3.02 * 3.02,
		Ma          = 0.3,
		Mw          = 1.2,
		wind_sigma	= 0.0,
		wind_time	= 0.0,
		Sw			= 0.36,
		dCydA		= {0.07, 0.036},
		A			= 0.36,
		maxAoa		= 0.24,
		finsTau		= 0.1,
		Mw_x		= 0.1,
		Ma_x		= 0.001,
	},
	
	radio_seeker = {
		FOV					= math.rad(15),
		op_time				= 200,
		keep_aim_time		= 4,
		pos_memory_time		= 60,
		sens_near_dist		= 200.0,
		sens_far_dist		= 20000.0,
		err_correct_time	= 1.2,		-- The time interval of calcuulation a random  aiming error, seconds
		err_val				= 0.0012,	-- Random  aiming error coefficient
		lock_err_val		= 0.06,
		calc_aim_dist		= 500000,
		blind_rad_val		= 0.2,
		blind_ctrl_dist		= 1000,
		aim_y_offset		= 2.2,
		min_sens_rad_val	= 0.00025,
	},
	
	simple_gyrostab_seeker = {
		omega_max	= math.rad(8)
	},
	
	fuze_proximity = {
		ignore_inp_armed	= 1,
		arm_delay			= 2,
		radius				= 4,
	},
	
	autopilot = {
		K				 = 90.0,
		Kg				 = 4.0,
		Ki				 = 0.0,
		finsLimit		 = 0.22,
		useJumpByDefault = 0,
		J_Power_K		 = 0.0,
		J_Diff_K		 = 0.0,
		J_Int_K			 = 0.0,
		J_Angle_K		 = 0.0,
		J_FinAngle_K	 = 0.0,
		J_Angle_W		 = 0.0,
		delay			 = 0.5,
	},
	
	start_helper = {
		delay				= 0.5,
		power				= 0.35,
		time				= 1,
		use_local_coord		= 0,
		max_vel				= 100,
		max_height			= 150,
		vh_logic_or			= 0,
	},
	
	warhead = warheads["AGM_122"],
	warhead_air = warheads["AGM_122"],

}, 
{
	mass		= 88,
	Reflection	= 0.02,
});


declare_missile("AGM_88", _('AGM-88C'), "AGM-88", "wAmmunitionAntiRad", wsType_AS_Missile, "anti_rad_missile",
{
	controller = {
		boost_start = 0.02,
		march_start = 1.02,
	},
	
	boost = {
		impulse								= 235,
		fuel_mass							= 25.5,
		work_time							= 1.0,
		nozzle_position						= {{-2.1, 0, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		nozzle_exit_area 					= 0.01368,
		tail_width							= 0.4,
		smoke_color							= {0.9, 0.9, 0.9},
		smoke_transparency					= 0.1,
		custom_smoke_dissipation_factor		= 0.3,
	},
	
	march = {
		impulse								= 226,
		fuel_mass							= 101.5,
		work_time							= 20.4,
		nozzle_position						= {{-2.1, 0, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		nozzle_exit_area 					= 0.01368,
		tail_width							= 0.3,
		smoke_color							= {0.8, 0.8, 0.8},
		smoke_transparency					= 0.1,
		custom_smoke_dissipation_factor		= 0.3,	
	},
	
	fm = {
		mass				= 361,  
		caliber				= 0.254,  
		wind_sigma			= 0.0,
		wind_time			= 0.0,
		tail_first			= 1,
		fins_part_val		= 0,
		rotated_fins_inp	= 0,
		delta_max			= math.rad(20),
		draw_fins_conv		= {math.rad(90),1,1},
		L					= 0.254,
		S					= 0.051,
		Ix					= 3.5,
		Iy					= 320.5,
		Iz					= 320.5,
		
		Mxd					= 0.3 * 57.3,
		Mxw					= -44.5,

		table_scale	= 0.2,
		table_degree_values = 1,
	--	Mach	  | 0.0		0.2		0.4		0.6		0.8		1.0		1.2		1.4		1.6		1.8		2.0		2.2		2.4		2.6		2.8		3.0		3.2		3.4		3.6		3.8		4.0	   |
		Cx0 	= {	0.359,	0.359,	0.359,	0.359,	0.359,	0.533,	0.63,	0.639,	0.612,	0.586,	0.563,	0.541,	0.521,	0.501,	0.483,	0.466,	0.449,	0.433,	0.418,	0.404,	0.3920 },
		CxB 	= {	0.016,	0.016,	0.016,	0.016,	0.016,	0.022,	0.056,	0.0687,	0.0646,	0.0607,	0.0569,	0.0533,	0.0499,	0.0465,	0.0432,	0.0401,	0.0367,	0.0339,	0.031,	0.0282,	0.0255 },
		K1		= { 0.0056,	0.0056,	0.0056,	0.0056,	0.0056,	0.0056,	0.0056,	0.0056,	0.0052,	0.0048,	0.0045,	0.0041,	0.0037,	0.0036,	0.0034,	0.0032,	0.0031,	0.0030,	0.0029,	0.0027,	0.0026 },
		K2		= { 0.0055,	0.0055,	0.0055,	0.0055,	0.0055,	0.0055,	0.0055,	0.0055,	0.0051,	0.0047,	0.0043,	0.0037,	0.0031,	0.0032,	0.0033,	0.0035,	0.0036,	0.0037,	0.0038,	0.0039,	0.0040 },
		Cya		= { 1.14,	1.14,	1.14,	1.14,	1.14,	1.42,	1.46,	1.39,	1.32,	1.15,	1.06,	1.00,	0.94,	0.89,	0.83,	0.78,	0.73,	0.69,	0.65,	0.61,	0.57 },
		Cza		= { 1.14,	1.14,	1.14,	1.14,	1.14,	1.42,	1.46,	1.39,	1.32,	1.15,	1.06,	1.00,	0.94,	0.89,	0.83,	0.78,	0.73,	0.69,	0.65,	0.61,	0.57 },
		Mya		= { -0.5,	-0.5},
		Mza		= { -0.5,	-0.5},
		Myw		= { -2.0,	-2.0},
		Mzw		= { -2.0,	-2.0},
		A1trim	= { 10.0,	10.0},
		A2trim	= { 10.0,	10.0},
		
		model_roll = math.rad(45),
		fins_stall = 1,
	},
	
	proximity_fuze = {
		radius		= 8,
		arm_delay	= 1.6,
	},
	
	seeker = {
		delay					= 2.4,
		op_time					= 200,
		FOV						= math.rad(60),
		max_w_LOS				= math.rad(20),
		sens_near_dist			= 100,
		sens_far_dist			= 70000,
		
		keep_aim_time		= 5,
		pos_memory_time		= 150,
		err_correct_time	= 2.0,
		calc_aim_dist		= 500000,
		blind_rad_val		= 0.1,
		aim_y_offset		= 2.5,		-- set 0.0 in tests
		
		ang_err_val			= math.rad(0.008),
		abs_err_val			= 2,
		
		lock_manual_target_types_only = 0,
	},

	autopilot = {
		delay				= 1.5,
		x_channel_delay		= 1.0,
		op_time				= 200,
		Kconv				= 3.0,
		Knv					= 0.0025,
		Kd					= 0.42,
		Ki					= 0.01,
		Kout				= 1.0,
		Kx					= 0.04,
		Krx					= 2.0,
		fins_limit			= math.rad(20),
		fins_limit_x		= math.rad(5),
		Areq_limit			= 14.0,
		bang_bang			= 0,
		max_signal_Fi		= math.rad(12),
		rotate_fins_output	= 0,
		alg					= 0,
		PN_dist_data 		= {	15000,	0,
								5000,	1},
		null_roll			= math.rad(45),
		
		loft_active_by_default		= 1,
		loft_add_pitch				= math.rad(13),
		loft_trig_ang				= math.rad(27),
		loft_min_dist				= 20000,
		K_heading_hor				= 50,
		K_heading_ver				= 0.3,
		K_loft						= 0.3,
		loft_min_add_pitch			= math.rad(5),
		loft_min_trig_ang			= math.rad(10),
		loft_trig_change_min_dist	= 3000,
		loft_trig_change_max_dist	= 35000,
		
		min_horiz_time				= 5.0,
	},
	
	warhead		= warheads["AGM_88"],
	warhead_air = warheads["AGM_88"],

}, 
{
	mass		= 361,
	Reflection	= 0.05,
});


declare_missile("X_58", _("Kh-58U"), "X-58", "wAmmunitionSelfHoming", wsType_AS_Missile, "anti_radiation_missile", 
{
	controller = {
		boost_start = 0.301,
		march_start = 3.900,
	},
	
	booster = {
		impulse								= 195,
		fuel_mass							= 112.18,
		work_time							= 3.6,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-1.5, -0.19, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.4,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.9,
		custom_smoke_dissipation_factor		= 0.2,	
	},
	
	march = {
		impulse								= 210,
		fuel_mass							= 70.86,
		work_time							= 15,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-1.5, -0.19, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.4,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.9,
		custom_smoke_dissipation_factor		= 0.2,	
	},
	
	
	fm = {
		mass        = 640,  
		caliber     = 0.380,  
		cx_coeff    = {1,0.4,1.1,0.5,1.4},
		L           = 4.8,
		I           = 1 / 12 * 640 * 4.8 * 4.8,
		Ma          = 0.3,
		Mw          = 1.116,
		wind_sigma	= 0.0,
		wind_time	= 0.0,
		Sw			= 1.65,
		dCydA		= {0.07, 0.036},
		A			= 0.36,
		maxAoa		= 0.28,
		finsTau		= 0.1,
		
		Ma_x		= 0.001,
		Mw_x		= 0.08,
		I_x			= 50,
	},
	
	radio_seeker = {
		FOV					= math.rad(5),
		op_time				= 600,--200Kh58
		keep_aim_time		= 4,
		pos_memory_time		= 200,
		sens_near_dist		= 300.0,
		sens_far_dist		= 70000.0,
		err_correct_time	= 2.5,
		err_val				= 0.0036,
		calc_aim_dist		= 500000,
		blind_rad_val		= 0.1,
		blind_ctrl_dist		= 2800,
		aim_y_offset		= 4.5,
	},
	
	simple_gyrostab_seeker = {
		omega_max	= math.rad(8)
	},
	
	fuze_proximity = {
		ignore_inp_armed = 1,
	},
	
	autopilot = {
		delay			 = 1.0,
		K				 = 300.0,
		Kg				 = 5.0,
		Ki				 = 0.0,
		finsLimit		 = 0.1,
		useJumpByDefault = 1,
		J_Power_K		 = 1.2,
		J_Diff_K		 = 0.3,
		J_Int_K			 = 0.0,
		J_Angle_K		 =  math.rad(11),
		J_FinAngle_K	 =  math.rad(18),		
		J_Angle_W		 = 3.5,
	},
	
	start_helper = {
		delay				= 1.0,
		power				= 0.1,
		time				= 1,
		use_local_coord		= 0,
		max_vel				= 200,
		max_height			= 200,
		vh_logic_or			= 0,
	},
	
	warhead = warheads["X_58"],
	warhead_air = warheads["X_58"],
}, 
{
	mass		= 640,
	Reflection	= 0.15,
});


declare_missile("X_25MP", _("Kh-25MPU"), "X-25MP", "wAmmunitionSelfHoming", wsType_AS_Missile, "anti_radiation_missile", 
{
	controller = {
		boost_start = 0.001,
		march_start = 2.001,
	},
	
	booster = {
		impulse								= 208,
		fuel_mass							= 22.1,
		work_time							= 2,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-1.14, 0.0, 0.15},{-1.14, -0.0, -0.15}},
		nozzle_orientationXYZ				= {{0.0, -0.15, 0.0},{0.0, 0.15, 0.0}},
		tail_width							= 0.1,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.9,
		custom_smoke_dissipation_factor		= 0.2,				
	},
	
	
	march = {
		impulse								= 208,
		fuel_mass							= 60.4,
		work_time							= 7,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-1.14, 0.0, 0.15},{-1.14, -0.0, -0.15}},
		nozzle_orientationXYZ				= {{0.0, -0.15, 0.0},{0.0, 0.15, 0.0}},
		tail_width							= 0.1,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.9,
		custom_smoke_dissipation_factor		= 0.2,	
	},
	
	
	fm = {
		mass        = 315,  
		caliber     = 0.275,  
		cx_coeff    = {1,0.55,1.0,0.75,1.2},
		L           = 3.7,
		I           = 1 / 12 * 297 * 3.7 * 3.7,
		Ma          = 0.3,
		Mw          = 1.116,
		wind_sigma	= 20.0,
		wind_time	= 1000.000000,
		Sw			= 0.46,
		dCydA		= {0.07, 0.036},
		A			= 0.36,
		maxAoa		= 0.3,
		finsTau		= 0.1,
		Ma_x		= 0.001,
		Mw_x		= 0.08,
		I_x			= 30,
	},
	
	radio_seeker = {
		FOV					= math.rad(5),
		op_time				= 90,
		keep_aim_time		= 4,
		pos_memory_time		= 40,
		sens_near_dist		= 300.0,
		sens_far_dist		= 40000.0,
		err_correct_time	= 2.5,
		err_val				= 0.0044,
		calc_aim_dist		= 500000,
		blind_rad_val		= 0.2,
		blind_ctrl_dist		= 2000,
		aim_y_offset		= 2.0,
	},
	
	simple_gyrostab_seeker = {
		omega_max	= math.rad(8)
	},
	
	fuze_proximity = {
		ignore_inp_armed = 0,
	},
	
	autopilot = {
		K				 = 120.0,
		Kg				 = 6.0,
		Ki				 = 0.0,
		finsLimit		 = 0.22,
		useJumpByDefault = 1,
		J_Power_K		 = 1.2,
		J_Diff_K		 = 0.4,
		J_Int_K			 = 0.0,
		J_Angle_K		 = math.rad(12),
		J_FinAngle_K	 = math.rad(18),
		J_Angle_W		 = 3.5,
		delay			 = 1.0,
	},
	
	warhead = warheads["X_25MP"],
	warhead_air = warheads["X_25MP"],
	
}, 
{
	mass = 315,
	Reflection = 0.06,
});

declare_missile("X_25MR", _("Kh-25MR"), "X-25MR", "wAmmunitionVikhr", wsType_AS_Missile, "command_guided_missile", 
{
	controller = {
		boost_start = 0.001,
		march_start = 2.001,
	},
	
	booster = {
		impulse								= 208,
		fuel_mass							= 22.1,
		work_time							= 2,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-1.14, 0.0, 0.15},{-1.14, -0.0, -0.15}},
		nozzle_orientationXYZ				= {{0.0, -0.15, 0.0},{0.0, 0.15, 0.0}},
		tail_width							= 0.1,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.9,
		custom_smoke_dissipation_factor		= 0.2,				
	},
	
	
	march = {
		impulse								= 208,
		fuel_mass							= 60.4,
		work_time							= 7,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-1.14, 0.0, 0.15},{-1.14, -0.0, -0.15}},
		nozzle_orientationXYZ				= {{0.0, -0.15, 0.0},{0.0, 0.15, 0.0}},
		tail_width							= 0.1,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.9,
		custom_smoke_dissipation_factor		= 0.2,	
	},
	
	
	fm = {
		mass        = 300,  
		caliber     = 0.275,  
		cx_coeff    = {1,0.55,1.0,0.75,1.2},
		L           = 3.7,
		I           = 1 / 12 * 297 * 3.7 * 3.7,
		Ma          = 0.4,
		Mw          = 1.2,
		wind_sigma	= 0.0,--80.0,
		wind_time	= 1000.000000,
		Sw			= 0.5,
		dCydA		= {0.07, 0.036},
		A			= 0.6,
		maxAoa		= 0.24,
		finsTau		= 0.1,
		lockRoll	= 1,
	},
	
	spiral_nav = {
		t_cone_near_rad		= 1000,
		def_cone_max_dist	= 10000,
		def_cone_near_rad	= 1000,
		def_cone_near_rad_st	= 0,
		def_cone_time_stab_rad	= 0,
		gb_angle			= 0.06,
		gb_min_dist			= 1,
		gb_use_time			= 1.1,
		gb_max_retW			= 0.24,
		gb_ret_Kp			= 0.7,
	},
	
	autopilot = {
		Kp					= 0.008,
		Ki					= 0.004,
		Kd					= 0.006,
		max_ctrl_angle		= 1.0,
		delay				= 0.9,
		op_time				= 0.0,
		fins_discreet		= 0.001,
		no_ctrl_center_ang	= 0.00005,
	},
	
	warhead = warheads["X_25MR"],
	warhead_air = warheads["X_25MR"],
}, 
{	
	mass		= 300,
	Reflection	= 0.06,
});


declare_missile("X_25ML", _("Kh-25ML"), "X-25ML", "wAmmunitionLaserHoming", wsType_AS_Missile, "laser_homing_gyrost_missile", 
{
	controller = {
		boost_start = 0.001,
		march_start = 2.001,
	},
	
	booster = {
		impulse								= 208,
		fuel_mass							= 22.1,
		work_time							= 2,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-1.14, 0.0, 0.15},{-1.14, -0.0, -0.15}},
		nozzle_orientationXYZ				= {{0.0, -0.15, 0.0},{0.0, 0.15, 0.0}},
		tail_width							= 0.1,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.9,
		custom_smoke_dissipation_factor		= 0.2,				
	},
	
	march = {
		impulse								= 208,
		fuel_mass							= 60.4,
		work_time							= 7,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-1.14, 0.0, 0.15},{-1.14, -0.0, -0.15}},
		nozzle_orientationXYZ				= {{0.0, -0.15, 0.0},{0.0, 0.15, 0.0}},
		tail_width							= 0.1,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.9,
		custom_smoke_dissipation_factor		= 0.2,	
	},
	
	
	fm = {
		mass        = 297,  
		caliber     = 0.275,  
		cx_coeff    = {1,0.55,1.0,0.75,1.2},
		L           = 3.7,
		I           = 1 / 12 * 297 * 3.7 * 3.7,
		Ma          = 0.4,
		Mw          = 1.1,
		wind_sigma	= 0.0,
		wind_time	= 0.0,
		Sw			= 0.5,
		dCydA		= {0.07, 0.036},
		A			= 0.36,
		maxAoa		= 0.3,
		finsTau		= 0.1,
		Ma_x		= 0.01,
		Mw_x		= 0.08,
		I_x			= 30,
	},
	
	seeker = {
		delay				= 0.0,
		FOV					= math.rad(60),
		max_seeker_range	= 13000,
	},
	
	simple_gyrostab_seeker = {
		omega_max	= math.rad(8)
	},
	
	autopilot = {
		K				 = 20.0,
		Kg				 = 3.8,
		Ki				 = 0.0002,
		finsLimit		 = 0.22,
		useJumpByDefault = 1,
		J_Power_K		 = 1.2,
		J_Diff_K		 = 0.6,
		J_Int_K			 = 0.0,
		J_Angle_K		 = math.rad(12),
		J_FinAngle_K	 = math.rad(16),
		J_Angle_W		 = 3.5,
		delay			 = 1.0,
	},
	
	warhead		= warheads["X_25ML"],
	warhead_air	= warheads["X_25ML"]
}, 
{
	mass		= 297,
	Reflection	= 0.06,
});


declare_missile("X_29L", _("Kh-29L"), "X-29L", "wAmmunitionLaserHoming", wsType_AS_Missile, "laser_homing_gyrost_missile", 
{
	controller = {
		boost_start = 0.001,
		march_start = 0.8,
	},
		
	booster = {
		impulse								= 208,
		fuel_mass							= 0,
		work_time							= 0,
		nozzle_position						= {{-1.3, -0.19, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.4,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.9,
		custom_smoke_dissipation_factor		= 0.2,				
	},
	
	march = {
		impulse								= 208,
		fuel_mass							= 132,
		work_time							= 5,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-1.3, -0.19, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.4,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.9,
		custom_smoke_dissipation_factor		= 0.2,	
	},
	
	fm = {
		mass        = 648,  
		caliber     = 0.380,  
		cx_coeff    = {1,0.55,1.0,0.75,1.25},
		L           = 3.875,
		I           = 1 / 12 * 648 * 3.875 * 3.875,
		Ma          = 0.3,
		Mw          = 1.2,
		wind_sigma	= 0.0,
		wind_time	= 0.0,
		Sw			= 1.55,
		dCydA		= {0.07, 0.036},
		A			= 0.36,
		maxAoa		= 0.3,
		finsTau		= 0.1,
		Ma_x		= 0.005,
		Mw_x		= 0.1,
		I_x			= 45,
	},
	
	seeker = {
		delay				= 0.0,
		FOV					= math.rad(60),
		max_seeker_range	= 13000,
	},
	
	simple_gyrostab_seeker = {
		omega_max	= math.rad(8)
	},
	
	autopilot = {
		K				 = 36.0,
		Kg				 = 6.0,
		Ki				 = 0.0005,
		finsLimit		 = 0.2,
		useJumpByDefault = 1,
		J_Power_K		 = 3.6,
		J_Diff_K		 = 1.0,
		J_Int_K			 = 0.0,
		J_Angle_K		 = math.rad(14),
		J_FinAngle_K	 = math.rad(18),
		J_Angle_W		 = 4.5,
		delay			 = 0.8,
	},
	
	warhead		= warheads["X_29L"],
	warhead_air	= warheads["X_29L"]
}, 
{
	mass		= 648,
	Reflection	= 0.175,
});


declare_missile("X_29T", _("Kh-29T"), "X-29T", "wAmmunitionSelfHoming", wsType_AS_Missile, "tv_homing_gyrost_missile", 
{
	controller = {
		boost_start = 0.01,
		march_start = 0.8,
	},
	
	boost = {
		impulse								= 148,
		fuel_mass							= 0,
		work_time							= 0,
		nozzle_position						= {{-1.3, -0.19, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.4,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.9,
		custom_smoke_dissipation_factor		= 0.2,	
	},
	
	march = {
		impulse								= 148,
		fuel_mass							= 100,
		work_time							= 6.2,
		nozzle_position						= {{-1.3, -0.19, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.4,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.9,
		custom_smoke_dissipation_factor		= 0.2,	
	},
	
	
	fm = {
		mass        = 668,  
		caliber     = 0.380,  
		cx_coeff    = {1,0.55,1.0,0.75,1.25},
		L           = 3.875,
		I           = 1 / 12 * 668 * 3.875 * 3.875,
		Ma          = 0.3,
		Mw          = 1.2,
		wind_sigma	= 0.0,
		wind_time	= 1000.0,
		Sw			= 1.55,
		dCydA		= {0.07, 0.036},
		A			= 0.36,
		maxAoa		= 0.3,
		finsTau		= 0.1,
		Ma_x		= 0.005,
		Mw_x		= 0.1,
		I_x			= 45,
	},
	
	seeker = {
		delay			= 0.0,
		op_time			= 40,
		FOV				= math.rad(60),
		max_w_LOS		= 0.5,
		max_w_LOS_surf	= 0.016,
		send_off_data	= 0,
		aim_sigma		= 0.5,
	},
	
	simple_gyrostab_seeker = {
		omega_max	= math.rad(8)
	},
	
	autopilot = {
		K				 = 36.0,
		Kg				 = 6.0,
		Ki				 = 0.0005,
		finsLimit		 = 0.2,
		useJumpByDefault = 1,
		J_Power_K		 = 3.6,
		J_Diff_K		 = 1.0,
		J_Int_K			 = 0.0,
		J_Angle_K		 = math.rad(14),
		J_FinAngle_K	 = math.rad(18),
		J_Angle_W		 = 4.5,
		delay			 = 0.8,
	},
	
	warhead		= warheads["X_29T"],
	warhead_air	= warheads["X_29T"]
}, 
{
	mass		= 668,
	Reflection	= 0.1729,
});


declare_missile("X_29TE", _("Kh-29TE"), "X-29TE", "wAmmunitionSelfHoming", wsType_AS_Missile, "tv_homing_gyrost_missile", 
{
	controller = {
		boost_start = 1.0,
		march_start = 1.0,
	},
	
	boost = {
		impulse								= 148,
		fuel_mass							= 0,
		work_time							= 0,
		nozzle_position						= {{-1.3, -0.19, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.4,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.1,
		custom_smoke_dissipation_factor		= 0.2,	
	},
	
	march = {
		impulse								= 148,
		fuel_mass							= 100,
		work_time							= 6.2,
		nozzle_position						= {{-1.3, -0.19, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.4,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.1,
		custom_smoke_dissipation_factor		= 0.2,	
	},
		
	fm = {
		mass        = 678,  
		caliber     = 0.380,  
		cx_coeff    = {1,0.55,1.0,0.75,1.25},
		L           = 3.875,
		I           = 1 / 12 * 678 * 3.875 * 3.875,
		Ma          = 0.3,
		Mw          = 1.2,
		wind_sigma	= 0.0,--80.0,
		wind_time	= 1000.000000,
		Sw			= 1.55,
		dCydA		= {0.07, 0.036},
		A			= 0.36,
		maxAoa		= 0.3,
		finsTau		= 0.1,
		Ma_x		= 0.005,
		Mw_x		= 0.1,
		I_x			= 45,
	},
	
	seeker = {
		delay			= 0.0,
		op_time			= 40,
		FOV				= math.rad(60),
		max_w_LOS		= 0.5,
		max_w_LOS_surf	= 0.016,
		send_off_data	= 0,
		aim_sigma		= 0.5,
	},
	
	simple_gyrostab_seeker = {
		omega_max	= math.rad(8)
	},
	
	autopilot = {
		K				 = 36.0,
		Kg				 = 6.0,
		Ki				 = 0.0005,
		finsLimit		 = 0.2,
		useJumpByDefault = 1,
		J_Power_K		 = 3.6,
		J_Diff_K		 = 1.0,
		J_Int_K			 = 0.0,
		J_Angle_K		 = math.rad(14),
		J_FinAngle_K	 = math.rad(18),
		J_Angle_W		 = 4.5,
		delay			 = 0.8,
	},
	
	warhead		= warheads["X_29TE"],
	warhead_air	= warheads["X_29TE"]
}, 
{
	mass		= 678,
	Reflection	= 0.1729,
});

declare_missile("AGM_154", _("AGM-154C"), "agm-154", "wAmmunitionCruise", wsType_AS_Missile, "AGM-154C", 
{
	fm =	{
		mass				= 485,  
		caliber				= 0.33,  
		cx_coeff			= {1, 0.3, 0.65, 0.010, 1.6},
		L					= 4.06,
		I					= 1000,
		Ma					= 2,
		Mw					= 7,
		wind_sigma			= 0.0,
		wind_time			= 0.0,
		Sw					= 1.1,
		dCydA				= {0.07, 0.036},
		A					= 0.06,
		maxAoa				= 0.22,
		finsTau				= 1.2,
		Ma_x				= 2,
		Ma_z				= 2,
		Mw_x				= 1.4,
	
		addDeplSw			= 0.6,
		addDeplCx0			= 0.05,
		no_wings_A_mlt		= 7,
		wingsDeplProcTime	= 5,
		wingsDeplDelay		= 9999,		
	},
	
	simple_seeker =	{
		sensitivity = 0,
		delay		= 0.0,
		FOV			= 0.6,
		maxW		= 500,
		opTime		= 9999,
	},
	
	control_block =	{
		seeker_activation_dist		= 7000,
		default_cruise_height		= -1,
		obj_sensor					= 0,
		can_update_target_pos		= 0,
		turn_before_point_reach		= 1,
		turn_hor_N					= 2.2,
		turn_max_calc_angle_deg		= 90,
		turn_point_trigger_dist		= 100,
	},
	
	autopilot =	{
		delay						= 2,
		K							= 600,
		Ki							= 0.0,
		Kg							= 36,
		nw_K						= 180,
		nw_Ki						= 0.001,
		nw_Kg						= 52,
		finsLimit					= 0.8,
		useJumpByDefault			= 0,
		J_Power_K					= 7,
		J_Diff_K					= 1.2,
		J_Int_K						= 0.0,
		J_Angle_K					= 0.14,
		J_FinAngle_K				= 0.25,
		J_Angle_W					= 0.12,
		hKp_err						= 460,
		hKp_err_croll				= 0.012,
		hKd							= -0.008,
		max_roll					= 1.3,
		egm_Angle_K					= 0.18,
		egm_FinAngle_K				= 0.26,
		egm_add_power_K				= 0.2,
		wings_depl_fins_limit_K		= 0.28,
		err_new_wlos_k				= 0.84,
		err_aoaz_k					= 28,
		err_aoaz_sign_k				= 0.18,
	},
		
	warhead		= warheads["BLU-111B"],
	warhead_air = warheads["BLU-111B"],	
}, 
{
	mass		= 485,
	Reflection	= 0.0618,
});

declare_missile("AGM_65D", _("AGM-65D"), "AGM-65D", "wAmmunitionSelfHoming", wsType_AS_Missile, "AGM-65", 
{
	fm = {
		mass        = 218,  
		caliber     = 0.305,  
		cx_coeff    = {1,0.39,0.38,0.236,1.31},
		L           = 2.49,
		I           = 1 / 12 * 209 * 2.49 * 2.49,
		Ma          = 0.68,
		Mw          = 1.116,
		wind_sigma	= 0.0,
		wind_time	= 0.0,
		Sw			= 0.55,
		dCydA		= {0.07, 0.036},
		A			= 0.36,
		maxAoa		= 0.23,
		finsTau		= 0.1,
		Ma_x		= 3,
		Mw_x		= 3.3,
		I_x			= 40,
	},
	
	seeker = {
		delay			= 0.0,
		op_time			= 105,
		FOV				= math.rad(60),
		max_w_LOS		= 0.06,
		max_w_LOS_surf	= 0.03,
	
		max_target_speed			= 33,
		max_target_speed_rnd_coeff	= 10,
	},
	
	PN_autopilot = {
		K			= 0.014,
		Ki			= 0,
		Kg			= 2.5,
		Kx			= 0.02,
		fins_limit	= 0.3,
		K_GBias		= 0.26,
	},
	
	march = {
		smoke_color			= {0.8, 0.8, 0.8},
		smoke_transparency	= 0.7,
	},
	
	warhead = warheads["AGM_65D"],
	warhead_air = warheads["AGM_65D"]
}, 
{
	mass		= 218,
	Reflection	= 0.063,
});


declare_missile("AGM_65E", _("AGM-65E"), "AGM-65E", "wAmmunitionLaserHoming", wsType_AS_Missile, "AGM-65E", 
{
	fm = {
		mass        = 292,  
		caliber     = 0.305,  
		cx_coeff    = {1,0.39,0.38,0.236,1.31},
		L           = 2.49,
		I           = 1 / 12 * 209 * 2.49 * 2.49,
		Ma          = 0.68,
		Mw          = 1.116,
		wind_sigma	= 0.0,
		wind_time	= 0.0,
		Sw			= 0.55,
		dCydA		= {0.07, 0.036},
		A			= 0.36,
		maxAoa		= 0.23,
		finsTau		= 0.1,
		Ma_x		= 3,
		Mw_x		= 3.3,
		I_x			= 40,
	},
	
	laser_spot_seeker = {
		FOV					= 0.558,
		max_seeker_range	= 18520,
	},

	PN_autopilot = {
		K			= 0.014,
		Ki			= 0,
		Kg			= 1.4,
		Kx			= 0.02,
		fins_limit	= 0.3,
		K_GBias		= 0.26,
	},
	
	march = {
		smoke_color			= {0.8, 0.8, 0.8},
		smoke_transparency	= 0.7,
	},
	
	warhead		= warheads["AGM_65E"],
	warhead_air = warheads["AGM_65E"]
}, 
{
	mass		= 292,
	Reflection	= 0.063,
});


declare_missile("AGM_65H", _("AGM-65H"), "AGM-65H", "wAmmunitionSelfHoming", wsType_AS_Missile, "AGM-65", 
{
	fm = {
		mass        = 208,  
		caliber     = 0.305,  
		cx_coeff    = {1,0.39,0.38,0.236,1.31},
		L           = 2.49,
		I           = 1 / 12 * 209 * 2.49 * 2.49,
		Ma          = 0.68,
		Mw          = 1.116,
		wind_sigma	= 0.0,
		wind_time	= 0.0,
		Sw			= 0.55,
		dCydA		= {0.07, 0.036},
		A			= 0.36,
		maxAoa		= 0.23,
		finsTau		= 0.1,
		Ma_x		= 3,
		Mw_x		= 3.3,
		I_x			= 40,
	},
	
	seeker = {
		delay			= 0.0,
		op_time			= 105,
		FOV				= math.rad(60),
		max_w_LOS		= 0.06,
		max_w_LOS_surf	= 0.03,
	
		max_target_speed			= 33,
		max_target_speed_rnd_coeff	= 10,
	},
	
	PN_autopilot = {
		K			= 0.014,
		Ki			= 0,
		Kg			= 2.5,
		Kx			= 0.02,
		fins_limit	= 0.3,
		K_GBias		= 0.26,
	},
	
	march = {
		smoke_color			= {0.9, 0.9, 0.9},
		smoke_transparency	= 0.9,
	},
	
	warhead = warheads["AGM_65H"],
	warhead_air = warheads["AGM_65H"]
}, 
{
	mass		= 208,
	Reflection	= 0.063,
});


declare_missile("AGM_65G", _("AGM-65G"), "AGM-65G", "wAmmunitionSelfHoming", wsType_AS_Missile, "AGM-65", 
{
	fm = {
		mass        = 301,  
		caliber     = 0.305,  
		cx_coeff    = {1,0.39,0.38,0.236,1.31},
		L           = 2.49,
		I           = 1 / 12 * 209 * 2.49 * 2.49,
		Ma          = 0.68,
		Mw          = 1.116,
		wind_sigma	= 0.0,
		wind_time	= 0.0,
		Sw			= 0.55,
		dCydA		= {0.07, 0.036},
		A			= 0.36,
		maxAoa		= 0.23,
		finsTau		= 0.1,
		Ma_x		= 3,
		Mw_x		= 3.3,
		I_x			= 40,
	},
	
	seeker = {
		delay			= 0.0,
		op_time			= 105,
		FOV				= math.rad(60),
		max_w_LOS		= 0.06,
		max_w_LOS_surf	= 0.03,
	
		max_target_speed			= 33,
		max_target_speed_rnd_coeff	= 10,

		ship_track_board_vis_angle	= math.rad(60),
	},
	
	PN_autopilot = {
		K			= 0.02,
		Ki			= 0,
		Kg			= 2.5,
		Kx			= 0.02,
		fins_limit	= 0.3,
		K_GBias		= 0.28,
	},
	
	march = {
		smoke_color			= {0.8, 0.8, 0.8},
		smoke_transparency	= 0.7,
	},
	
	warhead		= warheads["AGM_65G"],
	warhead_air	= warheads["AGM_65G"]
}, 
{	
	mass		= 301,
	Reflection	= 0.063,
});


declare_missile("AGM_65K", _("AGM-65K"), "AGM-65K", "wAmmunitionSelfHoming", wsType_AS_Missile, "AGM-65", 
{
	fm = {
		mass        = 297,  
		caliber     = 0.305,  
		cx_coeff    = {1,0.39,0.38,0.236,1.31},
		L           = 2.49,
		I           = 1 / 12 * 209 * 2.49 * 2.49,
		Ma          = 0.68,
		Mw          = 1.116,
		wind_sigma	= 0.0,
		wind_time	= 0.0,
		Sw			= 0.55,
		dCydA		= {0.07, 0.036},
		A			= 0.36,
		maxAoa		= 0.23,
		finsTau		= 0.1,
		Ma_x		= 3,
		Mw_x		= 3.3,
		I_x			= 40,
	},
	
	seeker = {
		delay			= 0.0,
		op_time			= 105,
		FOV				= math.rad(60),
		max_w_LOS		= 0.06,
		max_w_LOS_surf	= 0.03,
	
		max_target_speed			= 33,
		max_target_speed_rnd_coeff	= 10,
	},
	
	PN_autopilot = {
		K			= 0.014,
		Ki			= 0,
		Kg			= 2.5,
		Kx			= 0.02,
		fins_limit	= 0.3,
		K_GBias		= 0.238,
	},
	
	march = {
		smoke_color			= {0.9, 0.9, 0.9},
		smoke_transparency	= 0.5,
	},
	
	warhead		= warheads["AGM_65K"],
	warhead_air	= warheads["AGM_65K"]
}, 
{
	mass		= 360,
	Reflection	= 0.063,
});

declare_missile("AGM_84A", _('AGM-84A Harpoon'), "agm-84", "wAmmunitionAntiShip", wsType_AS_Missile, "anti_ship_missile_stpos_ctrl", 
{
	fm = {
		mass        = 555.0,  
		caliber     = 0.343,  
		cx_coeff    = {1,0.39,0.38,0.236,1.31},
		L           = 3.85,
		I           = 1 / 12 * 555.0 * 3.85 * 3.85,
		Ma          = 0.68,
		Mw          = 1.116,
		wind_sigma	= 0.0,
		wind_time	= 1000.0,
		Sw			= 0.7,
		dCydA		= {0.07, 0.036},
		A			= 0.5,
		maxAoa		= 0.3,
		finsTau		= 0.05,
		Ma_x		= 3,
		Ma_z		= 3,
		Kw_x 		= 0.05, -- Mw_x	= 3, -- quick fix, Mw_x and AP to be adjusted later
	},
	
	simple_seeker = {
		delay		= 1.0,
		FOV			= math.rad(45),
		stTime		= 0.5,
		opTime		= 9999,
	},
	
	autopilot =	--inertial autopilot + horiz correction when seeker is on
	{
		delay				= 1.0,		-- time delay
		Kpv					= 0.026,	-- vertical control PID
		Kdv					= 3.2,
		Kiv					= 0.00002,
		Kph					= 28.0,		-- horiz control PID
		Kdh					= 3.0,
		Kih					= 0.0,
		glide_height		= 35.0,		-- cruise glide height
		use_current_height	= 0,		-- keep launch height
		max_vert_speed 		= 25.0,		-- max vertical speed kept from launch height to glide height
		altim_vel_k			= 1.0,		-- proximity sensor correction by velocity coeff
		finsLimit			= 0.68,		-- max signal value from autopilot to fins 
		inertial_km_error	= 4.0,		-- inertial guidance error coeff to 1 km flight distance
	},
	
	final_autopilot =		-- final stage guidance with terminal maneuver
	{
		delay				= 0,
		K					= 60,		-- autopilot P
		Ki					= 0,		-- I
		Kg					= 16,		-- D
		finsLimit			= 0.9,		
		useJumpByDefault	= 1,		-- 
		J_Power_K			= 2.0,		-- terminal maneuver params: P
		J_Diff_K			= 0.8,		-- D
		J_Int_K				= 0,		-- I
		J_Angle_K			= 0.24,		-- jump maneuver angle
		J_FinAngle_K		= 0.32,		-- jump inactivation trigger angle to target
		J_Angle_W			= 2.4,		-- max maneuver angle speed
		bang_bang			= 0,		-- use only -1, 1 values to control fins
		J_Trigger_Vert		= 1,		-- use global y axis
	},
	
	triggers_control = {
		action_wait_timer				= 5,	-- wait for dist functions n sen, then set default values
		default_sensor_tg_dist			= 8000, -- turn on seeker and start horiz. correction if target is locked
		final_maneuver_by_default		= 1,
		default_final_maneuver_tg_dist	= 4000,
		default_destruct_tg_dist		= 1000,	-- if seeker still can not find a target explode warhead after reaching pred. target point + n. km
		trigger_by_path					= 1,
	},
	
	controller = {
		boost_start	= 0.001,
		march_start = 0.01,
	},
	
	boost = {	--	air launch - no booster
		impulse								= 0,
		fuel_mass							= 0,
		work_time							= 0,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{0, 0, 0}},
		nozzle_orientationXYZ				= {{0, 0, 0}},
		tail_width							= 0.0,
		smoke_color							= {0.0, 0.0, 0.0},
		smoke_transparency					= 0.0,
		custom_smoke_dissipation_factor		= 0.0,				
	},
	
	march = {
		impulse			= 550,
		fuel_mass		= 138.5,
		work_time		= 9999,
		min_fuel_rate	= 0.005,
		min_thrust		= -100,
		max_thrust		= 3000,
		thrust_Tau		= 0.0017,
		
		nozzle_position						= {{-1.70, -0.18, 0.0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.5,
		smoke_color							= {0.0, 0.0, 0.0},
		smoke_transparency					= 0.2,
		custom_smoke_dissipation_factor		= 0.2,	
		
		start_burn_effect			= 1,
		start_effect_delay			= {0.0,		0.3, 	0.8},
		start_effect_time			= {0.7,		1.0, 	0.1},
		start_effect_size			= {0.09,	0.104,	0.11},
		start_effect_smoke			= {0.01,	0.4, 	0.01},
		start_effect_x_pow			= {1.0,		1.0,	1.0},
		start_effect_x_dist			= {1.1,		0.9,	0.0},
		start_effect_x_shift		= {0.15,	0.15,	0.2},
	},
	
	engine_control = {
		default_speed	= 237,
		K				= 265,
		Kd				= 0.01,
		Ki				= 0.001,
		-- burst_signal = 9999, -- used in 'anti_ship_missile_tb' scheme
	},
	
	warhead = warheads["AGM_84A"],
	warhead_air = warheads["AGM_84A"]
}, 
{
	mass			= 555.0,
	Reflection		= 0.121,
	add_attributes	= {"Cruise missiles"},
});


declare_missile("AGM_84E", _('AGM-84E SLAM'), "agm-84e", "wAmmunitionAntiShip", wsType_AS_Missile, "SLAM", 
{
	controller = {
		boost_start	= 0.001,
		march_start = 0.01,
	},
	
	control_block = {
		default_cruise_height = 1524.0, 
	},
	
	
	boost = {				--	air launch - no booster
		impulse								= 0,
		fuel_mass							= 0,
		work_time							= 0,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{0, 0, 0}},
		nozzle_orientationXYZ				= {{0, 0, 0}},
		tail_width							= 0.0,
		smoke_color							= {0.0, 0.0, 0.0},
		smoke_transparency					= 0.0,
		custom_smoke_dissipation_factor		= 0.0,				
	},
	
	march = {
		impulse			= 2890,
		fuel_mass		= 24,
		work_time		= 9999,
		min_fuel_rate	= 0.005,
		min_thrust		= -100,
		max_thrust		= 2900,
		thrust_Tau		= 0.0018,
		
		nozzle_position						= {{-2.3, -0.2, 0.0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.5,
		smoke_color							= {0.0, 0.0, 0.0},
		smoke_transparency					= 0.01,
		custom_smoke_dissipation_factor		= 0.2,	
		
		start_burn_effect			= 1,
		start_effect_delay			= {0.0,		0.3, 	0.8},
		start_effect_time			= {0.7,		1.0, 	0.1},
		start_effect_size			= {0.09,	0.104,	0.11},
		start_effect_smoke			= {0.01,	0.4, 	0.01},
		start_effect_x_pow			= {1.0,		1.0,	1.0},
		start_effect_x_dist			= {1.1,		0.9,	0.0},
		start_effect_x_shift		= {0.15,	0.15,	0.2},
	},
	
	engine_control = {
		default_speed	= 237,
		K				= 240,
		Kd				= 1.0,
		Ki				= 0.01,
	},
	
		
	seeker = {
		delay				= 0.0,
		op_time				= 800,
		activate_on_update	= 1,
		
		FOV					= math.rad(60),
		max_w_LOS			= 0.06,
		max_w_LOS_surf		= 0.03,
	
		max_target_speed			= 33,
		max_target_speed_rnd_coeff	= 10,
		
		max_lock_dist		= 30000,
	},
	
	ins = {
		aim_sigma		= 35,
		check_AI		= 1,
		error_coeff		= 0.05,
	},
	
	fm = {
		mass        = 629.5,  
		caliber     = 0.343,  
		cx_coeff    = {1,0.39,0.38,0.236,1.31},
		L           = 4.49,
		I           = 1 / 12 * 628.0 * 4.49 * 4.49,
		Ma          = 0.68,
		Mw          = 1.116,
		wind_sigma	= 0.0,
		wind_time	= 1000.0,
		Sw			= 0.7,
		dCydA		= {0.07, 0.036},
		A			= 0.5,
		maxAoa		= 0.3,
		finsTau		= 0.02,
		Ma_x		= 3,
		Ma_z		= 3,
		Mw_x		= 2.6,
	},

	autopilot =
	{
		delay				= 1.0,
		Kpv					= 0.019,
		Kdv					= 2.8,
		Kiv					= 0.00002,
		Kph					= 28.0,
		Kdh					= 3.0,
		Kih					= 0.0,
		glide_height		= 1524,--1524 --4572 --10668
		use_current_height	= 1,
		max_vert_speed 		= 48.0,
		altim_vel_k			= 1.0,
		finsLimit			= 0.68,
		inertial_km_error	= 0.3,
		comfort_vel			= 175,
	},
	
	final_autopilot =		
	{
		delay				= 1.0,
		K					= 60,
		Ki					= 0,
		Kg					= 20,
		finsLimit			= 0.68,		
		useJumpByDefault	= 0,
		J_Power_K			= 0,
		J_Diff_K			= 0,
		J_Int_K				= 0,
		J_Angle_K			= 0,
		J_FinAngle_K		= 0,
		J_Angle_W			= 0,
		bang_bang			= 0,
		J_Trigger_Vert		= 0,
	},

	
	triggers_control = {
		action_wait_timer				= 5,	-- wait for dist functions n sen, then set default values
		default_sensor_tg_dist			= 11000, -- turn on seeker and start horiz. correction if target is locked
		default_final_maneuver_tg_dist	= 7000,
		default_straight_nav_tg_dist	= 7000,
		default_destruct_tg_dist		= 3000,	-- if seeker still can not find a target explode warhead after reaching pred. target point + n. km
		trigger_by_path					= 1,
		final_maneuver_trig_v_lim		= 3,
		use_horiz_dist					= 1,
		pre_maneuver_glide_height		= 1524,	-- triggers st nav instead of fin. maneuver if h>2*pre_maneuver_glide_height at fin. maneuver distance
		min_cruise_height				= 1524,
		min_cruise_height_trigger_sum	= 11000,	
		min_cruise_height_trigger_mlt	= 237/33,		
	},
	
	warhead		= warheads["AGM_84A"],
	warhead_air	= warheads["AGM_84A"]
}, 
{
	mass			= 629.5,
	Reflection		= 0.121,
	add_attributes	= {"Cruise missiles"},
});


declare_missile("X_28", _("Kh-28"), "X-28", "wAmmunitionSelfHoming", wsType_AS_Missile, "anti_radiation_missile_diff_loft", 
{
	controller = {
		march_start = 2.001,
	},

	march = {
		impulse								= 150,
		fuel_mass							= 235,
		work_time							= 10,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-2.85, -0.21, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.4,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.2,
		custom_smoke_dissipation_factor		= 0.2,	
		effect_type							= 1,
	},
	
	
	fm = {
		mass        = 715,  
		caliber     = 0.430,  
		cx_coeff    = {1,0.5,1.1,0.3,1.3},
		L           = 6.04,
		I           = 1 / 12 * 715 *6.04 * 6.04,
		Ma          = 0.3,
		Mw          = 1.116,
		wind_sigma	= 0.0,
		wind_time	= 0.0,
		Sw			= 1.6,
		dCydA		= {0.07, 0.036},
		A			= 0.36,
		maxAoa		= 0.2,
		finsTau		= 0.1,
		lockRoll	= 1,
		
		Ma_x		= 0.001,
		Mw_x		= 0.04,
		I_x			= 60,
	},
	
	radio_seeker = {
		FOV					= math.rad(5),
		op_time				= 900,--200Kh58
		keep_aim_time		= 4,
		pos_memory_time		= 200,
		sens_near_dist		= 300.0,
		sens_far_dist		= 70000.0,
		err_correct_time	= 2,
		err_val				= 0.012,
		calc_aim_dist		= 500000,
		blind_rad_val		= 0.1,
		blind_ctrl_dist		= 2500,
		aim_y_offset		= 2.5,
	},
	
	simple_gyrostab_seeker = {
		omega_max	= math.rad(8)
	},
	
	fuze_proximity = {
		ignore_inp_armed	= 1,
		arm_delay			= 10,
		radius				= 10,
	},
	
	autopilot = {
		delay			 = 2.0,	
		K				 = 140.0,
		Kg				 = 5.0,
		Ki				 = 0.0,
		finsLimit		 = 0.1,
		useJumpByDefault = 1,
		J_Power_K		 = 1.2,
		J_Diff_K		 = 0.3,
		J_Int_K			 = 0.0,
		J_FinAngle_K	 =  math.rad(38),
		J_Angle_W		 = 3.5,
		
		J_Angle_K			=  math.rad(28.5),
		K1_ang		 		= 28.5,
		K2_ang		 		= -1.9,
		K3_ang		 		= 0.032,
	},
	
	start_helper = {
		delay				= 1.0,
		power				= 0.3,
		time				= 2,
		use_local_coord		= 0,
		max_vel				= 200,
		max_height			= 600,
		vh_logic_or			= 0,
	},
	
	warhead = warheads["X_28"],
	warhead_air = warheads["X_28"]
}, 
{	
	mass		= 715,
	Reflection	= 0.15,
});


declare_missile("AGM_45", _("AGM-45"), "agm-45", "wAmmunitionSelfHoming", wsType_AS_Missile, "anti_radiation_missile2", 
{
	controller = {
		march_start = 0.021,
	},

	march = {
		impulse								= 190,
		fuel_mass							= 36,
		work_time							= 12,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-1.0, -0.1, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.3,
		smoke_color							= {0.6, 0.6, 0.6},
		smoke_transparency					= 0.8,
		custom_smoke_dissipation_factor		= 0.2,	
	},
	
	
	fm = {
		mass        = 177,  
		caliber     = 0.203,  
		cx_coeff    = {1,0.4,1.1,0.5,1.4},
		L           = 3.05,
		I           = 1 / 12 * 177 * 3.05 * 3.05,
		Ma          = 0.3,
		Mw          = 1.116,
		wind_sigma	= 0.0,
		wind_time	= 0.0,
		Sw			= 0.85,
		dCydA		= {0.07, 0.036},
		A			= 0.36,
		maxAoa		= 0.28,
		finsTau		= 0.1,
		
		Ma_x		= 0.001,
		Mw_x		= 0.13,
		I_x			= 50,
	},
	
	radio_seeker = {
		FOV					= math.rad(5),
		op_time				= 90,
		keep_aim_time		= 0.1,
		pos_memory_time		= 0.1,
		sens_near_dist		= 300.0,
		sens_far_dist		= 60000.0,
		err_correct_time	= 3.0,
		err_val				= 0.012,
		calc_aim_dist		= 500000,
		blind_rad_val		= 0.2,
		blind_ctrl_dist		= 2200,
		aim_y_offset		= 3.0,
		--min_sens_rad_val	= --0.00025,
	},
	
	simple_gyrostab_seeker = {
		omega_max	= math.rad(8)
	},
	
	fuze_proximity = {
		ignore_inp_armed	= 1,
		arm_delay			= 10,
		radius				= 10,
	},
	
	autopilot = {
		K				 = 220.0,
		Kg				 = 6.0,
		Ki				 = 0.0001,
		finsLimit		 = 0.1,
		useJumpByDefault = 1,
		J_Power_K		 = 1.2,
		J_Diff_K		 = 0.3,
		J_Int_K			 = 0.0,
		J_Angle_K		 = math.rad(10),
		J_FinAngle_K	 = math.rad(18),
		delay			 = 2.0,
		J_Angle_W		 = 2.5,
	},
	
	start_helper = {
		delay				= 0.2,
		power				= 0.02,
		time				= 2,
		use_local_coord		= 0,
		max_vel				= 200,
		max_height			= 400,
		vh_logic_or			= 1,
	},
	
	warhead = warheads["AGM_45"],
	warhead_air = warheads["AGM_45"]
}, 
{
	mass		= 177,
	Reflection	= 0.05,
}
);

declare_missile("X_31P", _("Kh-31P"), "X-31", "wAmmunitionSelfHoming", wsType_AS_Missile, "anti_radiation_missile", 
{
	controller = {
		boost_start = 0.001,
		march_start = 2.001,
	},
	
	booster = {
		impulse								= 160,
		fuel_mass							= 20,
		work_time							= 2,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-2.0, -0.21, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.2,
		smoke_color							= {0.8, 0.8, 0.8},
		smoke_transparency					= 0.8,
		custom_smoke_dissipation_factor		= 0.2,				
	},
	
	
	march = {
		impulse								= 280,
		fuel_mass							= 100,
		work_time							= 6,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-2.15, -0.21, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.1,
		smoke_color							= {0.9, 0.9, 0.9},
		smoke_transparency					= 0.05,
		custom_smoke_dissipation_factor		= 0.45,	
		effect_type 						= 1,
		min_start_speed						= 220,
	},
	
	
	fm = {
		mass        = 600,  
		caliber     = 0.360,  
		cx_coeff    = {1,0.5,1.1,0.5,1.4},
		L           = 4.7,
		I           = 1 / 12 * 600 * 4.7 * 4.7,
		Ma          = 0.3,
		Mw          = 1.116,
		wind_sigma	= 0.0,
		wind_time	= 0.0,
		Sw			= 0.6,
		dCydA		= {0.07, 0.036},
		A			= 0.36,
		maxAoa		= 0.28,
		finsTau		= 0.1,
		lockRoll	= 1,
		
		Ma_x		= 0.001,
		Mw_x		= 0.15,
		I_x			= 60,
	},
	
	radio_seeker = {
		FOV					= math.rad(30),
		op_time				= 900,
		keep_aim_time		= 4,
		pos_memory_time		= 40,
		sens_near_dist		= 300.0,
		sens_far_dist		= 40000.0,
		err_correct_time	= 2.5,
		err_val				= 0.0044,
		calc_aim_dist		= 500000,
		blind_rad_val		= 0.2,
		blind_ctrl_dist		= 2000,
		aim_y_offset		= 2.0,
	},
	
	simple_gyrostab_seeker = {
		omega_max	= math.rad(8)
	},
	
	fuze_proximity = {
		ignore_inp_armed = 1,
	},
	
	autopilot = {
		K				 = 240.0,
		Kg				 = 24.0,
		Ki				 = 0.0,
		finsLimit		 = 0.25,
		useJumpByDefault = 1,
		J_Power_K		 = 1.2,
		J_Diff_K		 = 0.4,
		J_Int_K			 = 0.0,
		J_Angle_K		 = math.rad(14),
		J_FinAngle_K	 = math.rad(24),
		J_Angle_W		 = 3.5,
		delay			 = 1.0,
	},
	
	
	warhead = warheads["X_31P"],
	warhead_air = warheads["X_31P"]
}, 
{
	mass		= 600,
	Reflection	= 0.3,
});


declare_missile("ALARM", _("ALARM"), "t-alarm", "wAmmunitionSelfHoming", wsType_AS_Missile, "anti_radiation_missile", 
{
	controller = {
		boost_start = 0.001,
		march_start = 1.001,
	},
	
	booster = {
		impulse								= 185,
		fuel_mass							= 15,
		work_time							= 1.0,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-2, -0.13, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.4,
		smoke_color							= {0.9, 0.9, 0.9},
		smoke_transparency					= 0.5,
		custom_smoke_dissipation_factor		= 0.3,				
	},
		
	march = {
		impulse								= 210,
		fuel_mass							= 55.0,
		work_time							= 9.0,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-2, -0.13, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.3,
		smoke_color							= {0.8, 0.8, 0.8},
		smoke_transparency					= 0.5,
		custom_smoke_dissipation_factor		= 0.3,	
	},
	
	fm = {
		mass        = 265,  
		caliber     = 0.254,  
		cx_coeff    = {1,0.65,1.0,0.6,1.3},
		L           = 4.3,
		I           = 1 / 12 * 265 * 4.3 * 4.3,
		Ma          = 0.3,
		Mw          = 1.2,
		wind_sigma	= 0.0,
		wind_time	= 0.0,
		Sw			= 1.16,
		dCydA		= {0.07, 0.036},
		A			= 0.36,
		maxAoa		= 0.28,
		finsTau		= 0.1,
		lockRoll	= 1,
		
		Ma_x		= 0.001,
		Mw_x		= 0.1,
		I_x			= 40,
	},
	
	radio_seeker = {
		FOV					= math.rad(6),	-- !	���� ������
		op_time				= 300,			-- !	����� ������ �������
		keep_aim_time		= 5,			-- !	����� �� ������ ������ ����� ���� ����� ������ �������
		pos_memory_time		= 150,			-- !	����� �� ������ ������ � ����� ������������
		sens_near_dist		= 150.0,		--		����������� ������� ���������	 
		sens_far_dist		= 70000.0,		--		������������ ������� ���������
		err_correct_time	= 1.2,			-- !!	������ ���������� ���� � ���� (��������������� ������)
		err_val				= 0.0026,		-- !!	������������ ������� ������
		calc_aim_dist		= 500000,		-- 		������������ ���������� ��� ���������� ����� ������������ (����)
		blind_rad_val		= 0.1,			--		������������ ������� �������� ������� �� ������� (����) (������ �-��� ����������)
		blind_ctrl_dist		= 2100,			--		���������� ��� ����� ������������ �� ����� ���������� (����)
		aim_y_offset		= 3.5,			-- !!	����� ������� �� ������ ������������ aimPoint ��������� ����
	},
	
	simple_gyrostab_seeker = {
		omega_max	= math.rad(8)
	},
	
	fuze_proximity = {
		ignore_inp_armed = 1,
	},
	
	autopilot = {
		K				 = 100.0,
		Kg				 = 2.4,
		Ki				 = 0.0,
		finsLimit		 = 0.08,
		useJumpByDefault = 1,
		J_Power_K		 = 1.9,
		J_Diff_K		 = 0.4,
		J_Int_K			 = 0.0,
		J_Angle_K		 = math.rad(8),
		J_FinAngle_K	 = math.rad(16),
		delay			 = 1.0,
		J_Angle_W		 = 3.5,
	},
	
	start_helper = {
		delay				= 1.0,
		power				= 0.1,
		time				= 1,
		use_local_coord		= 0,
		max_vel				= 200,
		max_height			= 200,
		vh_logic_or			= 0,
	},
	
	warhead = warheads["ALARM"],
	warhead_air = warheads["ALARM"]
}, 
{	
	mass		= 265,
	Reflection	= 0.0741,
});


declare_missile("BGM_109B", _("BGM-109B"), "tomahawk", "wAmmunitionCruise", wsType_SS_Missile, "cruise_missile_vert_start_booster_drop", 
{
	controller = {
		boost_start	= 0.01,
		march_start = 8.0,
	},
	
	fm = {
		mass			= 1440,  
		caliber			= 0.52,  
		cx_coeff		= {1, 0.3, 0.65, 0.018, 1.6},
		L				= 5.56,
		I				= 3000,
		Ma				= 2,
		Mw				= 4,
		wind_sigma		= 0.0,
		wind_time		= 0.0,
		Sw				= 1.2,
		dCydA			= {0.07, 0.036},
		A				= 0.08,
		maxAoa			= 0.3,
		finsTau			= 0.2,
		Ma_x			= 2,
		Mw_x			= 3,
		addDeplSw		= 1.0,
		wingsDeplDelay	= 20,
	},
	
	seeker = {
		coalition				= 2,
		coalition_rnd_coeff		= 5.0,
	},
	
	booster_animation = {
		start_val = 1,
	},
	
	play_booster_animation = {
		val = 0,
	},
	
	boost = {	--	air launch - no booster
		impulse								= 160,
		fuel_mass							= 247.5,
		work_time							= 7,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-3.64, 0, 0}},
		nozzle_orientationXYZ				= {{0, 0, 0}},
		tail_width							= 0.5,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.5,
		custom_smoke_dissipation_factor		= 0.5,
			
		wind_sigma					= 0.0,
		impulse_sigma				= 1,
		moment_sigma				= 1000000.0,
			
		mass						= 50.0,	
		caliber						= 0.5,	
		L							= 0.3,
		I							= 100,
		Ma							= 0.5,
		Mw							= 0.1,
		Cx							= 0.9,
			
		model_name					= "tomahawk_booster",
		start_impulse				= 0,
	},
	
	march = {
		impulse			= 5080,
		fuel_mass		= 100.0,
		work_time		= 9999,
		min_fuel_rate	= 0.005,
		min_thrust		= -100,
		max_thrust		= 1900,
		thrust_Tau		= 0.0017,
	},
	
	control_block ={
		seeker_activation_dist		= 12000,
		default_cruise_height		= 50,
		obj_sensor					= 1,
		can_update_target_pos		= 0,
		turn_before_point_reach		= 1,
		turn_hor_N					= 0.8,
		turn_max_calc_angle_deg		= 90,
		turn_point_trigger_dist		= 100,
	},
	
	start_autopilot = {
		delay			= 0.5,
		rollCtrlDelay	= 15.0,
		opTime 			= 20.0,
		K				= 6.4,
		Kd				= 90.0,
		rK				= 0.02,
		rKd				= 0.0001,
		finsLimit		= 60.0,
	},
	
	final_autopilot =		{
		delay				= 0,
		K					= 240,
		Ki					= 0.001,
		Kg					= 6,
		finsLimit			= 0.4,
		useJumpByDefault	= 1,
		J_Power_K			= 1.2,
		J_Diff_K			= 0.1,
		J_Int_K				= 0.001,
		J_Angle_K			= 0.23,
		J_FinAngle_K		= 0.38,
		J_Angle_W			= 0.4,
		hKp_err				= 100,
		hKp_err_croll		= 0.04,
		hKd					= 0.005,
		max_roll			= 0.7,
	},
	
	cruise_autopilot = {
		delay				= 1,
		Kp_hor_err			= 240,
		Kp_hor_err_croll	= 0.08,
		Kd_hor				= 0,
		Kp_ver				= 8,
		Kii_ver				= 0.3,
		Kd_ver				= 0.02,
		Kp_eng				= 200,
		Ki_eng				= 0.005,
		Kd_eng				= 0,
		Kp_ver_st1			= 0.009,
		Kd_ver_st1			= 0.015,
		Kp_ver_st2			= 0.00018,
		Kd_ver_st2			= 0.00005,
		
		auto_terrain_following			= 1,
		auto_terrain_following_height	= 50,
		
		alg_points_num			= 7,
		alg_calc_time			= 1.5,
		alg_vel_k				= 6,
		alg_div_k				= 2,
		alg_max_sin_climb		= 0.7,
		alg_section_temp_points	= 3,
		alg_tmp_point_vel_k		= 1.5,
		no_alg_vel_k			= 10,
		
		max_roll			= 0.7,
		max_start_y_vel		= 15,
		stab_vel			= 237.5,
		finsLimit			= 0.8,
		estimated_N_max		= 2,
		eng_min_thrust		= -100,
		eng_max_thrust		= 3000,		
	},
	
			
	warhead		= warheads["BGM_109B"],
	warhead_air = warheads["BGM_109B"],	
}, 
{	
	mass = 1440,
	Reflection = 0.3967,
});


declare_missile("AIM_7", _('AIM-7M'), "aim-7", "wAmmunitionSelfHoming", wsType_AA_Missile, "aa_missile_semi_active",
{
	controller = {
		boost_start = 0.5,
		march_start = 4.2,
	},
	
	boost = {
		impulse								= 247,
		fuel_mass							= 38.48,
		work_time							= 3.7,
		nozzle_position						= {{-1.9, 0, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.4,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.9,
		custom_smoke_dissipation_factor		= 0.2,	
	},
	
	march = {
		impulse								= 209,
		fuel_mass							= 21.82,
		work_time							= 10.8,
		nozzle_position						= {{-1.9, 0, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.4,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.9,
		custom_smoke_dissipation_factor		= 0.2,
		
--		fuel_rate_data	=	{	--t		rate
--								0.0,	2.0,
--								4.0,	1.8,
--							},
	},
	
	fm = {
		mass				= 231,  
		caliber				= 0.2,  
		wind_sigma			= 0.0,
		wind_time			= 0.0,
		tail_first			= 1,
		fins_part_val		= 0,
		rotated_fins_inp	= 0,
		delta_max			= math.rad(20),
		draw_fins_conv		= {math.rad(90),1,1},
		L					= 0.2,
		S					= 0.0324,
		Ix					= 3.5,
		Iy					= 127.4,
		Iz					= 127.4,
		
		Mxd					= 0.3 * 57.3,
		Mxw					= -44.5,

		table_scale	= 0.2,
		table_degree_values = 1,
	--	Mach	  | 0.0		0.2		0.4		0.6		0.8		1.0		1.2		1.4		1.6		1.8		2.0		2.2		2.4		2.6		2.8		3.0		3.2		3.4		3.6		3.8		4.0	 |
		Cx0 	= {	0.34,	0.34,	0.34,	0.34,	0.35,	1.10,	1.27,	1.23,	1.19,	1.12,	1.05,	1.0,	0.95,	0.91,	0.87,	0.84,	0.81,	0.78,	0.76,	0.74,	0.72 },
		CxB 	= {	0.11,	0.11,	0.11,	0.11,	0.11,	0.40,	0.19,	0.17,	0.16,	0.14,	0.13,	0.12,	0.12,	0.11,	0.11,	0.10,	0.09,	0.09,	0.08,	0.08,	0.07 },
		K1		= { 0.0056,	0.0056,	0.0056,	0.0056,	0.0056,	0.0056,	0.0056,	0.0056,	0.0052,	0.0048,	0.0045,	0.0041,	0.0037,	0.0036,	0.0034,	0.0032,	0.0031,	0.0030,	0.0029,	0.0027,	0.0026 },
		K2		= { 0.0055,	0.0055,	0.0055,	0.0055,	0.0055,	0.0055,	0.0055,	0.0055,	0.0051,	0.0047,	0.0043,	0.0037,	0.0031,	0.0032,	0.0033,	0.0035,	0.0036,	0.0037,	0.0038,	0.0039,	0.0040 },
		Cya		= { 1.14,	1.14,	1.14,	1.14,	1.14,	1.42,	1.46,	1.39,	1.32,	1.15,	1.06,	1.00,	0.94,	0.89,	0.83,	0.78,	0.73,	0.69,	0.65,	0.61,	0.57 },
		Cza		= { 1.14,	1.14,	1.14,	1.14,	1.14,	1.42,	1.46,	1.39,	1.32,	1.15,	1.06,	1.00,	0.94,	0.89,	0.83,	0.78,	0.73,	0.69,	0.65,	0.61,	0.57 },
		Mya		= { -0.5,	-0.5},
		Mza		= { -0.5,	-0.5},
		Myw		= { -2.0,	-2.0},
		Mzw		= { -2.0,	-2.0},
		A1trim	= { 10.0,	10.0},
		A2trim	= { 10.0,	10.0},
		
		model_roll = math.rad(45),
		fins_stall = 1,
	},
	
	proximity_fuze = {
		radius		= 12,
		arm_delay	= 1.6,
	},
	
	seeker = {
		delay					= 1.5,
		op_time					= 75,
		FOV						= math.rad(120),
		max_w_LOS				= math.rad(20),
		sens_near_dist			= 100,
		sens_far_dist			= 30000,
		ccm_k0					= 1.0,
		aim_sigma				= 5.5,
		height_error_k			= 100,
		height_error_max_vel	= 138,
		height_error_max_h		= 300,
		hoj						= 1,
	},

	autopilot = {
		x_channel_delay 	= 0.9,
		delay				= 1.5,
		op_time				= 75,
		Kconv				= 4.0,
		Knv					= 0.02,
		Kd					= 0.4,
		Ki					= 0.1,
		Kout				= 1.0,
		Kx					= 0.1,
		Krx					= 2.0,
		fins_limit			= math.rad(20),
		fins_limit_x		= math.rad(5),
		Areq_limit			= 25.0,
		bang_bang			= 0,
		max_side_N			= 10,
		max_signal_Fi		= math.rad(12),
		rotate_fins_output	= 0,
		alg					= 0,
		PN_dist_data 		= {	15000,	1,
								9000,	1},
		null_roll			= math.rad(45),
		
		loft_active_by_default	= 1,
		loft_add_pitch			= math.rad(30),
		loft_time				= 3.5,
		loft_min_dist			= 6500,
		loft_max_dist			= 20000,
	},
	
	warhead		= warheads["AIM_7"],
	warhead_air = warheads["AIM_7"]
}, 
{
	mass = 230,
	Reflection = 0.0366,
});

declare_missile("SeaSparrow", _('RIM-7'), "aim-7", "wAmmunitionSelfHoming", wsType_SA_Missile, "aa_missile_semi_active",
{
	controller = {
		boost_start = 0.02,
		march_start = 3.7,
	},
	
	boost = {
		impulse								= 247,
		fuel_mass							= 38.48,
		work_time							= 3.7,
		nozzle_position						= {{-1.9, 0, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.4,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.9,
		custom_smoke_dissipation_factor		= 0.2,	
	},
	
	march = {
		impulse								= 209,
		fuel_mass							= 21.82,
		work_time							= 10.8,
		nozzle_position						= {{-1.9, 0, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.4,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.9,
		custom_smoke_dissipation_factor		= 0.2,
		
--		fuel_rate_data	=	{	--t		rate
--								0.0,	2.0,
--								4.0,	1.8,
--							},
	},
	
	fm = {
		mass				= 231,  
		caliber				= 0.2,  
		wind_sigma			= 0.0,
		wind_time			= 0.0,
		tail_first			= 1,
		fins_part_val		= 0,
		rotated_fins_inp	= 0,
		delta_max			= math.rad(20),
		draw_fins_conv		= {math.rad(90),1,1},
		L					= 0.2,
		S					= 0.0324,
		Ix					= 3.5,
		Iy					= 127.4,
		Iz					= 127.4,
		
		Mxd					= 0.3 * 57.3,
		Mxw					= -44.5,

		table_scale	= 0.2,
		table_degree_values = 1,
	--	Mach	  | 0.0		0.2		0.4		0.6		0.8		1.0		1.2		1.4		1.6		1.8		2.0		2.2		2.4		2.6		2.8		3.0		3.2		3.4		3.6		3.8		4.0	 |
		Cx0 	= {	0.34,	0.34,	0.34,	0.34,	0.35,	1.10,	1.27,	1.23,	1.19,	1.12,	1.05,	1.0,	0.95,	0.91,	0.87,	0.84,	0.81,	0.78,	0.76,	0.74,	0.72 },
		CxB 	= {	0.11,	0.11,	0.11,	0.11,	0.11,	0.40,	0.19,	0.17,	0.16,	0.14,	0.13,	0.12,	0.12,	0.11,	0.11,	0.10,	0.09,	0.09,	0.08,	0.08,	0.07 },
		K1		= { 0.0056,	0.0056,	0.0056,	0.0056,	0.0056,	0.0056,	0.0056,	0.0056,	0.0052,	0.0048,	0.0045,	0.0041,	0.0037,	0.0036,	0.0034,	0.0032,	0.0031,	0.0030,	0.0029,	0.0027,	0.0026 },
		K2		= { 0.0055,	0.0055,	0.0055,	0.0055,	0.0055,	0.0055,	0.0055,	0.0055,	0.0051,	0.0047,	0.0043,	0.0037,	0.0031,	0.0032,	0.0033,	0.0035,	0.0036,	0.0037,	0.0038,	0.0039,	0.0040 },
		Cya		= { 1.14,	1.14,	1.14,	1.14,	1.14,	1.42,	1.46,	1.39,	1.32,	1.15,	1.06,	1.00,	0.94,	0.89,	0.83,	0.78,	0.73,	0.69,	0.65,	0.61,	0.57 },
		Cza		= { 1.14,	1.14,	1.14,	1.14,	1.14,	1.42,	1.46,	1.39,	1.32,	1.15,	1.06,	1.00,	0.94,	0.89,	0.83,	0.78,	0.73,	0.69,	0.65,	0.61,	0.57 },
		Mya		= { -0.5,	-0.5},
		Mza		= { -0.5,	-0.5},
		Myw		= { -2.0,	-2.0},
		Mzw		= { -2.0,	-2.0},
		A1trim	= { 10.0,	10.0},
		A2trim	= { 10.0,	10.0},
		
		model_roll = math.rad(45),
		fins_stall = 1,
	},
	
	proximity_fuze = {
		radius		= 12,
		arm_delay	= 1.6,
	},
	
	seeker = {
		delay					= 2,
		op_time					= 75,
		FOV						= math.rad(120),
		max_w_LOS				= math.rad(20),
		sens_near_dist			= 100,
		sens_far_dist			= 30000,
		ccm_k0					= 1,
		aim_sigma				= 5.5,
		height_error_k			= 100;
		height_error_max_vel	= 138;
		height_error_max_h		= 300;
	},

	autopilot = {
		x_channel_delay 	= 0.9,
		delay				= 1.6,
		op_time				= 75,
		Kconv				= 4.0,
		Knv					= 0.02,
		Kd					= 0.4,
		Ki					= 0.1,
		Kout				= 1.0,
		Kx					= 0.1,
		Krx					= 2.0,
		fins_limit			= math.rad(20),
		fins_limit_x		= math.rad(5),
		Areq_limit			= 25.0,
		bang_bang			= 0,
		max_side_N			= 10,
		max_signal_Fi		= math.rad(12),
		rotate_fins_output	= 0,
		alg					= 0,
		PN_dist_data 		= {	15000,	1,
								9000,	1},
		null_roll			= math.rad(45),
		
		loft_active_by_default	= 1,
		loft_add_pitch			= math.rad(30),
		loft_time				= 4.0,
		loft_min_dist			= 6000,
	},
	
	no_signal_destruct = {
		activate_by_port		= 0,
		activation_check_delay	= 2,
		flag_timer				= 5.0,
	},
	
	warhead		= warheads["RIM_7"],
	warhead_air = warheads["RIM_7"]
}, 
{
	mass = 230,
	Reflection = 0.0366,
});


declare_missile("SCUD_RAKETA", _('R-17'), "R-17", "wAmmunitionSelfHoming", wsType_SS_Missile, "SCUD",
{
	controller = {
		boost_start	= 0.01,
		march_start = 2.98,
	},
	
	fm = {
		mass			= 5862.0,
		caliber			= 0.88,  
		cx_coeff		= {0.5, 1, 0.8, 0.32, 1.8},
		L				= 11,
		I				= 1 / 12 * 5862 * 11 * 11,
		Ma				= 2,
		Mw				= 6,
		wind_sigma		= 0.0,
		wind_time		= 0.0,
		Sw				= 1.3,
		dCydA			= {0.07, 0.036},
		A				= 0.08,
		maxAoa			= 0.3,
		finsTau			= 8,
		Ma_x			= 2,
		Mw_x			= 0.42,
	},

	booster = {
		impulse								= 240,
		fuel_mass							= 350,
		work_time							= 3,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-5.5, 0, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 1,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.9,
		custom_smoke_dissipation_factor		= 0.2,	
	},
	
	march = {
		impulse								= 240,
		fuel_mass							= 3436,
		work_time							= 87,
		boost_time							= 0,
		boost_factor						= 0,
		nozzle_position						= {{-5.5, 0, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 1,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.01,
		custom_smoke_dissipation_factor		= 0.2,	
	},

	control_block = {
		test_mode		= 0,
		st0_ctrl_time	= 12,
		st_ctrl_time	= 55,
		pitch_trig_diff	= 0.05,
		pitch_trig_time	= 4.0,
		data_asc		= 1,
		engine_control_time = {58, 62.5, 65, 68, 71, 73.7, 76.7, 80, 85, 99},
		aim_data = {
		-- 1st engine mode
		--	tg deg		dist nw		****************************h=0***********************************	--------h=2000----------------	******h=8000**************	-Hdiff-
		--							fwd wind:											side:	sidef:	fwd:		side:		sidef:	fwd:		side:	sidef:	diff =500m
		--				no wind		15m/s		10m/s	5m/s	-5m/s	-10m/s	-15m/s	10m/s	10m/s	10m/s 		10m/s		10m/s	10m/s		10m/s	10m/s	no wind 

			55,			63989.2,	-116.91,	-21.23,	2.59,	-25.06,	-47.69,	-28.00,	-7.69,	34.91,	645.15,		1884.05,	45.96,	561.79,		372.86,	15.44,	578.31,
			55.5,		64069.1,	-118.49,	-20.66,	3.05,	-25.35,	-47.62,	-25.25,	-7.62,	34.68,	647.30,		1931.96,	49.13,	545.23,		386.62,	15.61,	572.44,
			56,			64131.5,	-120.06,	-20.17,	3.60,	-25.74,	-47.56,	-22.43,	-7.57,	34.33,	649.92,		1981.14,	57.31,	522.61,		399.38,	15.74,	571.53,
			56.5,		64171.0,	-117.03,	-19.51,	8.82,	-21.47,	-42.84,	-14.81,	-7.49,	32.76,	659.19,		2029.08,	54.83,	503.30,		415.11,	11.27,	560.74,
			57,			64197.9,	-124.81,	-20.26,	5.05,	-27.93,	-48.78,	-17.80,	-7.46,	33.75,	661.43,		2078.19,	59.91,	478.04,		430.03,	16.14,	559.51,
			57.5,		64199.9,	-121.95,	-18.35,	10.48,	-23.47,	-42.75,	-13.02,	-7.44,	28.81,	673.65,		2128.62,	64.06,	456.13,		443.83,	11.60,	553.54,
			58,			64186.3,	-126.55,	-17.77,	6.37,	-26.71,	-46.95,	-10.10,	-7.35,	33.12,	681.44,		2179.45,	66.85,	428.51,		458.85,	16.43,	552.13,
			58.5,		64149.7,	-130.05,	-19.00,	6.59,	-29.30,	-43.99,	-7.19,	-7.33,	32.69,	692.39,		2225.18,	73.15,	405.41,		476.70,	16.62,	545.84,
			59,			64090.8,	-125.12,	-16.66,	11.95,	-23.08,	-42.10,	0.57,	-7.34,	27.80,	705.81,		2275.08,	71.60,	380.32,		495.97,	12.17,	539.56,
			59.5,		64017.0,	-132.82,	-18.10,	7.49,	-29.56,	-48.24,	-1.88,	-7.32,	32.08,	714.69,		2325.33,	83.33,	344.17,		513.54,	16.91,	537.75,
			60,			63911.4,	-130.52,	-15.51,	14.82,	-24.02,	-40.24,	4.18,	-7.30,	27.09,	734.62,		2373.98,	82.25,	318.98,		535.32,	12.52,	526.47,
			60.5,		63782.4,	-132.11,	-14.67,	9.76,	-24.70,	-41.78,	7.69,	-7.27,	26.72,	757.09,		2427.89,	89.83,	281.62,		553.73,	12.70,	524.53,
			61,			63627.9,	-133.37,	-15.70,	8.31,	-26.44,	-41.54,	9.27,	-7.21,	30.82,	778.74,		2485.65,	96.43,	241.94,		571.40,	17.43,	517.43,
			61.5,		63440.6,	-130.61,	-15.24,	15.01,	-25.60,	-41.23,	12.71,	-7.20,	25.87,	813.91,		2542.35,	103.65,	204.77,		588.67,	12.98,	510.55,
			62,			63231.3,	-138.22,	-14.61,	9.94,	-27.37,	-42.50,	16.21,	-7.17,	29.96,	843.67,		2608.04,	111.39,	157.48,		596.53,	17.47,	507.96,
			62.5,		62987.9,	-137.90,	-13.66,	11.83,	-26.01,	-40.87,	21.12,	-7.13,	29.42,	881.06,		2666.15,	119.21,	116.69,		613.18,	17.55,	500.65,
			63,			62717.5,	-139.73,	-12.87,	10.93,	-28.02,	-40.79,	23.23,	-7.15,	28.93,	921.33,		2746.28,	128.03,	70.65,		608.69,	17.32,	493.06,
			63.5,		62417.4,	-143.06,	-16.85,	11.85,	-28.78,	-41.95,	27.01,	-7.20,	28.47,	955.23,		2805.56,	136.81,	22.09,		624.40,	17.37,	490.06,
			64,			62082.5,	-144.52,	-11.53,	17.46,	-29.23,	-41.58,	31.08,	-7.28,	23.52,	989.93,		2878.05,	146.25,	-22.67,		631.94,	12.85,	482.34,
			64.5,		61721.6,	-150.31,	-14.78,	13.96,	-34.10,	-41.43,	30.70,	-7.31,	27.39,	1020.66,	2938.44,	155.89,	-77.72,		648.02,	17.26,	478.77,
			65,			61320.9,	-147.54,	-9.29,	20.19,	-30.24,	-36.28,	39.87,	-7.38,	22.48,	1056.39,	2990.72,	161.60,	-126.55,	667.43,	12.92,	466.17,
			65.5,		60893.0,	-148.54,	-7.45,	16.72,	-30.86,	-41.02,	43.63,	-7.41,	26.23,	1087.51,	3048.40,	171.89,	-179.98,	689.06,	17.29,	462.36,
			66,			60433.2,	-154.96,	-10.80,	17.24,	-35.90,	-41.40,	43.19,	-7.59,	25.62,	1115.57,	3107.10,	188.41,	-238.91,	714.02,	17.39,	453.59,
			66.5,		59936.0,	-155.88,	-8.71,	18.78,	-32.32,	-41.55,	47.52,	-7.70,	25.05,	1147.07,	3160.95,	199.75,	-294.75,	730.70,	17.18,	449.49,
			67,			59401.6,	-153.57,	-3.21,	20.20,	-33.41,	-37.93,	55.72,	-7.89,	20.26,	1186.63,	3220.46,	208.21,	-351.68,	751.73,	12.95,	436.30,
			67.5,		58837.6,	-159.12,	-5.66,	21.62,	-34.53,	-42.84,	59.51,	-8.06,	23.87,	1212.79,	3281.63,	221.84,	-413.85,	767.97,	17.02,	431.56,
			68,			58235.0,	-160.42,	-3.72,	23.13,	-35.78,	-43.70,	63.26,	-8.27,	23.28,	1246.79,	3342.44,	236.12,	-474.52,	785.49,	16.91,	426.80,
			68.5,		57593.7,	-157.55,	-1.53,	24.80,	-37.26,	-41.57,	66.78,	-8.53,	18.65,	1279.33,	3403.15,	247.21,	-534.46,	801.75,	12.70,	413.21,
			69,			56920.1,	-162.59,	2.00,	26.80,	-39.01,	-46.55,	70.12,	-8.83,	22.12,	1307.97,	3464.32,	267.35,	-599.39,	817.93,	16.58,	407.81,
			69.5,		56207.1,	-163.38,	0.09,	25.08,	-41.00,	-48.54,	73.30,	-9.14,	21.54,	1337.74,	3525.41,	285.85,	-659.00,	832.61,	16.36,	402.33,
			70,			55452.0,	-164.03,	7.45,	31.54,	-43.24,	-47.01,	76.34,	-9.48,	20.96,	1369.81,	3585.62,	298.87,	-721.51,	848.45,	16.14,	392.57,
			70.5,		54659.1,	-164.58,	11.20,	34.31,	-41.89,	-49.67,	83.18,	-9.98,	16.55,	1399.02,	3647.22,	318.49,	-788.56,	863.87,	15.88,	382.55,
			71,			53827.6,	-165.23,	15.18,	37.21,	-45.94,	-52.37,	82.59,	-10.40,	19.81,	1431.51,	3707.88,	339.25,	-856.04,	879.15,	15.58,	376.33,
			71.5,		52953.6,	-166.15,	19.12,	37.42,	-47.04,	-54.98,	89.82,	-10.92,	19.23,	1465.03,	3765.45,	360.22,	-920.13,	895.10,	15.31,	365.98,
			72,			52041.1,	-167.43,	16.16,	39.88,	-53.15,	-57.36,	90.61,	-11.53,	18.64,	1496.30,	3821.15,	387.29,	-988.19,	917.55,	15.08,	355.35,
			72.5,		51083.2,	-169.19,	26.42,	42.15,	-51.95,	-56.07,	97.87,	-12.20,	18.04,	1532.91,	3876.65,	408.51,	-1054.02,	934.10,	14.80,	348.59,
			73,			50086.7,	-167.23,	26.32,	40.89,	-53.70,	-57.60,	99.19,	-12.98,	17.42,	1568.68,	3935.89,	434.68,	-1122.25,	955.40,	14.53,	337.62,
			73.5,		49048.6,	-172.82,	25.01,	43.01,	-55.40,	-58.87,	99.85,	-13.78,	16.80,	1602.16,	3990.57,	461.98,	-1190.33,	975.75,	14.33,	330.34,
			74,			47969.1,	-176.29,	27.72,	48.97,	-58.62,	-65.11,	108.53,	-14.61,	16.18,	1632.25,	4048.30,	495.34,	-1255.42,	992.74,	13.95,	319.27,
			74.5,		46848.0,	-177.98,	30.23,	47.29,	-59.13,	-61.75,	113.41,	-15.60,	15.61,	1675.86,	4108.05,	526.58,	-1326.22,	1012.23,13.69,	311.46,
			75,			45686.0,	-181.24,	32.51,	49.31,	-60.78,	-69.00,	115.74,	-16.61,	14.97,	1706.45,	4173.27,	566.43,	-1390.41,	1020.71,13.26,	300.03,

			55,			81350.5,	-114.16,	-27.64,	5.31,	-27.49,	-51.34,	-57.94,	-7.85,	42.62,	650.11,		2445.66,	46.65,	781.90,		747.59,		16.76,	677.05,
			55.5,		81574.6,	-116.75,	-26.94,	6.04,	-22.30,	-51.21,	-53.80,	-7.81,	36.67,	652.76,		2511.27,	50.94,	751.31,		769.29,		16.98,	665.95,
			56,			81778.2,	-125.01,	-26.22,	1.19,	-28.44,	-56.73,	-55.13,	-7.69,	41.89,	651.88,		2581.31,	61.42,	718.50,		788.45,		22.73,	666.46,
			56.5,		81949.3,	-122.04,	-25.37,	1.98,	-23.37,	-51.03,	-45.06,	-7.64,	40.36,	659.40,		2649.16,	65.19,	683.73,		809.45,		22.88,	661.15,
			57,			82094.0,	-126.08,	-25.81,	3.13,	-25.23,	-52.16,	-41.70,	-7.53,	41.09,	671.80,		2716.62,	65.84,	641.48,		831.60,		23.07,	655.47,
			57.5,		82209.2,	-129.03,	-23.72,	9.81,	-25.72,	-50.83,	-35.44,	-7.52,	35.06,	685.30,		2784.90,	71.38,	602.79,		853.76,		17.60,	649.75,
			58,			82300.3,	-135.69,	-28.53,	5.05,	-30.15,	-55.97,	-36.43,	-7.44,	40.22,	699.77,		2852.84,	81.20,	556.32,		878.20,		23.50,	643.32,
			58.5,		82351.8,	-134.73,	-23.90,	11.26,	-27.39,	-52.05,	-26.07,	-7.43,	33.98,	718.62,		2915.75,	77.87,	519.71,		904.86,		18.09,	637.55,
			59,			82381.3,	-141.07,	-26.74,	6.70,	-31.52,	-55.57,	-26.55,	-7.36,	39.17,	735.06,		2980.09,	87.99,	469.09,		934.99,		24.01,	630.76,
			59.5,		82374.4,	-145.41,	-22.45,	7.19,	-28.16,	-51.61,	-16.89,	-7.35,	38.62,	757.38,		3047.51,	91.48,	422.72,		964.07,		24.26,	624.20,
			60,			82334.3,	-143.64,	-18.89,	10.95,	-27.32,	-53.34,	-13.39,	-7.32,	38.06,	775.49,		3113.30,	101.89,	372.94,		996.12,		24.55,	617.38,
			60.5,		82260.6,	-152.20,	-23.38,	10.62,	-34.14,	-55.37,	-8.13,	-7.30,	37.52,	801.58,		3188.33,	112.07,	315.44,		1022.55,	24.70,	616.08,
			61,			82143.9,	-148.68,	-24.53,	9.01,	-30.66,	-54.94,	-5.22,	-7.26,	36.85,	832.91,		3267.38,	115.57,	258.23,		1047.71,	24.79,	602.72,
			61.5,		81986.9,	-151.18,	-18.31,	11.66,	-29.67,	-48.88,	-0.32,	-7.19,	36.28,	869.96,		3343.90,	125.11,	206.24,		1073.35,	24.92,	595.28,
			62,			81794.5,	-155.09,	-17.52,	11.05,	-31.81,	-50.29,	4.47,	-7.19,	35.65,	915.08,		3433.27,	135.28,	152.21,		1087.10,	24.92,	587.48,
			62.5,		81562.7,	-154.96,	-16.31,	13.42,	-30.17,	-48.22,	11.04,	-7.16,	34.92,	958.14,		3511.27,	139.96,	88.77,		1112.05,	25.07,	579.44,
			63,			81294.1,	-157.45,	-20.84,	12.36,	-32.65,	-48.02,	14.19,	-7.22,	34.26,	1000.19,	3622.19,	157.43,	24.22,		1109.30,	24.77,	570.98,
			63.5,		80980.2,	-161.86,	-14.67,	19.05,	-33.60,	-49.37,	24.90,	-7.31,	28.15,	1057.56,	3701.27,	163.39,	-38.39,		1132.73,	24.86,	562.70,
			64,			80630.9,	-169.43,	-19.03,	15.05,	-34.21,	-48.88,	24.96,	-7.36,	32.94,	1094.33,	3799.56,	181.40,	-113.07,	1146.39,	24.79,	559.55,
			64.5,		80234.9,	-171.44,	-17.55,	16.26,	-34.84,	-48.62,	30.47,	-7.44,	32.20,	1137.37,	3882.00,	194.19,	-184.42,	1170.82,	24.83,	550.54,
			65,			79791.7,	-168.32,	-10.69,	18.65,	-35.53,	-47.57,	36.98,	-7.48,	31.47,	1186.94,	3954.18,	202.14,	-253.98,	1199.52,	24.90,	535.76,
			65.5,		79311.3,	-175.27,	-13.72,	14.46,	-36.36,	-48.05,	42.19,	-7.65,	30.68,	1225.41,	4035.11,	215.99,	-329.57,	1231.61,	25.00,	531.88,
			66,			78782.3,	-178.25,	-12.46,	15.21,	-37.37,	-48.50,	47.49,	-7.84,	29.89,	1276.73,	4111.06,	231.74,	-412.35,	1266.60,	25.12,	522.20,
			66.5,		78203.2,	-174.46,	-9.80,	22.55,	-38.29,	-48.69,	58.65,	-7.95,	29.15,	1326.83,	4186.57,	241.75,	-486.45,	1295.20,	25.12,	512.61,
			67,			77584.7,	-182.50,	-8.09,	19.19,	-39.75,	-49.44,	58.86,	-8.24,	28.39,	1365.81,	4268.24,	263.92,	-572.84,	1326.10,	30.36,	507.85,
			67.5,		76909.8,	-179.37,	-5.83,	26.29,	-36.04,	-45.19,	69.33,	-8.52,	22.45,	1420.11,	4352.33,	276.90,	-650.50,	1351.20,	25.04,	492.23,
			68,			76193.4,	-186.60,	-3.31,	28.29,	-42.89,	-51.51,	69.38,	-8.78,	26.87,	1463.19,	4436.50,	296.03,	-742.35,	1378.06,	24.95,	487.03,
			68.5,		75424.6,	-188.49,	-0.44,	30.52,	-44.87,	-54.01,	79.35,	-9.11,	26.13,	1504.76,	4520.49,	316.34,	-828.46,	1403.18,	24.81,	476.25,
			69,			74606.3,	-190.14,	-0.92,	28.13,	-47.19,	-55.27,	79.01,	-9.57,	25.38,	1551.84,	4605.64,	337.97,	-921.03,	1428.21,	29.66,	470.52,
			69.5,		73734.7,	-191.56,	1.84,	31.16,	-49.84,	-57.90,	88.46,	-9.97,	24.64,	1595.16,	4691.02,	362.80,	-1012.15,	1451.47,	24.43,	459.31,
			70,			72811.1,	-192.78,	6.34,	34.54,	-52.82,	-61.02,	92.70,	-10.52,	23.92,	1641.77,	4774.64,	385.57,	-1107.01,	1476.11,	29.07,	447.73,
			70.5,		71830.7,	-193.93,	11.30,	38.27,	-51.32,	-59.68,	96.97,	-11.09,	23.20,	1689.75,	4862.11,	407.24,	-1198.15,	1501.17,	23.96,	436.18,
			71,			70797.9,	-195.18,	16.57,	42.18,	-56.51,	-63.27,	101.41,	-11.75,	22.48,	1731.86,	4946.62,	435.09,	-1295.09,	1525.33,	28.39,	429.37,
			71.5,		69707.2,	-196.81,	21.81,	42.63,	-58.19,	-66.77,	106.31,	-12.47,	21.75,	1780.36,	5027.36,	468.24,	-1392.78,	1550.50,	23.37,	417.36,
			72,			68563.8,	-203.51,	22.86,	46.00,	-66.11,	-70.00,	107.72,	-13.29,	21.02,	1830.98,	5105.68,	499.80,	-1491.15,	1583.26,	27.68,	409.90,
			72.5,		67358.5,	-206.18,	31.61,	49.14,	-64.68,	-68.47,	117.55,	-14.22,	20.28,	1879.11,	5182.36,	533.14,	-1586.96,	1607.50,	27.18,	397.42,
			73,			66095.4,	-204.02,	36.21,	52.26,	-62.68,	-70.60,	124.21,	-15.22,	19.52,	1935.66,	5263.83,	563.86,	-1686.36,	1639.03,	22.36,	384.89,
			73.5,		64779.6,	-207.24,	34.57,	55.14,	-69.45,	-72.44,	125.34,	-16.34,	18.76,	1989.42,	5337.79,	600.46,	-1790.15,	1667.68,	26.29,	376.63,
			74,			63402.4,	-212.48,	38.18,	62.90,	-73.96,	-76.58,	136.85,	-17.52,	13.79,	2038.50,	5420.30,	641.59,	-1885.73,	1695.76,	21.74,	359.35,
			74.5,		61967.6,	-210.92,	45.66,	65.10,	-70.51,	-72.45,	143.54,	-18.82,	13.20,	2100.95,	5503.80,	684.11,	-1984.88,	1722.71,	21.22,	350.78,
			75,			60480.0,	-219.86,	44.60,	63.74,	-76.96,	-86.29,	147.01,	-20.19,	16.55,	2142.29,	5593.89,	737.93,	-2087.66,	1738.36,	24.80,	341.63,

			55,			92309.0,	-114.65,	-31.69,	-2.79,	-28.19,	-61.63,	-81.31,	-7.95,	46.88,	628.43,		2800.67,	48.51,	978.07,		987.71,	27.13,	737.44,
			55.5,		92647.9,	-117.77,	-30.89,	-1.89,	-22.46,	-61.41,	-76.19,	-7.82,	46.45,	617.57,		2877.31,	53.43,	946.03,		1015.40,	27.43,	726.27,
			56,			92955.3,	-120.93,	-30.03,	5.30,	-22.97,	-54.97,	-70.89,	-7.78,	39.71,	622.61,		2956.73,	58.79,	904.96,		1041.46,	21.41,	721.73,
			56.5,		93236.7,	-124.15,	-35.33,	0.01,	-29.84,	-61.02,	-71.66,	-7.64,	50.77,	624.60,		3036.24,	69.70,	855.46,		1069.45,	27.93,	716.34,
			57,			93479.6,	-128.62,	-35.50,	1.25,	-25.39,	-61.94,	-60.92,	-7.60,	44.95,	633.25,		3115.37,	70.29,	810.06,		1097.46,	28.18,	711.08,
			57.5,		93687.6,	-132.19,	-33.40,	2.42,	-26.03,	-60.66,	-60.03,	-7.49,	44.47,	656.15,		3196.52,	76.70,	768.34,		1124.78,	28.40,	705.79,
			58,			93860.2,	-133.91,	-26.09,	3.49,	-24.99,	-53.82,	-48.01,	-7.39,	43.88,	673.97,		3278.24,	75.61,	717.74,		1153.86,	28.65,	693.35,
			58.5,		93998.5,	-132.86,	-26.92,	4.27,	-27.91,	-55.42,	-42.17,	-7.38,	43.18,	697.22,		3352.29,	84.37,	665.33,		1186.94,	28.95,	687.31,
			59,			94103.8,	-140.50,	-30.27,	5.54,	-32.83,	-59.55,	-42.20,	-7.37,	42.62,	717.56,		3429.18,	89.86,	603.47,		1224.02,	29.32,	687.64,
			59.5,		94166.1,	-139.19,	-25.20,	12.52,	-28.94,	-54.90,	-30.74,	-7.35,	41.97,	744.56,		3509.23,	93.81,	546.05,		1259.52,	29.62,	674.35,
			60,			94195.6,	-150.54,	-27.22,	10.75,	-34.48,	-57.13,	-25.70,	-7.36,	41.30,	766.60,		3587.69,	105.50,	484.63,		1298.59,	29.96,	674.05,
			60.5,		94180.0,	-154.50,	-25.95,	10.52,	-29.95,	-59.59,	-19.35,	-7.28,	40.63,	789.97,		3675.75,	117.09,	412.05,		1330.62,	30.11,	659.98,
			61,			94119.8,	-157.10,	-20.80,	8.88,	-32.24,	-59.04,	-15.56,	-7.27,	39.85,	826.20,		3766.03,	121.14,	342.70,		1364.62,	30.37,	652.42,
			61.5,		94011.5,	-160.37,	-20.08,	11.84,	-31.26,	-52.20,	-9.55,	-7.21,	39.18,	862.97,		3859.95,	132.78,	270.40,		1397.08,	30.51,	644.58,
			62,			93857.5,	-165.32,	-25.43,	11.32,	-33.71,	-53.75,	-3.43,	-7.24,	38.45,	912.50,		3964.32,	145.03,	190.51,		1413.14,	30.28,	636.23,
			62.5,		93653.9,	-165.76,	-24.02,	14.06,	-32.01,	-57.70,	4.53,	-7.23,	37.62,	961.26,		4057.26,	157.39,	113.24,		1444.83,	30.41,	627.55,
			63,			93398.0,	-169.07,	-16.58,	12.99,	-34.87,	-51.28,	8.69,	-7.24,	36.86,	1021.37,	4183.83,	171.35,	35.05,		1444.15,	29.99,	618.88,
			63.5,		93092.6,	-168.27,	-15.80,	14.41,	-29.86,	-52.85,	21.26,	-7.29,	36.15,	1086.36,	4279.17,	179.02,	-51.76,		1473.84,	30.06,	609.76,
			64,			92743.1,	-177.29,	-20.66,	10.04,	-36.85,	-58.53,	21.80,	-7.45,	35.36,	1134.78,	4395.07,	200.18,	-137.11,	1490.58,	36.03,	606.38,
			64.5,		92330.9,	-173.72,	-12.79,	17.65,	-37.65,	-52.13,	34.46,	-7.49,	34.53,	1196.08,	4492.32,	209.05,	-222.92,	1520.57,	29.88,	590.19,
			65,			91876.1,	-182.64,	-17.25,	14.31,	-38.50,	-51.03,	35.82,	-7.66,	33.71,	1249.93,	4577.58,	224.60,	-313.36,	1555.81,	30.00,	586.37,
			65.5,		91365.1,	-184.59,	-14.51,	21.82,	-39.48,	-51.61,	41.94,	-7.80,	32.82,	1302.47,	4672.51,	240.70,	-404.55,	1595.12,	30.15,	575.97,
			66,			90803.5,	-188.21,	-13.04,	16.65,	-40.69,	-52.20,	48.13,	-8.05,	31.93,	1357.76,	4761.87,	258.98,	-498.09,	1638.17,	36.37,	565.10,
			66.5,		90183.4,	-190.15,	-9.97,	25.02,	-41.80,	-52.47,	55.02,	-8.22,	31.10,	1417.92,	4850.10,	276.71,	-593.91,	1673.53,	30.38,	554.32,
			67,			89510.7,	-193.52,	-8.00,	27.21,	-43.51,	-53.37,	61.46,	-8.51,	30.24,	1471.46,	4946.98,	296.45,	-691.87,	1711.50,	30.43,	543.08,
			67.5,		88778.2,	-196.13,	-5.39,	29.38,	-39.39,	-48.64,	73.54,	-8.81,	29.39,	1530.40,	5045.42,	311.65,	-791.96,	1743.81,	30.42,	525.54,
			68,			87996.5,	-204.51,	-8.29,	25.90,	-47.22,	-55.86,	73.82,	-9.22,	28.54,	1582.83,	5145.07,	333.97,	-902.50,	1777.52,	36.20,	526.06,
			68.5,		87147.8,	-201.15,	0.82,	34.31,	-43.82,	-53.05,	85.37,	-9.59,	27.71,	1639.31,	5244.98,	357.74,	-1006.55,	1809.05,	30.28,	508.18,
			69,			86240.9,	-203.31,	6.05,	37.37,	-46.59,	-54.61,	90.92,	-10.11,	26.88,	1696.15,	5345.97,	377.32,	-1112.62,	1839.30,	30.05,	496.17,
			69.5,		85277.2,	-205.25,	9.16,	35.20,	-49.76,	-57.78,	96.20,	-10.61,	26.06,	1748.91,	5447.19,	406.36,	-1222.86,	1868.70,	29.85,	489.76,
			70,			84246.5,	-206.96,	14.25,	44.67,	-53.32,	-61.50,	101.27,	-11.24,	25.26,	1805.41,	5546.55,	433.10,	-1337.55,	1898.83,	29.55,	477.28,
			70.5,		83154.7,	-214.05,	14.44,	43.47,	-57.26,	-65.63,	106.38,	-11.96,	24.45,	1863.70,	5649.65,	464.05,	-1453.73,	1929.83,	29.30,	464.38,
			71,			81995.5,	-210.35,	20.50,	48.01,	-57.85,	-69.83,	117.04,	-12.71,	23.65,	1920.83,	5750.72,	491.33,	-1571.11,	1960.62,	29.00,	457.27,
			71.5,		80773.6,	-217.84,	26.57,	48.58,	-65.31,	-73.95,	117.51,	-13.62,	22.85,	1974.33,	5846.69,	530.11,	-1689.67,	1991.62,	33.96,	443.87,
			72,			79484.0,	-220.53,	27.78,	52.51,	-69.24,	-77.76,	119.33,	-14.56,	22.05,	2035.74,	5938.40,	566.90,	-1809.08,	2032.25,	33.61,	436.04,
			72.5,		78121.4,	-223.96,	37.89,	56.18,	-67.75,	-76.08,	135.94,	-15.67,	21.23,	2099.73,	6031.71,	606.28,	-1925.64,	2063.91,	33.18,	422.52,
			73,			76690.6,	-221.82,	43.22,	64.84,	-70.70,	-73.68,	143.72,	-16.90,	15.41,	2168.04,	6132.58,	643.11,	-2046.41,	2104.10,	27.88,	408.94,
			73.5,		75197.4,	-225.91,	41.35,	63.22,	-73.63,	-80.87,	145.12,	-18.12,	19.56,	2233.16,	6224.70,	686.68,	-2172.35,	2138.49,	32.24,	400.18,
			74,			73636.4,	-237.20,	45.56,	67.35,	-83.91,	-90.64,	153.60,	-19.51,	18.73,	2288.01,	6321.37,	739.59,	-2294.08,	2170.11,	31.55,	386.00,
			74.5,		72002.3,	-235.68,	49.45,	70.08,	-80.01,	-85.87,	161.54,	-21.08,	17.98,	2363.48,	6419.20,	789.21,	-2420.02,	2203.22,	30.82,	376.77,
			75,			70300.7,	-246.22,	53.02,	73.35,	-82.91,	-97.25,	170.41,	-22.69,	17.13,	2419.40,	6525.60,	852.19,	-2540.96,	2220.82,	29.92,	362.34,

			55,			106747.3,	-107.27,	-37.37,	-6.42,	-21.64,	-67.07,	-118.73,	-8.00,	52.28,	579.45,		3263.69,	43.10,	1279.07,	1311.49,	33.60,	803.80,
			55.5,		107255.0,	-111.11,	-36.45,	-5.29,	-22.19,	-66.69,	-112.35,	-7.87,	51.72,	565.69,		3354.51,	48.77,	1230.42,	1348.71,	34.06,	800.09,
			56,			107724.1,	-115.01,	-35.38,	-4.16,	-22.72,	-66.35,	-105.76,	-7.75,	51.12,	563.88,		3448.40,	54.89,	1178.32,	1384.14,	34.44,	788.24,
			56.5,		108153.5,	-118.97,	-34.25,	-2.99,	-23.40,	-58.99,	-98.98,		-7.70,	49.81,	565.83,		3543.75,	60.73,	1130.71,	1420.25,	34.80,	783.86,
			57,			108543.1,	-123.95,	-33.95,	-1.59,	-25.10,	-59.59,	-85.87,		-7.59,	49.85,	584.37,		3639.63,	68.36,	1073.30,	1455.94,	35.11,	778.80,
			57.5,		108890.4,	-121.15,	-31.79,	-0.19,	-25.99,	-58.45,	-84.79,		-7.47,	49.21,	604.93,		3737.71,	75.86,	1012.44,	1490.88,	35.39,	765.80,
			58,			109201.6,	-130.89,	-37.67,	-5.99,	-32.42,	-65.02,	-77.68,		-7.46,	48.49,	620.33,		3836.34,	82.33,	948.61,		1528.11,	35.71,	767.50,
			58.5,		109463.5,	-136.84,	-38.14,	2.28,	-28.26,	-66.56,	-70.49,		-7.45,	47.67,	649.43,		3926.20,	92.19,	882.38,		1570.23,	36.11,	761.35,
			59,			109678.1,	-138.96,	-27.75,	3.83,	-27.11,	-57.27,	-62.88,		-7.37,	46.95,	682.14,		4022.65,	92.04,	819.45,		1615.33,	36.50,	747.37,
			59.5,		109854.9,	-144.75,	-28.72,	4.81,	-29.77,	-58.97,	-56.37,		-7.40,	46.16,	701.02,		4118.47,	103.64,	739.83,		1658.35,	36.80,	740.05,
			60,			109984.9,	-151.27,	-30.57,	3.24,	-36.39,	-61.98,	-49.30,		-7.41,	45.35,	728.19,		4212.95,	109.73,	662.39,		1707.71,	37.26,	732.54,
			60.5,		110068.9,	-156.53,	-29.03,	3.19,	-38.93,	-65.11,	-41.64,		-7.37,	44.53,	755.66,		4319.52,	123.23,	578.92,		1750.58,	44.76,	724.62,
			61,			110091.4,	-159.74,	-22.94,	8.77,	-34.28,	-57.26,	-29.54,		-7.32,	43.59,	798.20,		4430.88,	128.51,	491.53,		1792.94,	37.84,	708.99,
			61.5,		110062.8,	-163.67,	-22.03,	12.11,	-33.28,	-56.57,	-22.22,		-7.28,	42.77,	842.02,		4540.73,	142.01,	400.55,		1834.58,	38.04,	700.26,
			62,			109978.5,	-169.52,	-28.10,	11.65,	-36.05,	-58.23,	-14.78,		-7.37,	41.89,	886.44,		4666.34,	156.53,	307.85,		1859.62,	37.92,	698.76,
			62.5,		109834.0,	-177.58,	-26.44,	7.62,	-41.39,	-62.83,	-12.42,		-7.30,	48.07,	945.24,		4779.31,	171.28,	203.39,		1900.05,	45.26,	689.03,
			63,			109626.0,	-174.49,	-25.02,	13.71,	-37.50,	-62.55,	0.02,		-7.44,	39.99,	1010.58,	4931.75,	187.93,	104.93,		1902.65,	37.58,	671.49,
			63.5,		109357.9,	-180.96,	-24.03,	15.40,	-38.90,	-57.17,	7.81,		-7.52,	39.16,	1082.22,	5047.47,	204.45,	-5.11,		1941.16,	37.69,	661.27,
			64,			109028.6,	-184.55,	-22.45,	17.52,	-39.87,	-56.61,	15.99,		-7.66,	38.21,	1150.20,	5187.14,	222.27,	-109.32,	1964.31,	44.54,	658.25,
			64.5,		108630.7,	-188.07,	-20.43,	19.27,	-33.84,	-56.35,	24.12,		-7.77,	37.24,	1226.37,	5306.30,	233.50,	-223.13,	2003.24,	37.47,	639.92,
			65,			108177.9,	-191.93,	-18.42,	15.55,	-42.00,	-62.12,	33.46,		-7.91,	43.28,	1289.51,	5410.35,	252.46,	-341.61,	2048.47,	44.60,	635.76,
			65.5,		107654.9,	-201.79,	-22.19,	17.33,	-43.26,	-62.80,	41.18,		-8.12,	42.21,	1359.28,	5526.14,	272.09,	-460.53,	2096.94,	44.63,	624.02,
			66,			107061.5,	-199.61,	-13.46,	25.41,	-44.77,	-56.57,	48.96,		-8.44,	34.22,	1438.41,	5635.23,	287.32,	-581.60,	2150.45,	37.84,	612.32,
			66.5,		106402.6,	-202.43,	-9.85,	28.23,	-39.33,	-56.96,	57.50,		-8.72,	33.26,	1508.91,	5743.96,	309.01,	-696.70,	2195.27,	37.84,	600.12,
			67,			105678.3,	-213.73,	-7.51,	24.08,	-48.28,	-58.09,	65.49,		-9.07,	32.28,	1585.54,	5861.50,	332.91,	-826.42,	2243.02,	44.66,	587.39,
			67.5,		104881.4,	-210.32,	-4.44,	26.73,	-43.65,	-59.47,	73.01,		-9.48,	31.31,	1653.38,	5982.34,	358.23,	-951.33,	2282.70,	44.52,	574.71,
			68,			104018.1,	-220.41,	-7.72,	29.59,	-52.75,	-61.13,	80.48,		-9.95,	30.35,	1725.91,	6103.34,	384.93,	-1088.69,	2324.90,	44.38,	561.55,
			68.5,		103080.9,	-223.61,	-3.78,	32.76,	-48.97,	-58.05,	94.14,		-10.40,	29.41,	1796.60,	6223.83,	406.63,	-1218.84,	2365.15,	44.19,	548.41,
			69,			102073.0,	-226.50,	2.44,	36.48,	-52.31,	-66.47,	100.91,		-11.08,	28.47,	1867.82,	6345.40,	436.78,	-1357.91,	2405.12,	43.93,	541.85,
			69.5,		100989.9,	-229.11,	6.18,	40.66,	-56.10,	-63.75,	107.38,		-11.65,	27.55,	1934.13,	6471.45,	471.83,	-1489.04,	2443.72,	43.70,	528.17,
			70,			99832.3,	-231.46,	12.27,	45.35,	-60.37,	-68.22,	113.60,		-12.45,	26.63,	2005.06,	6594.32,	504.12,	-1638.49,	2482.76,	43.30,	514.06,
			70.5,		98594.2,	-233.73,	19.01,	50.51,	-65.08,	-73.17,	119.87,		-13.30,	25.74,	2078.03,	6718.96,	534.76,	-1777.31,	2519.69,	42.69,	506.69,
			71,			97274.6,	-236.16,	26.15,	55.91,	-65.87,	-72.06,	132.55,		-14.23,	24.84,	2156.07,	6842.01,	573.97,	-1924.07,	2561.32,	36.26,	485.87,
			71.5,		95878.8,	-239.11,	33.31,	56.65,	-74.74,	-77.13,	139.57,		-15.34,	23.94,	2223.67,	6959.89,	614.36,	-2072.49,	2600.96,	41.95,	477.81,
			72,			94400.9,	-242.75,	34.78,	61.36,	-73.52,	-81.85,	141.88,		-16.45,	23.04,	2300.49,	7074.49,	658.92,	-2227.96,	2653.07,	41.63,	463.09,
			72.5,		92840.7,	-253.12,	40.87,	65.77,	-77.85,	-85.97,	149.77,		-17.80,	22.12,	2380.66,	7188.02,	706.18,	-2380.31,	2692.68,	41.03,	454.21,
			73,			91191.3,	-245.24,	53.07,	70.18,	-81.44,	-83.43,	165.06,		-19.25,	21.19,	2465.86,	7309.31,	750.47,	-2531.93,	2741.95,	40.54,	439.29,
			73.5,		89465.6,	-256.17,	45.28,	74.25,	-85.02,	-91.92,	166.99,		-20.81,	20.26,	2547.52,	7422.86,	803.01,	-2689.62,	2787.72,	39.97,	429.87,
			74,			87651.8,	-264.42,	55.91,	79.22,	-91.81,	-98.13,	182.76,		-22.40,	19.34,	2622.62,	7542.24,	861.24,	-2836.81,	2829.60,	39.30,	414.61,
			74.5,		85754.5,	-268.48,	60.55,	82.55,	-92.79,	-92.80,	186.92,		-24.28,	18.51,	2716.64,	7662.70,	926.59,	-2999.90,	2873.60,	38.61,	398.90,
			75,			83774.8,	-275.95,	59.58,	81.27,	-96.35,	-111.78,197.66,		-26.27,	17.57,	2787.43,	7793.97,	1002.39,-3151.91,	2898.35,	42.86,	388.66,

			55,			122687.3,	-96.51,		-43.69,	-10.70,	-20.98,		-72.84,		-155.41,	-8.07,	58.06,	511.34,		3768.21,	42.83,		1642.49,	1678.44,	41.06,	879.02,
			55.5,		123404.8,	-108.89,	-50.43,	-17.16,	-29.56,		-72.42,		-155.64,	-7.91,	65.24,	486.04,		3879.55,	49.64,		1582.23,	1722.96,	41.54,	875.10,
			56,			124067.7,	-105.56,	-49.07,	-7.85,	-22.28,		-72.01,		-139.84,	-7.84,	56.65,	483.32,		3992.81,	56.83,		1525.65,	1766.25,	41.96,	862.83,
			56.5,		124690.6,	-118.19,	-47.69,	-14.35,	-31.06,		-71.65,		-139.61,	-7.80,	63.50,	477.04,		4106.42,	64.07,		1457.89,	1811.79,	50.40,	858.04,
			57,			125257.1,	-115.61,	-46.84,	-12.82,	-24.64,		-63.96,		-123.90,	-7.74,	55.05,	499.36,		4219.40,	64.37,		1394.92,	1858.27,	42.88,	853.25,
			57.5,		125781.0,	-120.78,	-44.66,	-11.17,	-25.84,		-71.07,		-122.66,	-7.66,	54.26,	516.32,		4340.66,	73.34,		1319.61,	1901.79,	51.26,	838.68,
			58,			126253.1,	-132.55,	-43.08,	-9.51,	-33.60,		-70.49,		-113.97,	-7.53,	61.47,	544.06,		4455.21,	89.12,		1248.79,	1948.78,	51.70,	832.62,
			58.5,		126665.7,	-123.01,	-35.01,	0.06,	-20.39,		-63.77,		-97.11,		-7.54,	52.41,	579.69,		4564.14,	83.97,		1175.00,	2000.79,	44.09,	817.61,
			59,			127038.5,	-142.37,	-39.72,	-6.21,	-27.67,		-69.82,		-96.04,		-7.52,	51.54,	611.20,		4675.12,	100.33,		1088.44,	2058.32,	52.80,	818.98,
			59.5,		127348.9,	-140.95,	-32.26,	3.23,	-30.52,		-63.35,		-79.75,		-7.56,	50.59,	643.51,		4790.86,	105.38,		998.83,		2114.37,	45.17,	802.71,
			60,			127611.9,	-149.27,	-33.91,	1.92,	-30.15,		-67.21,		-70.23,		-7.59,	49.61,	676.48,		4904.80,	112.30,		903.22,		2175.45,	45.75,	794.51,
			60.5,		127821.1,	-156.13,	-32.15,	10.22,	-33.59,		-71.04,		-52.88,		-7.53,	48.62,	700.14,		5033.93,	119.85,		799.96,		2228.41,	46.09,	786.17,
			61,			127964.9,	-160.09,	-25.04,	8.64,	-36.36,		-70.21,		-46.59,		-7.56,	47.51,	741.59,		5168.73,	134.63,		700.29,		2280.36,	46.39,	768.36,
			61.5,		128047.1,	-173.03,	-32.13,	4.19,	-35.36,		-69.37,		-45.90,		-7.48,	54.68,	776.89,		5300.82,	150.52,		579.72,		2332.71,	54.82,	767.31,
			62,			128054.1,	-171.76,	-30.82,	11.97,	-38.45,		-71.07,		-28.79,		-7.63,	45.49,	838.14,		5450.95,	167.61,		464.99,		2365.81,	54.68,	748.53,
			62.5,		127988.9,	-173.25,	-28.93,	15.53,	-36.53,		-68.19,		-17.51,		-7.67,	44.33,	899.94,		5587.65,	185.10,		344.77,		2416.68,	46.74,	738.26,
			63,			127855.7,	-186.35,	-27.28,	14.45,	-40.21,		-67.85,		-10.89,		-7.82,	43.26,	978.41,		5770.56,	204.84,		222.81,		2422.87,	54.19,	727.22,
			63.5,		127642.1,	-185.93,	-18.02,	16.43,	-33.78,		-61.65,		-1.49,		-7.83,	42.27,	1064.74,	5910.48,	216.33,		95.44,		2470.92,	46.19,	716.33,
			64,			127363.1,	-190.44,	-24.27,	10.84,	-43.03,		-61.02,		8.34,		-8.03,	41.16,	1139.95,	6078.55,	237.52,		-41.80,		2502.41,	54.00,	704.22,
			64.5,		127002.0,	-194.89,	-21.93,	20.96,	-44.27,		-60.74,		18.11,		-8.25,	40.03,	1224.83,	6220.82,	259.07,		-174.31,	2552.01,	54.02,	692.21,
			65,			126566.0,	-207.71,	-19.61,	16.83,	-45.60,		-67.30,		29.30,		-8.49,	38.91,	1311.25,	6346.46,	281.47,		-320.48,	2608.72,	54.13,	679.61,
			65.5,		126046.1,	-203.49,	-15.90,	26.86,	-39.21,		-60.17,		38.65,		-8.69,	37.71,	1405.35,	6486.29,	296.84,		-467.47,	2670.63,	54.29,	667.07,
			66,			125449.7,	-209.42,	-13.85,	28.23,	-41.08,		-61.03,		48.07,		-9.10,	36.52,	1494.29,	6618.47,	323.11,		-617.49,	2737.29,	54.49,	653.93,
			66.5,		124774.2,	-220.94,	-17.47,	23.75,	-50.64,		-61.52,		58.36,		-9.40,	35.41,	1581.57,	6750.15,	348.84,		-770.62,	2794.20,	54.48,	640.25,
			67,			124012.0,	-226.50,	-14.66,	26.95,	-45.41,		-62.84,		68.05,		-9.89,	34.27,	1667.98,	6889.90,	376.95,		-926.55,	2855.90,	54.59,	626.59,
			67.5,		123169.1,	-231.04,	-10.97,	30.15,	-55.71,		-64.52,		77.40,		-10.33,	40.82,	1761.45,	7037.01,	407.47,		-1092.95,	2906.63,	54.39,	620.62,
			68,			122236.5,	-235.55,	-6.90,	33.57,	-51.00,		-66.52,		86.65,		-10.92,	32.05,	1853.67,	7185.58,	432.09,		-1258.04,	2961.02,	54.29,	606.34,
			68.5,		121213.8,	-232.37,	5.24,	37.36,	-54.46,		-63.16,		102.92,		-11.45,	30.97,	1943.42,	7334.10,	458.84,		-1421.30,	3011.04,	53.97,	584.00,
			69,			120112.2,	-243.84,	4.99,	34.37,	-65.88,		-72.92,		103.85,		-12.24,	37.33,	2033.71,	7483.93,	502.71,		-1594.18,	3058.93,	53.44,	584.68,
			69.5,		118911.8,	-247.40,	9.38,	46.75,	-62.98,		-70.01,		119.19,		-12.97,	28.87,	2117.47,	7633.56,	536.65,		-1764.78,	3107.16,	53.10,	561.89,
			70,			117621.7,	-250.68,	16.49,	52.29,	-68.07,		-75.32,		126.81,		-13.94,	27.85,	2205.93,	7781.07,	575.09,		-1942.46,	3157.34,	52.69,	554.32,
			70.5,		116234.5,	-253.85,	24.39,	58.40,	-66.57,		-74.10,		134.50,		-14.92,	26.83,	2304.16,	7934.66,	612.36,		-2115.55,	3207.66,	52.25,	538.90,
			71,			114756.0,	-264.24,	25.76,	57.78,	-74.73,		-87.23,		142.47,		-16.13,	25.83,	2393.84,	8085.26,	659.33,		-2304.95,	3258.39,	51.78,	522.96,
			71.5,		113178.1,	-268.14,	34.28,	58.87,	-85.22,		-93.18,		151.15,		-17.34,	24.82,	2485.96,	8227.74,	714.62,		-2489.42,	3309.70,	51.30,	514.38,
			72,			111500.9,	-272.82,	36.17,	64.60,	-84.11,		-91.96,		161.11,		-18.69,	23.82,	2581.54,	8368.56,	761.13,		-2682.21,	3374.01,	50.87,	498.21,
			72.5,		109717.2,	-271.89,	50.33,	76.66,	-82.47,		-90.10,		177.54,		-20.25,	22.79,	2680.88,	8507.41,	811.05,		-2864.84,	3425.18,	50.25,	482.03,
			73,			107839.3,	-276.60,	57.97,	75.40,	-93.47,		-100.65,	182.41,		-22.08,	21.76,	2786.70,	8654.56,	877.47,		-3066.73,	3487.14,	56.22,	472.25,
			73.5,		105855.4,	-283.27,	55.62,	80.41,	-91.42,		-97.69,		191.54,		-23.90,	20.72,	2887.95,	8793.85,	933.93,		-3256.41,	3545.57,	49.09,	455.67,
			74,			103771.4,	-300.00,	61.70,	92.76,	-106.12,	-111.76,	203.94,		-25.83,	19.70,	2981.73,	8939.89,	1003.89,	-3446.74,	3598.61,	48.30,	438.95,
			74.5,		101579.6,	-298.92,	73.47,	96.78,	-101.13,	-105.65,	221.71,		-28.00,	18.79,	3104.35,	9087.28,	1075.82,	-3643.37,	3654.27,	47.49,	422.14,
			75,			99287.7,	-308.34,	72.58,	101.55,	-105.63,	-122.06,	234.52,		-30.42,	17.75,	3193.18,	9249.10,	1166.94,	-3839.00,	3687.87,	46.40,	411.49,

		--	tg deg		dist nw		****************************h=0***************************************	--------h=2000----------------	******h=8000******************	-Hdiff-
		--							fwd wind:												side:	sidef:	fwd:		side:		sidef:	fwd:		side:		sidef:	diff =500m
		--				no wind		15m/s		10m/s		5m/s	-5m/s	-10m/s	-15m/s	10m/s	10m/s	10m/s 		10m/s		10m/s	10m/s		10m/s		10m/s	no wind 

			48,			121620.8,	3.98,		-77.05,		-45.64,	8.12,	-70.61,	-315.47,	-10.57,	70.79,	885.84,	2683.74,	3.69,	2415.97,	1386.03,	31.59,	1004.41,
			48.5,		122990.4,	-0.33,		-76.62,		-44.71,	0.65,	-70.49,	-310.35,	-10.41,	70.66,	834.11,	2773.99,	4.99,	2418.51,	1431.40,	32.33,	1008.65,
			49,			124346.1,	-5.12,		-76.30,		-43.89,	-7.71,	-70.26,	-304.82,	-10.22,	70.50,	771.88,	2873.01,	7.11,	2408.34,	1476.65,	40.70,	1003.65,
			49.5,		125662.9,	4.03,		-61.91,		-29.09,	5.74,	-55.99,	-284.91,	-10.03,	70.23,	751.43,	2974.72,	-4.40,	2409.41,	1521.66,	33.70,	999.00,
			50,			126974.0,	-1.09,		-69.44,		-42.00,	4.87,	-63.76,	-300.19,	-9.87,	69.94,	710.65,	3079.07,	12.29,	2397.94,	1567.78,	42.19,	1002.03,
			50.5,		128255.2,	-6.38,		-74.40,		-41.00,	3.96,	-69.32,	-293.48,	-9.69,	69.55,	681.75,	3183.78,	7.45,	2381.87,	1615.55,	42.95,	996.26,
			51,			129511.9,	-24.48,		-81.30,		-39.68,	3.14,	-76.85,	-286.10,	-9.53,	69.02,	658.76,	3290.08,	18.41,	2361.42,	1663.94,	43.70,	998.39,
			51.5,		130722.2,	-17.35,		-67.77,		-38.31,	1.94,	-64.08,	-278.54,	-9.34,	68.61,	648.83,	3400.32,	14.02,	2345.04,	1712.24,	44.41,	982.61,
			52,			131917.5,	-31.44,		-79.13,		-36.80,	0.61,	-68.49,	-270.22,	-9.18,	68.06,	616.38,	3525.41,	18.57,	2315.74,	1758.78,	45.08,	983.68,
			52.5,		133075.3,	-41.47,		-69.04,		-34.74,	-4.48,	-68.49,	-252.53,	-8.98,	67.36,	597.76,	3644.32,	22.73,	2281.75,	1798.67,	45.57,	975.53,
			53,			134200.8,	-45.71,		-62.50,		-31.28,	-3.34,	-66.26,	-228.70,	-8.88,	66.67,	583.41,	3783.39,	27.31,	2242.03,	1822.92,	45.68,	975.33,
			53.5,		135310.9,	-63.31,		-51.67,		-17.23,	-14.98,	-68.42,	-218.77,	-8.75,	66.02,	542.75,	3902.86,	23.23,	2197.87,	1849.30,	45.82,	965.66,
			54,			136385.5,	-69.55,		-50.43,		-15.95,	-16.55,	-68.90,	-210.34,	-8.65,	65.29,	495.21,	4014.37,	17.71,	2148.71,	1937.38,	47.34,	955.19,
			54.5,		137421.9,	-76.97,		-59.72,		-16.59,	-19.53,	-79.19,	-203.79,	-8.35,	64.43,	451.89,	4139.94,	26.37,	2094.32,	1990.69,	47.96,	953.65,
			55,			138405.1,	-82.11,		-58.34,		-15.03,	-20.23,	-78.58,	-203.52,	-8.30,	63.66,	426.58,	4267.46,	33.27,	2035.82,	2043.02,	48.51,	941.56,
			55.5,		139335.5,	-87.31,		-57.06,		-13.30,	-21.02,	-78.01,	-185.85,	-8.04,	62.78,	405.25,	4395.95,	40.95,	1981.55,	2097.12,	49.09,	929.01,
			56,			140220.0,	-101.44,	-55.43,		-20.42,	-21.67,	-77.49,	-185.23,	-7.93,	61.97,	383.94,	4527.60,	49.04,	1904.56,	2150.12,	49.60,	924.70,
			56.5,		141048.3,	-106.89,	-62.70,		-18.70,	-22.55,	-77.00,	-175.63,	-7.98,	69.93,	376.42,	4659.98,	66.55,	1832.72,	2205.70,	58.99,	919.96,
			57,			141810.6,	-103.93,	-52.41,		-17.03,	-15.03,	-68.02,	-157.22,	-7.90,	60.07,	402.45,	4791.23,	66.68,	1756.92,	2261.98,	50.73,	905.40,
			57.5,		142523.0,	-110.00,	-50.29,		-15.14,	-16.48,	-76.22,	-155.74,	-7.75,	59.11,	423.01,	4926.67,	67.57,	1676.07,	2316.98,	51.21,	899.68,
			58,			143174.8,	-114.83,	-48.43,		-4.22,	-25.54,	-66.70,	-145.42,	-7.67,	58.08,	456.00,	5066.64,	77.12,	1590.96,	2373.35,	51.69,	883.75,
			58.5,		143766.2,	-122.22,	-39.00,		-2.36,	-19.45,	-67.80,	-135.02,	-7.71,	56.98,	498.35,	5191.52,	80.03,	1493.23,	2436.40,	52.28,	876.70,
			59,			144301.6,	-126.40,	-44.45,		-9.20,	-27.96,	-74.83,	-124.25,	-7.67,	55.93,	526.66,	5320.80,	98.74,	1399.02,	2507.95,	53.10,	869.04,
			59.5,		144773.4,	-134.03,	-44.78,		-7.56,	-30.98,	-67.41,	-114.40,	-7.77,	54.83,	565.31,	5458.52,	104.50,	1292.15,	2574.39,	62.70,	860.75,
			60,			145181.2,	-144.22,	-37.13,		9.54,	-30.86,	-72.13,	-84.26,		-7.68,	53.69,	604.06,	5594.32,	112.37,	1187.18,	2647.45,	54.37,	842.64,
			60.5,		145545.4,	-161.80,	-35.13,		0.85,	-35.26,	-76.70,	-82.53,		-7.81,	61.58,	622.07,	5745.72,	130.15,	1063.98,	2710.91,	63.80,	842.83,
			61,			145824.1,	-166.56,	-36.12,		8.42,	-38.22,	-75.70,	-65.78,		-7.93,	51.26,	660.31,	5901.83,	137.98,	935.18,		2772.55,	64.10,	823.48,
			61.5,		146030.5,	-172.17,	-34.89,		3.41,	-37.25,	-74.69,	-64.47,		-7.76,	59.16,	701.53,	6056.59,	156.21,	801.04,		2837.87,	64.53,	812.91,
			62,			146149.3,	-180.08,	-33.41,		3.13,	-40.62,	-76.42,	-53.93,		-7.94,	57.95,	763.06,	6232.91,	175.96,	663.88,		2878.55,	64.33,	802.40,
			62.5,		146184.0,	-182.22,	-31.30,		16.14,	-38.63,	-64.25,	-31.88,		-7.97,	47.57,	835.16,	6394.77,	187.18,	529.22,		2940.02,	55.52,	781.67,
			63,			146138.8,	-188.12,	-29.42,		15.08,	-33.70,	-63.83,	-23.88,		-8.09,	46.34,	917.64,	6607.94,	209.99,	383.23,		2957.69,	55.12,	769.93,
			63.5,		146008.9,	-188.01,	-28.06,		17.35,	-35.61,	-65.88,	-12.87,		-8.26,	45.20,	1009.82,6772.10,	232.58,	230.74,		3011.25,	63.95,	757.61,
			64,			145793.0,	-202.42,	-25.97,		11.21,	-45.96,	-74.09,	-10.28,		-8.51,	52.87,	1099.71,6964.66,	256.68,	66.94,		3055.83,	63.93,	754.41,
			64.5,		145481.3,	-207.79,	-23.31,		13.63,	-38.52,	-64.85,	10.10,		-8.73,	42.63,	1200.78,7132.84,	272.75,	-92.03,		3111.87,	63.71,	731.95,
			65,			145081.9,	-213.62,	-20.69,		18.03,	-40.15,	-63.30,	23.15,		-9.04,	41.36,	1303.76,7282.11,	298.78,	-266.71,	3182.80,	64.00,	718.53,
			65.5,		144593.1,	-218.23,	-25.31,		20.49,	-50.77,	-64.24,	25.38,		-9.33,	48.80,	1406.72,7446.36,	325.75,	-442.53,	3257.28,	64.18,	713.97,
			66,			144005.6,	-225.28,	-22.88,		22.19,	-44.15,	-65.21,	45.27,		-9.81,	38.64,	1512.98,7605.67,	356.41,	-621.81,	3339.09,	64.54,	699.88,

			48,			136044.0,	38.22,		-91.17,	-57.81,	15.64,	-76.45,	-398.53,	-11.04,	79.78,	908.82,		3015.12,	-2.65,	2975.67,	1680.61,	46.26,	1087.57,
			48.5,		137777.9,	33.09,		-98.73,	-56.61,	-2.41,	-84.33,	-392.01,	-10.84,	79.51,	837.21,		3120.62,	-1.39,	2977.79,	1736.27,	47.26,	1094.57,
			49,			139485.8,	27.43,		-98.39,	-55.59,	-3.40,	-84.12,	-385.30,	-10.70,	79.22,	769.85,		3236.18,	0.85,	2982.69,	1792.00,	48.23,	1092.59,
			49.5,		141155.4,	38.63,		-81.13,	-46.21,	12.69,	-67.15,	-361.54,	-10.40,	78.83,	735.35,		3355.99,	-13.20,	2982.66,	1847.01,	49.13,	1080.08,
			50,			142817.8,	24.19,		-80.71,	-61.72,	11.61,	-67.25,	-379.16,	-10.13,	86.94,	685.91,		3477.12,	6.46,	2968.42,	1904.52,	50.07,	1085.42,
			50.5,		144444.7,	18.01,		-96.00,	-60.57,	10.47,	-83.42,	-371.27,	-9.83,	86.53,	641.51,		3597.99,	1.13,	2957.41,	1965.45,	51.08,	1081.07,
			51,			146033.0,	5.31,		-85.80,	-50.25,	18.24,	-74.20,	-353.75,	-9.81,	77.16,	621.92,		3726.21,	-4.28,	2941.09,	2023.52,	51.94,	1066.58,
			51.5,		147583.7,	14.08,		-78.28,	-48.52,	7.98,	-58.87,	-344.72,	-9.71,	76.63,	600.48,		3853.79,	-0.42,	2920.24,	2083.17,	52.82,	1069.71,
			52,			149107.4,	7.21,		-82.70,	-46.66,	15.35,	-73.77,	-334.61,	-9.46,	75.92,	561.19,		3996.83,	4.42,	2884.38,	2142.37,	53.70,	1062.53,
			52.5,		150595.8,	-14.49,		-80.28,	-44.07,	-0.52,	-73.76,	-323.05,	-9.15,	75.02,	538.47,		4136.17,	8.90,	2852.41,	2192.06,	54.30,	1054.15,
			53,			152045.2,	-18.99,		-71.39,	-39.62,	1.41,	-70.49,	-294.05,	-9.13,	83.33,	511.98,		4299.32,	13.78,	2794.80,	2224.71,	54.46,	1054.52,
			53.5,		153477.2,	-39.73,		-68.28,	-22.67,	-12.06,	-82.63,	-281.90,	-8.96,	82.64,	462.97,		4438.40,	18.30,	2750.64,	2258.95,	54.61,	1044.76,
			54,			154867.2,	-47.25,		-66.82,	-21.12,	-14.00,	-73.99,	-271.79,	-8.91,	72.42,	405.57,		4566.88,	11.22,	2700.57,	2366.05,	56.54,	1034.23,
			54.5,		156212.2,	-56.73,		-68.37,	-22.53,	-18.21,	-86.14,	-264.64,	-8.68,	71.34,	343.62,		4715.73,	12.45,	2644.27,	2425.26,	57.05,	1023.14,
			55,			157503.1,	-72.37,		-76.30,	-30.25,	-19.02,	-85.36,	-263.64,	-8.49,	79.98,	303.24,		4865.01,	29.74,	2573.60,	2496.98,	67.60,	1020.41,
			55.5,		158722.1,	-68.89,		-65.25,	-18.59,	-19.93,	-84.59,	-243.38,	-8.40,	69.33,	276.57,		5015.71,	28.90,	2506.96,	2561.02,	58.63,	1007.72,
			56,			159895.8,	-84.92,		-73.02,	-26.33,	-20.61,	-83.90,	-241.99,	-8.42,	78.11,	242.09,		5173.24,	47.97,	2414.71,	2627.85,	69.06,	1003.12,
			56.5,		160993.6,	-91.34,		-71.29,	-24.27,	-21.59,	-83.23,	-230.58,	-8.34,	77.71,	232.71,		5329.73,	58.57,	2327.78,	2695.42,	69.78,	988.31,
			57,			162023.3,	-87.89,		-59.20,	-22.46,	-12.73,	-72.67,	-208.91,	-8.16,	75.92,	253.35,		5487.45,	58.61,	2246.21,	2762.94,	70.47,	983.17,
			57.5,		162994.0,	-95.06,		-67.15,	-20.28,	-24.45,	-82.21,	-207.22,	-8.16,	74.80,	278.22,		5648.62,	69.90,	2138.43,	2828.63,	71.04,	977.13,
			58,			163893.4,	-111.40,	-64.99,	-17.93,	-25.27,	-81.62,	-194.92,	-7.83,	73.65,	317.61,		5811.43,	81.24,	2045.62,	2898.42,	71.71,	959.80,
			58.5,		164721.2,	-109.62,	-53.91,	-15.60,	-17.97,	-82.37,	-182.53,	-8.03,	72.42,	358.05,		5960.85,	84.42,	1928.32,	2976.66,	72.55,	952.30,
			59,			165473.3,	-115.26,	-50.30,	-13.09,	-18.01,	-70.65,	-159.79,	-7.96,	61.18,	402.70,		6115.41,	96.14,	1824.61,	3062.73,	63.52,	934.24,
			59.5,		166160.1,	-123.97,	-50.11,	-11.02,	-21.15,	-72.04,	-147.80,	-8.18,	59.88,	449.08,		6274.58,	102.31,	1706.36,	3145.59,	64.34,	925.47,
			60,			166782.6,	-146.62,	-40.98,	-1.42,	-31.44,	-77.92,	-122.28,	-8.28,	68.60,	484.77,		6432.81,	110.87,	1569.49,	3232.37,	75.16,	916.06,
			60.5,		167344.1,	-157.34,	-38.75,	-0.75,	-37.09,	-83.38,	-109.60,	-8.24,	67.25,	495.30,		6617.33,	121.41,	1431.54,	3314.53,	75.88,	895.42,
			61,			167815.5,	-163.08,	-39.59,	8.01,	-40.24,	-82.16,	-100.07,	-8.48,	55.70,	529.34,		6799.00,	140.74,	1286.94,	3391.58,	76.34,	885.11,
			61.5,		168201.5,	-169.72,	-38.17,	2.33,	-39.32,	-91.01,	-87.83,		-8.19,	64.43,	567.50,		6987.24,	162.22,	1125.67,	3470.77,	76.82,	873.67,
			62,			168484.4,	-178.87,	-36.47,	2.21,	-43.00,	-82.66,	-75.37,		-8.51,	63.01,	629.13,		7194.93,	185.06,	960.46,		3521.10,	76.54,	862.28,
			62.5,		168668.3,	-181.89,	-34.09,	6.64,	-40.99,	-79.18,	-60.21,		-8.51,	51.40,	713.79,		7385.11,	198.39,	797.44,		3600.13,	77.02,	839.58,
			63,			168757.5,	-188.95,	-31.95,	5.67,	-35.46,	-78.63,	-50.42,		-8.72,	60.01,	801.16,		7636.10,	224.89,	621.59,		3619.03,	76.16,	826.87,
			63.5,		168746.8,	-199.29,	-30.35,	8.31,	-47.66,	-80.78,	-37.37,		-8.89,	58.64,	900.52,		7831.18,	251.14,	438.20,		3693.01,	76.39,	813.55,
			64,			168634.6,	-205.91,	-37.97,	11.56,	-49.30,	-79.96,	-23.83,		-9.23,	57.16,	1018.63,	8066.76,	279.84,	241.30,		3742.83,	86.00,	799.61,
			64.5,		168410.0,	-212.49,	-34.92,	14.37,	-41.09,	-79.56,	-10.26,		-9.55,	55.63,	1139.73,	8265.60,	298.89,	48.96,		3820.14,	76.25,	785.81,
			65,			168081.4,	-219.60,	-31.86,	19.39,	-43.00,	-77.78,	5.13,		-9.59,	54.10,	1263.48,	8444.34,	329.25,	-151.84,	3904.80,	76.49,	771.29,
			65.5,		167647.0,	-225.39,	-27.03,	12.43,	-55.00,	-78.78,	18.30,		-10.00,	52.49,	1387.55,	8642.47,	360.99,	-364.69,	3996.17,	86.61,	756.07,
			66,			167095.7,	-233.92,	-24.23,	24.31,	-47.73,	-70.08,	31.59,		-10.79,	50.87,	1515.73,	8830.12,	386.70,	-572.72,	4095.34,	77.19,	740.90,
			
			48,			153082.6,	82.79,		-117.53,	-82.07,	25.46,	-92.24,	-502.79,	-11.64,	90.81,	930.25,	3402.40,	-20.42,	3713.59,	2032.58,	55.12,	1186.56,
			48.5,		155276.6,	76.90,		-116.73,	-71.83,	12.34,	-83.29,	-494.98,	-11.35,	90.38,	851.73,	3523.43,	-19.61,	3725.64,	2100.95,	56.34,	1178.08,
			49,			157448.5,	70.42,		-116.13,	-70.49,	11.23,	-82.90,	-487.05,	-11.20,	89.95,	749.75,	3660.83,	-17.36,	3731.03,	2171.12,	57.57,	1178.55,
			49.5,		159573.9,	84.35,		-95.06,		-48.85,	30.87,	-62.18,	-458.44,	-10.93,	89.39,	706.95,	3799.92,	-35.02,	3739.70,	2242.71,	58.80,	1177.81,
			50,			161690.3,	77.57,		-94.41,		-76.72,	20.41,	-71.39,	-469.61,	-11.07,	88.81,	646.33,	3948.30,	-11.47,	3722.69,	2314.59,	59.98,	1175.66,
			50.5,		163773.9,	70.50,		-112.79,	-75.29,	19.02,	-90.93,	-469.43,	-10.41,	97.54,	582.71,	4091.17,	-7.92,	3708.67,	2385.94,	70.53,	1172.09,
			51,			165811.8,	44.91,		-110.96,	-73.37,	17.85,	-80.69,	-449.26,	-10.18,	87.16,	547.35,	4240.04,	-14.02,	3697.88,	2460.45,	62.24,	1168.36,
			51.5,		167793.5,	55.54,		-91.26,		-61.66,	25.76,	-62.08,	-438.27,	-10.33,	86.46,	531.09,	4391.21,	-9.71,	3671.47,	2534.25,	63.33,	1152.35,
			52,			169753.1,	47.32,		-107.39,	-59.39,	23.91,	-79.98,	-425.98,	-9.92,	85.54,	483.00,	4559.22,	-4.29,	3638.14,	2609.09,	64.47,	1145.75,
			52.5,		171670.3,	21.15,		-104.46,	-56.14,	4.80,	-79.91,	-411.77,	-9.69,	84.38,	444.68,	4730.55,	-9.03,	3598.32,	2667.10,	65.02,	1137.94,
			53,			173539.9,	16.33,		-82.41,		-60.53,	7.84,	-75.19,	-376.10,	-9.56,	93.37,	413.43,	4921.06,	-4.01,	3539.55,	2710.27,	65.22,	1139.81,
			53.5,		175389.9,	1.92,		-68.09,		-29.73,	2.39,	-79.00,	-350.84,	-9.37,	82.26,	353.46,	5083.54,	-9.72,	3495.33,	2759.87,	65.59,	1130.93,
			54,			177200.1,	-7.11,		-66.13,		-27.83,	0.08,	-79.87,	-338.53,	-9.43,	81.12,	272.92,	5242.43,	-18.55,	3433.67,	2885.39,	67.82,	1120.13,
			54.5,		178967.5,	-40.18,		-89.65,		-40.83,	-16.21,	-94.37,	-341.16,	-9.26,	90.21,	187.56,	5416.83,	4.90,	3353.96,	2964.06,	79.14,	1119.39,
			55,			180648.1,	-36.90,		-77.19,		-38.72,	-17.11,	-93.30,	-328.52,	-9.19,	78.61,	138.70,	5592.11,	13.58,	3289.56,	3048.68,	69.70,	1095.11,
			55.5,		182265.2,	-44.10,		-86.18,		-36.25,	-18.17,	-92.32,	-315.76,	-8.89,	87.92,	83.49,	5771.71,	23.76,	3197.20,	3131.80,	81.29,	1092.75,
			56,			183805.5,	-51.63,		-83.92,		-33.98,	-18.88,	-91.38,	-302.51,	-8.78,	76.18,	54.01,	5958.25,	23.73,	3107.89,	3214.62,	71.50,	1078.02,
			56.5,		185278.0,	-59.13,		-81.91,		-31.50,	-19.96,	-90.49,	-299.65,	-8.96,	87.19,	31.12,	6146.57,	47.59,	3002.77,	3293.16,	82.95,	1073.56,
			57,			186658.0,	-55.00,		-67.61,		-29.55,	-9.42,	-77.93,	-273.92,	-8.31,	73.37,	55.85,	6330.67,	47.02,	2902.92,	3380.81,	73.05,	1056.96,
			57.5,		187979.0,	-74.46,		-76.99,		-38.01,	-11.76,	-89.15,	-272.04,	-8.75,	82.91,	74.95,	6526.49,	60.24,	2784.47,	3460.87,	84.64,	1050.36,
			58,			189204.5,	-82.92,		-74.40,		-24.19,	-13.50,	-88.55,	-257.23,	-8.23,	70.51,	122.04,	6716.23,	73.68,	2671.04,	3551.63,	85.67,	1032.41,
			58.5,		190355.6,	-91.92,		-72.32,		-32.32,	-15.65,	-88.68,	-242.37,	-8.62,	80.13,	160.11,	6895.85,	76.93,	2541.10,	3644.32,	86.55,	1024.24,
			59,			191418.0,	-99.50,		-68.81,		-18.26,	-16.53,	-87.38,	-227.23,	-8.70,	67.51,	213.63,	7079.72,	91.02,	2414.51,	3751.01,	87.84,	1004.52,
			59.5,		192402.0,	-109.44,	-56.67,		-15.61,	-19.73,	-77.33,	-212.57,	-8.72,	77.14,	258.08,	7271.22,	97.93,	2271.03,	3853.63,	88.91,	995.14,
			60,			193310.4,	-136.37,	-56.91,		-15.27,	-31.73,	-95.90,	-170.29,	-8.90,	75.59,	301.00,	7464.04,	107.67,	2117.40,	3965.67,	90.20,	985.37,
			60.5,		194147.9,	-149.97,	-43.16,		-2.95,	-27.83,	-91.33,	-155.24,	-8.67,	62.76,	324.39,	7682.91,	108.63,	1949.84,	4061.73,	90.83,	963.67,
			61,			194889.7,	-156.92,	-43.74,		7.30,	-31.10,	-89.81,	-132.15,	-8.78,	61.01,	341.23,	7907.26,	131.68,	1775.11,	4156.36,	91.36,	940.25,
			61.5,		195529.9,	-164.84,	-42.11,		0.79,	-41.56,	-99.60,	-128.91,	-8.95,	70.68,	374.90,	8128.83,	156.33,	1592.23,	4256.10,	103.34,	940.17,
			62,			196048.8,	-175.44,	-40.17,		0.91,	-45.56,	-89.99,	-114.14,	-9.02,	69.04,	435.54,	8378.15,	183.10,	1392.36,	4323.78,	103.22,	915.70,
			62.5,		196450.5,	-179.63,	-37.49,		5.83,	-43.57,	-86.17,	-96.40,		-9.17,	67.23,	523.57,	8606.77,	199.22,	1193.94,	4420.60,	92.47,	903.11,
			63,			196739.1,	-188.12,	-35.02,		5.02,	-37.32,	-85.46,	-84.33,		-9.28,	65.52,	616.57,	8908.75,	230.55,	991.15,		4448.65,	91.44,	889.45,
			63.5,		196908.6,	-200.25,	-44.37,		8.07,	-39.85,	-87.72,	-68.75,		-9.78,	63.92,	735.92,	9146.35,	261.64,	767.38,		4542.96,	91.86,	875.13,
			64,			196956.6,	-208.41,	-41.58,		11.82,	-53.01,	-86.76,	-52.48,		-10.14,	62.18,	867.52,	9426.39,	295.30,	539.05,		4610.75,	102.81,	860.16,
			64.5,		196870.6,	-216.52,	-38.06,		15.11,	-43.94,	-75.16,	-25.08,		-10.67,	60.38,	1014.53,9667.98,	318.51,	303.99,		4705.56,	91.84,	833.33,
			65,			196660.0,	-225.27,	-23.45,		20.87,	-46.23,	-73.23,	-6.81,		-11.44,	47.53,	1164.78,9884.72,	343.23,	58.63,		4811.61,	92.23,	817.78,
			65.5,		196322.5,	-232.54,	-29.02,		24.30,	-48.81,	-74.38,	-1.98,		-11.53,	56.73,	1315.76,10125.38,	380.92,	-201.06,	4924.43,	103.62,	801.48,
			66,			195845.5,	-231.97,	-25.75,		26.76,	-40.88,	-75.64,	25.02,		-12.06,	43.90,	1471.77,10354.34,	412.04,	-456.20,	5050.47,	93.37,	785.21,

			48,			181358.5,	164.23,		-159.80,	-111.86,	44.17,	-105.93,	-695.24,	-12.71,	119.98,	948.19,		4042.67,	-40.24,	5101.95,	2632.70,	71.13,	1329.11,
			48.5,		184424.3,	166.76,		-148.97,	-109.86,	24.79,	-105.65,	-685.23,	-12.72,	119.49,	830.99,		4204.17,	-39.55,	5129.02,	2722.05,	72.70,	1325.71,
			49,			187461.5,	158.80,		-148.03,	-108.25,	23.31,	-95.29,		-674.98,	-12.20,	109.09,	705.10,		4376.74,	-47.27,	5147.15,	2821.68,	74.51,	1320.78,
			49.5,		190447.5,	177.81,		-130.20,	-79.79,		49.38,	-77.80,		-637.36,	-11.99,	118.36,	636.52,		4548.81,	-71.76,	5157.30,	2916.16,	76.10,	1324.11,
			50,			193422.1,	169.29,		-129.51,	-104.56,	47.88,	-77.75,		-652.32,	-11.83,	117.68,	544.23,		4731.12,	-41.81,	5158.32,	3012.95,	88.02,	1314.36,
			50.5,		196353.7,	149.76,		-153.93,	-113.23,	46.29,	-103.40,	-650.25,	-11.59,	116.83,	460.98,		4916.87,	-37.80,	5139.78,	3104.02,	89.51,	1314.95,
			51,			199237.8,	116.26,		-151.58,	-110.85,	45.03,	-102.29,	-636.29,	-11.15,	115.63,	401.44,		5108.36,	-34.08,	5123.41,	3208.73,	91.41,	1314.05,
			51.5,		202048.3,	130.34,		-125.80,	-108.38,	42.81,	-77.83,		-622.07,	-11.33,	114.83,	366.67,		5301.26,	-29.10,	5099.23,	3307.39,	93.02,	1299.23,
			52,			204830.0,	130.71,		-147.11,	-105.72,	40.35,	-101.43,	-605.95,	-10.16,	113.70,	290.22,		5515.09,	-33.78,	5065.97,	3409.19,	94.73,	1295.46,
			52.5,		207556.5,	96.40,		-143.17,	-90.29,		15.24,	-90.14,		-575.78,	-11.20,	112.21,	239.35,		5729.09,	-28.19,	5035.90,	3496.12,	84.60,	1277.69,
			53,			210220.1,	102.85,		-102.23,	-82.20,		32.07,	-82.45,		-516.19,	-10.11,	110.78,	210.45,		5972.14,	-34.21,	4971.10,	3561.62,	84.98,	1270.71,
			53.5,		212884.2,	71.29,		-96.27,		-54.73,		12.64,	-88.19,		-495.66,	-10.52,	109.62,	106.16,		6187.69,	-40.92,	4910.81,	3622.75,	85.09,	1262.25,
			54,			215496.2,	47.58,		-93.72,		-52.35,		9.43,	-101.28,	-491.28,	-10.31,	108.20,	-24.13,		6389.10,	-41.85,	4829.42,	3792.02,	100.05,	1265.16,
			54.5,		218041.0,	18.23,		-110.73,	-69.37,		-11.71,	-108.26,	-482.93,	-10.15,	106.43,	-136.05,	6611.39,	-24.14,	4762.38,	3897.34,	101.31,	1241.50,
			55,			220498.8,	8.98,		-120.40,	-66.77,		-12.79,	-118.77,	-478.72,	-9.82,	105.06,	-225.60,	6837.80,	-13.79,	4663.77,	4008.79,	102.72,	1241.53,
			55.5,		222862.3,	-0.25,		-118.62,	-63.62,		-14.12,	-105.24,	-462.51,	-9.87,	103.36,	-311.28,	7068.48,	-13.56,	4568.81,	4126.64,	104.31,	1227.83,
			56,			225140.2,	-9.91,		-115.76,	-60.83,		-14.80,	-116.17,	-445.67,	-9.56,	102.15,	-362.75,	7309.38,	-0.59,	4451.33,	4236.23,	105.50,	1212.17,
			56.5,		227317.9,	-19.51,		-113.49,	-57.70,		-3.57,	-102.50,	-428.23,	-9.76,	116.35,	-393.84,	7547.08,	29.03,	4327.56,	4352.21,	106.87,	1195.97,
			57,			229390.4,	-14.17,		-95.30,		-55.74,		10.15,	-86.31,		-395.32,	-9.58,	98.66,	-375.47,	7787.07,	15.06,	4209.30,	4466.59,	108.09,	1178.11,
			57.5,		231373.8,	-12.37,		-94.71,		-52.75,		6.98,	-100.50,	-393.26,	-9.49,	96.82,	-349.76,	8038.91,	31.01,	4067.83,	4579.87,	109.19,	1159.36,
			58,			233263.0,	-37.46,		-91.37,		-49.12,		-9.50,	-99.95,		-374.11,	-9.54,	95.09,	-302.50,	8292.46,	49.23,	3932.42,	4699.09,	110.45,	1138.94,
			58.5,		235042.1,	-47.53,		-87.21,		-45.00,		2.47,	-85.81,		-354.87,	-9.69,	93.37,	-238.27,	8528.33,	52.38,	3764.27,	4824.75,	111.71,	1131.06,
			59,			236724.1,	-58.79,		-97.08,		-41.38,		-13.07,	-98.42,		-335.74,	-9.86,	91.45,	-183.22,	8767.64,	70.77,	3598.73,	4970.49,	113.62,	1123.08,
			59.5,		238292.4,	-70.68,		-81.51,		-37.69,		-3.18,	-85.75,		-316.23,	-9.96,	89.55,	-124.90,	9019.98,	78.80,	3424.45,	5106.91,	115.05,	1100.07,
			60,			239778.7,	-92.30,		-54.08,		-22.52,		-18.11,	-96.09,		-261.65,	-9.66,	87.58,	-83.32,		9270.39,	76.77,	3236.93,	5252.35,	116.59,	1075.87,
			60.5,		241204.8,	-124.48,	-64.13,		-7.47,		-41.87,	-118.04,	-242.55,	-9.89,	85.53,	-96.62,		9546.00,	91.22,	3030.53,	5388.91,	117.78,	1065.07,
			61,			242494.1,	-133.61,	-51.00,		5.42,		-32.12,	-102.92,	-213.27,	-10.26,	83.37,	-76.01,		9843.28,	107.27,	2800.41,	5524.71,	118.89,	1039.30,
			61.5,		243653.1,	-143.76,	-48.96,		-2.49,		-31.67,	-100.91,	-194.57,	-10.10,	81.31,	-46.63,		10133.67,	138.10,	2572.11,	5659.53,	119.85,	1026.63,
			62,			244669.8,	-156.79,	-59.72,		-1.82,		-36.02,	-102.15,	-188.61,	-10.52,	79.21,	3.87,		10461.55,	171.90,	2322.84,	5756.85,	132.91,	1012.94,
			62.5,		245536.5,	-176.42,	-56.56,		-9.30,		-34.28,	-97.85,		-166.39,	-10.77,	76.95,	75.31,		10759.85,	193.12,	2060.61,	5890.08,	133.73,	999.01,
			63,			246256.9,	-187.45,	-53.54,		3.42,		-39.92,	-109.90,	-150.10,	-10.68,	74.80,	182.68,		11148.97,	245.56,	1791.68,	5936.07,	132.37,	983.81,
			63.5,		246810.9,	-189.50,	-38.03,		7.17,		-29.92,	-86.01,		-116.89,	-11.32,	72.76,	323.77,		11464.70,	258.83,	1509.64,	6070.14,	133.18,	954.85,
			64,			247221.3,	-200.41,	-47.73,		11.76,		-45.56,	-97.88,		-95.96,		-11.92,	70.56,	496.97,		11835.63,	301.95,	1207.22,	6168.95,	133.02,	938.32,
			64.5,		247472.9,	-224.38,	-43.46,		2.85,		-48.26,	-97.26,		-87.94,		-12.54,	68.32,	676.97,		12151.18,	345.29,	895.02,		6304.75,	146.67,	920.98,
			65,			247549.7,	-223.05,	-39.14,		9.90,		-51.19,	-94.93,		-64.43,		-13.28,	66.10,	874.79,		12446.10,	391.38,	581.76,		6445.26,	133.92,	903.82,
			65.5,		247461.5,	-246.06,	-45.39,		14.33,		-54.48,	-96.17,		-43.60,		-13.24,	63.75,	1074.49,	12761.11,	426.08,	249.59,		6602.55,	147.58,	885.79,
			66,			247193.0,	-246.91,	-28.35,		17.67,		-45.49,	-84.74,		-9.69,		-14.22,	61.41,	1281.08,	13070.32,	467.15,	-92.12,		6775.16,	135.79,	853.99,

			48,			212559.1,	281.45,		-201.31,	-159.92,	79.06,	-121.92,	-936.45,	-14.68,	144.81,	962.44,		4743.20,	-78.16,	6871.29,	3296.55,	90.25,	1465.50,
			48.5,		216734.7,	283.20,		-199.75,	-157.56,	41.24,	-121.34,	-923.79,	-14.14,	144.03,	796.66,		4944.81,	-78.55,	6919.01,	3426.28,	92.71,	1458.02,
			49,			220885.4,	262.79,		-198.76,	-155.74,	39.33,	-120.52,	-910.87,	-14.02,	143.27,	606.57,		5158.12,	-76.93,	6954.93,	3552.41,	105.55,	1471.87,
			49.5,		224957.7,	299.03,		-162.31,	-118.71,	73.66,	-84.32,		-861.86,	-13.66,	142.28,	515.88,		5381.44,	-120.46,6979.53,	3678.37,	97.08,	1458.57,
			50,			229027.4,	288.47,		-161.40,	-151.46,	71.76,	-84.03,		-892.93,	-13.39,	141.28,	394.65,		5615.41,	-82.07,	6992.26,	3802.14,	110.18,	1467.92,
			50.5,		233041.8,	277.29,		-193.36,	-149.32,	81.18,	-117.45,	-877.04,	-13.14,	140.02,	286.10,		5847.70,	-77.98,	6993.52,	3934.46,	112.57,	1449.43,
			51,			237006.6,	234.37,		-201.88,	-146.15,	68.22,	-115.69,	-858.96,	-12.64,	138.30,	195.75,		6083.59,	-74.61,	6984.05,	4070.43,	114.95,	1453.89,
			51.5,		240876.7,	253.39,		-168.45,	-142.89,	65.32,	-83.56,		-840.58,	-12.53,	137.17,	149.33,		6326.84,	-81.19,	6964.53,	4201.55,	117.13,	1443.00,
			52,			244710.5,	239.88,		-184.17,	-139.38,	74.31,	-102.03,	-819.52,	-12.19,	135.59,	49.05,		6602.96,	-73.79,	6933.37,	4331.28,	106.96,	1430.88,
			52.5,		248498.7,	182.92,		-191.20,	-133.77,	29.36,	-114.12,	-794.62,	-11.68,	145.94,	-42.99,		6863.95,	-68.36,	6879.35,	4450.88,	120.82,	1427.98,
			53,			252193.7,	190.53,		-139.53,	-122.58,	50.75,	-89.84,		-718.02,	-11.96,	131.53,	-95.51,		7176.83,	-75.32,	6822.49,	4541.39,	121.49,	1425.02,
			53.5,		255903.1,	150.13,		-131.23,	-86.43,		26.69,	-111.10,	-690.90,	-10.97,	142.85,	-243.83,	7439.98,	-71.30,	6757.72,	4635.80,	122.18,	1405.03,
			54,			259533.1,	147.60,		-114.89,	-70.41,		35.42,	-100.17,	-657.31,	-11.27,	128.09,	-411.42,	7701.32,	-114.92,6681.20,	4846.17,	126.33,	1384.73,
			54.5,		263119.8,	96.93,		-150.05,	-105.69,	-4.94,	-137.61,	-675.31,	-11.21,	138.96,	-584.70,	7984.53,	-64.88,	6579.75,	4995.57,	141.66,	1389.50,
			55,			266567.5,	85.38,		-147.21,	-89.08,		7.29,	-135.55,	-654.93,	-11.12,	123.87,	-699.88,	8273.70,	-66.30,	6482.23,	5146.69,	130.34,	1364.01,
			55.5,		269911.1,	87.69,		-145.16,	-84.97,		5.87,	-119.96,	-634.61,	-10.60,	121.60,	-839.20,	8567.03,	-65.14,	6374.37,	5296.36,	132.22,	1351.75,
			56,			273146.2,	75.79,		-141.53,	-81.46,		5.49,	-117.94,	-613.43,	-11.26,	120.17,	-906.13,	8875.64,	-49.76,	6239.95,	5453.09,	134.25,	1321.86,
			56.5,		276270.3,	64.12,		-138.88,	-77.44,		4.34,	-115.98,	-591.55,	-10.71,	138.30,	-977.69,	9173.50,	-13.53,	6113.78,	5600.18,	135.82,	1305.31,
			57,			279262.8,	71.58,		-115.81,	-89.78,		22.05,	-95.24,		-564.39,	-10.62,	115.70,	-970.27,	9486.46,	-30.50,	5963.26,	5751.01,	137.47,	1302.59,
			57.5,		282145.3,	58.18,		-131.28,	-86.38,		17.69,	-113.14,	-562.87,	-10.77,	113.29,	-938.32,	9811.59,	-11.38,	5797.90,	5904.02,	139.08,	1283.59,
			58,			284923.9,	11.70,		-141.62,	-81.87,		-3.55,	-127.14,	-538.66,	-11.14,	125.54,	-907.68,	10133.52,	26.57,	5608.93,	6062.61,	155.18,	1277.27,
			58.5,		287534.7,	29.98,		-105.49,	-61.73,		27.01,	-94.48,		-499.70,	-11.27,	109.07,	-811.90,	10435.70,	-0.28,	5438.02,	6235.35,	142.77,	1240.20,
			59,			290053.8,	-0.97,		-118.16,	-71.83,		7.01,	-110.64,	-490.06,	-11.50,	106.53,	-755.98,	10741.95,	38.09,	5240.34,	6430.30,	145.45,	1216.30,
			59.5,		292429.4,	-0.06,		-98.16,		-52.04,		4.60,	-94.72,		-449.76,	-11.11,	104.13,	-681.17,	11062.70,	31.70,	5016.34,	6612.72,	147.51,	1207.62,
			60,			294717.8,	-59.08,		-79.21,		-46.97,		-13.94,	-123.92,	-379.73,	-10.98,	116.44,	-643.67,	11389.62,	43.73,	4775.69,	6810.30,	164.67,	1197.01,
			60.5,		296933.5,	-100.55,	-75.79,		-28.80,		-29.41,	-135.92,	-355.79,	-11.82,	99.02,	-678.20,	11752.65,	46.94,	4524.76,	6993.21,	166.43,	1154.48,
			61,			298992.2,	-112.34,	-59.73,		-12.74,		-32.39,	-133.14,	-319.11,	-12.16,	96.34,	-701.09,	12130.74,	82.33,	4260.31,	7170.49,	167.84,	1142.40,
			61.5,		300886.6,	-125.07,	-72.24,		-22.40,		-32.55,	-130.50,	-310.46,	-12.14,	93.72,	-696.35,	12506.02,	105.11,	3965.48,	7356.68,	169.50,	1129.29,
			62,			302601.1,	-125.71,	-69.45,		-20.94,		-37.05,	-130.96,	-286.42,	-12.08,	106.09,	-664.41,	12932.22,	147.14,	3643.98,	7495.85,	184.84,	1098.70,
			62.5,		304127.1,	-150.33,	-65.80,		-14.66,		-35.82,	-126.28,	-259.05,	-12.44,	88.26,	-589.93,	13324.01,	174.96,	3335.55,	7674.69,	170.97,	1084.44,
			63,			305466.9,	-164.37,	-62.19,		0.71,		-41.95,	-109.69,	-237.41,	-13.32,	85.55,	-468.96,	13830.20,	224.45,	2986.50,	7751.45,	169.54,	1052.34,
			63.5,		306612.2,	-167.85,	-59.17,		5.25,		-30.60,	-111.75,	-196.81,	-13.85,	82.95,	-319.51,	14236.98,	258.18,	2635.12,	7933.58,	170.79,	1035.97,
			64,			307573.4,	-197.19,	-70.11,		-4.28,		-48.85,	-110.23,	-185.21,	-14.15,	95.24,	-111.50,	14714.49,	311.89,	2242.23,	8065.84,	185.44,	1017.66,
			64.5,		308316.9,	-211.54,	-64.99,		0.82,		-52.28,	-109.39,	-158.33,	-13.55,	92.43,	122.26,		15134.20,	366.82,	1850.31,	8247.44,	186.23,	999.75,
			65,			308853.4,	-226.82,	-59.69,		-5.74,		-55.97,	-106.66,	-128.55,	-15.61,	89.59,	378.11,		15515.91,	409.00,	1439.35,	8446.90,	187.24,	980.89,
			65.5,		309163.1,	-225.43,	-51.70,		14.80,		-45.19,	-93.02,		-101.63,	-16.28,	71.69,	637.57,		15935.65,	454.79,	1018.59,	8663.87,	173.69,	946.17,
			66,			309272.3,	-258.18,	-46.50,		4.31,		-50.10,	-109.52,	-74.33,		-17.86,	83.65,	891.61,		16341.88,	522.48,	568.86,		8889.99,	189.94,	941.41,
		},
	},

	autopilot = {
		delay			= 1.0,
		omega_ctrl		= 1,
		fins_limit		= 0.5,
		fins_limit_x	= 0.1,
		Areq_limit		= 3.0,		
		Kconv			= 1.0,
		K				= 3.0,
		Kd				= 7.0,
		Ki				= 5.5,
		Kr				= 0.1,
		Krd				= 0.1,
		Kri				= 0.0,
	},
			
	warhead		= warheads["SCUD_8F14"],
	warhead_air = warheads["SCUD_8F14"],	
}, 
{	
	mass = 5862.0,
	Reflection = 0.45,
});


declare_missile("AIM_120", _('AIM-120B'), "aim-120b", "wAmmunitionSelfHoming", wsType_AA_Missile, "aa_missile_amraam",
{
	controller = {
		boost_start = 0.5,
		march_start = 2.6,
	},
	
	boost = {
		impulse								= 236,
		fuel_mass							= 18.21,
		work_time							= 2.1,
		nozzle_position						= {{-1.9, 0, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		nozzle_exit_area 					= 0.0132,
		tail_width							= 0.4,
		smoke_color							= {0.8, 0.8, 0.8},
		smoke_transparency					= 0.03,
		custom_smoke_dissipation_factor		= 0.2,	
	},
	
	march = {
		impulse								= 227,
		fuel_mass							= 28.33,
		work_time							= 5.0,
		nozzle_position						= {{-1.9, 0, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		nozzle_exit_area 					= 0.0132,
		tail_width							= 0.4,
		smoke_color							= {0.8, 0.8, 0.8},
		smoke_transparency					= 0.03,
		custom_smoke_dissipation_factor		= 0.2,
		
--		fuel_rate_data	=	{	--t		rate
--								0.0,	2.0,
--								4.0,	1.8,
--							},
	},
	
	fm = {
		mass				= 157.85,  
		caliber				= 0.178,  
		wind_sigma			= 0.0,
		wind_time			= 0.0,
		tail_first			= 0,
		fins_part_val		= 0,
		rotated_fins_inp	= 0,
		delta_max			= math.rad(20),
		draw_fins_conv		= {math.rad(90),1,1},
		L					= 0.178,
		S					= 0.0248,
		Ix					= 1.24,
		Iy					= 130.12,
		Iz					= 130.12,
		
		Mxd					= 0.1 * 57.3,
		Mxw					= -15.8,

		table_scale	= 0.2,
		table_degree_values = 1,
	--	Mach	  | 0.0		0.2		0.4		0.6		0.8		1.0		1.2		1.4		1.6		1.8		2.0		2.2		2.4		2.6		2.8		3.0		3.2		3.4		3.6		3.8		4.0	 	4.2		4.4		4.6		4.8		5.0 |
		Cx0 	= {	0.515,	0.515,	0.515,	0.515,	0.527,	0.85,	0.949,	0.905,	0.8605,	0.8094,	0.7636,	0.7204,	0.6813,	0.6458,	0.6135,	0.5839,	0.5567,	0.5316,	0.5082,	0.4864,	0.4659,	0.4468,	0.4288,	0.4121,	0.3968,	0.384  },
		CxB 	= {	0.021,	0.021,	0.021,	0.021,	0.021,	0.138,	0.153,	0.146,	0.1382,	0.1272,	0.1167,	0.1073,	0.0987,	0.0909,	0.0837,	0.077,	0.0708,	0.065,	0.0595,	0.0544,	0.0495,	0.0449,	0.0406,	0.0364,	0.0324,	0.0286 },
		K1		= { 0.0039,	0.0039,	0.0039,	0.0039,	0.0039,	0.0048,	0.004,	0.00325,	0.002845,	0.002602,	0.002378,	0.002176,	0.001994,	0.001832,	0.001689,	0.001564,	0.001456,	0.001366,	0.00129,	0.001229,	0.001182,	0.001147,	0.001123,	0.001108,	0.001101,	0.0011 },
		K2		= { -0.0041,-0.0041,-0.0041,-0.0041,-0.0041,-0.0049,-0.0042,-0.0036,	-0.003121,	-0.002725,	-0.002408,	-0.00213,	-0.001888,	-0.001677,	-0.001494,	-0.001334,	-0.001196,	-0.001077,	-0.000973,	-0.000884,	-0.000808,	-0.000743,	-0.000689,	-0.000646,	-0.000615,	-0.0006 },
		Cya		= { 0.345,	0.345,	0.345,	0.345,	0.357,	0.401,	0.448,	0.495,	0.513,	0.506,	0.5,	0.495,	0.49,	0.486,	0.482,	0.478,	0.474,	0.471,	0.468,	0.465,	0.462,	0.46,	0.457,	0.455,	0.453,	0.451 },
		Cza		= { 0.345,	0.345,	0.345,	0.345,	0.357,	0.401,	0.448,	0.495,	0.513,	0.506,	0.5,	0.495,	0.49,	0.486,	0.482,	0.478,	0.474,	0.471,	0.468,	0.465,	0.462,	0.46,	0.457,	0.455,	0.453,	0.451 },
		Mya		= { -1.316,-1.316,	-1.316,	-1.316,	-1.458,	-1.982,	-1.418,	-1.0883,-0.9411,-0.8255,-0.733,	-0.6574,-0.5942,-0.5403,-0.4935,-0.4525,-0.4164,-0.3846,-0.3568,-0.3328,-0.3125,-0.2959,-0.283,-0.2739,-0.2683,-0.2665 },
		Mza		= { -1.316,-1.316,	-1.316,	-1.316,	-1.458,	-1.982,	-1.418,	-1.0883,-0.9411,-0.8255,-0.733,	-0.6574,-0.5942,-0.5403,-0.4935,-0.4525,-0.4164,-0.3846,-0.3568,-0.3328,-0.3125,-0.2959,-0.283,-0.2739,-0.2683,-0.2665 },
		Myw		= { -16.3145,-16.3145,-16.3145,-16.3145,-16.8944,-19.8659,-18.1868,-17.1716,-16.504,-15.88,-15.2958,-14.7478,-14.2328,-13.7477,-13.2901,-12.8574,-12.4477,-12.0593,-11.6911,-11.3421,-11.0121,-10.7015,-10.4118,-10.1458,-9.9098,-9.7256 },
		Mzw		= { -16.3145,-16.3145,-16.3145,-16.3145,-16.8944,-19.8659,-18.1868,-17.1716,-16.504,-15.88,-15.2958,-14.7478,-14.2328,-13.7477,-13.2901,-12.8574,-12.4477,-12.0593,-11.6911,-11.3421,-11.0121,-10.7015,-10.4118,-10.1458,-9.9098,-9.7256 },
		A1trim	= { 24,		24,		24,		24,		23.5,	23,		25.16,	27.23,	29.04,	30.6,	31.93,	33.08,	34.07,	34.95,	35.74,	36.45,	37.09,	37.68,	38.2,	38.66,	39.06,	39.39,	39.66,	39.85,	39.96,	40 },
		A2trim	= { 24,		24,		24,		24,		23.5,	23,		25.16,	27.23,	29.04,	30.6,	31.93,	33.08,	34.07,	34.95,	35.74,	36.45,	37.09,	37.68,	38.2,	38.66,	39.06,	39.39,	39.66,	39.85,	39.96,	40 },
		
		model_roll = math.rad(45),
		fins_stall = 1,
	},
	
	seeker = {
		delay						= 1.5,
		op_time						= 80,
		FOV							= math.rad(120),
		max_w_LOS					= math.rad(30),
		sens_near_dist				= 100,
		sens_far_dist				= 30000,
		ccm_k0						= 0.2,
		aim_sigma					= 7.5,
		height_error_k				= 25,
		height_error_max_vel		= 60,
		height_error_max_h			= 300,
		hoj							= 1,
		rad_correction				= 1,
		active_radar_lock_dist		= 15000.0,
		active_dist_trig_by_default	= 1,
	},

	autopilot = {
		delay				= 1.0,
		op_time				= 80,
		Tf					= 0.1,
		Knav				= 4.0,
		Kd					= 110.0,
		Ka					= 22.0,
		T1					= 292.0,
		Tc					= 0.04,
		Kx					= 0.1,
		Krx					= 2.0,
		gload_limit			= 30.0,
		fins_limit			= math.rad(18),
		fins_limit_x		= math.rad(5),
		null_roll			= math.rad(45),
		accel_coeffs		= { 0, 9.4, 1.8, 0.35, 23.6,
								0.0248 * 0.75 * 0.009 },
		
		loft_active			= 1,
		loft_factor			= 4.5,
		loft_sin			= math.sin(30/57.3),
		loft_off_range		= 15000,
		dV0					= 347,
	},
	
	actuator = {
		Tf					= 0.005,
		D					= 250.0,
		T1					= 0.002,
		T2					= 0.006,
		max_omega			= math.rad(400),
		max_delta			= math.rad(20),
		fin_stall			= 1,
		sim_count			= 4,
	},
	
	proximity_fuze = {
		radius		= 7.0,
		arm_delay	= 1.6,
	},
	
	warhead		= warheads["AIM_120"],
	warhead_air = warheads["AIM_120"]
}, 
{
	mass = 157.85,
	Reflection = 0.0366,
});

declare_missile("AIM_120C", _('AIM-120C'), "aim-120c", "wAmmunitionSelfHoming", wsType_AA_Missile, "aa_missile_amraam",
{
	controller = {
		boost_start = 0.4,
		march_start = 0.5,
	},
	
	boost = {
		impulse								= 0,
		fuel_mass							= 0,
		work_time							= 0.1,
		nozzle_position						= {{-1.9, 0, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		nozzle_exit_area 					= 0.0132,
		tail_width							= 0.4,
		smoke_color							= {0.8, 0.8, 0.8},
		smoke_transparency					= 0.03,
		custom_smoke_dissipation_factor		= 0.2,	
	},
	
	march = {
		impulse								= 234,
		fuel_mass							= 51.26,
		work_time							= 6.5,
		nozzle_position						= {{-1.9, 0, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		nozzle_exit_area 					= 0.0132,
		tail_width							= 0.4,
		smoke_color							= {0.8, 0.8, 0.8},
		smoke_transparency					= 0.03,
		custom_smoke_dissipation_factor		= 0.2,
		
--		fuel_rate_data	=	{	--t		rate
--								0.0,	2.0,
--								4.0,	1.8,
--							},
	},
	
	fm = {
		mass				= 161.48,  
		caliber				= 0.178,  
		wind_sigma			= 0.0,
		wind_time			= 0.0,
		tail_first			= 0,
		fins_part_val		= 0,
		rotated_fins_inp	= 0,
		delta_max			= math.rad(20),
		draw_fins_conv		= {math.rad(90),1,1},
		L					= 0.178,
		S					= 0.0248,
		Ix					= 1.04,
		Iy					= 125.32,
		Iz					= 125.32,
		
		Mxd					= 0.1 * 57.3,
		Mxw					= -15.8,

		table_scale	= 0.2,
		table_degree_values = 1,
	--	Mach	  | 0.0		0.2		0.4		0.6		0.8		1.0		1.2		1.4		1.6		1.8		2.0		2.2		2.4		2.6		2.8		3.0		3.2		3.4		3.6		3.8		4.0	 	4.2		4.4		4.6		4.8		5.0 |
		Cx0 	= {	0.468,	0.468,	0.468,	0.468,	0.479,	0.751,	0.88,	0.8572,	0.8132,	0.7645,	0.7205,	0.6808,	0.6447,	0.6119,	0.582,	0.5545,	0.5292,	0.5057,	0.4838,	0.4633,	0.4439,	0.4256,	0.4083,	0.3921,	0.377,	0.364  },
		CxB 	= {	0.021,	0.021,	0.021,	0.021,	0.021,	0.138,	0.153,	0.146,	0.1382,	0.1272,	0.1167,	0.1073,	0.0987,	0.0909,	0.0837,	0.077,	0.0708,	0.065,	0.0595,	0.0544,	0.0495,	0.0449,	0.0406,	0.0364,	0.0324,	0.0286 },
		K1		= { 0.0025,	0.0025,	0.0025,	0.0025,	0.0025,	0.0024,	0.002,	 0.00172, 0.00151, 0.00135,0.00123, 0.00114, 0.00106, 0.00099,0.00094, 0.00088, 0.00084, 0.00079, 0.00074, 0.0007, 0.00066, 0.00062, 0.00058, 0.00055,0.00052, 0.0005  },
		K2		= {-0.0024,-0.0024,-0.0024,-0.0024,-0.0024,-0.0024,-0.00206,-0.00186,-0.00168,-0.0015,-0.00134,-0.00118,-0.00104,-0.0009,-0.00078,-0.00066,-0.00056,-0.00046,-0.00038,-0.0003,-0.00024,-0.00018,-0.00014,-0.0001,-0.00008,-0.00006 },
		Cya		= { 0.318,	0.318,	0.318,	0.318,	0.336,	0.425,	0.467,	0.506,	0.518,	0.503,	0.491,	0.48,	0.471,	0.463,	0.456,	0.45,	0.445,	0.441,	0.438,	0.434,	0.431,	0.429,	0.427,	0.424,	0.423,	0.421 },
		Cza		= { 0.318,	0.318,	0.318,	0.318,	0.336,	0.425,	0.467,	0.506,	0.518,	0.503,	0.491,	0.48,	0.471,	0.463,	0.456,	0.45,	0.445,	0.441,	0.438,	0.434,	0.431,	0.429,	0.427,	0.424,	0.423,	0.421 },
		Mya		= {-0.712, -0.712, -0.712, -0.712, -0.776, -0.916, -0.907, -0.825, -0.7191,-0.5719,-0.4711,-0.4019,-0.3538,-0.3193,-0.2934,-0.2728,-0.2553,-0.2398,-0.2254,-0.2119,-0.199, -0.1868,-0.1754,-0.1649,-0.1557,-0.149 },
		Mza		= {-0.712, -0.712, -0.712, -0.712, -0.776, -0.916, -0.907, -0.825, -0.7191,-0.5719,-0.4711,-0.4019,-0.3538,-0.3193,-0.2934,-0.2728,-0.2553,-0.2398,-0.2254,-0.2119,-0.199, -0.1868,-0.1754,-0.1649,-0.1557,-0.149 },
		Myw		= { -8.8081,-8.8081,-8.8081,-8.8081,-9.0256,-11.32,-10.0494,-10.0967,-10.111,-10.0959,-10.0547,-9.9906,-9.9065,-9.8052,-9.6892,-9.5609,-9.4224,-9.2756,-9.1223,-8.9639,-8.8019,-8.6373,-8.471,-8.3037,-8.1361,-7.9682 },
		Mzw		= { -8.8081,-8.8081,-8.8081,-8.8081,-9.0256,-11.32,-10.0494,-10.0967,-10.111,-10.0959,-10.0547,-9.9906,-9.9065,-9.8052,-9.6892,-9.5609,-9.4224,-9.2756,-9.1223,-8.9639,-8.8019,-8.6373,-8.471,-8.3037,-8.1361,-7.9682 },
		A1trim	= { 28,		28,		28,		28,		28,		31.2,	32.74,	33.39,	33.7,	33.89,	34.04,	34.18,	34.31,	34.44,	34.57,	34.7,	34.83,	34.96,	35.09,	35.22,	35.35,	35.48,	35.61,	35.74,	35.87,	36 },
		A2trim	= { 28,		28,		28,		28,		28,		31.2,	32.74,	33.39,	33.7,	33.89,	34.04,	34.18,	34.31,	34.44,	34.57,	34.7,	34.83,	34.96,	35.09,	35.22,	35.35,	35.48,	35.61,	35.74,	35.87,	36 },
		
		model_roll = math.rad(45),
		fins_stall = 1,
	},
	
	seeker = {
		delay						= 1.5,
		op_time						= 80,
		FOV							= math.rad(120),
		max_w_LOS					= math.rad(30),
		sens_near_dist				= 100,
		sens_far_dist				= 30000,
		ccm_k0						= 0.1,
		aim_sigma					= 6.0,
		height_error_k				= 20,
		height_error_max_vel		= 50,
		height_error_max_h			= 300,
		hoj							= 1,
		rad_correction				= 1,
		active_radar_lock_dist		= 15000.0,
		active_dist_trig_by_default	= 1,
	},

	autopilot = {
		delay				= 1.0,
		op_time				= 80,
		Tf					= 0.1,
		Knav				= 4.0,
		Kd					= 180.0,
		Ka					= 16.0,
		T1					= 309.0,
		Tc					= 0.06,
		Kx					= 0.1,
		Krx					= 2.0,
		gload_limit			= 30.0,
		fins_limit			= math.rad(18),
		fins_limit_x		= math.rad(5),
		null_roll			= math.rad(45),
		accel_coeffs		= { 0, 11.5,-1.2,-0.25, 24.0,
								0.0248 * 0.75 * 0.0091 },
		
		loft_active			= 1,
		loft_factor			= 4.5,
		loft_sin			= math.sin(30/57.3),
		loft_off_range		= 15000,
		dV0					= 393,
	},
	
	actuator = {
		Tf					= 0.005,
		D					= 250.0,
		T1					= 0.002,
		T2					= 0.006,
		max_omega			= math.rad(400),
		max_delta			= math.rad(20),
		fin_stall			= 1,
		sim_count			= 4,
	},
	
	proximity_fuze = {
		radius		= 7.0,
		arm_delay	= 1.6,
	},
	
	warhead		= warheads["AIM_120C"],
	warhead_air = warheads["AIM_120C"]
}, 
{
	mass = 161.48,
	Reflection = 0.0366,
});


--[[
declare_missile("AIM_54", _('AIM-54'), "aim-54", "wAmmunitionSelfHoming", wsType_AA_Missile, "aa_missile_active",
{
	controller = {
		boost_start = 0.5,
		march_start = 5.5,
	},
	
	boost = {
		impulse								= 240,
		fuel_mass							= 148.6,
		work_time							= 5.0,
		nozzle_position						= {{-1.794, -0.195, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.5,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.9,
		custom_smoke_dissipation_factor		= 0.2,	
	},
	
	march = {
		impulse								= 200,
		fuel_mass							= 134,
		work_time							= 22.0,
		nozzle_position						= {{-1.794, -0.195, 0}},
		nozzle_orientationXYZ				= {{0.0, 0.0, 0.0}},
		tail_width							= 0.5,
		smoke_color							= {1.0, 1.0, 1.0},
		smoke_transparency					= 0.9,
		custom_smoke_dissipation_factor		= 0.2,
	},
	
	fm = {
		mass				= 463,  
		caliber				= 0.38,  
		wind_sigma			= 0.0,
		wind_time			= 0.0,
		tail_first			= 1,
		fins_part_val		= 0,
		rotated_fins_inp	= 0,
		delta_max			= math.rad(20),
		draw_fins_conv		= {math.rad(90),1,1},
		L					= 0.38,
		S					= 0.11,
		Ix					= 10.0,
		Iy					= 610.0,
		Iz					= 610.0,
		
		Mxd					= 0.3 * 57.3,
		Mxw					= -44.5,

		table_scale	= 0.2,
		table_degree_values = 1,
	--	Mach	  | 0.0		0.2		0.4		0.6		0.8		1.0		1.2		1.4		1.6		1.8		2.0		2.2		2.4		2.6		2.8		3.0		3.2		3.4		3.6		3.8		4.0	 	|
		Cx0 	= {	0.07,	0.07,	0.07,	0.07,	0.0714,	0.08,	0.055,	0.0413,	0.033,	0.0276,	0.024,	0.0215,	0.0196,	0.0182,	0.0172,	0.0164,	0.0157,	0.0152,	0.148,	0.0144,	0.0141	},
		CxB 	= {	0.11,	0.11,	0.11,	0.11,	0.11,	0.40,	0.19,	0.17,	0.16,	0.14,	0.13,	0.12,	0.12,	0.11,	0.11,	0.10,	0.09,	0.09,	0.08,	0.08,	0.07	},
		K1		= { 0.0056,	0.0056,	0.0056,	0.0056,	0.0056,	0.0056,	0.0056,	0.0056,	0.0052,	0.0048,	0.0045,	0.0041,	0.0037,	0.0036,	0.0034,	0.0032,	0.0031,	0.0030,	0.0029,	0.0027,	0.0026	},
		K2		= { 0.0055,	0.0055,	0.0055,	0.0055,	0.0055,	0.0055,	0.0055,	0.0055,	0.0051,	0.0047,	0.0043,	0.0037,	0.0031,	0.0032,	0.0033,	0.0035,	0.0036,	0.0037,	0.0038,	0.0039,	0.0040	},
		Cya		= { 0.6,	0.6,	0.6,	0.6,	0.6,	0.6,	0.6,	0.6,	0.6,	0.568,	0.519,	0.484,	0.459,	0.439,	0.423,	0.410,	0.400,	0.391,	0.383,	0.377,	0.372	},
		Cza		= { 0.6,	0.6,	0.6,	0.6,	0.6,	0.6,	0.6,	0.6,	0.6,	0.568,	0.519,	0.484,	0.459,	0.439,	0.423,	0.410,	0.400,	0.391,	0.383,	0.377,	0.372	},
		Mya		= { -0.5,	-0.5},
		Mza		= { -0.5,	-0.5},
		Myw		= { -2.0,	-2.0},
		Mzw		= { -2.0,	-2.0},
		A1trim	= { 10.0,	10.0},
		A2trim	= { 10.0,	10.0},
		
		model_roll = math.rad(45),
		fins_stall = 1,
	},
	
	proximity_fuze = {
		radius		= 15,
		arm_delay	= 1.6,
	},
	
	seeker = {
		delay							= 2.5,
		op_time							= 120,
		FOV								= math.rad(120),
		max_w_LOS						= math.rad(20),
		sens_near_dist					= 100.0,
		sens_far_dist					= 30000.0,
		ccm_k0							= 1,
		aim_sigma						= 5.5,
		height_error_k					= 100,
		height_error_max_vel			= 138,
		height_error_max_h				= 300,
		rad_correction					= 1,
		hoj								= 0,
		active_dist_trig_by_default		= 1,
		active_radar_lock_dist			= 15000.0,
		active_radar_filter_dist		= 3000.0,
	},

	autopilot = {
		delay					= 1.5,
		op_time					= 120,
		Kconv					= 3.0,
		Knv						= 0.005,
		Kd						= 0.4,
		Ki						= 0.25,
		Kout					= 1.0,
		Kx						= 0.015,
		Krx						= 2.0,
		fins_limit				= math.rad(20),
		fins_limit_x			= math.rad(5),
		Areq_limit				= 25.0,
		bang_bang				= 0,
		max_side_N				= 10,
		max_signal_Fi			= math.rad(12),
		rotate_fins_output		= 0,
		alg						= 0,
		PN_dist_data 			= {	15000,	1,
									9000,	1},
		null_roll				= math.rad(45),
		
		loft_active_by_default	= 1,
		loft_add_pitch			= math.rad(30),
		loft_time				= 4.0,
		loft_min_dist			= 6000,
	},
	
	warhead		= warheads["AIM_54"],
	warhead_air = warheads["AIM_54"]
}, 
{
	mass		= 463.0,
	Reflection	= 0.076,
});
]]
