shadows = 
{

	Nevada = {

		{	--flat only
			1,
			{0, 0, 0, 0, 0, 7000},	
			{0, 0, 0, 0, 0, 7000}	
		},
		{	--low
			2048,								-- size of shadowmap
			{0, 0, 0.02, 20.0, 70.0, 7000},		-- split distances outside
			{0, 0, 0.02, 2.0,  20.0, 7000}		-- split distances in cockpit
		},
		{	--medium
			2048,
			{0, 0.02, 20.0, 70.0, 250.0, 7000},	
			{0, 0.02, 2.0,  20.0, 130.0, 7000}	
		},
		{	--high
			4096,
			{0.02, 25.0, 100.0, 400.0, 1500.0, 7000},	
			{0.02, 2.5,  25.0,  250.0, 1500.0, 7000}
		},
		{	--ultra
			8192,
			{0.02, 25.0, 100.0, 500.0, 2000.0, 7000},	
			{0.02, 2.5,  25.0,  300.0, 2000.0, 7000}
		},

	},

	default = {

		{	--flat only
			1,
			{0, 0, 0, 0, 0, 7000},	
			{0, 0, 0, 0, 0, 7000}	
		},
		{	--low
			1024,										-- size of shadowmap
			{0.02, 20.0, 70.0, 250.0, 1000.0, 7000},	-- split distances outside
			{0.02, 2.0,  20.0, 130.0, 1000.0, 7000}		-- split distances in cockpit
		},
		{	--medium
			2048,
			{0.02, 20.0, 70.0, 250.0, 1000.0, 7000},		
			{0.02, 2.0,  20.0, 130.0, 1000.0, 7000}
		},
		{	--high
			4096,
			{0.02, 25.0, 100.0, 400.0, 1500.0, 7000},	
			{0.02, 2.5,  25.0,  250.0, 1500.0, 7000}
		},
		{	--ultra
			8192,
			{0.02, 25.0, 100.0, 500.0, 2000.0, 7000},	
			{0.02, 2.5,  25.0,  300.0, 2000.0, 7000}
		},

	},


};