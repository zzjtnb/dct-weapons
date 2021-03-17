                                        [%%INDEX%%] = 
                                        {
                                            x = %%X%%,
                                            y = %%Y%%,
                                            speed = %%SPEED%%,
                                            action = "%%FORMATION%%",
                                            ETA_locked = %%ETALOCK%%,
                                            alt = 0,
                                            alt_type = "BARO",
                                            targets = 
                                            {
                                            }, -- end of targets
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
                                            type = "Turning Point",
                                            ETA = 0,
                                            formation_template = "",
                                            delay_template = "",
                                            delay = 0,
                                            speed_locked = true,
                                        }, -- end of [%%INDEX%%]
