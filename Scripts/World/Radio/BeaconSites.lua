dofile('Scripts/World/Radio/BeaconTypes.lua')

--deep copying
local function copy(source)
	local dest
	for key, value in pairs(source or {}) do
		dest = dest or {}
		if type(value) == 'table' then
			dest[key] = copy(value)
		else
			dest[key] = value
		end
	end
	return dest
end

--Beacon system determines transmitters parameters: power, antenna radiation pattern and signal type.

--Identifiers of the beacon systems
SystemName = {
	PAR_10					= 1,
	RSBN_4H					= 2,
	TACAN					= 3,
	TACAN_TANKER_MODE_X		= 4,
	TACAN_TANKER_MODE_Y		= 5,
	VOR						= 6,
	ILS_LOCALIZER			= 7,
	ILS_GLIDESLOPE			= 8,
	PRMG_LOCALIZER			= 9,
	PRMG_GLIDESLOPE			= 10,
	BROADCAST_STATION		= 11,
	VORTAC					= 12,
	TACAN_AA_MODE_X			= 13,
	TACAN_AA_MODE_Y			= 14,
	VORDME					= 15,
	ICLS_LOCALIZER			= 16,
	ICLS_GLIDESLOPE			= 17,
	TACAN_MOBILE_MODE_X		= 18,
	TACAN_MOBILE_MODE_Y		= 19,
}

--Beacon site determines what objects will be used as body of beacon systems

--Identifiers of the beacon sites
PAR_10_site_name =
{
	PAR_10S_FAR_WITH_MARKER = 1,
		PAR_10S_NEAR_WITH_MARKER = 2,
	PAR_10S_FAR = 3,
		PAR_10S_NEAR = 4,
	PAR_10MA_FAR_WITH_MARKER = 5,
		PAR_10MA_NEAR_WITH_MARKER = 6,
	PAR_10_in_lighthouse = 7,
	PAR_10_in_radio_tower = 8
}

RSBN_site_name =
{
	RSBN_ON_LAND = 1,
	RSBN_ON_HILL = 2
}

Broadcast_Station_site_name =
{
	BROADCAST_TOWER = 1
}

TACAN_site_name =
{
	STATIONARY_TACAN = 1,
	MOBILE_TACAN = 2
}

VOR_site_name =
{
	REGULAR_VOR = 1
}

PRMG_site_name =
{
	DEFAULT_LOCALIZER = 1,
	DEFAULT_GLIDESLOPE = 2,
}

ICLS_site_name =
{
	DEFAULT_LOCALIZER = 1,
	DEFAULT_GLIDESLOPE = 2,
}

--Default system and site for each type of beacon
default_systems = {
	[BEACON_TYPE_HOMER] = {
		system	= SystemName.PAR_10,
		site	= PAR_10_site_name.PAR_10S_FAR
	},
	[BEACON_TYPE_AIRPORT_HOMER] = {
		system	= SystemName.PAR_10,
		site	= PAR_10_site_name.PAR_10S_FAR
	},
	[BEACON_TYPE_AIRPORT_HOMER_WITH_MARKER] = {
		system	= SystemName.PAR_10,
		site	= PAR_10_site_name.PAR_10S_FAR_WITH_MARKER
	},
	[BEACON_TYPE_ILS_FAR_HOMER] = {
		system 	= SystemName.PAR_10,
		site 	= PAR_10_site_name.PAR_10S_FAR_WITH_MARKER
	},
	[BEACON_TYPE_ILS_NEAR_HOMER] = {
		system	= SystemName.PAR_10,
		site	= PAR_10_site_name.PAR_10S_NEAR_WITH_MARKER
	},
	[BEACON_TYPE_RSBN] = {
		system	= SystemName.RSBN_4H,
		site	= RSBN_site_name.RSBN_ON_HILL
	},
	[BEACON_TYPE_TACAN] = {
		system	= SystemName.TACAN,
		site	= TACAN_site_name.STATIONARY_TACAN
	},
	[BEACON_TYPE_VOR] = {
		system	= SystemName.VOR,
		site	= VOR_site_name.REGULAR_VOR
	},
	[BEACON_TYPE_VORTAC] = {
		system	= SystemName.VORTAC,
	},
	[BEACON_TYPE_VOR_DME] = {
		system	= SystemName.VORDME,
	},
	[BEACON_TYPE_ILS_LOCALIZER] = {
		system	= SystemName.ILS_LOCALIZER
	},
	[BEACON_TYPE_ILS_GLIDESLOPE] = {
		system	= SystemName.ILS_GLIDESLOPE
	},
	[BEACON_TYPE_PRMG_LOCALIZER] = {
		system	= SystemName.PRMG_LOCALIZER,
		site = PRMG_site_name.DEFAULT_LOCALIZER
	},
	[BEACON_TYPE_PRMG_GLIDESLOPE] = {
		system	= SystemName.PRMG_GLIDESLOPE,
		site = PRMG_site_name.DEFAULT_GLIDESLOPE
	},	
	[BEACON_TYPE_NAUTICAL_HOMER] = {
		system = SystemName.PAR_10,
		site = PAR_10_site_name.PAR_10_in_lighthouse
	},
	[BEACON_TYPE_BROADCAST_STATION] = {
		system	= SystemName.BROADCAST_STATION,
		site	= Broadcast_Station_site_name.BROADCAST_TOWER
	},
	[BEACON_TYPE_ICLS_LOCALIZER] = {
		system	= SystemName.ICLS_LOCALIZER,
		site = ICLS_site_name.DEFAULT_LOCALIZER
	},
	[BEACON_TYPE_ICLS_GLIDESLOPE] = {
		system	= SystemName.ICLS_GLIDESLOPE,
		site = ICLS_site_name.DEFAULT_GLIDESLOPE
	},	
}

default_child_systems = {
	[BEACON_TYPE_TACAN] = {
		system	= SystemName.TACAN,
	}
}

function get_default_system(beacon_type)
	if default_systems[beacon_type] ~= nil then
		return default_systems[beacon_type]["system"] or 0
	else
		return 0
	end
end

function get_default_child_system(beacon_type)
	if default_child_systems[beacon_type] ~= nil then
		return default_child_systems[beacon_type]["system"] or 0
	else
		return 0
	end
end

function get_default_site(beacon_type)
	if(default_systems[beacon_type] ~= nil) then
		if(default_systems[beacon_type]["site"] ~= nil) then
			return default_systems[beacon_type]["site"]
		else
			return 0
		end
	else
		return 0
	end	
end

DEVICE_TYPE_TRANSMITTER = 0
DEVICE_TYPE_RECEIVER = 1

TYPE_VOID = 0
TYPE_APPARATURE = 1
TYPE_ANTENNA = 2
TYPE_POWER_SOURCE = 3
TYPE_OTHER = 4

--Radio signals
SIGNAL_NULL							= 0
SIGNAL_VOICE_AM						= 1
SIGNAL_VOICE_FM						= 2
SIGNAL_TACAN_BEARING				= 4
SIGNAL_DME							= 8
SIGNAL_TACAN_RANGE_AA				= 16
SIGNAL_TACAN_X						= 32
SIGNAL_TACAN_Y						= 64
SIGNAL_RSBN_RANGE					= 128
SIGNAL_RSBN_BEARING					= 256
SIGNAL_VOR							= 512
SIGNAL_DVOR							= 1024
SIGNAL_ILS_LOCALIZER				= 2048
SIGNAL_ILS_GLIDESLOPE				= 4096
SIGNAL_PRMG_LOCALIZER				= 8192
SIGNAL_PRMG_GLIDESLOPE				= 16384
SIGNAL_INNER_MARKER					= 32768
SIGNAL_MIDDLE_MARKER				= 65536
SIGNAL_OUTER_MARKER					= 131072
SIGNAL_ICLS_LOCALIZER_CHAN_1_10		= 262144	-- Instrument Carrier Landing System (channels 1-10)
SIGNAL_ICLS_GLIDESLOPE_CHAN_1_10	= 524288	-- Instrument Carrier Landing System (channels 1-10)
SIGNAL_ICLS_LOCALIZER_CHAN_11_20	= 1048576	-- Instrument Carrier Landing System (channels 11-20)
SIGNAL_ICLS_GLIDESLOPE_CHAN_11_20	= 2097152	-- Instrument Carrier Landing System (channels 11-20)
--RESERVED				= 4194304

--Beacon systems
beacon_system = {
	--ПАР - ПРИВОДНАЯ АЭРОДРОМНАЯ РАДИОСТАНЦИЯ
	[SystemName.PAR_10] = {
		name = "ПАР-10",
		devices = {
			[1] = {
				type = DEVICE_TYPE_TRANSMITTER,
				name = "Homing transmitter P200", -- Приводной передатчик П200
				bandwidth = 800.0,
				power = 400.0, --watt
				signals = SIGNAL_VOICE_AM,
				height = 3.0,
				antenna = {
					polarization = 0,
					type = 'GCirclebyElev'
				}
			},
			[2] = {
				type = DEVICE_TYPE_TRANSMITTER,
				name = "Marker transmitter E-615.5", -- Маркерный передатчик Е-615.5
				defaultFrequency = 75E6,
				bandwidth = 3000.0,
				power = 0.320, --watt
				signals = SIGNAL_VOICE_AM,
				maxDistance = 12000.0,
				height = 0.8,
				elevation = 90,
				roll = 90,
				antenna = {
					polarization = 0.0,
					type = 'GbyAzElev',
					az = {
						{math.pi / 4, 		{2.0345,    0.4158,   -5.1561,    3.1623}},
						{math.pi / 2,		{-0.0799,   0.3638,   -0.5117,    0.3162}},
						{math.pi,			{0.0029,    0.0212,   -0.0882,    0.1000}},
						{3 * math.pi / 2,	{-0.0104,   0.0516,         0,    0.0251}},
					},
					elev = {
						{math.pi / 4, 		{2.0610,    0.3357,   -4.9232,    3.1623}},
						{math.pi / 2,		{-0.2368,   0.5216,   -0.5819,    0.5012}},
						{math.pi,			{0.0232,    0.0039,   -0.2007,    0.2512}}
					}
				}
			}
		}
	},
	[SystemName.RSBN_4H] = {
		name = "RSBN-4H",
		devices = {
			[1] = {
				type = DEVICE_TYPE_TRANSMITTER,
				name = "Short range radio navigation system RSBN-4N", -- угломерно-дальномерная система РСБН-4Н
				bandwidth = 1000.0,
				power = 80.0, --watt
				signals = SIGNAL_VOICE_AM + SIGNAL_RSBN_BEARING,
				height = 3.0,
				antenna = {
					polarization = 0,
					type = 'GCirclebyElev'
				}
			},
			[2] = {
				type = DEVICE_TYPE_TRANSMITTER,
				name = "Short range radio navigation system RSBN-4N", -- угломерно-дальномерная система РСБН-4Н
				bandwidth = 1000.0,
				power = 80.0, --watt
				signals = SIGNAL_RSBN_RANGE,
				height = 3.0,
				antenna = {
					polarization = 0,
					type = 'GCirclebyElev'
				}
			},
			--[[
			[3] = {
				type = DEVICE_TYPE_TRANSMITTER,
				name = "угломерно-дальномерная система РСБН-4Н",
				bandwidth = 800.0,
				power = 30000.0, --watt
				signals = SIGNAL_RSBN_RANGE,
				height = 3.0,
				antenna = {
					polarization = 0,
					type = 'GCirclebyElev'
				}
			},		
			--]]
		}
	},
	--TACAN
	[SystemName.TACAN] = {
		name = "TACAN",
		devices = {
			[1] = {
				type = DEVICE_TYPE_TRANSMITTER,
				name = "TACAN transmitter",
				bandwidth = 5000.0,
				power = 120.0,
				signals = SIGNAL_VOICE_AM + SIGNAL_TACAN_BEARING + SIGNAL_DME + SIGNAL_TACAN_X,
				height = 5.0,
				antenna = {
					polarization = 0,
					type = 'GCirclebyElev'
				}
			}
		},
		sites = {
			[TACAN_site_name.STATIONARY_TACAN] = {
				name = 'Stationary TACAN',
				elements = {
					{
						name	= 'self',
						shape	= 'tacan_a',
						dependencies = {1}
					}
				}
			},
			[TACAN_site_name.MOBILE_TACAN] = {
				name = 'Stationary TACAN',
				elements = {
					{
						name	= 'self',
						shape	= 'tacan_b',
						dependencies = {1}
					}
				}
			}
		},
		default_site = TACAN_site_name.STATIONARY_TACAN
	},

	--TACAN_TANKER
	[SystemName.TACAN_TANKER_MODE_X] = {
		name = "TACAN TANKER MODE X",
		devices = {
			[1] = {
				type = DEVICE_TYPE_TRANSMITTER,
				name = "TACAN TANKER transmitter",
				bandwidth = 5000.0,
				power = 120.0,
				signals = SIGNAL_VOICE_AM + SIGNAL_TACAN_BEARING + SIGNAL_TACAN_RANGE_AA + SIGNAL_TACAN_X,
				antenna = {
					polarization = 0,
					type = 'GCirclebyElev'
				}
			}
		},
	},

	--TACAN_TANKER
	[SystemName.TACAN_TANKER_MODE_Y] = {
		name = "TACAN TANKER MODE Y",
		devices = {
			[1] = {
				type = DEVICE_TYPE_TRANSMITTER,
				name = "TACAN TANKER transmitter",
				bandwidth = 5000.0,
				power = 120.0,
				signals = SIGNAL_VOICE_AM + SIGNAL_TACAN_BEARING + SIGNAL_TACAN_RANGE_AA + SIGNAL_TACAN_Y,
				antenna = {
					polarization = 0,
					type = 'GCirclebyElev'
				}
			}
		}
	},

	--TACAN_AA
	[SystemName.TACAN_AA_MODE_X] = {
		name = "TACAN AA MODE X",
		devices = {
			[1] = {
				type = DEVICE_TYPE_TRANSMITTER,
				name = "TACAN AA transmitter",
				bandwidth = 5000.0,
				power = 120.0,
				signals = SIGNAL_VOICE_AM + SIGNAL_TACAN_RANGE_AA + SIGNAL_TACAN_X,
				antenna = {
					polarization = 0,
					type = 'GCirclebyElev'
				}
			}
		},
	},

	--TACAN_AA
	[SystemName.TACAN_AA_MODE_Y] = {
		name = "TACAN AA MODE Y",
		devices = {
			[1] = {
				type = DEVICE_TYPE_TRANSMITTER,
				name = "TACAN AA transmitter",
				bandwidth = 5000.0,
				power = 120.0,
				signals = SIGNAL_VOICE_AM + SIGNAL_TACAN_RANGE_AA + SIGNAL_TACAN_Y,
				antenna = {
					polarization = 0,
					type = 'GCirclebyElev'
				}
			}
		}
	},


	-- VOR
	[SystemName.VOR] = {
		name = "VOR",
		devices = {
			[1] = {
				type = DEVICE_TYPE_TRANSMITTER,
				name = "VOR transmitter",
				bandwidth = 2500.0,
				power = 100.0,
				signals = SIGNAL_VOICE_AM + SIGNAL_VOR,
				height = 3.0,
				antenna = {
					polarization = 0,
					type = 'GCirclebyElev'
				}
			}
		},
		sites = {
			[VOR_site_name.REGULAR_VOR] = {
				name = 'Regular VOR',
				elements = {
					{
						name	= 'self',
						shape	= 'airbase_vor',
						dependencies = {1}
					}
				}
			}
		},
		default_site = VOR_site_name.REGULAR_VOR
	},

	-- VORTAC
	[SystemName.VORTAC] = {
		name = "VORTAC",
		devices = {
			[1] = {
				type = DEVICE_TYPE_TRANSMITTER,
				name = "TACAN transmitter",
				bandwidth = 5000.0,
				power = 120.0,
				signals = SIGNAL_VOICE_AM + SIGNAL_TACAN_BEARING + SIGNAL_DME + SIGNAL_TACAN_X,
				height = 7.0,
				antenna = {
					polarization = 0,
					type = 'GCirclebyElev'
				}
			},
			[2] = {
				type = DEVICE_TYPE_TRANSMITTER,
				name = "VOR transmitter",
				bandwidth = 2500.0,
				power = 100.0,
				signals = SIGNAL_VOICE_AM + SIGNAL_VOR,
				height = 3.0,
				antenna = {
					polarization = 0,
					type = 'GCirclebyElev'
				}
			},
		},
		-- TODO: to check
		sites = {
			[VOR_site_name.REGULAR_VOR] = {
				name = 'Regular VOR',
				elements = {
					{
						name	= 'self',
						shape	= 'airbase_vor',
						dependencies = {1}
					}
				}
			}
		},
		default_site = VOR_site_name.REGULAR_VOR
	},

	-- VOR/DME
	[SystemName.VORDME] = {
		name = "VOR/DME",
		devices = {
			[1] = {
				type = DEVICE_TYPE_TRANSMITTER,
				name = "VOR/DME transmitter",
				bandwidth = 2500.0,
				power = 100.0,
				signals = SIGNAL_VOICE_AM + SIGNAL_VOR + SIGNAL_DME,
				height = 3.0,
				antenna = {
					polarization = 0,
					type = 'GCirclebyElev'
				}
			}
		},
		-- TODO: to check
		sites = {
			[VOR_site_name.REGULAR_VOR] = {
				name = 'Regular VOR',
				elements = {
					{
						name	= 'self',
						shape	= 'airbase_vor',
						dependencies = {1}
					}
				}
			}
		},
		default_site = VOR_site_name.REGULAR_VOR
	},

	[SystemName.ILS_LOCALIZER] = {
		name = "LOCALIZER",
		devices = {
			[1] = {
				type = DEVICE_TYPE_TRANSMITTER,
				name = "LOCALIZER",
				bandwidth = 300.0,
				power = 15, -- Localizer output power CSB (Course and Clearance) - 5-25W adjustable, per NOMARC 7000B specification
				signals = SIGNAL_VOICE_AM + SIGNAL_ILS_LOCALIZER,
				height = 2.8,    -- meters
				elevation = 3, -- elevation above horizon (3 degrees is a typical glideslope angle)
				--[[
				antenna = {
					polarization = 0.0,
					type = 'GbyAzElev',					
					az = {
						{ 0.069813, { -126.4345, 195.8431, -82.4745, 7.0876} },
						{ 0.10472, { 35035.4996, -1018.2998, -56.9783, 2.2413} },
						{ 0.13963, { -51017.5228, 2671.2712, 0, 0.50176} },
						{ 0.17453, { 25730.058, -1618.6897, 0, 1.5867} },
						{ 0.20944, { 9402.3954, -220.8413, -18.952, 0.70876} },
						{ 0.24435, { -38705.3162, 2026.6056, 0, 0.17803} },
						{ 0.27925, { 33614.9269, -1763.4577, 0, 1.0012} },
						{ 0.97738, { -0.42498, 0.51605, -0.23627, 0.28216} },
						{ 1.5708, { 1.6351, -1.3399, -0.13712, 0.22413} },
						{ 2.7925, { 0.0029383, 0.002982, 0, 0.012604} },
						{ 3.0194, { 2.1147, 2.453, 0.020444, 0.022413} },
						{ 3.1416, { -751.1689, 236.3738, 1.4602, 0.17803} },
					},
					elev = {
						{ 0.7854, { 0.042295, -0.38411, -2.36, 7.0876} },
						{ 1.5708, { 5.1054, -4.3939, -2.8851, 5.0176} },
						{ 0.7854, { 0.030903, 0.17951, -0.33916, 2.5148} },
						{ 3.1416, { 0, 0.22805, 0, 2.3741} },
					}
				}
				]]
				antenna = {
					polarization = 0.0,
					type = 'GbyAzElev_v2',
					az = {
						{ -3.14159265359,	{ 0, 0, 0, 0} },                                   -- -180 (degrees)
						{ -3.07614,			{ 6441.005371, -599.428284, -2.927322, 1.006213}}, -- -176.25
						{ -2.426,			{ 0.538547, -0.701848, 0.139100, 0.056261}},       -- -139
						{ -2.00713,			{ 0.039719, -0.030572, 0.005999, -0.000044}},      -- -115
						{ -1.13446,			{ 0, 0, 0, 0}},                                    -- -65
						{ -0.71559,			{ -0.037087, 0.015479, -0.000406, 0.000010}},      -- -41
						{ -0.06545,			{ -0.583210, 0.394386, 0.079252, -0.001768}},      -- -3.75
						{  0.0, 			{-7856.531250, 809.570251, -5.195197, 0.066666} },
						{  0.06545,			{6441.005371, -599.428284, -2.927322, 1.006213} }, -- 3.75
						{  0.71559,			{0.538547, -0.701848, 0.139100, 0.056261}},        -- 41
						{  1.13446,			{ 0.039719, -0.030572, 0.005999, -0.000044}},      -- 65
						{  2.00713,			{ 0, 0, 0, 0}},      							   -- 115
						{  2.426,			{-0.037087, 0.015479, -0.000406, 0.000010}},       -- 139
						{  3.07614,			{-0.583210, 0.394386, 0.079252, -0.001768}}, 	   -- 176.25
						{  3.14159265359,	{-7856.531250, 809.570251, -5.195197, 0.066666} }, -- 180
					},
					elev = {
						{ -3.14159265359,	{ 0, 0, 0, 0} },
						{ -0.1287, 			{ 0, 0, 0, 0}},
						{  0.0, 			{511.807465, -192.394821, 24.291565, -0.039082} },
						{  0.1287, 			{-211.206161, -24.578102, -1.215318, 1.006062} },
						{  3.14159265359,	{ 0, 0, 0, 0} },
					}
				}
			}
		}
	},
	[SystemName.ILS_GLIDESLOPE] = {
		name = "GLIDESLOPE",
		devices = {
			[1] = {
				type = DEVICE_TYPE_TRANSMITTER,
				name = "GLIDESLOPE transmitter",
				bandwidth = 300.0,
				power = 5, -- Glidepath output power CSB: 3-8 Watt adjustable (Course), 0.3–1 Watt adjustable (Clearance), per NOMARC 7000B specification
				signals = SIGNAL_ILS_GLIDESLOPE,
				height = 14.0 * 0.3048, --lower (CSB) antenna height of null-reference glideslope system
				antenna = {
					polarization = 0.0,
					type = 'GbyAzElev',
					az = {
						{ 0.21817, { 1.7746, -4.3235, -3.3745, 3.1623} },
						{ 0.5236, { 81.2643, -29.0336, -5.0076, 2.2387} },
						{ 0.69813, { -30.8015, 8.0638, 0, 0.31623} },
						{ 1.0472, { 11.7358, -6.5432, 0, 0.39811} },
						{ 1.5708, { 0.1313, 0.1624, -0.27805, 0.1} },
						{ 2.618, { -0.12749, 0.26182, 0, 0.017783} },
						{ 3.1416, { 0.0032237, -0.0094192, 0.12892, 0.15849} },
					},
					elev = {
						{ 0.69813, { -0.015631, -0.026624, -1.2967, 3.1623} },
						{ 2.0944, { 0.36283, -0.53869, -1.3567, 2.2387} },
						{ 2.5307, { 1.9456, -0.42663, -0.73895, 0.28184} },
						{ 3.1416, { 0.53066, 0.16909, 0, 0.039811} },
					}
				}
			}
		}
	},

	[SystemName.PRMG_LOCALIZER] = {
		name = "LOCALIZER",
		devices = {
			[1] = {
				type = DEVICE_TYPE_TRANSMITTER,
				name = "LOCALIZER",
				bandwidth = 300.0,
				power = 14.0,
				signals = SIGNAL_VOICE_AM + SIGNAL_PRMG_LOCALIZER,
				height = 2.8,
				antenna = {
					polarization = 0.0,
					type = 'GbyAzElev_v2',
					az = {
						{ -3.14159265359,	{ 0, 0, 0, 0} },
						{ -0.7854,			{ 0, 0, 0, 0} },
						{ -0.2618,			{ 0, 3.9591, -0.3555, 0.00018159} },
						{ 0.2618,			{ 0, -1.7, 0.8901, 0.9135} },
						{ 0.7854,			{ 0, 3.9591, -3.6661, 0.8409} },
						{ 3.14159265359,	{ 0, 0, 0, 0} },
					},
					elev = {
						{ -3.14159265359,	{ 0, 0, 0, 0} },
						{ -0.15708,			{ 0, 0, 0, 0} },
						{ 0.0148353,		{ 0, 39.5726, -1.2347, 0.0032} },
						{ 0.137,			{ 0, -13.3992, 1.6374, 0.95} },
						{ 0.23911,			{ 0, 20.466, -10.4131, 0.9496} },
						{ 0.5236,			{ 0, 1.5027, -0.779, 0.1} },
						{ 3.14159265359,	{ 0, 0, 0, 0} },
					}
				}
			}
		},
		sites = {
			[PRMG_site_name.DEFAULT_LOCALIZER] = {
				elements = {
					{
						name	= 'KRM',
						shape	= 'RSP-7',
					}
				}
			}
		},
	},
	[SystemName.PRMG_GLIDESLOPE] = {
		name = "GLIDESLOPE",
		devices = {
			[1] = {
				type = DEVICE_TYPE_TRANSMITTER,
				name = "GLIDESLOPE transmitter",
				bandwidth = 300.0,
				power = 14.0,
				signals = SIGNAL_PRMG_GLIDESLOPE,
				height = 14.0 * 0.3048, --lower (CSB) antenna height of null-reference glidslope system
				antenna = {
					polarization = 0.0,
					type = 'GbyAzElev_v2',
					az = {
						{ -3.14159265359,	{ 0, 0, 0, 0} },
						{ -0.31416,			{ 0, 0, 0, 0} },
						{ -0.20944,			{ 0, 36.4756, 0, 0} },
						{ -0.13962634,		{ 0, -90.2772, 14.6069, 0.4003} },
						{ 0.13962634,		{ 0, -2.5647, 0.7161, 0.9800} },
						{ 0.20944,			{ 0, -90.2772, -2.0042, 0.9800} },
						{ 0.31416,			{ 0, 36.4756, -7.6380, 0.3998} },
						{ 3.14159265359,	{ 0, 0, 0, 0} },
					},
					elev = {
						{ -3.14159265359,	{ 0, 0, 0, 0} },
						{ -0.122173,		{ 0, 0, 0, 0} },
						{ 0.0,				{ 0, 15.4761, -0.2538, 0.0000406} },
						{ 0.015708,			{ 0, -1459.0, 72.6582, 0.1979} },
						{ 0.09163,			{ 0, -34.7387, 2.6401, 0.9799} },
						{ 0.22253,			{ 0, 37.9347, -11.6915, 0.9805} },
						{ 0.31416,			{ 0, 13.2007, -2.3022, 0.1004} },
						{ 3.14159265359,	{ 0, 0, 0, 0} },
					}
				}
			}
		},
		sites = {
			[PRMG_site_name.DEFAULT_GLIDESLOPE] = {
				elements = {
					{
						name	= 'GRM',
						shape	= 'RSP-7',
					}
				}
			}
		},
	},

	[SystemName.ICLS_LOCALIZER] = {
		name = "LOCALIZER",
		devices = {
			[1] = {
				type = DEVICE_TYPE_TRANSMITTER,
				name = "LOCALIZER",
				bandwidth = 1000000.0,
				power = 14.0,	-- TODO:
				signals = SIGNAL_ICLS_LOCALIZER_CHAN_1_10 + SIGNAL_ICLS_LOCALIZER_CHAN_11_20,
				height = 2.8,	-- TODO:
				antenna = {
					polarization = 0.0,
					type = 'GbyAzElev_v2',
					az = {
						{ -3.14159265359,	{ 0, 0, 0, 0} },
						{ -0.7854,			{ 0, 0, 0, 0} },
						{ -0.349,			{ 0, 6.0, -0.48, 0.0096} },
						{ 0.349,			{ 0, -0.95, 0.6631, 0.904289} },
						{ 0.7854,			{ 0, 6.0, -4.764, 0.945654} },
						{ 3.14159265359,	{ 0, 0, 0, 0} },
					},
					elev = {
						{ -3.14159265359,	{ 0, 0, 0, 0} },
						{ -0.174533,		{ 0, 0, 0, 0} },
						{ -0.0349066,		{ 0, 30.0, 0.6, 0.003} },
						{ 0.0,				{ 0, -40.0, 10.4, 0.624} },
						{ 0.174533,			{ 0, -3.5, 0.610862, 0.973346} },
						{ 0.20944,			{ 0, -40.0, -7.6, 0.939} },
						{ 0.349066,			{ 0, 30.0, -8.7, 0.63075} },
						{ 3.14159265359,	{ 0, 0, 0, 0} },
					}
				}
			}
		},
		sites = {
			[ICLS_site_name.DEFAULT_LOCALIZER] = {
				elements = {
					{
						name	= 'ICLS Localizer',
						shape	= 'TRN-30',
					}
				}
			}
		},
	},
	[SystemName.ICLS_GLIDESLOPE] = {
		name = "GLIDESLOPE",
		devices = {
			[1] = {
				type = DEVICE_TYPE_TRANSMITTER,
				name = "GLIDESLOPE transmitter",
				bandwidth = 1000000.0,
				power = 14.0,		-- TODO:
				signals = SIGNAL_ICLS_GLIDESLOPE_CHAN_1_10 + SIGNAL_ICLS_GLIDESLOPE_CHAN_11_20,
				height = 14.0 * 0.3048, --lower (CSB) antenna height of null-reference glidslope system		-- TODO:
				antenna = {
					polarization = 0.0,
					type = 'GbyAzElev_v2',
					az = {
						{ -3.14159265359,	{ 0, 0, 0, 0} },
						{ -0.7854,			{ 0, 0, 0, 0} },
						{ -0.349,			{ 0, 6.0, -0.48, 0.0096} },
						{ 0.349,			{ 0, -0.95, 0.6631, 0.904289} },
						{ 0.7854,			{ 0, 6.0, -4.764, 0.945654} },
						{ 3.14159265359,	{ 0, 0, 0, 0} },
					},
					elev = {
						{ -3.14159265359,	{ 0, 0, 0, 0} },
						{ -0.174533,		{ 0, 0, 0, 0} },
						{ -0.0349066,		{ 0, 30.0, 0.6, 0.003} },
						{ 0.0,				{ 0, -40.0, 10.4, 0.624} },
						{ 0.174533,			{ 0, -3.5, 0.610862, 0.973346} },
						{ 0.20944,			{ 0, -40.0, -7.6, 0.939} },
						{ 0.349066,			{ 0, 30.0, -8.7, 0.63075} },
						{ 3.14159265359,	{ 0, 0, 0, 0} },
					}
				}
			}
		},
		sites = {
			[ICLS_site_name.DEFAULT_GLIDESLOPE] = {
				elements = {
					{
						name	= 'ICLS Glidepath',
						shape	= 'TRN-30',
					}
				}
			}
		},
	},

	-- Mobile TACAN
	[SystemName.TACAN_MOBILE_MODE_X] = {
		name = "Mobile TACAN",
		devices = {
			[1] = {
				type = DEVICE_TYPE_TRANSMITTER,
				name = "Mobile ground TACAN transmitter",
				bandwidth = 5000.0,
				power = 100.0,
				signals = SIGNAL_VOICE_AM + SIGNAL_TACAN_BEARING + SIGNAL_DME + SIGNAL_TACAN_X,
				height = 2.0,
				antenna = {
					polarization = 0,
					type = 'GCirclebyElev'
				}
			}
		},
	},
	[SystemName.TACAN_MOBILE_MODE_Y] = {
		name = "Mobile TACAN",
		devices = {
			[1] = {
				type = DEVICE_TYPE_TRANSMITTER,
				name = "Mobile ground TACAN transmitter",
				bandwidth = 5000.0,
				power = 100.0,
				signals = SIGNAL_VOICE_AM + SIGNAL_TACAN_BEARING + SIGNAL_DME + SIGNAL_TACAN_Y,
				height = 2.0,
				antenna = {
					polarization = 0,
					type = 'GCirclebyElev'
				}
			}
		},
	},
}

PAR_10_element_name =
{
	APPARATURE = 1,
	ANTENNA_MAST_1ST = 2,
	ANTENNA_MAST_2ND = 3,
	MARKER_ANTENNA_MAST = 4,
	POWER_SOURCE = 5,
	FUEL_DEPOT = 6,
	FENCE = 7
}

--Sorry my lua

beacon_system[SystemName.PAR_10]["default_site"] = PAR_10_site_name.PAR_10S_FAR_WITH_MARKER
beacon_system[SystemName.PAR_10]["sites"] = {}
--stationary PAR-10S in buildings
--FAR
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER] = {}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["name"] = "ПАР-10С ДПРМ"
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"] = {}
--
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.FENCE] = {}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.FENCE]["type"] = TYPE_OTHER
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.FENCE]["name"] = "Ограда"
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.FENCE]["shape"] = "PAR_Ograd"
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.FENCE]["position"] = {}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.FENCE]["position"]["S0"] = 0.0
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.FENCE]["position"]["Z0"] = 0.0
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.FENCE]["position"]["rotate"] = 270
--
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.APPARATURE] = {}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.APPARATURE]["type"] = TYPE_APPARATURE
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.APPARATURE]["name"] = "Аппаратная"
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.APPARATURE]["shape"] = "PAR_Apparatnaya_20"
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.APPARATURE]["position"] = {}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.APPARATURE]["position"]["S0"] = -10.2
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.APPARATURE]["position"]["Z0"] = -0.5
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.APPARATURE]["position"]["rotate"] = 180.0
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.APPARATURE]["dependencies"] = {}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.APPARATURE]["dependencies"][1] = 1
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.APPARATURE]["dependencies"][2] = 2
--
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.ANTENNA_MAST_1ST] = {}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.ANTENNA_MAST_1ST]["type"] = TYPE_ANTENNA
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.ANTENNA_MAST_1ST]["name"] = "Левая опора антенны"
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.ANTENNA_MAST_1ST]["shape"] = "PAR_Anten20_L"
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.ANTENNA_MAST_1ST]["position"] = {}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.ANTENNA_MAST_1ST]["position"]["S0"] = 0.0
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.ANTENNA_MAST_1ST]["position"]["Z0"] = -31.5
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.ANTENNA_MAST_1ST]["position"]["rotate"] = 90.0
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.ANTENNA_MAST_1ST]["dependencies"] = {}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.ANTENNA_MAST_1ST]["dependencies"][1] = 1
--
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.ANTENNA_MAST_2ND] = {}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.ANTENNA_MAST_2ND]["type"] = TYPE_ANTENNA
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.ANTENNA_MAST_2ND]["name"] = "Правая опора антенны"
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.ANTENNA_MAST_2ND]["shape"] = "PAR_Anten20_R_Provod"
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.ANTENNA_MAST_2ND]["position"] = {}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.ANTENNA_MAST_2ND]["position"]["S0"] = 0.0
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.ANTENNA_MAST_2ND]["position"]["Z0"] = 34.0
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.ANTENNA_MAST_2ND]["position"]["rotate"] = 90.0
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.ANTENNA_MAST_2ND]["dependencies"] = {}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.ANTENNA_MAST_2ND]["dependencies"][1] = 1
--
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.MARKER_ANTENNA_MAST] = {}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.MARKER_ANTENNA_MAST]["type"] = TYPE_ANTENNA
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.MARKER_ANTENNA_MAST]["name"] = "Антенны маркерного маяка"
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.MARKER_ANTENNA_MAST]["shape"] = "PAR_Anten_Mrk"
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.MARKER_ANTENNA_MAST]["position"] = {}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.MARKER_ANTENNA_MAST]["position"]["S0"] = 6.0
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.MARKER_ANTENNA_MAST]["position"]["Z0"] = 0.0
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.MARKER_ANTENNA_MAST]["position"]["rotate"] = 90.0
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.MARKER_ANTENNA_MAST]["dependencies"] = {}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.MARKER_ANTENNA_MAST]["dependencies"][1] = 2
--
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.POWER_SOURCE] = {}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.POWER_SOURCE]["type"] = TYPE_POWER_SOURCE
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.POWER_SOURCE]["name"] = "Агрегатная"
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.POWER_SOURCE]["shape"] = "PAR_Agregatnaya"
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.POWER_SOURCE]["position"] = {}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.POWER_SOURCE]["position"]["S0"] = 10.0
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.POWER_SOURCE]["position"]["Z0"] = -8.0
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.POWER_SOURCE]["dependencies"] = {}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.POWER_SOURCE]["dependencies"][1] = 1
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.POWER_SOURCE]["dependencies"][2] = 2
--
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.FUEL_DEPOT] = {}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.FUEL_DEPOT]["type"] = TYPE_OTHER
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.FUEL_DEPOT]["name"] = "Склад ГСМ"
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.FUEL_DEPOT]["shape"] = "PAR_GSM"
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.FUEL_DEPOT]["position"] = {}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.FUEL_DEPOT]["position"]["S0"] = 10.0
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.FUEL_DEPOT]["position"]["Z0"] = -14.0
--
--NEAR
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_NEAR_WITH_MARKER] = copy(beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER])
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_NEAR_WITH_MARKER]["name"] = "ПАР-10С БПРМ"
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_NEAR_WITH_MARKER]["elements"][PAR_10_element_name.APPARATURE]["shape"] = "PAR_Apparatnaya"
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_NEAR_WITH_MARKER]["elements"][PAR_10_element_name.ANTENNA_MAST_1ST]["shape"] = "PAR_Anten7_L"
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_NEAR_WITH_MARKER]["elements"][PAR_10_element_name.ANTENNA_MAST_2ND]["shape"] = "PAR_Anten7_R_Provod"

--mobility PAR-10MA
--FAR
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10MA_FAR_WITH_MARKER] = copy(beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER])
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10MA_FAR_WITH_MARKER]["name"] = "ПАР-10МА дальн"
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10MA_FAR_WITH_MARKER]["elements"][PAR_10_element_name.APPARATURE]["shape"] = "PAR_10_MA"
--NEAR
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10MA_NEAR_WITH_MARKER] = copy(beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_NEAR_WITH_MARKER])
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10MA_NEAR_WITH_MARKER]["name"] = "ПАР-10МА ближн"
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10MA_NEAR_WITH_MARKER]["elements"][PAR_10_element_name.APPARATURE]["shape"] = "PAR_10_MA"

--PAR-10S without marker
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR]={}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR]["name"] = "ПАР-10С ОПРС"
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR]["elements"] = {}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR]["elements"][PAR_10_element_name.APPARATURE] = copy(beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.APPARATURE])
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR]["elements"][PAR_10_element_name.ANTENNA_MAST_1ST] = copy(beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.ANTENNA_MAST_1ST])
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR]["elements"][PAR_10_element_name.ANTENNA_MAST_2ND] = copy(beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.ANTENNA_MAST_2ND])
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR]["elements"][PAR_10_element_name.POWER_SOURCE] = copy(beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.POWER_SOURCE])
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR]["elements"][PAR_10_element_name.FUEL_DEPOT] = copy(beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.FUEL_DEPOT])
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR]["elements"][PAR_10_element_name.FENCE] = copy(beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_FAR_WITH_MARKER]["elements"][PAR_10_element_name.FENCE])

beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_NEAR]={}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_NEAR]["name"] = "ПАР-10С ОПРС"
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_NEAR]["elements"] = {}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_NEAR]["elements"][PAR_10_element_name.APPARATURE] = copy(beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_NEAR_WITH_MARKER]["elements"][PAR_10_element_name.APPARATURE])
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_NEAR]["elements"][PAR_10_element_name.ANTENNA_MAST_1ST] = copy(beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_NEAR_WITH_MARKER]["elements"][PAR_10_element_name.ANTENNA_MAST_1ST])
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_NEAR]["elements"][PAR_10_element_name.ANTENNA_MAST_2ND] = copy(beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_NEAR_WITH_MARKER]["elements"][PAR_10_element_name.ANTENNA_MAST_2ND])
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_NEAR]["elements"][PAR_10_element_name.POWER_SOURCE] = copy(beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_NEAR_WITH_MARKER]["elements"][PAR_10_element_name.POWER_SOURCE])
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_NEAR]["elements"][PAR_10_element_name.FUEL_DEPOT] = copy(beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_NEAR_WITH_MARKER]["elements"][PAR_10_element_name.FUEL_DEPOT])
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_NEAR]["elements"][PAR_10_element_name.FENCE] = copy(beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10S_NEAR_WITH_MARKER]["elements"][PAR_10_element_name.FENCE])

beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10_in_lighthouse]={}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10_in_lighthouse]["name"] = "ПАР-10 в башне маяка"
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10_in_lighthouse]["elements"] = {}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10_in_lighthouse]["elements"][PAR_10_element_name.APPARATURE] = {}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10_in_lighthouse]["elements"][PAR_10_element_name.APPARATURE]["type"] = TYPE_APPARATURE
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10_in_lighthouse]["elements"][PAR_10_element_name.APPARATURE]["shape"] = "majak"
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10_in_lighthouse]["elements"][PAR_10_element_name.APPARATURE]["dependencies"] = {1}

beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10_in_radio_tower]={}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10_in_radio_tower]["name"] = "ПАР-10 на вышке"
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10_in_radio_tower]["elements"] = {}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10_in_radio_tower]["elements"][PAR_10_element_name.APPARATURE] = {}
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10_in_radio_tower]["elements"][PAR_10_element_name.APPARATURE]["type"] = TYPE_APPARATURE
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10_in_radio_tower]["elements"][PAR_10_element_name.APPARATURE]["shape"] = "tele_bash_m"
beacon_system[SystemName.PAR_10]["sites"][PAR_10_site_name.PAR_10_in_radio_tower]["elements"][PAR_10_element_name.APPARATURE]["dependencies"] = {1}

--РСБН - РАДИОСИСТЕМА БЛИЖНЕЙ НАВИГАЦИИ
beacon_system[SystemName.RSBN_4H]["name"] = "РСБН-4H"
--beacon_system[SystemName.RSBN_4H]["devices"] = {}
beacon_system[SystemName.RSBN_4H]["default_site"] = RSBN_site_name.RSBN_ON_LAND
RSBN_element_name = 
{
	HILL = 1,
	APPARATURE = 2,
	ANTENNA_MAST_ST = 3,
	POWER_SOURCE = 4,
	FUEL_DEPOT = 5,
}
--RSBN on LAND
beacon_system[SystemName.RSBN_4H]["sites"] = {}
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_LAND] = {}
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_LAND]["name"] = "РСБН"
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_LAND]["elements"] = {}
--
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_LAND]["elements"][RSBN_element_name.APPARATURE] = {}
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_LAND]["elements"][RSBN_element_name.APPARATURE]["type"] = TYPE_APPARATURE
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_LAND]["elements"][RSBN_element_name.APPARATURE]["name"] = "Аппаратно-антенный модуль"
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_LAND]["elements"][RSBN_element_name.APPARATURE]["shape"] = "RSBN"
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_LAND]["elements"][RSBN_element_name.APPARATURE]["position"] = {}
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_LAND]["elements"][RSBN_element_name.APPARATURE]["position"]["S0"] = 0.0
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_LAND]["elements"][RSBN_element_name.APPARATURE]["position"]["Z0"] = 0.0
--
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_LAND]["elements"][RSBN_element_name.POWER_SOURCE] = {}
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_LAND]["elements"][RSBN_element_name.POWER_SOURCE]["type"] = TYPE_POWER_SOURCE
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_LAND]["elements"][RSBN_element_name.POWER_SOURCE]["name"] = "Дизель-генератор"
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_LAND]["elements"][RSBN_element_name.POWER_SOURCE]["shape"] = "RSBN_GENER"
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_LAND]["elements"][RSBN_element_name.POWER_SOURCE]["position"] = {}
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_LAND]["elements"][RSBN_element_name.POWER_SOURCE]["position"]["S0"] = 6.5
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_LAND]["elements"][RSBN_element_name.POWER_SOURCE]["position"]["Z0"] = -7.2
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_LAND]["elements"][RSBN_element_name.POWER_SOURCE]["position"]["rotate"] = 270.0
--
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_LAND]["elements"][RSBN_element_name.FUEL_DEPOT] = {}
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_LAND]["elements"][RSBN_element_name.FUEL_DEPOT]["type"] = TYPE_OTHER
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_LAND]["elements"][RSBN_element_name.FUEL_DEPOT]["name"] = "Склад ГСМ"
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_LAND]["elements"][RSBN_element_name.FUEL_DEPOT]["shape"] = "RSBN_GSM"
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_LAND]["elements"][RSBN_element_name.FUEL_DEPOT]["position"] = {}
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_LAND]["elements"][RSBN_element_name.FUEL_DEPOT]["position"]["S0"] = 8.0
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_LAND]["elements"][RSBN_element_name.FUEL_DEPOT]["position"]["Z0"] = 10.0
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_LAND]["elements"][RSBN_element_name.FUEL_DEPOT]["position"]["rotate"] = 90.0
--RSBN on HILL
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL] = {}
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["name"] = "Цивильный РСБН"
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"] = {}
--
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.HILL] = {}
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.HILL]["type"] = TYPE_OTHER
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.HILL]["name"] = "Холм"
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.HILL]["shape"] = "RSBN_HILL"
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.HILL]["position"] = {}
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.HILL]["position"]["S0"] = 3.0
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.HILL]["position"]["Z0"] = -3.0
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.HILL]["position"]["rotate"] = 90.0
--
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.APPARATURE] = {}
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.APPARATURE]["type"] = TYPE_APPARATURE
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.APPARATURE]["name"] = "Аппаратно-антенный модуль"
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.APPARATURE]["shape"] = "RSBN"
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.APPARATURE]["position"] = {}
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.APPARATURE]["position"]["S0"] = 0.0
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.APPARATURE]["position"]["Z0"] = 0.0
--
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.POWER_SOURCE] = {}
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.POWER_SOURCE]["type"] = TYPE_POWER_SOURCE
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.POWER_SOURCE]["name"] = "Дизель-генератор"
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.POWER_SOURCE]["shape"] = "RSBN_GENER"
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.POWER_SOURCE]["position"] = {}
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.POWER_SOURCE]["position"]["S0"] = 6.5
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.POWER_SOURCE]["position"]["Z0"] = -7.2
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.POWER_SOURCE]["position"]["rotate"] = 270.0
--
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.FUEL_DEPOT] = {}
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.FUEL_DEPOT]["type"] = TYPE_OTHER
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.FUEL_DEPOT]["name"] = "Склад ГСМ"
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.FUEL_DEPOT]["shape"] = "RSBN_GSM"
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.FUEL_DEPOT]["position"] = {}
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.FUEL_DEPOT]["position"]["S0"] = 8.0
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.FUEL_DEPOT]["position"]["Z0"] = 1.5
beacon_system[SystemName.RSBN_4H]["sites"][RSBN_site_name.RSBN_ON_HILL]["elements"][RSBN_element_name.FUEL_DEPOT]["position"]["rotate"] = 90.0


--BROADCAST STATION
beacon_system[SystemName.BROADCAST_STATION] = {}
beacon_system[SystemName.BROADCAST_STATION]["name"] = "Радиовещательная вышка"
beacon_system[SystemName.BROADCAST_STATION]["devices"] = {}
beacon_system[SystemName.BROADCAST_STATION]["default_site"] = Broadcast_Station_site_name.BROADCAST_TOWER
beacon_system[SystemName.BROADCAST_STATION]["sites"] = {}
beacon_system[SystemName.BROADCAST_STATION]["sites"][Broadcast_Station_site_name.BROADCAST_TOWER] = {}
beacon_system[SystemName.BROADCAST_STATION]["sites"][Broadcast_Station_site_name.BROADCAST_TOWER]["name"] = "Вышка широковещательной радиостанции"
beacon_system[SystemName.BROADCAST_STATION]["sites"][Broadcast_Station_site_name.BROADCAST_TOWER]["elements"] = {}
beacon_system[SystemName.BROADCAST_STATION]["sites"][Broadcast_Station_site_name.BROADCAST_TOWER]["elements"][1] = {}
beacon_system[SystemName.BROADCAST_STATION]["sites"][Broadcast_Station_site_name.BROADCAST_TOWER]["elements"][1]["type"] = TYPE_OTHER
beacon_system[SystemName.BROADCAST_STATION]["sites"][Broadcast_Station_site_name.BROADCAST_TOWER]["elements"][1]["name"] = "Вышка"
beacon_system[SystemName.BROADCAST_STATION]["sites"][Broadcast_Station_site_name.BROADCAST_TOWER]["elements"][1]["shape"] = "tele_bash_m"
beacon_system[SystemName.BROADCAST_STATION]["sites"][Broadcast_Station_site_name.BROADCAST_TOWER]["elements"][1]["dependencies"] = {1}

beacon_system[SystemName.BROADCAST_STATION]["devices"][1] = {}
beacon_system[SystemName.BROADCAST_STATION]["devices"][1]["type"] = DEVICE_TYPE_TRANSMITTER
beacon_system[SystemName.BROADCAST_STATION]["devices"][1]["name"] = "Вещательная станция на 1500 Вт."
beacon_system[SystemName.BROADCAST_STATION]["devices"][1]["freq_min"] = 88000000.0 --Hz
beacon_system[SystemName.BROADCAST_STATION]["devices"][1]["freq_max"] = 108000000.0 --Hz
beacon_system[SystemName.BROADCAST_STATION]["devices"][1]["power"] = 1500.0 --watt
beacon_system[SystemName.BROADCAST_STATION]["devices"][1]["bandwidth"] = 25000.0 --Hz
beacon_system[SystemName.BROADCAST_STATION]["devices"][1]["modulation"] = "FM" --watt