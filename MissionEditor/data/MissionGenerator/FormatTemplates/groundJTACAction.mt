                                                        [1] = 
                                                        {
                                                            valid = true,
                                                            name = "",
                                                            auto = false,
                                                            id = "ControlledTask",
                                                            number = 1,
                                                            enabled = true,
                                                            params = 
                                                            {
                                                                condition = 
                                                                {
                                                                }, -- end of condition
                                                                task = 
                                                                {
                                                                    id = "FAC",
                                                                    params = 
                                                                    {
                                                                    }, -- end of params
                                                                }, -- end of task
                                                                stopCondition = 
                                                                {
                                                                }, -- end of stopCondition
                                                            }, -- end of params
                                                        }, -- end of [1]
                                                        [2] = 
                                                        {
                                                            valid = true,
                                                            auto = false,
                                                            id = "WrappedAction",
                                                            enabled = true,
                                                            number = 2,
                                                            params = 
                                                            {
                                                                action = 
                                                                {
                                                                    id = "SetCallsign",
                                                                    params = 
                                                                    {
                                                                        number = 1,
                                                                        callname = %%CALLSIGN%%,
                                                                    }, -- end of params
                                                                }, -- end of action
                                                            }, -- end of params
                                                        }, -- end of [2]
                                                        [3] = 
                                                        {
                                                            valid = true,
                                                            auto = false,
                                                            id = "WrappedAction",
                                                            enabled = true,
                                                            number = 3,
                                                            params = 
                                                            {
                                                                action = 
                                                                {
                                                                    id = "SetFrequency",
                                                                    params = 
                                                                    {
                                                                        modulation = 1,
                                                                        frequency = %%FREQUENCY%%,
                                                                    }, -- end of params
                                                                }, -- end of action
                                                            }, -- end of params
                                                        }, -- end of [3]
                                                        [4] = 
                                                        {
                                                            ["enabled"] = true,
                                                            ["auto"] = false,
                                                            ["id"] = "WrappedAction",
                                                            ["valid"] = true,
                                                            ["number"] = 4,
                                                            ["params"] = 
                                                            {
                                                                ["action"] = 
                                                                {
                                                                    ["id"] = "SetInvisible",
                                                                    ["params"] = 
                                                                    {
                                                                        ["value"] = true,
                                                                    }, -- end of ["params"]
                                                                }, -- end of ["action"]
                                                            }, -- end of ["params"]
                                                        }, -- end of [4]
