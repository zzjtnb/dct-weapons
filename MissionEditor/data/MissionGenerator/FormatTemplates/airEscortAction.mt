						[%%INDEX%%] = 
						{
							enabled = true,
							auto = false,
							id = "Escort",
							number = %%INDEX%%,
							params = 
							{
								lastWptIndexFlagChangeManually = true,
								lastWptIndexFlag = false,
								engagementDistMax = 60000,
								targetTypes = 
								{
									[1] = "Planes",
								}, -- end of targetTypes
								groupId = %%GROUPID%%,
								noTargetTypes = 
								{
									[1] = "Helicopters",
								},
								pos = 
								{
									y = 0,		--Elevation
									x = -500,	--Distance
									z = 200,	--Interval
								},
							}, -- end of params
						}, -- end of [1]
