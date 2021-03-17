        [%%INDEX%%] = 
        {
            predicate = "triggerOnce",
            rules = 
            {
                [1] = 
                {
                    coalitionlist = "",
                    scores = %%SCORE%%,
                    zone = "",
                    predicate = "c_player_score_more",
                }, -- end of [1]
            }, -- end of rules
            actions = 
            {
                [1] = 
                {
                    flag = 1,
                    text = "%%TEXT%%",
                    predicate = "a_out_text_delay",
                    seconds = 10,
					KeyDict_text = "%%TEXT%%",
                }, -- end of [1]
            }, -- end of actions
            comment = "Score%%INDEX%%",
        }, -- end of [%%INDEX%%]
