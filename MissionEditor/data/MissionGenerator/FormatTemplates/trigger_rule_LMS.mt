	[%%INDEX%%] = 
        {
            predicate = "triggerStart",
            rules = 
            {
            }, -- end of rules
            actions = 
            {
                [1] = 
                {
                    flag = 1,
                    predicate = "a_add_safety_zone",
					zone = %%ID%%,
                }, -- end of [1]
                [2] = 
                {
                    predicate = "a_add_match_zone",
                    zone = %%ID1%%,
                }, -- end of [2]
            }, -- end of actions
            comment = "TriggerStart LMS",
        }, -- end of [%%INDEX%%]
