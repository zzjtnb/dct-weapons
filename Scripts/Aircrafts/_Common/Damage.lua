-- Damage model specific data.
-- Copyright (C) 2004, Eagle Dynamics.

-- the file is not intended for an end-user editing

------------------------------------------------------------
-- definitions
------------------------------------------------------------

damage_max_distance	= 75
damage_curvature	= 100
damage_total_damage	= 3.0
damage_pow		= 1/3
damage_use_new_damage	= true
damage_use_shield	= true

-- level 4
Default  = 0
-- all level4 loaded from wsTypes.lua , before executing this files


------------------------------------------------------------
-- functions
------------------------------------------------------------

function copy_table(tbl1)
	tbl2 = {}
	
	for k, v in pairs(tbl1) do
		tbl2[k] = v
	end
	
	return tbl2
end

-------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------



damage_cells = {}

-- Ref. WorldGeneral::DamageCells for enum names. - Made Dragon

-- IDx:
-- 0 - nose center
-- 1 - nose left
-- 2 - nose right
-- 3 - cockpit
-- 4 - cabin left
-- 5 - cabin right
-- 6 - cabin bottom 
-- 7 - gun
-- 8 - front gear
-- 9 - fuselage left
-- 10 - fuselage right
-- 11 - engine in left 
-- 12 - engine in right 
-- 13 - nacelle, left bottom
-- 14 - nacelle, right bottom
-- 15 - gear left 
-- 16 - gear right 
-- 17 - nacelle, left (left engine out, left ewu) 
-- 18 - nacelle, right (right engine out, right ewu) 
-- 19 - airbrake left 
-- 20 - airbrake right 
-- 21 - slat out left 
-- 22 - slat out right 
-- 23 - wing out left 
-- 24 - wing out right 
-- 25 - aileron left 
-- 26 - aileron right 
-- 27 - slat centre left 
-- 28 - slat centre right 
-- 29 - wing centre left 
-- 30 - wing centre right 
-- 31 - flap out left 
-- 32 - flap out right 
-- 33 - slat in left 
-- 34 - slat in right 
-- 35 - wing in left 
-- 36 - wing in right 
-- 37 - flap in left 
-- 38 - flap in right 
-- 39 - fin top left 
-- 40 - fin top right 
-- 41 - fin centre left
-- 42 - fin centre right
-- 43 - fin bottom left
-- 44 - fin bottom right
-- 45 - stabilizer out left
-- 46 - stabilizer out right
-- 47 - stabilizer in left
-- 48 - stabilizer in right
-- 49 - elevator out left
-- 50 - elevator out  right
-- 51 - elevator in left
-- 52 - elevator in right
-- 53 - rudder left
-- 54 - rudder right
-- 55 - tail
-- 56 - tail left
-- 57 - tail right
-- 58 - tail bottom
-- 59 - nose bottom
-- 60 - pitot
-- 61 - fuel tank front (left)
-- 62 - fuel tank  back (right)
-- 63 - rotor
-- 64 - blade 1 in
-- 65 - blade 1 centre
-- 66 - blade 1 out
-- 67 - blade 2 in
-- 68 - blade 2 centre
-- 69 - blade 2 out
-- 70 - blade 3 in
-- 71 - blade 3 centre
-- 72 - blade 3 out
-- 73 - blade 4 in
-- 74 - blade 4 centre
-- 75 - blade 4 out
-- 76 - blade 5 in
-- 77 - blade 5 centre
-- 78 - blade 5 out
-- 79 - blade 6 in
-- 80 - blade 6 centre
-- 81 - blade 6 out
-- 82 - fuselage bottom 
-- 83 - wheel nose
-- 84 - wheel left
-- 85 - wheel right
-- 86 - payload1
-- 87 - payload2
-- 88 - payload3
-- 89 - payload4
-- 90 - crew 1
-- 91 - crew 2
-- 92 - crew 3
-- 93 - crew 4
-- 94 - armor nose left
-- 95 - armor nose right
-- 96 - armor left
-- 97 - armor right
-- 98 - hook
-- 100 - tail top
-- 101 - flap centre left
-- 102 - flap centre right

-- 103 - engine # 1
-- 104 - engine # 2
-- 105 - engine # 3
-- 106 - engine # 4
-- 107 - engine # 5
-- 108 - engine # 6
-- 109 - engine # 7
-- 110 - engine # 8

-- 111 - custom range starts here (NB: update with new damage cells)

-------------------------------------------------------------

-- Nose
damage_cells["NOSE_CENTER"] = 0
damage_cells["FRONT"] = 0
damage_cells["Line_NOSE"] = 0

damage_cells["NOSE_LEFT_SIDE"] = 1

damage_cells["NOSE_RIGHT_SIDE"] = 2



-- Cockpit
damage_cells["COCKPIT"] = 3
damage_cells["CABINA"] = 3

damage_cells["CABIN_LEFT_SIDE"] = 4

damage_cells["CABIN_RIGHT_SIDE"] = 5

damage_cells["CABIN_BOTTOM"] = 6



-- Tertiary
damage_cells["GUN"] = 7



-- Undercarriage
damage_cells["FRONT_GEAR_BOX"] = 8
damage_cells["GEAR_REAR"] = 8
damage_cells["GEAR_C"] = 8
damage_cells["GEAR_F"] = 8
damage_cells["STOIKA_F"] = 8
damage_cells["GEAR_FRONT"] = 8



-- Fuselage
damage_cells["FUSELAGE_LEFT_SIDE"] = 9

damage_cells["FUSELAGE_RIGHT_SIDE"] = 10
damage_cells["MAIN"] = 10
damage_cells["Line_MAIN"] = 10



-- Engine
damage_cells["ENGINE"] = 11
damage_cells["ENGINE_L"] = 11
damage_cells["ENGINE_L_VNUTR"] = 11
damage_cells["ENGINE_L_IN"] = 11

damage_cells["ENGINE_R"] = 12
damage_cells["ENGINE_R_VNUTR"] = 12
damage_cells["ENGINE_R_IN"] = 12

damage_cells["MTG_L_BOTTOM"] = 13

damage_cells["MTG_R_BOTTOM"] = 14



-- Undercarriage (CONT'D)
damage_cells["LEFT_GEAR_BOX"] = 15
damage_cells["GEAR_L"] = 15
damage_cells["STOIKA_L"] = 15

damage_cells["RIGHT_GEAR_BOX"] = 16
damage_cells["GEAR_R"] = 16
damage_cells["STOIKA_R"] = 16



-- Engine (CONT'D)
damage_cells["MTG_L"] = 17
damage_cells["ENGINE_L_VNESHN"] = 17
damage_cells["ENGINE_L_OUT"] = 17
damage_cells["EWU_L"] = 17  -- for Helicopters

damage_cells["MTG_R"] = 18
damage_cells["ENGINE_R_VNESHN"] = 18
damage_cells["ENGINE_R_OUT"] = 18
damage_cells["EWU_R"] = 18  -- for Helicopters



-- Air Brake
damage_cells["AIR_BRAKE_L"] = 19

damage_cells["AIR_BRAKE_R"] = 20



-- Wings & Wing Appendexes
damage_cells["WING_L_PART_OUT"] = 21

damage_cells["WING_R_PART_OUT"] = 22

damage_cells["WING_L_OUT"] = 23

damage_cells["WING_R_OUT"] = 24

damage_cells["ELERON_L"] = 25
damage_cells["AILERON_L"] = 25

damage_cells["ELERON_R"] = 26
damage_cells["AILERON_R"] = 26

damage_cells["WING_L_PART_CENTER"] = 27

damage_cells["WING_R_PART_CENTER"] = 28

damage_cells["WING_L_CENTER"] = 29

damage_cells["WING_R_CENTER"] = 30

damage_cells["FLAP_L_OUT"] = 31

damage_cells["FLAP_R_OUT"] = 32

damage_cells["WING_L_PART_IN"] = 33

damage_cells["WING_R_PART_IN"] = 34

damage_cells["WING_L_IN"] = 35
damage_cells["WING_L"] = 35
damage_cells["Line_WING_L"] = 35

damage_cells["WING_R_IN"] = 36
damage_cells["WING_R"] = 36
damage_cells["Line_WING_R"] = 36



damage_cells["FLAP_L_IN"] = 37
damage_cells["FLAP_L"] = 37

damage_cells["FLAP_R_IN"] = 38
damage_cells["FLAP_R"] = 38



-- Keel
damage_cells["FIN_L_TOP"] = 39
damage_cells["KEEL_L_OUT"] = 39
damage_cells["KEEL_OUT"] = 39

damage_cells["FIN_R_TOP"] = 40
damage_cells["KEEL_R_OUT"] = 40

damage_cells["FIN_L_CENTER"] = 41
damage_cells["KEEL_L_CENTER"] = 41
damage_cells["KEEL_CENTER"] = 41

damage_cells["FIN_R_CENTER"] = 42
damage_cells["KEEL_R_CENTER"] = 42

damage_cells["FIN_L_BOTTOM"] = 43
damage_cells["KIL_L"] = 43
damage_cells["Line_KIL_L"] = 43
damage_cells["KEEL"] = 43
damage_cells["KEEL_IN"] = 43
damage_cells["KEEL_L"] = 43
damage_cells["KEEL_L_IN"] = 43

damage_cells["FIN_R_BOTTOM"] = 44
damage_cells["KIL_R"] = 44
damage_cells["Line_KIL_R"] = 44
damage_cells["KEEL_R"] = 44
damage_cells["KEEL_R_IN"] = 44



-- Stabilizers & Appendexes
damage_cells["STABILIZER_L_OUT"] = 45
damage_cells["STABILIZATOR_L_OUT"] = 45
damage_cells["STABILIZER_R_OUT"] = 46
damage_cells["STABILIZATOR_R_OUT"] = 46

damage_cells["STABILIZER_L_IN"] = 47
damage_cells["STABILIZATOR_L"] = 47
damage_cells["STABILIZATOR_L01"] = 47
damage_cells["Line_STABIL_L"] = 47

damage_cells["STABILIZER_R_IN"] = 48
damage_cells["STABILIZATOR_R"] = 48
damage_cells["STABILIZATOR_R01"] = 48
damage_cells["Line_STABIL_R"] = 48

damage_cells["ELEVATOR_L_OUT"] = 49

damage_cells["ELEVATOR_R_OUT"] = 50

damage_cells["ELEVATOR_L_IN"] = 51
damage_cells["ELEVATOR_L"] = 51
damage_cells["RV_L"] = 51

damage_cells["ELEVATOR_R_IN"] = 52
damage_cells["ELEVATOR_R"] = 52
damage_cells["RV_R"] = 52



-- Rudder & Keel Appendexes
damage_cells["RUDDER_L"] = 53
damage_cells["RN_L"] = 53
damage_cells["RUDDER"] = 53

damage_cells["RUDDER_R"] = 54
damage_cells["RN_R"] = 54



-- Tail Part
damage_cells["TAIL"] = 55

damage_cells["TAIL_LEFT_SIDE"] = 56

damage_cells["TAIL_RIGHT_SIDE"] = 57

damage_cells["TAIL_BOTTOM"] = 58



-- Tertiary (CONT'D)
damage_cells["NOSE_BOTTOM"] = 59

damage_cells["PWD"] = 60
damage_cells["PITOT"] = 60

damage_cells["FUEL_TANK_F"] = 61
damage_cells["FUEL_TANK_LEFT_SIDE"] = 61

damage_cells["FUEL_TANK_B"] = 62
damage_cells["FUEL_TANK_RIGHT_SIDE"] = 62



-- Rotary Parts
damage_cells["ROTOR"] = 63

damage_cells["BLADE_1_IN"] = 64
damage_cells["BLADE_1_CENTER"] = 65
damage_cells["BLADE_1_OUT"] = 66

damage_cells["BLADE_2_IN"] = 67
damage_cells["BLADE_2_CENTER"] = 68
damage_cells["BLADE_2_OUT"] = 69

damage_cells["BLADE_3_IN"] = 70
damage_cells["BLADE_3_CENTER"] = 71
damage_cells["BLADE_3_OUT"] = 72

damage_cells["BLADE_4_IN"] = 73
damage_cells["BLADE_4_CENTER"] = 74
damage_cells["BLADE_4_OUT"] = 75

damage_cells["BLADE_5_IN"] = 76
damage_cells["BLADE_5_CENTER"] = 77
damage_cells["BLADE_5_OUT"] = 78

damage_cells["BLADE_6_IN"] = 79
damage_cells["BLADE_6_CENTER"] = 80
damage_cells["BLADE_6_OUT"] = 81



-- Fuselage (CONT'D)
damage_cells["FUSELAGE_BOTTOM"] = 82



-- Undercarriage (Yet CONT'D)
damage_cells["WHEEL_F"] = 83
damage_cells["WHEEL_C"] = 83
damage_cells["WHEEL_REAR"] = 83
damage_cells["WHEEL_FRONT"] = 83

damage_cells["WHEEL_L"] = 84

damage_cells["WHEEL_R"] = 85



-- Tertiary (Yet CONT'D)
damage_cells["PYLON1"] = 86
damage_cells["PYLONL"] = 86

damage_cells["PYLON2"] = 87
damage_cells["PYLONR"] = 87

damage_cells["PYLON3"] = 88

damage_cells["PYLON4"] = 89



-- Crew Members
damage_cells["CREW_1"] = 90
damage_cells["CREW_2"] = 91
damage_cells["CREW_3"] = 92
damage_cells["CREW_4"] = 93



-- Exterior Armor Plates
damage_cells["ARMOR_NOSE_PLATE_LEFT"] = 94
damage_cells["ARMOR_NOSE_PLATE_RIGHT"] = 95
damage_cells["ARMOR_PLATE_LEFT"] = 96
damage_cells["ARMOR_PLATE_RIGHT"] = 97



-- Arresting Hook
damage_cells["HOOK"] = 98



-- Fuselage (Yet CONT'D)
damage_cells["FUSELAGE_TOP"] = 99



-- Tail (CONT'D)
damage_cells["TAIL_TOP"] = 100



-- Wings (CONT'D)
damage_cells["FLAP_L_CENTER"] = 101
damage_cells["FLAP_R_CENTER"] = 102

-- Motors by number
damage_cells["ENGINE_1"] = 103
damage_cells["ENGINE_2"] = 104
damage_cells["ENGINE_3"] = 105
damage_cells["ENGINE_4"] = 106
damage_cells["ENGINE_5"] = 107
damage_cells["ENGINE_6"] = 108
damage_cells["ENGINE_7"] = 109
damage_cells["ENGINE_8"] = 110

-- Custom range starts here
damage_cells["MaxValue"] = 111

-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------



function verbose_to_dmg_properties(verbose_table)
	local start_index  = damage_cells["MaxValue"]
	local sorted 	  = {}
	local indices 	  = {}
	local sorted_flag = {}

	local store_for_sort =  function (key)
		if  sorted_flag[key]  then
			return
		end
		sorted_flag[key]    = true
		sorted[#sorted + 1] = key
	end
	for i,o in pairs(verbose_table) do
		store_for_sort(i)
		if o.deps_cells then
		   for j,chld in ipairs(o.deps_cells) do
			   store_for_sort(chld)
		   end
		end
		if o.children then
		   for j,chld in ipairs(o.children) do
			   store_for_sort(chld)
		   end
		end
	end
	--sort in alphabetical order for stable indices
	table.sort(sorted)
	
	local new_keys_count = 0
	for i,key in ipairs(sorted) do
		local idx = damage_cells[key]
		if  not idx then
			idx 		   = start_index    + new_keys_count
			new_keys_count = new_keys_count + 1
		end
		indices[key] = idx
	end

	local out   = {}
	for i,key in ipairs(sorted) do
		local cell_index 	  = indices		 [key]
		local o 			  = verbose_table[key]
        if o == nil then
            print("ERROR: No cell named", key)
        end
		local entry		      = {}
		
		entry.critical_damage = o.critical_damage
		entry.args 			  = o.args
		entry.damage_boundary = o.damage_boundary
		entry.droppable		  = o.droppable 
		entry.droppable_shape = o.droppable_shape 
		if o.deps_cells ~= nil then
		   entry.deps_cells = {}
		   local k = 0
		   for j,chld in ipairs(o.deps_cells) do
			   entry.deps_cells[j] = indices[chld]
		   end
		end
		if o.children ~= nil then
		   entry.children = {}
		   local k = 0
		   for j,chld in ipairs(o.children) do
			   entry.children[j] = indices[chld]
		   end
		end
        entry.construction = o.construction
        entry.detachable = o.detachable
        entry.innards = o.innards
        entry.failures = o.failures
		out[cell_index] = entry
	end
	if  new_keys_count > 0 then
		out.cell_indices = indices
	end
	return out
end



function verbose_to_failures_table ( failures_compacted_table )
    local out = {}

    for i,o in pairs(failures_compacted_table) do
        local entry = {}
        entry.id = o.id
        entry.label = o.label
        entry.enable = o.enable or false
        entry.hh = o.hh or 0
        entry.mm = o.mm or 0
        entry.mint = o.mint or 1
        entry.prob = o.prob or 100
        entry.hidden = o.hidden or false
        out[i] = entry
    end

    return out
end



------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------



default_cells_properties = {
	[0] = {critical_damage = 5, args = {82}},
	[3] = {critical_damage = 10, args = {65}},
	[8] = {critical_damage = 10},
	[11] = {critical_damage = 3},
	[12] = {critical_damage = 3},
	[15] = {critical_damage = 10},
	[16] = {critical_damage = 10},
	[17] = {critical_damage = 3},
	[18] = {critical_damage = 3},
	[25] = {critical_damage = 5, args = {53}},
	[26] = {critical_damage = 5, args = {54}},
	[35] = {critical_damage = 10, args = {67}, deps_cells = {25, 37}},
	[36] = {critical_damage = 10, args = {68}, deps_cells = {26, 38}},
	[37] = {critical_damage = 4, args = {55}},
	[38] = {critical_damage = 4, args = {56}},
	[43] = {critical_damage = 4, args = {61}, deps_cells = {53}},
	[44] = {critical_damage = 4, args = {62}, deps_cells = {54}},
	[47] = {critical_damage = 5, args = {63}, deps_cells = {51}},
	[48] = {critical_damage = 5, args = {64}, deps_cells = {52}},
	[51] = {critical_damage = 2, args = {59}},
	[52] = {critical_damage = 2, args = {60}},
	[53] = {critical_damage = 2, args = {57}},
	[54] = {critical_damage = 2, args = {58}},
	[55] = {critical_damage = 15, args = {81}},
}



typical_single_engined_fighter = {
	[0]  = {critical_damage = 3, args = {82}},
	[3]  = {critical_damage = 10, args = {65}},
	[8]  = {critical_damage = 3},
	[11] = {critical_damage = 3},
	[12] = {critical_damage = 3},
	[15] = {critical_damage = 5},
	[16] = {critical_damage = 5},
	[17] = {critical_damage = 3},
	[18] = {critical_damage = 3},
	[25] = {critical_damage = 3, args = {53}},
	[26] = {critical_damage = 3, args = {54}},
	[35] = {critical_damage = 5, args = {67}, deps_cells = {25, 37}},
	[36] = {critical_damage = 5, args = {68}, deps_cells = {26, 38}},
	[37] = {critical_damage = 2, args = {55}},
	[38] = {critical_damage = 2, args = {56}},
	[43] = {critical_damage = 2, args = {61}, deps_cells = {53}},
	[44] = {critical_damage = 2, args = {62}, deps_cells = {54}},
	[47] = {critical_damage = 3, args = {63}, deps_cells = {51}},
	[48] = {critical_damage = 3, args = {64}, deps_cells = {52}},
	[51] = {critical_damage = 2, args = {59}},
	[52] = {critical_damage = 2, args = {60}},
	[53] = {critical_damage = 2, args = {57}},
	[54] = {critical_damage = 2, args = {58}},
	[55] = {critical_damage = 10, args = {81}},
}
------------------------------------------------------------

wing_engine_cells_properties = copy_table(default_cells_properties)
wing_engine_cells_properties[35] = {critical_damage = 20, args = {67}, deps_cells = {25, 37, 11, 17}}
wing_engine_cells_properties[36] = {critical_damage = 20, args = {68}, deps_cells = {26, 38, 12, 18}}

------------------------------------------------------------

T_Tail_cells_properties = copy_table(wing_engine_cells_properties)
T_Tail_cells_properties[43] = {critical_damage = 10, args = {61}, deps_cells = {53, 47, 48, 51, 52}}

------------------------------------------------------------

armour_canopy_cells_properties = copy_table(default_cells_properties)
armour_canopy_cells_properties[3] = {critical_damage = 20, args = {65}}

------------------------------------------------------------

su25t_cells_properties = {                                                                                        
	[0] = {critical_damage = 10, args = {146}, deps_cells = {1, 2}}                                               ,
	[1] = {critical_damage = 10, args = {146, 296, 297}}                                                          ,
	[2] = {critical_damage = 10, args = {146, 298, 299}}                                                          ,
	[3] = {critical_damage = 15, args = {65}}                                                                     ,
	[4] = {critical_damage = 14, args = {147, 150}, deps_cells = {0, 1, 2, 3}}                                    ,
	[5] = {critical_damage = 14, args = {147, 149}, deps_cells = {0, 1, 2, 3}}                                    ,
	[6] = {critical_damage = 14, args = {147}, deps_cells = {0, 1, 2, 3, 4, 5}}                                   ,
	[7] = {critical_damage = 4}                                                                                   ,
	[8] = {critical_damage = 5, args = {265, 134}}                                                                ,
	[9] = {critical_damage = 8, args = {154, 299}}                                                                ,
	[10] = {critical_damage = 8, args = {153, 303}}                                                               ,
	[11] = {critical_damage = 3, args = {167}}                                                                    ,
	[12] = {critical_damage = 3, args = {161}}                                                                    ,
	[13] = {critical_damage = 3, args = {169}}                                                                    ,
	[14] = {critical_damage = 3, args = {163}}                                                                    ,
	[15] = {critical_damage = 5,args = {266, 135}}                                                                ,
	[16] = {critical_damage = 5,args = {267, 136}}                                                                ,
	[17] = {critical_damage = 5, args = {168}}                                                                    ,
	[18] = {critical_damage = 5, args = {162}}                                                                    ,
	[19] = {critical_damage = 4, args = {187}}                                                                    ,
	[20] = {critical_damage = 4, args = {183}}                                                                    ,
	[21] = {critical_damage = 3, args = {230}}                                                                    ,
	[22] = {critical_damage = 3, args = {220}}                                                                    ,
	[23] = {critical_damage = 8, args = {223}, deps_cells = {19, 21, 25}}                                         ,
	[24] = {critical_damage = 8, args = {213}, deps_cells = {20, 22, 26}}                                         ,
	[25] = {critical_damage = 3, args = {226}}                                                                    ,
	[26] = {critical_damage = 3, args = {216}}                                                                    ,
	[27] = {critical_damage = 4, args = {231}}                                                                    ,
	[28] = {critical_damage = 4, args = {221}}                                                                    ,
	[29] = {critical_damage = 9, args = {224}, deps_cells = {19, 21, 23, 25, 27, 31}}                             ,
	[30] = {critical_damage = 9, args = {214}, deps_cells = {20, 22, 24, 26, 28, 32}}                             ,
	[31] = {critical_damage = 4, args = {227}}                                                                    ,
	[32] = {critical_damage = 4, args = {217}}                                                                    ,
	[33] = {critical_damage = 4, args = {232}}                                                                    ,
	[34] = {critical_damage = 4, args = {222}}                                                                    ,
	[35] = {critical_damage = 10, args = {225}, deps_cells = {19, 21, 23, 25, 27, 29, 31, 37, 33}}                ,
	[36] = {critical_damage = 10, args = {215}, deps_cells = {20, 22, 24, 26, 28, 30, 32, 38 ,34}}                ,
	[37] = {critical_damage = 3, args = {228}}                                                                    ,
	[38] = {critical_damage = 3, args = {218}}                                                                    ,
	[40] = {critical_damage = 3, args = {241}}                                                                    ,
	[42] = {critical_damage = 3, args = {242}, deps_cells = {40, 53}}                                             ,
	[44] = {critical_damage = 4, args = {243}, deps_cells = {40, 42, 53, 54}}                                     ,
	[45] = {critical_damage = 4, args = {235}, deps_cells = {49}}                                                 ,
	[46] = {critical_damage = 4, args = {233}, deps_cells = {50}}                                                 ,
	[47] = {critical_damage = 3, args = {236}, deps_cells = {45, 51, 49}}                                         ,
	[48] = {critical_damage = 3, args = {234}, deps_cells = {46, 50, 52}}                                         ,
	[49] = {critical_damage = 2, args = {239}}                                                                    ,
	[50] = {critical_damage = 2, args = {237}}                                                                    ,
	[51] = {critical_damage = 2, args = {240}}                                                                    ,
	[52] = {critical_damage = 2, args = {238}}                                                                    ,
	[53] = {critical_damage = 2, args = {248}}                                                                    ,
	[54] = {critical_damage = 2, args = {247}}                                                                    ,
	[55] = {critical_damage = 10, args = {81}, deps_cells = {45, 51, 49, 46, 50, 52, 44, 40, 42, 53, 54, 47, 48}} ,
}
------------------------------------------------------------

-- Moved to CoreMods
--[[
a10_cells_properties = {
	[0]		= {critical_damage = 5, args = {146}}                                                ,
	[3]		= {critical_damage = 20,args = {65}}                                                 ,
	[4]		= {critical_damage = 20, args = {150}}                                               ,
	[5]		= {critical_damage = 20, args = {147}}                                               ,
	[7]		= {critical_damage = 4, args = {249}}                                                ,
	[9]		= {critical_damage = 3, args = {154}}                                                ,
	[10]	= {critical_damage = 3, args = {153}}                                                ,
	[11]	= {critical_damage = 3, args = {167}}                                                ,
	[12]	= {critical_damage = 3, args = {161}}                                                ,
	[15]	= {critical_damage = 5, args = {267}}                                                ,
	[16]	= {critical_damage = 5, args = {266}}                                                ,
	[23]	= {critical_damage = 8, args = {223}, deps_cells = {25}}                             ,
	[24]	= {critical_damage = 8, args = {213}, deps_cells = {26, 60}}                         ,
	[25]	= {critical_damage = 3, args = {226}}                                                ,
	[26]	= {critical_damage = 3, args = {216}}                                                ,
	[29]	= {critical_damage = 9, args = {224}, deps_cells = {31, 25, 23}}                     ,
	[30]	= {critical_damage = 9, args = {214}, deps_cells = {32, 26, 24, 60}}                 ,
	[31]	= {critical_damage = 4, args = {229}}                                                ,
	[32]	= {critical_damage = 4, args = {219}}                                                ,
	[35]	= {critical_damage = 10, args = {225}, deps_cells = {29, 31, 25, 23}}                ,
	[36]	= {critical_damage = 10, args = {215}, deps_cells = {30, 32, 26, 24, 60}}            ,
	[37]	= {critical_damage = 4, args = {227}}                                                ,
	[38]	= {critical_damage = 4, args = {217}}                                                ,
	[39]	= {critical_damage = 7,	args = {244}, deps_cells = {53}}                             ,
	[40]	= {critical_damage = 7, args = {241}, deps_cells = {54}}                             ,
	[45]	= {critical_damage = 9, args = {235}, deps_cells = {39, 51, 53}}                     ,
	[46]	= {critical_damage = 9, args = {233}, deps_cells = {40, 52, 54}}                     ,
	[51]	= {critical_damage = 3, args = {239}}                                                ,
	[52]	= {critical_damage = 3, args = {237}}                                                ,
	[53]	= {critical_damage = 3, args = {248}}                                                ,
	[54]	= {critical_damage = 3, args = {247}}                                                ,
	[55]	= {critical_damage = 20, args = {81}, deps_cells = {39, 40, 45, 46, 51, 52, 53, 54}} ,
	[59]	= {critical_damage = 5, args = {148}}                                                ,
	[60]	= {critical_damage = 1, args = {144}}                                                ,
	[83]	= {critical_damage = 3, args = {134}}, -- nose wheel                                  
	[84]	= {critical_damage = 3, args = {136}}, -- left wheel                                  
	[85]	= {critical_damage = 3, args = {135}}, -- right wheel                                 
}
--]]
------------------------------------------------------------

p51d_cells_properties = {
	[11]		= {critical_damage = 3, args = {147}}, -- engine l
	[39]		= {critical_damage = 2, args = {242}}, -- fin top left
	[43]		= {critical_damage = 5, args = {243}, deps_cells = {39, 54, 45, 46, 49, 50}}, -- fin bottom left
	[54]		= {critical_damage = 1, args = {247}}, -- rudder right
	[45]		= {critical_damage = 2, args = {235}}, -- stabilizer out left
	[47]		= {critical_damage = 3, args = {236}, deps_cells = {49}} ,-- stabilizer in left
	[46]		= {critical_damage = 2, args = {233}}, -- stabilizer out right
	[48]		= {critical_damage = 3, args = {234}, deps_cells = {50}}, -- stabilizer in right
	[49]		= {critical_damage = 1, args = {240}},-- elevator out left
	[50]		= {critical_damage = 1, args = {238}},-- elevator out right
	[4]		= {critical_damage = 2, args = {154}},-- cabin left
	[5]		= {critical_damage = 2, args = {153}},-- cabin right
	[82]		= {critical_damage = 3, args = {152}},-- fuselage bottom
	[56]		= {critical_damage = 3, args = {158}},-- tail left
	[57]		= {critical_damage = 3, args = {157}},-- tail right
	[55]		= {critical_damage = 6, args = {81}, deps_cells = {43, 54, 45, 46}}, -- tail 
	[3]		= {critical_damage = 1, args = {65}}, -- cockpit 
	[59]		= {critical_damage = 3, args = {148}}, -- nose bottom 
	[1]		= {critical_damage = 2, args = {150}}, -- nose left
	[2]		= {critical_damage = 2, args = {149}}, -- nose right
	[24]		= {critical_damage = 6, args = {213}, deps_cells = {26}},-- wing out right 
	[30]		= {critical_damage = 7, args = {214}, deps_cells = {24, 26, 38}},-- wing center right 
	[36]		= {critical_damage = 7, args = {215}, deps_cells = {30, 24, 26, 38}}, -- wing in right 
	[26]		= {critical_damage = 1, args = {216}}, -- eleron right 
	[38]		= {critical_damage = 2, args = {217}},-- flap in right 
	[23]		= {critical_damage = 6, args = {223}, deps_cells = {25}}, -- wing out left
	[29]		= {critical_damage = 7, args = {224}, deps_cells = {23, 25, 37}}, -- wing center left 
	[35]		= {critical_damage = 7, args = {225}, deps_cells = {29, 23, 25, 37}}, -- wing in left 
	[25]		= {critical_damage = 1, args = {226}}, -- eleron left 
	[37]		= {critical_damage = 2, args = {227}}, -- flap in left 
	[83]		= {critical_damage = 2, args = {134}}, -- wheel nose 
	[85]		= {critical_damage = 3, args = {135}}, -- wheel right 
	[84]		= {critical_damage = 3, args = {136}}, -- wheel left 
	[63]		= {critical_damage = 3, args = {53}, deps_cells = {66, 69, 72, 75}}, -- rotor
	[66]		= {critical_damage = 3, args = {270}}, -- blade 1 out
	[69]		= {critical_damage = 3, args = {271}}, -- blade 2 out
	[72]		= {critical_damage = 3, args = {272}}, -- blade 3 out
	[75]		= {critical_damage = 3, args = {273}}, -- blade 4 out
	[64]		= {critical_damage = 3, args = {429}}, -- blade 1 in  (for contact model!)
	[67]		= {critical_damage = 3, args = {430}}, -- blade 2 in  (for contact model!)
	[70]		= {critical_damage = 3, args = {431}}, -- blade 3 in  (for contact model!)
	[73]		= {critical_damage = 3, args = {119}}, -- blade 4 in  (for contact model!)
}
------------------------------------------------------------

AN_26B_cells_properties = {
	[0]  = {critical_damage = 6, args = {146}},
	[1]  = {critical_damage = 5, args = {296}},
	[2]  = {critical_damage = 5, args = {297}},
	[3]  = {critical_damage = 15, args = {65}},
	[9]  = {critical_damage = 6, args = {154}},
	[10] = {critical_damage = 6, args = {153}},
	[15] = {critical_damage = 6, args = {267}},
	[16] = {critical_damage = 6, args = {266}},
	[11] = {critical_damage = 6, args = {168}},
	[12] = {critical_damage = 6, args = {162}},
	[23] = {critical_damage = 6, args = {223}, deps_cells = {25}},
	[24] = {critical_damage = 6, args = {213}, deps_cells = {26}},
	[25] = {critical_damage = 6, args = {226}},
	[26] = {critical_damage = 6, args = {216}},
	[29] = {critical_damage = 8, args = {224}, deps_cells = {23, 25}},
	[30] = {critical_damage = 8, args = {214}, deps_cells = {24, 26}},
	[35] = {critical_damage = 20, args = {225}, deps_cells = {11, 29, 23, 25}},
	[36] = {critical_damage = 20, args = {215}, deps_cells = {12, 30, 24, 26}},
	[43] = {critical_damage = 6, args = {244}, deps_cells = {54}},
	[44] = {critical_damage = 6, args = {241}, deps_cells = {54}},
	[47] = {critical_damage = 6, args = {236}, deps_cells = {51}},
	[48] = {critical_damage = 6, args = {234}, deps_cells = {52}},
	[51] = {critical_damage = 6, args = {240}},
	[52] = {critical_damage = 6, args = {238}},
	[54] = {critical_damage = 6, args = {247}},
	[55] = {critical_damage = 50, args = {159}, deps_cells = {56, 57, 58, 43, 44, 54, 48, 52, 47, 51}},
	[56] = {critical_damage = 50, args = {158}, deps_cells = {43, 44, 54, 48, 52, 47, 51}},
	[57] = {critical_damage = 50, args = {157}, deps_cells = {43, 44, 54, 48, 52, 47, 51}},
	[58] = {critical_damage = 50, args = {156}, deps_cells = {43, 44, 54, 48, 52, 47, 51}},
	[61] = {critical_damage = 4, args = {147}},
	[62] = {critical_damage = 6, args = {250}},
	[82] = {critical_damage = 6, args = {152}},
}
------------------------------------------------------------

E_2C_cells_properties = {
	[0]  = {critical_damage = 6, args = {146}},  
	[1]  = {critical_damage = 5, args = {296}},
	[2]  = {critical_damage = 5, args = {297}},
	[3]  = {critical_damage = 15, args = {65}},
	[9]  = {critical_damage = 6, args = {154}},
	[10] = {critical_damage = 6, args = {153}},
	[11] = {critical_damage = 6, args = {167}},
	[12] = {critical_damage = 6, args = {161}},
	[13] = {critical_damage = 10, args = {66}},
	[14] = {critical_damage = 10, args = {162}},
	[15] = {critical_damage = 6, args = {267}},
	[16] = {critical_damage = 6, args = {266}},
	[23] = {critical_damage = 6, args = {223}, deps_cells = {25}},
	[24] = {critical_damage = 6, args = {213}, deps_cells = {26}},
	[25] = {critical_damage = 6, args = {226}},
	[26] = {critical_damage = 6, args = {216}},
	[29] = {critical_damage = 8, args = {224}, deps_cells = {23, 25, 31}},
	[30] = {critical_damage = 8, args = {214}, deps_cells = {24, 26, 32}},
	[31] = {critical_damage = 5, args = {227}},
	[32] = {critical_damage = 5, args = {217}},
	[35] = {critical_damage = 20, args = {225}, deps_cells = {11, 29, 23, 25, 31, 37}},
	[36] = {critical_damage = 20, args = {215}, deps_cells = {12, 30, 24, 26, 32, 38}},
	[37] = {critical_damage = 5, args = {228}},
	[38] = {critical_damage = 5, args = {218}},
	[39] = {critical_damage = 6, args = {244}, deps_cells = {53}},
	[40] = {critical_damage = 6, args = {241}, deps_cells = {54}},
	[47] = {critical_damage = 12, args = {236}, deps_cells = {51, 39, 53}},
	[48] = {critical_damage = 12, args = {234}, deps_cells = {52, 40, 54}},
	[51] = {critical_damage = 6, args = {240}},
	[52] = {critical_damage = 6, args = {238}},
	[53] = {critical_damage = 6, args = {248}},
	[54] = {critical_damage = 6, args = {247}},
	[55] = {critical_damage = 50, args = {159}, deps_cells = {56, 57, 58, 47, 51, 39, 53, 48, 52, 40, 54}},
	[56] = {critical_damage = 50, args = {158}, deps_cells = {47, 51, 39, 53, 48, 52, 40, 54}},
	[57] = {critical_damage = 50, args = {157}, deps_cells = {47, 51, 39, 53, 48, 52, 40, 54}},
	[58] = {critical_damage = 50, args = {156}, deps_cells = {47, 51, 39, 53, 48, 52, 40, 54}},
	[59] = {critical_damage = 6, args = {148}},
	[61] = {critical_damage = 4, args = {147}},
	[82] = {critical_damage = 6, args = {152}},
}
------------------------------------------------------------

KC_135_cells_properties = {
	[0]	= {critical_damage = 5, args = {146}},
	[3]	= {critical_damage = 20,args = {65}},  
	[4]	= {critical_damage = 5, args = {150}},
	[5]	= {critical_damage = 5, args = {147}},
	[6]	= {critical_damage = 5, args = {152}}, 
	[9]	= {critical_damage = 4, args = {148}},
	[10]	= {critical_damage = 4, args = {149}},
	[11]	= {critical_damage = 3, args = {167}},
	[12]	= {critical_damage = 3, args = {161}},
	[17]	= {critical_damage = 3, args = {162}},
	[18]	= {critical_damage = 3, args = {163}},
	[23]	= {critical_damage = 8, args = {223}, deps_cells = {25}},
	[24]	= {critical_damage = 8, args = {213}, deps_cells = {26}},
	[25]	= {critical_damage = 3, args = {226}},
	[26]	= {critical_damage = 3, args = {216}},
	[29]	= {critical_damage = 9, args = {224}, deps_cells = {25, 23}},
	[30]	= {critical_damage = 9, args = {214}, deps_cells = {26, 24}},
	[35]	= {critical_damage = 20, args = {225}, deps_cells = {29, 25, 23, 12, 18}},
	[36]	= {critical_damage = 20, args = {215}, deps_cells = {30, 26, 24, 11, 17}}, 
	[43]	= {critical_damage = 9, args = {142}, deps_cells = {53}},
	[47]	= {critical_damage = 5, args = {236}, deps_cells = {51}},
	[48]	= {critical_damage = 5, args = {234}, deps_cells = {52}},
	[51]	= {critical_damage = 3, args = {240}},
	[52]	= {critical_damage = 3, args = {237}},
	[53]	= {critical_damage = 3, args = {248}},
	[56]	= {critical_damage = 5, args = {141}},
	[57]	= {critical_damage = 5, args = {140}},
	[55]	= {critical_damage = 5, args = {159}},
	[61]	= {critical_damage = 6, args = {151}},
	[82]	= {critical_damage = 5, args = {153}},
}
------------------------------------------------------------

IL_76_cells_properties = {
	[0]	= {critical_damage = 5, args = {146}},
	[3]	= {critical_damage = 20,args = {65}},  
	[4]	= {critical_damage = 5, args = {150}},
	[5]	= {critical_damage = 5, args = {149}},
	[6]	= {critical_damage = 200, args = {82}, deps_cells = {0, 3, 4, 5, 59}},
	[7]	= {critical_damage = 3, args = {249}},
	[9]	= {critical_damage = 4, args = {154}},
	[10]	= {critical_damage = 4, args = {153}},
	[11]	= {critical_damage = 3, args = {167}},
	[12]	= {critical_damage = 3, args = {161}},
	[17]	= {critical_damage = 3, args = {162}},
	[18]	= {critical_damage = 3, args = {163}},
	[19]	= {critical_damage = 5, args = {183}},
	[20]	= {critical_damage = 5, args = {185}},
	[23]	= {critical_damage = 15, args = {223}, deps_cells = {25}},
	[24]	= {critical_damage = 15, args = {213}, deps_cells = {26}},
	[25]	= {critical_damage = 3, args = {226}},
	[26]	= {critical_damage = 3, args = {216}},
	[29]	= {critical_damage = 50, args = {224}, deps_cells = {25, 23, 11, 17, 19, 31, 37}},
	[30]	= {critical_damage = 50, args = {214}, deps_cells = {26, 24, 12, 18, 20, 32, 38}},
	[31]	= {critical_damage = 5, args = {229}},
	[32]	= {critical_damage = 5, args = {219}},
	[35]	= {critical_damage = 30, args = {225}, deps_cells = {29, 11, 19, 31, 37}},
	[36]	= {critical_damage = 30, args = {215}, deps_cells = {30, 12, 20, 32, 38}}, 
	[37]	= {critical_damage = 5, args = {227}},
	[38]	= {critical_damage = 5, args = {217}},
	[39]	= {critical_damage = 20, args = {244}, deps_cells = {47, 48, 51, 52, 53}},
	[43]	= {critical_damage = 20, args = {243}, deps_cells = {39, 47, 48, 51, 52, 53}},
	[47]	= {critical_damage = 5, args = {235}, deps_cells = {51}},
	[48]	= {critical_damage = 5, args = {234}, deps_cells = {52}},
	[51]	= {critical_damage = 3, args = {237}},
	[52]	= {critical_damage = 3, args = {239}},
	[53]	= {critical_damage = 3, args = {248}},
	[55]	= {critical_damage = 200, args = {81}, deps_cells = {43, 39, 47, 48, 51, 52, 53, 57, 58}},
	[56]	= {critical_damage = 5, args = {141}},
	[57]	= {critical_damage = 5, args = {140}},
	[58]	= {critical_damage = 7, args = {156}},
	[59]	= {critical_damage = 5, args = {148}},
	[61]	= {critical_damage = 8, args = {151}},
	[82]	= {critical_damage = 8, args = {152}},
}
------------------------------------------------------------

F_15_cells_properties = {
	[0]  = {critical_damage = 5,  args = {146}},
	[1]  = {critical_damage = 3,  args = {296}},
	[2]  = {critical_damage = 3,  args = {297}},
	[3]  = {critical_damage = 8, args = {65}},
	[4]  = {critical_damage = 2,  args = {298}},
	[5]  = {critical_damage = 2,  args = {301}},
	[7]  = {critical_damage = 2,  args = {249}},
	[8]  = {critical_damage = 3,  args = {265}},
	[9]  = {critical_damage = 3,  args = {154}},
	[10] = {critical_damage = 3,  args = {153}},
	[11] = {critical_damage = 1,  args = {167}},
	[12] = {critical_damage = 1,  args = {161}},
	[13] = {critical_damage = 2,  args = {169}},
	[14] = {critical_damage = 2,  args = {163}},
	[15] = {critical_damage = 2,  args = {267}},
	[16] = {critical_damage = 2,  args = {266}},
	[17] = {critical_damage = 2,  args = {168}},
	[18] = {critical_damage = 2,  args = {162}},
	[20] = {critical_damage = 2,  args = {183}},
	[23] = {critical_damage = 5, args = {223}},
	[24] = {critical_damage = 5, args = {213}},
	[25] = {critical_damage = 2,  args = {226}},
	[26] = {critical_damage = 2,  args = {216}},
	[29] = {critical_damage = 5, args = {224}, deps_cells = {23, 25}},
	[30] = {critical_damage = 5, args = {214}, deps_cells = {24, 26}},
	[35] = {critical_damage = 6, args = {225}, deps_cells = {23, 29, 25, 37}},
	[36] = {critical_damage = 6, args = {215}, deps_cells = {24, 30, 26, 38}}, 
	[37] = {critical_damage = 2,  args = {228}},
	[38] = {critical_damage = 2,  args = {218}},
	[39] = {critical_damage = 2,  args = {244}, deps_cells = {53}}, 
	[40] = {critical_damage = 2,  args = {241}, deps_cells = {54}}, 
	[43] = {critical_damage = 2,  args = {243}, deps_cells = {39, 53}},
	[44] = {critical_damage = 2,  args = {242}, deps_cells = {40, 54}}, 
	[51] = {critical_damage = 2,  args = {240}}, 
	[52] = {critical_damage = 2,  args = {238}},
	[53] = {critical_damage = 2,  args = {248}},
	[54] = {critical_damage = 2,  args = {247}},
	[56] = {critical_damage = 2,  args = {158}},
	[57] = {critical_damage = 2,  args = {157}},
	[59] = {critical_damage = 3,  args = {148}},
	[61] = {critical_damage = 2,  args = {147}},
	[82] = {critical_damage = 2,  args = {152}},
}
------------------------------------------------------------

Su_27_cells_properties = {
	[0]  = {critical_damage = 5,  args = {146}},
	[1]  = {critical_damage = 3,  args = {296}},
	[2]  = {critical_damage = 3,  args = {297}},
	[3]  = {critical_damage = 8,  args = {65}},
	[4]  = {critical_damage = 2,  args = {298}},
	[5]  = {critical_damage = 2,  args = {301}},
	[7]  = {critical_damage = 2,  args = {249}},
	[8]  = {critical_damage = 2,  args = {265}},
	[9]  = {critical_damage = 3,  args = {154}},
	[10] = {critical_damage = 3,  args = {153}},
	[11] = {critical_damage = 1,  args = {167}},
	[12] = {critical_damage = 1,  args = {161}},
	[13] = {critical_damage = 2,  args = {169}},
	[14] = {critical_damage = 2,  args = {163}},
	[15] = {critical_damage = 2,  args = {267}},
	[16] = {critical_damage = 2,  args = {266}},
	[17] = {critical_damage = 2,  args = {168}},
	[18] = {critical_damage = 2,  args = {162}},
	[20] = {critical_damage = 1,  args = {183}},
	[23] = {critical_damage = 5,  args = {223}},
	[24] = {critical_damage = 5,  args = {213}},
	[27] = {critical_damage = 3,  args = {231}},
	[28] = {critical_damage = 3,  args = {221}},
	[29] = {critical_damage = 6,  args = {224}, deps_cells = {23}},
	[30] = {critical_damage = 6,  args = {214}, deps_cells = {24}},
	[35] = {critical_damage = 6,  args = {225}, deps_cells = {23, 29, 27, 37}},
	[36] = {critical_damage = 6,  args = {215}, deps_cells = {24, 30, 28, 38}}, 
	[37] = {critical_damage = 2,  args = {228}},
	[38] = {critical_damage = 2,  args = {218}},
	[39] = {critical_damage = 2,  args = {244}}, 
	[40] = {critical_damage = 2,  args = {241}}, 
	[43] = {critical_damage = 2,  args = {243}, deps_cells = {39, 53}},
	[44] = {critical_damage = 2,  args = {242}, deps_cells = {40, 54}}, 
	[51] = {critical_damage = 2,  args = {240}}, 
	[52] = {critical_damage = 2,  args = {238}},
	[53] = {critical_damage = 2,  args = {248}},
	[54] = {critical_damage = 2,  args = {247}},
	[55] = {critical_damage = 2,  args = {159}},
	[58] = {critical_damage = 2,  args = {156}},
	[59] = {critical_damage = 2,  args = {148}},
	[82] = {critical_damage = 2,  args = {152}},
	[83] = {critical_damage = 3, args = {134}}, -- nose wheel                                  
	[84] = {critical_damage = 3, args = {136}}, -- left wheel                                  
	[85] = {critical_damage = 3, args = {135}}, -- right wheel                                 

}
------------------------------------------------------------

Su_33_cells_properties = {
	[0]  = {critical_damage = 5,  args = {146}},
	[1]  = {critical_damage = 3,  args = {296}},
	[2]  = {critical_damage = 3,  args = {297}},
	[3]  = {critical_damage = 8,  args = {65}},
	[4]  = {critical_damage = 2,  args = {298}},
	[5]  = {critical_damage = 2,  args = {301}},
	[7]  = {critical_damage = 2,  args = {249}},
	[8]  = {critical_damage = 2,  args = {265}},
	[9]  = {critical_damage = 3,  args = {154}},
	[10] = {critical_damage = 3,  args = {153}},
	[11] = {critical_damage = 1,  args = {167}},
	[12] = {critical_damage = 1,  args = {161}},
	[13] = {critical_damage = 2,  args = {169}},
	[14] = {critical_damage = 2,  args = {163}},
	[15] = {critical_damage = 2,  args = {267}},
	[16] = {critical_damage = 2,  args = {266}},
	[17] = {critical_damage = 2,  args = {168}},
	[18] = {critical_damage = 2,  args = {162}},
	[20] = {critical_damage = 1,  args = {183}},
	[21] = {critical_damage = 1,  args = {252}}, 
	[22] = {critical_damage = 1,  args = {250}},
	[23] = {critical_damage = 5,  args = {223}, deps_cells = {25, 27}}, 
	[24] = {critical_damage = 5,  args = {213}, deps_cells = {26, 28}}, 
	[25] = {critical_damage = 1,  args = {226}}, 
	[26] = {critical_damage = 1,  args = {216}}, 
	[27] = {critical_damage = 3,  args = {231}},
	[28] = {critical_damage = 3,  args = {221}}, 
	[29] = {critical_damage = 6,  args = {224}, deps_cells = {23, 25, 27, 31, 45}}, 
	[30] = {critical_damage = 6,  args = {214}, deps_cells = {24, 26, 28, 32, 46}},
	[31] = {critical_damage = 3,  args = {229}},
	[32] = {critical_damage = 3,  args = {219}},
	[33] = {critical_damage = 3,  args = {230}},
	[34] = {critical_damage = 3,  args = {220}},
	[35] = {critical_damage = 6,  args = {225}, deps_cells = {23, 25, 27, 29, 31, 33, 37, 45, 47}},
	[36] = {critical_damage = 6,  args = {215}, deps_cells = {24, 26, 28, 30, 32, 34, 38, 46, 48}},
	[37] = {critical_damage = 2,  args = {228}},
	[38] = {critical_damage = 2,  args = {218}},
	[39] = {critical_damage = 2,  args = {244}},
	[40] = {critical_damage = 2,  args = {241}},
	[43] = {critical_damage = 2,  args = {243}, deps_cells = {39, 53}},
	[44] = {critical_damage = 2,  args = {242}, deps_cells = {40, 54}},
	[45] = {critical_damage = 3,  args = {235}, deps_cells = {31}},
	[46] = {critical_damage = 3,  args = {233}, deps_cells = {32}}, 
	[47] = {critical_damage = 3,  args = {236}, deps_cells = {37}}, 
	[48] = {critical_damage = 3,  args = {234}, deps_cells = {38}}, 
	[49] = {critical_damage = 3,  args = {239}}, 
	[50] = {critical_damage = 3,  args = {237}}, 
	[51] = {critical_damage = 2,  args = {240}, deps_cells = {49}}, 
	[52] = {critical_damage = 2,  args = {238}, deps_cells = {50}}, 
	[53] = {critical_damage = 2,  args = {248}},
	[54] = {critical_damage = 2,  args = {247}},
	[55] = {critical_damage = 2,  args = {159}},
	[58] = {critical_damage = 2,  args = {156}},
	[59] = {critical_damage = 2,  args = {148}},
	[82] = {critical_damage = 2,  args = {152}},
	[83] = {critical_damage = 3,  args = {134}}, 
	[84] = {critical_damage = 3,  args = {136}}, 
	[85] = {critical_damage = 3,  args = {135}},

}
------------------------------------------------------------

MiG_29_cells_properties = {
	[0]  = {critical_damage = 5,  args = {146}}, 
	[1]  = {critical_damage = 3,  args = {296}}, 
	[2]  = {critical_damage = 3,  args = {297}}, 
	[3]  = {critical_damage = 8,  args = {65}}, 
	[4]  = {critical_damage = 2,  args = {298}}, 
	[5]  = {critical_damage = 2,  args = {301}}, 	
	[7]  = {critical_damage = 2,  args = {249}}, 
	[8]  = {critical_damage = 2,  args = {265}}, 
	[9]  = {critical_damage = 3,  args = {154}}, 
	[10] = {critical_damage = 3,  args = {153}}, 
	[11] = {critical_damage = 1,  args = {167}}, 
	[12] = {critical_damage = 1,  args = {161}}, 
	[13] = {critical_damage = 2,  args = {169}}, 
	[14] = {critical_damage = 2,  args = {163}},
	[15] = {critical_damage = 2,  args = {267}}, 
	[16] = {critical_damage = 2,  args = {266}}, 
	[17] = {critical_damage = 2,  args = {168}}, 
	[18] = {critical_damage = 2,  args = {162}}, 
	[20] = {critical_damage = 1,  args = {183}}, 
	[21] = {critical_damage = 2,  args = {230}},      
	[22] = {critical_damage = 2,  args = {220}},     
	[23] = {critical_damage = 5,  args = {223}}, 
	[24] = {critical_damage = 5,  args = {213}}, 	
	[25] = {critical_damage = 2,  args = {226}}, 
	[26] = {critical_damage = 2,  args = {216}}, 
	[29] = {critical_damage = 6,  args = {224}, deps_cells = {21, 23, 25}}, 
	[30] = {critical_damage = 6,  args = {214}, deps_cells = {22, 24, 26}},  	
	[33] = {critical_damage = 2,  args = {231}},     
	[34] = {critical_damage = 2,  args = {221}},      
	[35] = {critical_damage = 6,  args = {225}, deps_cells = {21, 23, 25, 29, 33, 37}}, 
	[36] = {critical_damage = 6,  args = {215}, deps_cells = {22, 24, 26, 30, 34, 38}}, 	
	[37] = {critical_damage = 2,  args = {228}}, 
	[38] = {critical_damage = 2,  args = {218}}, 	
	[39] = {critical_damage = 2,  args = {244}}, 
	[40] = {critical_damage = 2,  args = {241}}, 
	[43] = {critical_damage = 2,  args = {243}, deps_cells = {39, 53}}, 
	[44] = {critical_damage = 2,  args = {242}, deps_cells = {40, 54}}, 
	[51] = {critical_damage = 2,  args = {240}}, 
	[52] = {critical_damage = 2,  args = {238}}, 
	[53] = {critical_damage = 2,  args = {248}},
	[54] = {critical_damage = 2,  args = {247}},
	[55] = {critical_damage = 2,  args = {159}}, 
	[58] = {critical_damage = 2,  args = {156}}, 
	[59] = {critical_damage = 2,  args = {148}},  
	[82] = {critical_damage = 2,  args = {152}}, 
	[83] = {critical_damage = 3, args = {134}}, -- nose wheel                                  
	[84] = {critical_damage = 3, args = {136}}, -- left wheel                                  
	[85] = {critical_damage = 3, args = {135}}, -- right wheel                                
	
}
------------------------------------------------------------
MiG_29C_cells_properties = {
	[0]  = {critical_damage = 5,  args = {146}}, 
	[1]  = {critical_damage = 3,  args = {296}}, 
	[2]  = {critical_damage = 3,  args = {297}}, 
	[3]  = {critical_damage = 8,  args = {65}}, 
	[4]  = {critical_damage = 2,  args = {298}}, 
	[5]  = {critical_damage = 2,  args = {301}}, 	
	[7]  = {critical_damage = 2,  args = {249}}, 
	[8]  = {critical_damage = 2,  args = {265}}, 
	[9]  = {critical_damage = 3,  args = {154}}, 
	[10] = {critical_damage = 3,  args = {153}}, 
	[11] = {critical_damage = 1,  args = {167}}, 
	[12] = {critical_damage = 1,  args = {161}}, 
	[13] = {critical_damage = 2,  args = {169}}, 
	[14] = {critical_damage = 2,  args = {163}},
	[15] = {critical_damage = 2,  args = {267}}, 
	[16] = {critical_damage = 2,  args = {266}}, 
	[17] = {critical_damage = 2,  args = {168}}, 
	[18] = {critical_damage = 2,  args = {162}}, 
	[20] = {critical_damage = 1,  args = {183}}, 
	[21] = {critical_damage = 2,  args = {230}},      
	[22] = {critical_damage = 2,  args = {220}},     
	[23] = {critical_damage = 5,  args = {223}}, 
	[24] = {critical_damage = 5,  args = {213}}, 	
	[25] = {critical_damage = 2,  args = {226}}, 
	[26] = {critical_damage = 2,  args = {216}}, 
	[29] = {critical_damage = 6,  args = {224}, deps_cells = {21, 23, 25}}, 
	[30] = {critical_damage = 6,  args = {214}, deps_cells = {22, 24, 26}},  	
	[33] = {critical_damage = 2,  args = {231}},     
	[34] = {critical_damage = 2,  args = {221}},      
	[35] = {critical_damage = 6,  args = {225}, deps_cells = {21, 23, 25, 29, 33, 37}}, 
	[36] = {critical_damage = 6,  args = {215}, deps_cells = {22, 24, 26, 30, 34, 38}}, 	
	[37] = {critical_damage = 2,  args = {228}}, 
	[38] = {critical_damage = 2,  args = {218}}, 	
	[39] = {critical_damage = 2,  args = {244}}, 
	[40] = {critical_damage = 2,  args = {241}}, 
	[43] = {critical_damage = 2,  args = {243}, deps_cells = {39, 53}}, 
	[44] = {critical_damage = 2,  args = {242}, deps_cells = {40, 54}}, 
	[51] = {critical_damage = 2,  args = {240}}, 
	[52] = {critical_damage = 2,  args = {238}}, 
	[53] = {critical_damage = 2,  args = {248}},
	[54] = {critical_damage = 2,  args = {247}},
	[55] = {critical_damage = 2,  args = {159}}, 
	[58] = {critical_damage = 2,  args = {156}}, 
	[59] = {critical_damage = 2,  args = {148}},  
	[82] = {critical_damage = 2,  args = {152}}, 
	[83] = {critical_damage = 3, args = {134}}, -- nose wheel                                  
	[84] = {critical_damage = 3, args = {136}}, -- left wheel                                  
	[85] = {critical_damage = 3, args = {135}}, -- right wheel
	[90] = {critical_damage = 1, args = {663}}, -- ������
}

------------------------------------------------------------

mi26_cells_properties = {
	[0]  = {critical_damage = 6,  args = {142}},
	[1]  = {critical_damage = 6,  args = {154}},
	[2]  = {critical_damage = 6,  args = {153}},
	[3]  = {critical_damage = 12, args = {135}},
	[4]  = {critical_damage = 6,  args = {138}},
	[5]  = {critical_damage = 6,  args = {137}},
	[6]  = {critical_damage = 6,  args = {136}},
	[9]  = {critical_damage = 20, args = {150}},
	[10] = {critical_damage = 20, args = {149}},
	[11] = {critical_damage = 3,  args = {167}},
	[12] = {critical_damage = 3,  args = {161}},
	[17] = {critical_damage = 4,  args = {147}},
	[18] = {critical_damage = 4,  args = {146}},
	[35] = {critical_damage = 6,  args = {145}},
	[36] = {critical_damage = 6,  args = {144}},
	[53] = {critical_damage = 10, args = {244}},
	[54] = {critical_damage = 10, args = {241}},
	[55] = {critical_damage = 16, args = {81}},
	[56] = {critical_damage = 18, args = {141}, deps_cells = {55}},
	[57] = {critical_damage = 18, args = {140}, deps_cells = {55}},
	[58] = {critical_damage = 6,  args = {143}},
	[59] = {critical_damage = 6,  args = {152}},
	[61] = {critical_damage = 5,  args = {151}},
	[82] = {critical_damage = 6,  args = {148}},
}

------------------------------------------------------------

mi24v_cells_properties = {
	[3]  = {critical_damage = 10, args = {65}},
	[4]  = {critical_damage = 10, args = {150}},
	[5]  = {critical_damage = 10, args = {149}},
	[7]  = {critical_damage = 4,  args = {249}},
	[9]  = {critical_damage = 5, args = {154, 298, 299}},
	[10] = {critical_damage = 5, args = {153, 301, 302}},
	[11] = {critical_damage = 1,  args = {167}},
	[12] = {critical_damage = 1,  args = {161}},
	[23] = {critical_damage = 5, args = {223}} ,
	[24] = {critical_damage = 5, args = {213}} ,
	[35] = {critical_damage = 5, args = {224}, deps_cells = {23}},
	[36] = {critical_damage = 5, args = {214}, deps_cells = {24}},
	[45] = {critical_damage = 3,  args = {235}},
	[46] = {critical_damage = 3,  args = {233}},
	[55] = {critical_damage = 4,  args = {159}, deps_cells = {45, 46}},
	[56] = {critical_damage = 14, args = {81, 158}, deps_cells = {55, 45, 46}},
	[57] = {critical_damage = 14, args = {81, 157}, deps_cells = {55, 45, 46}},
	[59] = {critical_damage = 5,  args = {148}},
	[60] = {critical_damage = 1,  args = {144}},
	[82] = {critical_damage = 3,  args = {152}},
}

------------------------------------------------------------

mi28n_cells_properties = {
	[0]  = {critical_damage = 4,  args = {146}},
	[3]  = {critical_damage = 20, args =  {65}},
	[4]  = {critical_damage = 13, args = {150}},
	[5]  = {critical_damage = 13, args = {149}},
	[7]  = {critical_damage = 4,  args = {249}},
	[9]  = {critical_damage = 14, args = {154, 299}},
	[10] = {critical_damage = 14, args = {153, 303}},
	[11] = {critical_damage = 2,  args = {167}},
	[12] = {critical_damage = 2,  args = {161}},
	[23] = {critical_damage = 8,  args = {214}},
	[24] = {critical_damage = 8,  args = {213}},
	[29] = {critical_damage = 8,  args = {224}},
	[30] = {critical_damage = 8,  args = {214}},
	[45] = {critical_damage = 4,  args = {235}},
	[55] = {critical_damage = 3,  args = {159}},
	[56] = {critical_damage = 14, args = {81, 158}, deps_cells = {55}},
	[57] = {critical_damage = 14, args = {81, 157}, deps_cells = {55}},
}

------------------------------------------------------------

ah1w_cells_properties = {
	[0]  = {critical_damage = 3,	args = {146}},
	[3]  = {critical_damage = 10,	args = {65}},
	[4]  = {critical_damage = 10,	args = {150}},
	[5]  = {critical_damage = 10,	args = {149}},
	[7]  = {critical_damage = 4,	args = {249}},
	[9]  = {critical_damage = 10,	args = {154}},
	[10] = {critical_damage = 10,	args = {153}},
	[11] = {critical_damage = 2,	args = {167}},
	[12] = {critical_damage = 2,	args = {161}},
	[23] = {critical_damage = 7,	args = {223}},
	[24] = {critical_damage = 7,	args = {213}},
	[29] = {critical_damage = 8,	args = {224}},
	[30] = {critical_damage = 8,	args = {214}},
	[45] = {critical_damage = 3,	args = {235},   droppable = false},
	[46] = {critical_damage = 3,	args = {233},   droppable = false},
	[55] = {critical_damage = 3,	args = {159},   droppable = false},
	[56] = {critical_damage = 12,	args = {81, 158}, deps_cells = {55}},
	[57] = {critical_damage = 12,	args = {81, 157}, deps_cells = {55}},
}
------------------------------------------------------------

ab212_cells_properties = {
--ab212_cells_properties[1]  = {critical_damage = 5, args = {167}},--
	[0]  = {critical_damage = 3, args = {142}}, --�����
	[1]  = {critical_damage = 1, args = {146}}, --����� ����� ������ � ����� �����
	[2]  = {critical_damage = 1, args = {297}}, --������ ����� ������ � ����� �����
	[4]  = {critical_damage = 1, args = {454}}, --������ ������ ������
	[5]  = {critical_damage = 1, args = {453}}, --������ ������� ������
	[6]  = {critical_damage = 1, args = {298}}, --��� ����
	[8]  = {critical_damage = 3, args = {265}}, --������� �� �����
	[9]  = {critical_damage = 2, args = {154}}, --����� ����� ������� ��� ����������
	[10] = {critical_damage = 2, args = {153}}, --������ ����� ������� ��� ����������
	[11] = {critical_damage = 2, args = {167}}, -- ����� ���������
	[14] = {critical_damage = 5, args = {163}}, --����������� �����
	[13] = {critical_damage = 5, args = {169}}, --����� ���������
	[15] = {critical_damage = 50, args = {258}},--����
	[16] = {critical_damage = 50, args = {256}},--����
	[19] = {critical_damage = 50, args = {257}},--����
	[20] = {critical_damage = 50, args = {255}},--����
	[21] = {critical_damage = 1, args = {899}},--copilot (bs argument not to interfere with a correct new logic)
	[22] = {critical_damage = 1, args = {898}},--pilot (bs argument not to interfere with a correct new logic)
	[23] = {critical_damage = 1, args = {465}},--����� �������
	[24] = {critical_damage = 1, args = {466}},--������ �������
	[25] = {critical_damage = 2, args = {459}},--����� �����
	[26] = {critical_damage = 2, args = {460}},--������ �����
	[27] = {critical_damage = 1, args = {455}},--����� ���� ������
	[28] = {critical_damage = 1, args = {456}},--������ ���� ������
	[29] = {critical_damage = 1, args = {457}},--����� ������� ����
	[30] = {critical_damage = 1, args = {458}},--������ ������� ����
	[31] = {critical_damage = 2, args = {461}},--����� ������� �����
	[32] = {critical_damage = 2, args = {462}},--������ ������� �����
	[45] = {critical_damage = 3, args = {235}},
	[46] = {critical_damage = 3, args = {233}},
	[53] = {critical_damage = 5, args = {81}},--����� �������
	[55] = {critical_damage = 3, args = {159, 244}},
	[56] = {critical_damage = 3,	args = {158}, deps_cells = {55, 53}},
	[57] = {critical_damage = 3,	args = {157}, deps_cells = {55, 53}},
	[82] = {critical_damage = 8, args = {152}},
	[63] = {critical_damage = 10,  args = {530}, deps_cells = {64, 65, 66, 67, 68, 69}}, -- Rotor
	[64] = {critical_damage = 5,  args = {429}, deps_cells = {65, 66}},
	[65] = {critical_damage = 5,  args = {430}, deps_cells = {66}},
	[66] = {critical_damage = 5,  args = {431}},
	[67] = {critical_damage = 5,  args = {432}, deps_cells = {68, 69}},
	[68] = {critical_damage = 5,  args = {433}, deps_cells = {69}},
	[69] = {critical_damage = 5,  args = {434}},
	[71] = {critical_damage = 2, args = {435}},
	[74] = {critical_damage = 2, args = {436}},
}	

------------------------------------------------------------

ah64a_cells_properties = {
	[0]  = {critical_damage = 2, args = {146}},
	[1]  = {critical_damage = 1, args = {296}},
	[2]  = {critical_damage = 1, args = {297}},
	[3]  = {critical_damage = 12, args = {65}},
	[4]  = {critical_damage = 12, args = {150}},
	[5]  = {critical_damage = 12, args = {149}},
	[7]  = {critical_damage = 4, args = {249}},
	[9]  = {critical_damage = 13, args = {154, 299}},
	[10] = {critical_damage = 13, args = {153, 303}},
	[11] = {critical_damage = 2, args = {167}},
	[12] = {critical_damage = 2, args = {161}},
	[29] = {critical_damage = 8, args = {224}},
	[30] = {critical_damage = 8, args = {214}},
	[35] = {critical_damage = 8, args = {224}},
	[36] = {critical_damage = 8, args = {214}},
	[45] = {critical_damage = 4, args = {235}},
	[46] = {critical_damage = 4, args = {233}},
	[63] = {critical_damage = 10, args = {53}},
	[55] = {critical_damage = 3, args = {159}},
	[56] = {critical_damage = 13, args = {81, 158}, deps_cells = {55}},
	[57] = {critical_damage = 13, args = {81, 157}, deps_cells = {55}},
	[59] = {critical_damage = 4, args = {148}},
	[61] = {critical_damage = 8, args = {147}},
	[62] = {critical_damage = 8, args = {250}},
	[82] = {critical_damage = 14, args = {152}},
}

------------------------------------------------------------

uh60a_cells_properties = {
	[3]   = {critical_damage = 20, args = {65}},
	[4]   = {critical_damage = 10,  args = {146, 296}},
	[5]   = {critical_damage = 10,  args = {146, 297}},
	[9]   = {critical_damage = 5,  args = {154}},
	[10]  = {critical_damage = 5, args = {153}},
	[11]  = {critical_damage = 1,  args = {167}},
	[12]  = {critical_damage = 1,  args = {161}},
	[23]  = {critical_damage = 3,  args = {223}},
	[24]  = {critical_damage = 3,  args = {213}},
	[45]  = {critical_damage = 3,  args = {235}},
	[46]  = {critical_damage = 3,  args = {233}},
	[55]  = {critical_damage = 4,  args = {159}},
	[56]  = {critical_damage = 14, args = {81, 158}, deps_cells = {55}},
	[57]  = {critical_damage = 14, args = {81, 157}, deps_cells = {55}},
	[58]  = {critical_damage = 14, args = {81, 156}, deps_cells = {55}},
	[63]  = {critical_damage = 10,  args = {53}},
	[82]  = {critical_damage = 3,  args = {156}},
}
------------------------------------------------------------

oh58d_cells_properties = {
	[0]  = {critical_damage = 4, args = {146}},
	[3]  = {critical_damage = 10, args = {146}},
	[9]  = {critical_damage = 12, args = {154}},
	[10] = {critical_damage = 12, args = {153}},
	[12] = {critical_damage = 2, args = {161}, deps_cells = {11}},
	[11] = {critical_damage = 2, args = {161}},
	[55] = {critical_damage = 3},
	[56] = {critical_damage = 8, args = {81}, deps_cells = {55}},
	[82] = {critical_damage = 12, args = {152}},
}
------------------------------------------------------------

ch47d_cells_properties = {
	[0]  = {critical_damage = 6, args = {146}},
	[1]  = {critical_damage = 6, args = {296}},
	[2]  = {critical_damage = 6, args = {297}},
	[3]  = {critical_damage = 12, args = {65}},
	[4]  = {critical_damage = 6, args = {150}},
	[5]  = {critical_damage = 6, args = {149}},
	[39]  = {critical_damage = 4, args = {244}},
	[40]  = {critical_damage = 4, args = {241}},
	[9]  = {critical_damage = 14, args = {154}},
	[10] = {critical_damage = 14, args = {153}},
	[11] = {critical_damage = 2, args = {167}},
	[12] = {critical_damage = 2, args = {161}},
	[56] = {critical_damage = 16, args = {158}},
	[57] = {critical_damage = 16, args = {157}},
	[58] = {critical_damage = 16, args = {156}},
	[82] = {critical_damage = 17, args = {152}}, -- fuselage bottom
}

------------------------------------------------------------

ka27_cells_properties = {
	[0] = {critical_damage = 4, args = {146}}, -- nose center
	[1] = {critical_damage = 5, args = {296}}, 
	[2] = {critical_damage = 5, args = {297}}, 
	[3] = {critical_damage = 10, args = {65}},  
	[4] = {critical_damage = 20, args = {147, 150, 298}, deps_cells = {3}}, 
	[5] = {critical_damage = 20, args = {147, 149, 301, 302}, deps_cells = {3}}, 
	[9] = {critical_damage = 5, args = {154, 299}},
	[10] = {critical_damage = 5, args = {153, 302, 303}},
	[11] = {critical_damage = 1, args = {167}}, 
	[12] = {critical_damage = 1, args = {161}},
	[39] = {critical_damage = 3, args = {244}},  
	[40] = {critical_damage = 3, args = {241}},
	[45] = {critical_damage = 3, args = {235}, deps_cells = {39}},
	[46] = {critical_damage = 3, args = {233}, deps_cells = {40}},
	[53] = {critical_damage = 3, args = {248}}, 
	[54] = {critical_damage = 3, args = {247}}, 
	[55] = {critical_damage = 4, args = {159}, deps_cells = {54}},
	[59] = {critical_damage = 5, args = {148}},
	[82] = {critical_damage = 3, args = {152}}, -- fuselage bottom
}

------------------------------------------------------------

ka50_cells_properties = {
	[0] = {critical_damage = 2, args = {146}, deps_cells = {60}}, -- nose center
	[1] = {critical_damage = 3, args = {296}}, 
	[2] = {critical_damage = 3, args = {297}}, 
	[3] = {critical_damage = 15, args = {65}},  
	[4] = {critical_damage = 15, args = {150, 298}, deps_cells = {3}}, 
	[5] = {critical_damage = 17, args = {149, 301, 302}, deps_cells = {3}}, 
	[7] = {critical_damage = 3, args = {249}}, 
	[8] = {critical_damage = 3, args = {265}},
	[9] = {critical_damage = 5, args = {154, 299}},
	[10] = {critical_damage = 5, args = {153, 302, 303}},
	[11] = {critical_damage = 3, args = {167}}, 
	[12] = {critical_damage = 3, args = {161}},
	[15] = {critical_damage = 3,args = {267}},
	[16] = {critical_damage = 3,args = {266}},
	[17] = {critical_damage = 3, args = {188}},
	[18] = {critical_damage = 3, args = {189}},
	[23] = {critical_damage = 4, args = {223}}, 
	[24] = {critical_damage = 4, args = {213}}, 
	[29] = {critical_damage = 5, args = {224}, deps_cells = {23}},
	[30] = {critical_damage = 5, args = {214}, deps_cells = {24}},
	[39] = {critical_damage = 3, args = {244}},  
	[40] = {critical_damage = 3, args = {241}},
	[45] = {critical_damage = 3, args = {235}, deps_cells = {39}},
	[46] = {critical_damage = 3, args = {233}, deps_cells = {40}},
	[54] = {critical_damage = 3, args = {247}}, 
	[55] = {critical_damage = 3, args = {159}, deps_cells = {54}},
	[56] = {critical_damage = 5, args = {81, 304, 158}, deps_cells = {39, 40, 45, 46, 54, 55}}, 
	[57] = {critical_damage = 5, args = {81, 305, 157}, deps_cells = {39, 40, 45, 46, 54, 55}},
	[58] = {critical_damage = 5, args = {81, 156}, deps_cells = {39, 40, 45, 46, 54, 55}}, 
	[59] = {critical_damage = 3, args = {148}},
	[60] = {critical_damage = 1, args = {144}},
	[61] = {critical_damage = 5, args = {147}},
	[62] = {critical_damage = 5, args = {250}},
	[63] = {critical_damage = 10, args = {53}, deps_cells = {64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81}}, -- Rotor
	[64] = {critical_damage = 5, args = {117}, deps_cells = {65, 66}}, -- blade 1 in
	[65] = {critical_damage = 5, args = {116}, deps_cells = {66}},   -- blade 1 center
	[66] = {critical_damage = 5, args = {115}},     -- blade 1 out
	[67] = {critical_damage = 5, args = {120}, deps_cells = {68, 69}},  -- blade 2 in
	[68] = {critical_damage = 5, args = {119}, deps_cells = {69}},  -- blade 2 center
	[69] = {critical_damage = 5, args = {118}},     -- blade 2 out
	[70] = {critical_damage = 5, args = {123}, deps_cells = {71, 72}},  -- blade 3 in
	[71] = {critical_damage = 5, args = {122}, deps_cells = {72}},   -- blade 3 center
	[72] = {critical_damage = 5, args = {121}},      -- blade 3 out
	[73] = {critical_damage = 5, args = {126}, deps_cells = {74, 75}}, -- blade 4 in
	[74] = {critical_damage = 5, args = {125}, deps_cells = {75}},  -- blade 4 center
	[75] = {critical_damage = 5, args = {124}},      -- blade 4 out
	[76] = {critical_damage = 5, args = {129}, deps_cells = {77, 78}},  -- blade 5 in
	[77] = {critical_damage = 5, args = {128}, deps_cells = {78}},   -- blade 5 center
	[78] = {critical_damage = 5, args = {127}},      -- blade 5 out
	[79] = {critical_damage = 5, args = {132}, deps_cells = {80, 81}},  -- blade 6 in
	[80] = {critical_damage = 5, args = {131}, deps_cells = {81}},   -- blade 6 center
	[81] = {critical_damage = 5, args = {130}},      -- blade 6 out
	[82] = {critical_damage = 3, args = {152}}, -- fuselage bottom
	[83] = {critical_damage = 3, args = {134}}, -- nose wheel
	[84] = {critical_damage = 3, args = {136}}, -- left wheel
	[85] = {critical_damage = 3, args = {135}}, -- right wheel
	[86] = {critical_damage = 2},-- pylon1
	[87] = {critical_damage = 2}, -- pylon2
	[88] = {critical_damage = 2}, -- pylon3
	[89] = {critical_damage = 2}, -- pylon4
}
------------------------------------------------------------
------------------------------------------------------------

planes_dmg_properties = {}

planes_dmg_properties[Default]  = default_cells_properties
planes_dmg_properties[B_1]		= wing_engine_cells_properties
planes_dmg_properties[B_52]		= wing_engine_cells_properties
planes_dmg_properties[Tu_95]	= wing_engine_cells_properties
planes_dmg_properties[Tu_142]	= wing_engine_cells_properties
planes_dmg_properties[Tu_160]	= wing_engine_cells_properties
planes_dmg_properties[E_2C]		= E_2C_cells_properties
planes_dmg_properties[Yak_40]	= F_15_cells_properties
planes_dmg_properties[E_3]		= KC_135_cells_properties
planes_dmg_properties[C_130]	= KC_135_cells_properties
planes_dmg_properties[KC_135]	= KC_135_cells_properties
planes_dmg_properties[AN_26B]   = AN_26B_cells_properties
planes_dmg_properties[AN_30M]   = AN_26B_cells_properties
planes_dmg_properties[S_3R]     = wing_engine_cells_properties
planes_dmg_properties[S_3A]     = wing_engine_cells_properties
planes_dmg_properties[F_15]     = F_15_cells_properties
planes_dmg_properties[F_15E]    = F_15_cells_properties
planes_dmg_properties[A_50]		= IL_76_cells_properties
planes_dmg_properties[IL_78]	= IL_76_cells_properties
planes_dmg_properties[IL_76]	= IL_76_cells_properties
planes_dmg_properties[C_17]		= T_Tail_cells_properties

planes_dmg_properties[Su_34]	= armour_canopy_cells_properties

planes_dmg_properties[KA_52]	= mi24v_cells_properties
planes_dmg_properties[CH_53E]	= mi24v_cells_properties
planes_dmg_properties[SH_60B]	= oh58d_cells_properties
planes_dmg_properties[SH_3H]	= mi24v_cells_properties
planes_dmg_properties[Sea_Lynx]	= mi24v_cells_properties

planes_dmg_properties[Su_25]   = su25t_cells_properties
planes_dmg_properties[Su_39]   = su25t_cells_properties
planes_dmg_properties[Su_25T]  = su25t_cells_properties
planes_dmg_properties[Su_27]   = Su_27_cells_properties
planes_dmg_properties[Su_33]   = Su_33_cells_properties
planes_dmg_properties[MiG_29]  = MiG_29_cells_properties
planes_dmg_properties[MiG_29G]  = MiG_29_cells_properties
planes_dmg_properties[MiG_29C]  = MiG_29C_cells_properties

-- Moved to CoreMods
--[[
planes_dmg_properties[A_10A]	= a10_cells_properties
planes_dmg_properties[A_10C]	= a10_cells_properties
--]]

planes_dmg_properties[MI_24W]	= mi24v_cells_properties
planes_dmg_properties[KA_50]	= ka50_cells_properties
planes_dmg_properties[UH_60A]	= uh60a_cells_properties
planes_dmg_properties[AH_1W]	= ah1w_cells_properties 
planes_dmg_properties[AB_212]	= ab212_cells_properties 
planes_dmg_properties[AH_64A]	= ah64a_cells_properties
planes_dmg_properties[AH_64D]	= ah64a_cells_properties
planes_dmg_properties[MI_28N]	= mi28n_cells_properties
planes_dmg_properties[MI_26]	= mi26_cells_properties
planes_dmg_properties[OH_58D]	= oh58d_cells_properties
planes_dmg_properties[KA_27]	= ka27_cells_properties
planes_dmg_properties[CH_47D]	= ch47d_cells_properties
planes_dmg_properties[MI_8MT]	= verbose_to_dmg_properties({
["NOSE_CENTER"]         = {critical_damage = 2, args = {137}, construction = {durability = 0.91, skin = "Glass"}, droppable = true,}, -- ��� ������ (������ �� ������)
["NOSE_LEFT_SIDE"]      = {critical_damage = 2, args = {251}, construction = {durability = 0.73, skin = "Glass"}, droppable = true,}, -- ��� ���� (������ �����)
["NOSE_RIGHT_SIDE"]     = {critical_damage = 2, args = {146}, construction = {durability = 0.73, skin = "Glass"}, droppable = true,}, -- ��� ���� (������ ������)
["NOSE_BOTTOM"]         = {critical_damage = 2, args = {138}, construction = {durability = 0.83, skin = "Glass"}, droppable = true,}, -- nose bottom (������ �����)
["COCKPIT"]             = {critical_damage = 6, args = {151}, damage_boundary = 0.05, construction = {durability = 4.02, skin = "Aluminum"},}, -- ������ (������� ������ ������)
["CABIN_LEFT_SIDE"]     = {critical_damage = 1.5, args = {150}, construction = {durability = 1.23, skin = "Aluminum"}, droppable = true,}, -- ������ ���� (������� ������ �����)
["CABIN_RIGHT_SIDE"]    = {critical_damage = 1.5, args = {149}, construction = {durability = 1.23, skin = "Aluminum"}, droppable = true,}, -- ������ ���� (������� ������ ������)
["GUN"]                 = {critical_damage = 0.5, args = {-1}, construction = {durability = 0.05, skin = "Fabric"},},
["FUSELAGE_LEFT_SIDE"]  = {critical_damage = 10, args = {154}, construction = {durability = 7.69, skin = "Aluminum"},},
["FUSELAGE_RIGHT_SIDE"] = {critical_damage = 10, args = {153}, construction = {durability = 7.69, skin = "Aluminum"},},
["ENGINE_L"]            = {critical_damage = 5, args = {167}, construction = {durability = 2.22, skin = "Aluminum"},},
["ENGINE_R"]            = {critical_damage = 5, args = {161}, construction = {durability = 2.22, skin = "Aluminum"},},
["MTG_L_BOTTOM"]        = {critical_damage = 5, args = {166}, construction = {durability = 2.65, skin = "Aluminum"},}, -- mtg bottom l  - �� ����� ���� ��� ��������
["MTG_R_BOTTOM"]        = {critical_damage = 5, args = {160}, construction = {durability = 2.65, skin = "Aluminum"},}, -- mtg bottom r
["EWU_L"]               = {critical_damage = 1, args = {188}, construction = {durability = 1.02, skin = "Aluminum"},},
["EWU_R"]               = {critical_damage = 1, args = {189}, construction = {durability = 1.02, skin = "Aluminum"},},
["WING_L_OUT"]          = {critical_damage = 10, args = {225}, construction = {durability = 1.00, skin = "Steel"},},
["WING_R_OUT"]          = {critical_damage = 10, args = {215}, construction = {durability = 1.00, skin = "Steel"},},
["WING_L_CENTER"]       = {critical_damage = 10, args = {-1}, construction = {durability = 1.00, skin = "Steel"},},
["WING_R_CENTER"]       = {critical_damage = 10, args = {-1}, construction = {durability = 1.00, skin = "Steel"},},
["WING_L_IN"]           = {critical_damage = 3, args = {158}, construction = {durability = 3.09, skin = "Aluminum"},}, -- ������ ����� �������� (����� ����)
["WING_R_IN"]           = {critical_damage = 3, args = {157}, construction = {durability = 3.09, skin = "Aluminum"},}, -- (������ ����)
["STABILIZER_L_OUT"]    = {critical_damage = 3.4, args = {236}, construction = {durability = 0.71, skin = "Aluminum"},}, -- ��� ����
["STABILIZER_R_OUT"]    = {critical_damage = 3.4, args = {234}, construction = {durability = 0.71, skin = "Aluminum"},}, -- ���� ����
["RV_R"]                = {critical_damage = 10, args = {81}, deps_cells = {"STABILIZER_L_OUT", "STABILIZER_R_OUT", "RUDDER_R", "TAIL"}}, -- �������� ������� ��� 81 ���������! (�����) - ������ ������ ����������
["RN_L"]                = {critical_damage = 10, args = {1100}, deps_cells = {"TAIL", "RUDDER_R"}}, -- �������� ������� ��� �������� ����� ������� ������ (����������)
["RUDDER_R"]            = {critical_damage = 3, args = {247}, construction = {durability = 1.00, skin = "Aluminum"},}, --��
["TAIL"]                = {critical_damage = 5.2, args = {243}, deps_cells = {"RUDDER_R"}, construction = {durability = 0.88, skin = "Aluminum"},} ,-- ����
["TAIL_LEFT_SIDE"]      = {critical_damage = 3, args = {156}, construction = {durability = 3.98, skin = "Aluminum"},}, -- ����� ����� �����
["TAIL_RIGHT_SIDE"]     = {critical_damage = 3, args = {155}, construction = {durability = 3.98, skin = "Aluminum"},}, -- ����� ������ �����
["TAIL_BOTTOM"]         = {critical_damage = 3, args = {297}, construction = {durability = 5.24, skin = "Aluminum"},}, -- ������� �������� ������
["ROTOR"]               = {critical_damage = 100, args = {53}, deps_cells = {"BLADE_1_IN", "BLADE_2_IN", "BLADE_3_IN", "BLADE_4_IN", "BLADE_5_IN"}, construction = {durability = 1000.0, skin = "Steel"},}, -- Rotor
["BLADE_1_IN"]          = {critical_damage = 5, args = {117}, deps_cells = {"BLADE_1_CENTER"}, construction = {durability = 1.56, skin = "Aluminum"},}, -- blade 1 in
["BLADE_1_CENTER"]      = {critical_damage = 5, args = {116}, deps_cells = {"BLADE_1_OUT"}, construction = {durability = 1.59, skin = "Aluminum"},},   -- blade 1 center
["BLADE_1_OUT"]         = {critical_damage = 5, args = {115}, construction = {durability = 1.58, skin = "Aluminum"},},     -- blade 1 out
["BLADE_2_IN"]          = {critical_damage = 5, args = {120}, deps_cells = {"BLADE_2_CENTER"}, construction = {durability = 1.56, skin = "Aluminum"},},  -- blade 2 in
["BLADE_2_CENTER"]      = {critical_damage = 5, args = {119}, deps_cells = {"BLADE_2_OUT"}, construction = {durability = 1.59, skin = "Aluminum"},},  -- blade 2 center
["BLADE_2_OUT"]         = {critical_damage = 5, args = {118}, construction = {durability = 1.58, skin = "Aluminum"},},     -- blade 2 out
["BLADE_3_IN"]          = {critical_damage = 5, args = {123}, deps_cells = {"BLADE_3_CENTER"}, construction = {durability = 1.56, skin = "Aluminum"},},  -- blade 3 in
["BLADE_3_CENTER"]      = {critical_damage = 5, args = {122}, deps_cells = {"BLADE_3_OUT"}, construction = {durability = 1.59, skin = "Aluminum"},},   -- blade 3 center
["BLADE_3_OUT"]         = {critical_damage = 5, args = {121}, construction = {durability = 1.58, skin = "Aluminum"},},      -- blade 3 out
["BLADE_4_IN"]          = {critical_damage = 5, args = {126}, deps_cells = {"BLADE_4_CENTER"}, construction = {durability = 1.56, skin = "Aluminum"},}, -- blade 4 in
["BLADE_4_CENTER"]      = {critical_damage = 5, args = {125}, deps_cells = {"BLADE_4_OUT"}, construction = {durability = 1.59, skin = "Aluminum"},},  -- blade 4 center
["BLADE_4_OUT"]         = {critical_damage = 5, args = {124}, construction = {durability = 1.58, skin = "Aluminum"},},      -- blade 4 out
["BLADE_5_IN"]          = {critical_damage = 5, args = {129}, deps_cells = {"BLADE_5_CENTER"}, construction = {durability = 1.56, skin = "Aluminum"},},  -- blade 5 in
["BLADE_5_CENTER"]      = {critical_damage = 5, args = {128}, deps_cells = {"BLADE_5_OUT"}, construction = {durability = 1.59, skin = "Aluminum"},},   -- blade 5 center
["BLADE_5_OUT"]         = {critical_damage = 5, args = {127}, construction = {durability = 1.58, skin = "Aluminum"},},      -- blade 5 out	
["FUSELAGE_BOTTOM"]     = {critical_damage = 10, args = {152}, construction = {durability = 10.88, skin = "Aluminum"},}, -- fuselage bottom
["WHEEL_F"]             = {critical_damage = 0.15, args = {134}, construction = {durability = 0.88, skin = "Rubber"}, droppable = false,}, -- nose wheel
["WHEEL_L"]             = {critical_damage = 0.25, args = {136}, construction = {durability = 0.88, skin = "Rubber"}, droppable = false,}, -- left wheel
["WHEEL_R"]             = {critical_damage = 0.25, args = {135}, construction = {durability = 0.88, skin = "Rubber"}, droppable = false,}, -- right wheel
["CREW_1"]              = {critical_damage = 1, args = {663}, construction = {durability = 2.00, skin = "Fabric"},},--����� �����
["CREW_2"]              = {critical_damage = 1, args = {664}, construction = {durability = 2.00, skin = "Fabric"},},--������ �����
["CREW_3"]              = {critical_damage = 1, args = {665}, construction = {durability = 2.00, skin = "Fabric"},},--������
["CREW_4"]              = {critical_damage = 1, args = {999}, construction = {durability = 2.00, skin = "Fabric"},},--������� ����
["PYLON1"]              = {critical_damage = 3, args = {-1}, construction = {durability = 1.00, skin = "Aluminum"},},
["PYLON2"]              = {critical_damage = 3, args = {-1}, construction = {durability = 1.00, skin = "Aluminum"},},
["PYLON3"]              = {critical_damage = 3, args = {-1}, construction = {durability = 1.00, skin = "Aluminum"},},
["PYLON4"]              = {critical_damage = 3, args = {-1}, construction = {durability = 1.00, skin = "Aluminum"},},
["FUEL_TANK_RIGHT_SIDE"]= {critical_damage = 4, args = {252}, construction = {durability = 5.24, skin = "Aluminum"},}, -- fuel tank right side
["FUEL_TANK_LEFT_SIDE"] = {critical_damage = 4, args = {147}, construction = {durability = 5.24, skin = "Aluminum"},}, -- fuel tank left side

["CREW_5"]                  = {critical_damage = 1, args = {-1}, construction = {durability = 2.00, skin = "Fabric"},},
["ARMOR_NOSE_PLATE_LEFT"]   = {critical_damage = 10, args = {-1}, construction = {durability = 0.53, skin = "Steel"},},--armor nose left
["ARMOR_NOSE_PLATE_RIGHT"]  = {critical_damage = 10, args = {-1}, construction = {durability = 0.53, skin = "Steel"},},--armor nose right
["ARMOR_PLATE_LEFT"]        = {critical_damage = 10, args = {-1}, construction = {durability = 0.55, skin = "Steel"},},--armor left
["ARMOR_PLATE_RIGHT"]       = {critical_damage = 10, args = {-1}, construction = {durability = 0.55, skin = "Steel"},},--armor right
["CABINE_BOTTOM"]           = {critical_damage = 6, args = {148}, construction = {durability = 4.17, skin = "Aluminum"},}, -- ������ ����� (������� ������ �����)
[" FUEL_TANK_RIGHT_SIDE"]   = {critical_damage = 4, args = {252}, construction = {durability = 5.24, skin = "Aluminum"},}, -- fuel tank right side
[" FUEL_TANK_LEFT_SIDE"]    = {critical_damage = 4, args = {147}, construction = {durability = 5.24, skin = "Aluminum"},}, -- fuel tank left side
["LEFT_WHEEL"]              = {critical_damage = 99999, args = {-1}, construction = {durability = 99999.99999, skin = "Water"},},
["RIGHT_WHEEL"]             = {critical_damage = 99999, args = {-1}, construction = {durability = 99999.99999, skin = "Water"},},
["FRONT_WHEEL"]             = {critical_damage = 99999, args = {-1}, construction = {durability = 99999.99999, skin = "Water"},},
["PYLON5"]                  = {critical_damage = 3, args = {-1}, construction = {durability = 1.00, skin = "Aluminum"},},
["PYLON6"]                  = {critical_damage = 3, args = {-1}, construction = {durability = 1.00, skin = "Aluminum"},},
})

planes_dmg_properties[F_16]		= typical_single_engined_fighter
planes_dmg_properties[F_16A]	= typical_single_engined_fighter

--[[
package.path = package.path..";./Scripts/?.lua"
S = require("Serializer")
S.fout = io.open("planes_dmg_properties_Su_25.lua","w")
S] = {serialize_compact("planes_dmg_properties",planes_dmg_properties[Su_25])
io.close(S.fout) 
--]]

planes_dmg_properties[MiG_31]   = verbose_to_dmg_properties(
{
["FIN_L_TOP"] 			 = {critical_damage = 10, args = {244},deps_cells = {"RUDDER_L"}},
["RUDDER_L"] 			 = {critical_damage = 5 , args = {248}},
["FIN_R_TOP"] 			 = {critical_damage = 10, args = {241},deps_cells = {"RUDDER_R"}},
["RUDDER_R"] 			 = {critical_damage = 5 , args = {247}},
["ELEVATOR_R_IN"]		 = {critical_damage = 5 , args = {237}},
["ELEVATOR_L_IN"]		 = {critical_damage = 5 , args = {239}},

["ENGINE_L"]			 = {critical_damage = 10 , args = {167},droppable = false},
["ENGINE_R"]			 = {critical_damage = 10 , args = {169},droppable = false},
["FUSELAGE_LEFT_SIDE"]   = {critical_damage = 5 , args = {154,299},droppable = false},
["FUSELAGE_RIGHT_SIDE"]  = {critical_damage = 5 , args = {153,303},droppable = false},
["FUSELAGE_BOTTOM"]  	 = {critical_damage = 5 , args = {152}	   ,droppable = false},

["NOSE_CENTER"]  	 	 = {critical_damage = 5 , args = {146},droppable = false},
["NOSE_BOTTOM"]  	 	 = {critical_damage = 5 , args = {148},droppable = false},
["CABIN_LEFT_SIDE"]  	 = {critical_damage = 5 , args = {150 , 298},droppable = false},
["CABIN_RIGHT_SIDE"]  	 = {critical_damage = 5 , args = {149 , 301 , 302},droppable = false},
["COCKPIT"]  	 		 = {critical_damage = 5 , args = {65},droppable = false},

["WING_R_CENTER"]  	= {critical_damage = 10, args = {214},deps_cells = {"ELERON_R"}},
["WING_R_IN"]  	 	= {critical_damage = 10, args = {215},deps_cells = {"FLAP_R_IN"},droppable = false},
["ELERON_R"]  	 	= {critical_damage = 5 , args = {216},droppable = false},
["FLAP_R_IN"]  	 	= {critical_damage = 5 , args = {217},droppable = false},
["WING_L_CENTER"]  	= {critical_damage = 10, args = {224},deps_cells = {"ELERON_L"}},
["WING_L_IN"]  	 	= {critical_damage = 10, args = {225},deps_cells = {"FLAP_L_IN"},droppable = false},
["ELERON_L"]  	 	= {critical_damage = 5 , args = {226},droppable = false},
["FLAP_L_IN"]  	 	= {critical_damage = 5 , args = {227},droppable = false},
})

planes_dmg_properties[Tu_22M3]  = verbose_to_dmg_properties({
["NOSE_CENTER"] 		= {critical_damage = 5 ,args =  {146}},
["COCKPIT"]				= {critical_damage = 10,args =  { 65}},
["NOSE_RIGHT_SIDE"]		= {critical_damage = 5 ,args =  {147}},
["NOSE_LEFT_SIDE"] 		= {critical_damage = 5 ,args =  {150}},
["NOSE_BOTTOM"]			= {critical_damage = 3 ,args =  {148}},
["FUSELAGE_LEFT_SIDE"]  = {critical_damage = 3, args =  {154}},
["FUSELAGE_RIGHT_SIDE"] = {critical_damage = 3, args =  {153}},
["WING_L_IN"] 			= {critical_damage = 10,args =  {225}},
["WING_R_IN"]			= {critical_damage = 10,args =  {215}},
["WING_L_OUT"]			= {critical_damage = 3, args =  {223},deps_cells = {"WING_L_PART_CENTER","FLAP_L_OUT","FLAP_L_IN","FLAP_L_ CENTER"}},
["WING_R_OUT"]      	= {critical_damage = 3, args =  {213},deps_cells = {"WING_R_PART_CENTER","FLAP_R_OUT","FLAP_R_IN","FLAP_R_ CENTER"}},
["FUSELAGE_BOTTOM"]		= {critical_damage = 4, args =  {152}},
["TAIL_BOTTOM"]			= {critical_damage = 5, args =  {297}},
["STABILIZER_L_IN"]		= {critical_damage = 7, args =  {235}},
["STABILIZER_R_IN"]		= {critical_damage = 7, args =  {233}},
["ENGINE_L"] 			= {critical_damage = 3, args =  {167}},
["ENGINE_R"]			= {critical_damage = 3, args =  {161}},
["FIN_TOP"]  			= {critical_damage = 4, args =  {244}},
["RUDDER"] 				= {critical_damage = 3, args =  {247}},
["LEFT_GEAR_BOX"] 		= {critical_damage = 6, args =  {267}},
["RIGHT_GEAR_BOX"] 		= {critical_damage = 6, args =  {266}},
["FLAP_R_OUT"]			= {critical_damage = 6, args =  {219}},
["FLAP_R_ CENTER"]		= {critical_damage = 6, args =  {218}},
["FLAP_R_IN"]			= {critical_damage = 6, args =  {217}},
["FLAP_L_IN"]			= {critical_damage = 6, args =  {227}},
["FLAP_L_ CENTER"]		= {critical_damage = 6, args =  {228}},
["FLAP_L_OUT"]			= {critical_damage = 6, args =  {229}},
["WING_L_PART_CENTER"]	= {critical_damage = 6, args =  {221}},
["WING_R_PART_CENTER"]	= {critical_damage = 6, args =  {231}},
})


local fencer  = verbose_to_dmg_properties({
["COCKPIT"]				= {critical_damage = 2,args =  { 65}},
["NOSE_CENTER"]			= {critical_damage = 3,args =  {146}},
["NOSE_RIGHT_SIDE"] 	= {critical_damage = 3,args =  {147}},
["NOSE_LEFT_SIDE"]		= {critical_damage = 3,args =  {150}},
["NOSE_BOTTOM"]			= {critical_damage = 3,args =  {148}},
["NOSE_TOP_SIDE"]		= {critical_damage = 3,args =  {147}},

["WING_L_OUT"]			= {critical_damage = 10,args =  {223},deps_cells = {"FLAP_L_IN","WING_L_PART_OUT"}},
["WING_R_OUT"]			= {critical_damage = 10,args =  {213},deps_cells = {"FLAP_R_IN","WING_R_PART_OUT"}},
["WING_L_PART_OUT"]		= {critical_damage = 3, args =  {221}},
["WING_R_PART_OUT"]		= {critical_damage = 3, args =  {231}},
["FLAP_L_IN"]			= {critical_damage = 4, args =  {227}},
["FLAP_R_IN"]			= {critical_damage = 4, args =  {217}},

["FUSELAGE_BOTTOM"]		= {critical_damage = 4, args =  {152}},
["FUSELAGE_CENTR_TOP"]	= {critical_damage = 4, args =  {151}},
["FUSELAGE_CENTR_L"]	= {critical_damage = 4, args =  {154}},
["FUSELAGE_CENTR_R"]	= {critical_damage = 4, args =  {153}},

["FIN_TOP"]				= {critical_damage = 4, args =  {244}},
["RUDDER"]				= {critical_damage = 2, args =  {247}},

["ENGINE_L"]			= {critical_damage = 3, args =  {167}},
["ENGINE_R"]			= {critical_damage = 3, args =  {161}},

["STABILIZER_L_IN"]		= {critical_damage = 3, args =  {235}},
["STABILIZER_R_IN"]		= {critical_damage = 3, args =  {233}},
})

planes_dmg_properties[Su_24]   = fencer
planes_dmg_properties[Su_24MR] = fencer

planes_dmg_parts = {
[MiG_23] = {
			[1] = "MIG-23-OBLOMOK-WING-R",-- ������ �����
			[2] = "MIG-23-OBLOMOK-WING-L",
		},
[MiG_29] = { 
			[1] = "MIG-29A-OBLOMOK-WING-R",-- ������ �����
			[2] = "MIG-29A-OBLOMOK-WING-L",--����� �����
			},
[MiG_29G] = { 
			[1] = "MIG-29G-OBLOMOK-WING-R",-- ������ �����
			[2] = "MIG-29G-OBLOMOK-WING-L",--����� �����
			},		
[MiG_29C] = { 
			[1] = "MIG-29C-OBLOMOK-WING-R",-- ������ �����
			[2] = "MIG-29C-OBLOMOK-WING-L",--����� �����
			},			
[Su_27] = {  
			[1] = "SU-27-OBLOMOK-WING-R",-- ������ �����
			[2] = "SU-27-OBLOMOK-WING-L",--����� �����
			},
[Su_33] = {  
			[1] = "SU-33-OBLOMOK-WING-R",-- ������ �����
			[2] = "SU-33-OBLOMOK-WING-L",--����� �����
			},
[F_14] = {   
			[1] = "F-14A-OBLOMOK-WING-R",-- ������ �����
			[2] = "F-14A-OBLOMOK-WING-L",--����� �����
			},
[F_15] = {   
			[1] = "F-15-OBLOMOK-WING-R",-- ������ �����
			[2] = "F-15-OBLOMOK-WING-L",--����� �����
			},
[F_16] = {   
			[1] = "F-16-OBLOMOK-WING-R",-- ������ �����
			[2] = "F-16-OBLOMOK-WING-L",--����� �����
			},
[MiG_25] = { 
			[1] = "MIG-25-OBLOMOK-WING-R", -- ������ �����
			[2] = "MIG-25-OBLOMOK-WING-L",--����� �����
			},
[MiG_31] = { 
			[1] = "MIG-31-OBLOMOK-WING-R",-- ������ �����
			[2] = "MIG-31-OBLOMOK-WING-L",--����� �����
			},
[F_2] = {
			[1] = "TORNADO-OBLOMOK-WING-R",-- ������ �����
			[2] = "TORNADO-OBLOMOK-WING-L",
			},
[MiG_27] = { 
			[1] = "MIG-27-OBLOMOK-WING-R",
			[2] = "MIG-27-OBLOMOK-WING-L",
			},
[Su_24] = {  
			[1] = "SU-24-OBLOMOK-WING-R",
			[2] = "SU-24-OBLOMOK-WING-L",
			},
[Su_30] = {  
			[1] = "SU-30-OBLOMOK-WING-R",
			[2] = "SU-30-OBLOMOK-WING-L",
			},
[FA_18] = {
			[1] = "F-18C-OBLOMOK-WING-R",
			[2] = "F-18C-OBLOMOK-WING-L",
			},
[Su_25] = {  
			[1] = "SU-25-WING-R",
			[2] = "SU-25-WING-L",
			[3] = "SU-25-NOSE",
			[4] = "SU-25-TAIL",
			},
[Su_25T] = {  
			[1] = "SU-25T-WING-R",
			[2] = "SU-25T-WING-L",
			[3] = "SU-25T-NOSE",
			[4] = "SU-25T-TAIL",
			},
-- Moved to CoreMods
--[[
[A_10A] = {
			[1] = "A-10-OBLOMOK-WING-R",
			[2] = "A-10-OBLOMOK-WING-L",
			},
--]]
[Tu_160] = {
			[1] = "TU-160-OBLOMOK-WING-R",
			[2] = "TU-160-OBLOMOK-WING-L",
			},  
[B_1] = {
			[1] = "B-1B-OBLOMOK-WING-R",
			[2] = "B-1B-OBLOMOK-WING-L",
			},     
[Su_34] = {
			[1] = "SU-34-OBLOMOK-WING-R",
			[2] = "SU-34-OBLOMOK-WING-L",
			},   
[Tu_95] = {
			[1] = "TU-95MS-OBLOMOK-WING-R",
			[2] = "TU-95MS-OBLOMOK-WING-L",
			},   
[Tu_142] = {
			[1] = "TU-142-OBLOMOK-WING-R",
			[2] = "TU-142-OBLOMOK-WING-L",
			},  
[B_52] = {
			[1] = "B-52-OBLOMOK-WING-R",
			[2] = "B-52-OBLOMOK-WING-L",
			},    
[Tu_22M3] = {
			[1] = "TU-22-OBLOMOK-WING-R",
			[2] = "TU-22-OBLOMOK-WING-L",
			}, 
[A_50] = {
			[1] = "A50-OBLOMOK-WING-R",
			[2] = "A50-OBLOMOK-WING-L",
			[3] = "A50-OBLOMOK-NOSE",
			[4] = "A50-OBLOMOK-TAIL",
			},    
[E_3] = {
			[1] = "E-3-OBLOMOK-WING-R",
			[2] = "E-3-OBLOMOK-WING-L",
			},     
[IL_78] = {
			[1] = "IL-78M-OBLOMOK-WING-R",
			[2] = "IL-78M-OBLOMOK-WING-L",
			[3] = "IL-78M-OBLOMOK-NOSE",
			[4] = "IL-78M-OBLOMOK-TAIL",
			},   
[KC_10] = {
			[1] = "KC-10A-OBLOMOK-WING-R",
			[2] = "KC-10A-OBLOMOK-WING-L",
			},   
[KC_135] = {
            [1] = "KC-135-OBLOMOK-WING-R",
            [2] = "KC-135-OBLOMOK-WING-L",
            },   
[IL_76] = {
			[1] = "IL-76MD-OBLOMOK-WING-R",
			[2] = "IL-76MD-OBLOMOK-WING-L",
			[3] = "IL-76MD-OBLOMOK-NOSE",
			[4] = "IL-76MD-OBLOMOK-TAIL",
			},   
[C_130] = {
			[1] = "C-130-OBLOMOK-WING-R",
			[2] = "C-130-OBLOMOK-WING-L",
			},   
[MIG_29K] = {
			[1] = "MIG-29K-OBLOMOK-WING-R",
			[2] = "MIG-29K-OBLOMOK-WING-L",
			}, 
[S_3R] = {
			[1] = "S-3R-OBLOMOK-WING-R",
			[2] = "S-3R-OBLOMOK-WING-L",
			},	 		
[Mirage] = {
			[1] = "M2000-OBLOMOK-WING-R",
			[2] = "M2000-OBLOMOK-WING-L",
			},  
[F_117] = {
			[1] = "F-117-OBLOMOK-WING-R",
			[2] = "F-117-OBLOMOK-WING-L",
			},   
[Su_39] = {
			[1] = "SU-39-OBLOMOK-WING-R",
			[2] = "SU-39-OBLOMOK-WING-L",
			},   
[AN_26B] = {
			[1] = "AN-26B-OBLOMOK-WING-R",
			[2] = "AN-26B-OBLOMOK-WING-L",
			},  
[AN_30M] = {
			[1] = "AN-30M-OBLOMOK-WING-R",
			[2] = "AN-30M-OBLOMOK-WING-L",
			},  
[E_2C] = {
			[1] = "E-2C-OBLOMOK-WING-R",
			[2] = "E-2C-OBLOMOK-WING-L",
			},    				
[S_3A] = {
			[1] = "S-3A-OBLOMOK-WING-R",
			[2] = "S-3A-OBLOMOK-WING-L",
			},    		
[AV_8B] = {
			[1] = "AV-8B-OBLOMOK-WING-R",
			[2] = "AV-8B-OBLOMOK-WING-L",
			},   	
[EA_6B] = {
			[1] = "EA-6B-OBLOMOK-WING-R",
			[2] = "EA-6B-OBLOMOK-WING-L",
			},   						
[F_4E] = {
			[1] = "F-4E-OBLOMOK-WING-R",
			[2] = "F-4E-OBLOMOK-WING-L",
			},    		
[C_17] = {
			[1] = "C-17-OBLOMOK-WING-R",
			[2] = "C-17-OBLOMOK-WING-L",
			},    
[SU_17M4] = {
			[1] = "SU-17-OBLOMOK-WING-R",
			[2] = "SU-17-OBLOMOK-WING-L",
			}, 
[Su_24MR] = {
			[1] = "SU-24MR-OBLOMOK-WING-R",
			[2] = "SU-24MR-OBLOMOK-WING-L",
			}, 
[MI_24W] = {
			[1] = "Mi-24V-WING-R",
			[2] = "Mi-24V-WING-L",
			[4] = "Mi-24V-TAIL",
			},
[MI_8MT] = {
			[1] = "MI-8MT_wing_r",
			[2] = "MI-8MT_wing_l",
			[4] = "MI-8MT_oblomok_hvost",
			[5] = "MI-8MT_rotor",
			},
[MI_26] = {
			[4] = "mi-26_tail",
			},
[KA_27] = {
			[4] = "KA-27-TAIL",
			},
[KA_50] = {
			[1] = "KA-50-WING-R",
			[2] = "KA-50-WING-L",
			[3] = "KA-50-NOSE",
			[4] = "KA-50-TAIL",
			[5] = "KA-50-BLADE",
			},
[MI_28N] = {
			[1] = "Mi-28-WING-R",
			[2] = "Mi-28-WING-L",
			[4] = "Mi-28-TAIL",
			},
[AH_1W] = {
			[1] = "AH-1W-WING-R",
			[2] = "AH-1W-WING-L",
			[4] = "AH-1W-TAIL",
			},
[AH_64A] = {
			[1] = "AH-64A-WING-R",
			[2] = "AH-64A-WING-L",
			[4] = "AH-64A-TAIL",
			},
[AH_64D] = {
			[1] = "AH-64D-WING-R",
			[2] = "AH-64D-WING-L",
			[4] = "AH-64D-TAIL",
			},
[UH_60A] = {
				[4] = "uh-60-tail",
			},
[OH_58D] = {
				[4] = "oh-58d-tail",
			},
[AB_212] = {    
				[4] = "AB-212-TAIL",
				[5] = "ab-212_rotor",
				[8] = "ab-212_cargo",
			},
}

planes_dmg_parts[F_15E]   		= planes_dmg_parts[F_15]
planes_dmg_parts[F_16A]   		= planes_dmg_parts[F_16]
planes_dmg_parts[FA_18C]  		= planes_dmg_parts[F_18]
-- Moved to CoreMods
--planes_dmg_parts[A_10C]   		= planes_dmg_parts[A_10A]
planes_dmg_parts[TORNADO_IDS]	= planes_dmg_parts[F_2]
planes_dmg_parts[MiG_25P]		= planes_dmg_parts[MiG_25]
