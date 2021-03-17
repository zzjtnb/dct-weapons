mission = 
{
%%GENERATORPARAMS%%
	date = 
	{
		Year = %%YEAR%%,
		Day = %%DAY%%,
		Month = %%MONTH%%,
	}, -- end of date
%%TRIGGERS%%
    weather = 
    {
%%WEATHER%%
    }, -- end of weather
    map = 
    {
        centerX = %%X%%,
        centerY = %%Y%%,
        zoom = 100000,
    }, -- end of map
    sortie = "%%MISSIONNAME%%",
    descriptionText = "%%MISSIONDESCRIPTION%%",
    descriptionBlueTask = "%%GOALDESCRIPTIONBLUE%%",
    descriptionRedTask = "%%GOALDESCRIPTIONRED%%",
%%COALITIONS%%
    start_time = %%TIME%%,
    groundControl = 
    {
        isPilotControlVehicles = false,
        roles = 
        {
            artillery_commander = 
            {
                blue = 0,
                red = 0,
            }, -- end of artillery_commander
            instructor = 
            {
                blue = 0,
                red = 0,
            }, -- end of instructor
            observer = 
            {
                blue = 0,
                red = 0,
            }, -- end of observer
            forward_observer = 
            {
                blue = 0,
                red = 0,
            }, -- end of forward_observer
        }, -- end of roles
    }, -- end of groundControl
    goals = 
    {
    }, -- end of goals
	result = 
    {
        offline = 
        {
            conditions = 
            {
            }, -- end of conditions
            actions = 
            {
            }, -- end of actions
            func = 
            {
            }, -- end of func
        }, -- end of offline
        blue = 
        {
            conditions = 
            {
            }, -- end of conditions
            actions = 
            {
            }, -- end of actions
            func = 
            {
            }, -- end of func
        }, -- end of blue
        red = 
        {
            conditions = 
            {
            }, -- end of conditions
            actions = 
            {
            }, -- end of actions
            func = 
            {
            }, -- end of func
        }, -- end of red
    }, -- end of result
    pictureFileNameR = 
    {
    }, -- end of pictureFileNameR
    pictureFileNameB = 
    {
    }, -- end of pictureFileNameB
    --version = 2,
    currentKey = 42,--24
    theatre = "%%THEATREOFWAR%%",
	forcedOptions = 
    {
    }, -- end of forcedOptions
    failures = 
    {
    }, -- end of failures
	["maxDictId"] = %%MAXDICT%%,
	["version"] = 16,
} -- end of mission
