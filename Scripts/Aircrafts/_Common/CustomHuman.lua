PlaneType =
{
	MiG_23  =  1;
	MiG_29  =  2;
	Su_27   =  3;
	Su_33   =  4;
	F_14    =  5;
	F_15    =  6;
	F_16    =  7;
	MiG_25  =  8; 
	MiG_31  =  9; 
	F_2     =  10;  -- Tornado F.2 IDS GR.1A  
	MiG_27  =  11; 
	Su_24   =  12; 
	Su_30   =  13; 
	FA_18   =  14;  -- F/A-18A Hornet           
	F_111   =  15; 
	Su_25   =  16; 
	A_10A   =  17; 
	Tu_160  =  18;  
	B_1     =  19;  
	Su_34   =  20;  
	Tu_95   =  21;  
	Tu_142  =  22;  
	B_52    =  23;  
	MiG_25P =  24; 
	Tu_22M3 =  25; 
	A_50    =  26; 
	E_3     =  27; 
	IL_78   =  28;  
	KC_10   =  29;    
	IL_76   =  30;
	C_130   =  31;
	MIG_29K =  32;   
	S_3R  =  33;             
	Mirage  =  34;       
	Tu_143  =  35;   
	Tu_141  =  36;
	F_117   =  37; 
	Su_39   =  38; 
	AN_26B  =  39; 
	AN_30M  =  40; 
	E_2C    =  41; 
	S_3A    =  42; 
	AV_8B   =  43; 
	EA_6B   =  44;       
	F_4E    =  45; 
	F_5E    =  46; 
	C_17    =  47; 
	SU_17M4 =  48; 
	MiG_29G  = 49;  -- MiG-29 Fulcrum germany 
	MiG_29C  = 50;  -- MiG-29 Fulcrum 9.13  
	Su_24MR  = 51;  
	F_16A    = 52;  
	FA_18C   = 53;  
	Su_25T   = 54;  
	RQ_1A_Predator = 55;
	TORNADO_IDS = 56;
	Yak_40  =  57; 
	F_15E  =  59; 
	KC_135 = 60;
	L_39ZA = 61;
	P_51B = 62;
	P_51D = 63;
    P_51D_30_NA = 64;
    TF_51D = 65;
    J_11A = 66;
}
CWSType =
{
	iCWS_Su_27   = PlaneType.Su_27,
	iCWS_Su_33   = PlaneType.Su_33,
	iCWS_Su_25   = PlaneType.Su_25,
	iCWS_Su_25t  = PlaneType.Su_25T,
	iCWS_MiG_29  = PlaneType.MiG_29,
	iCWS_MiG_29C = PlaneType.MiG_29C,
	iCWS_MiG_29G = PlaneType.MiG_29G,
	iCWS_MiG_29K = PlaneType.MiG_29K,
	iCWS_A_10    = PlaneType.A_10A,
	iCWS_F_15    = PlaneType.F_15,
}
CustomHumanData = {}

CustomHumanData[PlaneType.MiG_29 ] = CWSType.iCWS_MiG_29
CustomHumanData[PlaneType.MiG_29C] = CWSType.iCWS_MiG_29C
CustomHumanData[PlaneType.MiG_29G] = CWSType.iCWS_MiG_29G
CustomHumanData[PlaneType.MIG_29K] = CWSType.iCWS_MiG_29K
CustomHumanData[PlaneType.Su_27  ] = CWSType.iCWS_Su_27
CustomHumanData[PlaneType.Su_33  ] = CWSType.iCWS_Su_33
CustomHumanData[PlaneType.Su_25  ] = CWSType.iCWS_Su_25
CustomHumanData[PlaneType.Su_25T ] = CWSType.iCWS_Su_25t
CustomHumanData[PlaneType.Su_39  ] = CWSType.iCWS_Su_25t
CustomHumanData[PlaneType.F_15   ] = CWSType.iCWS_F_15
CustomHumanData[PlaneType.A_10A  ] = CWSType.iCWS_A_10
CustomHumanData[PlaneType.P_51B  ] = CWSType.iCWS_A_10
CustomHumanData[PlaneType.P_51D  ] = CWSType.iCWS_A_10
CustomHumanData[PlaneType.P_51D_30_NA] = CWSType.iCWS_A_10
CustomHumanData[PlaneType.TF_51D ] = CWSType.iCWS_A_10


--[[ for example :)
CustomHumanData[PlaneType.F_14]   = CWSType.iCWS_F_15
CustomHumanData[PlaneType.F_16]   = CWSType.iCWS_F_15
CustomHumanData[PlaneType.B_52]   = CWSType.iCWS_A_10
CustomHumanData[PlaneType.F_5E]   = CWSType.iCWS_MiG_29G
CustomHumanData[PlaneType.Tu_160] = CWSType.iCWS_A_10
CustomHumanData[PlaneType.AV_8B]  = CWSType.iCWS_A_10
CustomHumanData[PlaneType.F_2]    = CWSType.iCWS_F_15
--]]