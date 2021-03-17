	[%%INDEX%%] = 
        {
            predicate = "triggerOnce",
            rules = 
            {
                [1] = 
                {
                    coalitionlist = "red",
                    zone = "166",
                    predicate = "c_dead_zone",
                }, -- end of [1]
            }, -- end of rules
            actions = 
            {
                [1] = 
                {
                    flag = 1,
                    text = "%%TEXT%%",
                    predicate = "a_end_mission",
                    seconds = 10,
                }, -- end of [1]
            }, -- end of actions
            comment = "Score%%INDEX%%",
        }, -- end of [%%INDEX%%]
