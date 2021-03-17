    trig = 
    {
        actions = 
        {
%%ACTIONS%%
        }, -- end of actions
        custom = 
        {
        }, -- end of custom
        func = 
        {
%%FUNCTIONS%%
        }, -- end of func
        flag = 
        {
%%FLAGS%%
        }, -- end of flag
        conditions = 
        {
%%CONDITIONS%%
        }, -- end of conditions
        customStartup = 
        {
             [1] = "local tab = mission.result.red.conditions 		 for i,t in ipairs(tab)	do if type(t) == 'string' then tab[i] = loadstring(t) end end",
             [2] = "local tab = mission.result.blue.conditions 		 for i,t in ipairs(tab)	do if type(t) == 'string' then tab[i] = loadstring(t) end end",
             [3] = "local tab = mission.result.offline.conditions	 for i,t in ipairs(tab)	do if type(t) == 'string' then tab[i] = loadstring(t) end end",
             [4] = "local tab = mission.result.red.actions 			 for i,t in ipairs(tab)	do if type(t) == 'string' then tab[i] = loadstring(t) end end",
             [5] = "local tab = mission.result.blue.actions 		 for i,t in ipairs(tab)	do if type(t) == 'string' then tab[i] = loadstring(t) end end",
             [6] = "local tab = mission.result.offline.actions 		 for i,t in ipairs(tab)	do if type(t) == 'string' then tab[i] = loadstring(t) end end",
             [7] = "local tab = mission.trig.conditions 			 for i,t in ipairs(tab)	do if type(t) == 'string' then tab[i] = loadstring(t) end end",
             [8] = "local tab = mission.trig.actions 				 for i,t in ipairs(tab)	do if type(t) == 'string' then tab[i] = loadstring(t) end end",
        }, -- end of customStartup
        funcStartup = 
        {
%%FUNCSTARTUP%%
        }, -- end of funcStartup
    }, -- end of trig
    trigrules = 
    {
%%RULES%%
    }, -- end of trigrules
    triggers = 
    {
		zones =
		{
%%ZONES%%
		} -- end of zones
    }, -- end of triggers
