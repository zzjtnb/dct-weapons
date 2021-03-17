                                        [%%INDEX%%] = 
                                        {
                                            alt = %%ALT%%,
                                            x = %%X%%,
                                            y = %%Y%%,
                                            speed = %%SPEED%%,
                                            ETA_locked = %%ETALOCK%%,
                                            task = 
                                            {
                                                id = "ComboTask",
                                                params = 
                                                {
                                                    tasks = 
                                                    {
%%ACTIONS%%
                                                    }, -- end of tasks
                                                }, -- end of params
                                            }, -- end of task
                                            action = "%%ACTION%%",
                                            alt_type = "BARO",
                                            targets = 
                                            {
                                            }, -- end of targets
                                            type = "%%TYPE%%",
                                            ETA = 0,
                                            formation_template = "",
                                            delay_template = "",
                                            delay = 0,
                                            speed_locked = true,
                                            airdromeId = %%AIRDROME%%,
                                        }, -- end of [%%INDEX%%]
