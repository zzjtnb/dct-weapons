								[%%INDEX%%] = 
								{
									["enabled"] = true,
									["auto"] = false,
									["id"] = "FollowBigFormation",
									["number"] = %%INDEX%%,
									["params"] = 
									{
										["groupId"] = %%ID%%,
										["formationType"] = 15,
										["lastWptIndexFlagChangedManually"] = true,
										["posInGroup"] = 0,				-- 1 = left, 2 = right, 0 - Leader
										["posInWing"] = %%POSWING%%,	-- 1 = left, 2 = right, 0 - Leader Group
										["posInBox"] = 0,				-- 1 = Above(right above), 2 = Low(low left), 3 = LowLow(low behind), 0 - Leader
										["lastWptIndexFlag"] = false,
										["pos"] = 
										{
											["y"] = %%YPOSWING%%,
											["x"] = %%XPOSWING%%,
											["z"] = %%ZPOSWING%%,
										}, -- end of ["pos"]
									}, -- end of ["params"]
								}, -- end of [1]