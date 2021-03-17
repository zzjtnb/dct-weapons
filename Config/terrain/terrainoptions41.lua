useTerrainShaderCache = 01;

options = 
{
	initItemsCount = 200;	-- начальное число элементов в слое
	maxSuperficialsPerFrame = 4;
	vehiclesDecimation = 1;
	flatShadowsLayerInFinalColorPass = 13;
}

grass =
{
	grassType = 2; -- 0 - off, 1 - procedure grass1, 2 - procedure grass2
}


function surface5_transition_distance(near, far)
	return near + (far - near) * 2.0 / 3.0;
end

distances =
{
	commonFactor = 1;
	surfaceLevel0 = 30000.0;
	surfaceLevel1 = 40000.0;
	
	surfaceLod =
	{
		{0, 0, 2000, 4000};
		{4000, 4000, surface5_transition_distance(4000, 8000), 8000};
		{8000, 8000, surface5_transition_distance(8000, 16000), 16000};
		{16000, 16000, 50000, 150000};
 	};

	uniqueScene = 20000.0;
	details = {256, 512, 1024, 2048, 4096, 8192, 16384, 16384, 16384, 16384, 16384, 16384, 16384};
	vehicles = 2000;
	instancerFactor = 1;
	wireMaxDistance = 900;
	uniqueSceneAdaptive = 
	{
		enable = false;
		minimalSquareOnScreen = 50;
		minimalSquareOnScreenFull = 100;
	};
	block = 
	{
		-- Дальность в метрах с которой вместо edm начинает рендерится нулевой лод домиков
		lod0 = 200.0;
		-- Дальность в метрах с которой вместо нулевого лода начинает рендерится первый лод
		lod1 = 600.0;
		-- Дальность в метрах с которой домики начинают блендится с землей и сплющиваться
		blend = 2000.0;
		-- Дальность в метрах дальше которой кварталы не рендерятся
		far = 2010.0;
	};
}
lights = 
{
	lampsScale = 1;
}
gpuCounters =
{
	-- counterName -> queue, layers
	{"surfaceLevel0", "surface", ""},
	-- details
	{"details", "computeinstancer", ""},
	-- buildings
	{"buildings", "flat_shadows_opaque", ""},
	{"buildings", "opaque", ""},
	{"buildings", "reflectionmap", ""},
	{"buildings", "lights", ""},
}

_fullFrameTime = 16.6
gpuTimeLimits = 
{
	type = ""; -- "separate", "summary"
	surfaceLevel0 = 9;
	buildings = 9;
	details = 9;

	degradateThreshold = _fullFrameTime*0.6;
	strongThreshold = _fullFrameTime*0.8;
	achtungThreshold = _fullFrameTime*0.9;
	upStep = 2/128;
	downStep = 3/128;
	plotGraphics = false;
}

weather =
{
	useWindFromConfig = false;
	windDirection = {1, 1};
	windSpeed = 5;
}

clipmapQuality = 1
--clipmapQuality = 4

clipmap = 
{
	loggingEnabled = false;
	maxUpdatePerFrame = 10;
	interlaced = 3;
--	updateToGPU = 3;
--	updateToGPU = 8;
	updateToGPU = 15;
	updateFlagsToGPU = true;
--	colorTextureAlias = "source";
}

-- Параметры текстур клипмапов
updatesClipmapPerFrame = 1
clipmapsForcedRGBA = false
clipmapTextureSize = 1024 * clipmapQuality
clipmapUpdateStep = 32 * clipmapQuality
clipmaptextures =	
{
	colortexture = 
	{
		textureSize = clipmapTextureSize,
		updateStep  = clipmapUpdateStep,
		updatesPerFrame = updatesClipmapPerFrame,
		forcedRGBA = clipmapsForcedRGBA,
	},
	source = 
	{
		textureSize = clipmapTextureSize,
		updateStep  = clipmapUpdateStep,
		updatesPerFrame = updatesClipmapPerFrame,
		forcedRGBA = clipmapsForcedRGBA,
	},
	normalmap = 
	{
		textureSize = clipmapTextureSize,
		updateStep  = clipmapUpdateStep,
		updatesPerFrame = updatesClipmapPerFrame,
		forcedRGBA = clipmapsForcedRGBA,
	},
	shadowmap = 
	{
		textureSize = clipmapTextureSize,
		updateStep  = clipmapUpdateStep,
		updatesPerFrame = updatesClipmapPerFrame,
		forcedRGBA = clipmapsForcedRGBA,
	},
	lightsmap = 
	{
		textureSize = clipmapTextureSize,
		updateStep  = clipmapUpdateStep,
		updatesPerFrame = updatesClipmapPerFrame,
		forcedRGBA = clipmapsForcedRGBA,
	},
	splatmap = 
	{
		textureSize = clipmapTextureSize,
		updateStep  = clipmapUpdateStep,
		updatesPerFrame = updatesClipmapPerFrame,
		forcedRGBA = clipmapsForcedRGBA,
	},

}

waves = 
{
 waveMaxWindValue = 20; -- значение ветра больше которой значения принимаются = highWind
 lowWind = 
 {
  waveLength = 2; -- Длина волны (м)
  waveSpeed = 0.3; -- скорость волны м/с
  wavePowerX = 0.2; -- число волн в продольном направлении (0-1)
  wavePowerY = 0.2; -- число волн в поперечном направлении (0-1)
  waveHeight = 0.5;  -- высота волны
 };
 highWind = 
 {
  waveLength = 60;
  waveSpeed = 4;
  wavePowerX = 1;
  wavePowerY = 0.6;
  waveHeight = 5;
 };
}

hiddensemantics = {
--	"Sea",
--	"Lake", 
--	"Island",
--	"Land",
--	"Field",
--	"Beach",
--	"Plant",
--	"Town",
--	"River",
--	"Channel",
--	"Road",
--	"Rail",
--	"Runway",
--	"Building",
--	"ELT",
--	"Isoline",
--	"SmallShit",
--	"Forest",
--	"Grass",
--	"Stone",
--	"Trees",
--	"Lamp",
--	"Line",
--	"MGRS",
--	"Shelf",
--	"SurfaceDetails",
--	"Undef",
--	"Rock",
};

hiddenqueuelayers = {
--	{"compute", 0, 1, 2, 3, 9},
--	{"surface", 1, 2, 3, 4, 5, 6, 7},
--	{"opaque", 100, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17},
};

hiddenlayer = {
--	0,
--	1,
--	2, 
--	3, 
--	4, 
--	5, 
--	6, 
--	18,
--	19,		-- flat_shadows		
--	20,		-- houses
--	21,		-- trees
--	22,		-- pole
--	23,		-- lights
--	24
};

hiddenlevels = {
--	0, 
--	1, 
--	2,
--	3,
};

hiddenqueues = {
--	"farsurface",
--	"surface",
--	"flatshadows",
--	"opaque",
--	"transparent",
--	"lights",
--	"shelf",
--	"waves",
--	"compute",
--	"heightmap",
--	"reflectionmap",
};

hiddenLibraries = {
--	"vehicles.ref",
};
viewOnlyLibraries = {
--	"vehicles.ref",
};
hiddenFiles =
{
--	"CaucasusChecker.tile",
};
instancer =
{
	bufferSize = 30000;
	checkBufferSize = false;

	multiAppendBufferSize = 524288;
	parentBufferSize = 20000;
	childsBufferSize = 100000;

	vertexInstancer = true;
	geometryReference = true;
--	debugMode = 2+16;

--	checkreference = "blackgum_rt";
--	checkreference = "blackgum_rt_100<150<300<400";
--	checkreference = "blackgum_rt_100<150<4000<5000";
--	checkreference = "blacktree_rt_-1<0<200<300";
--	checkreference = "blacktree_rt_100<200<500<1000";
--	checkreference = "blacktree_rt_400<500<3000<5000";
--	checkreference = "cirlypalm_rt_-1<0<200<400";
--	checkreference = "cirlypalm_rt_200<300<700<1000";
--	checkreference = "cirlypalm_rt_600<700<3000<5000";
--	checkreference = "datepalm_rt_-1<0<300<500";
--	checkreference = "datepalm_rt_200<300<700<1000";
--	checkreference = "datepalm_rt_600<700<3000<5000";
--	checkreference = "fraserfir_rt_-1<0<200<400";
--	checkreference = "fraserfir_rt_100<200<500<1000";
--	checkreference = "fraserfir_rt_400<500<3000<5000";
--	checkreference = "greenash_rt_-1<0<200<400";
--	checkreference = "greenash_rt_100<200<500<1000";
--	checkreference = "greenash_rt_0<100<200<300";
--	checkreference = "shrub_rt_0<0<30<40";
--	checkreference = "shrub_rt_20<30<90<100";
--	checkreference = "shrub_rt_80<90<300<400";
--	checkreference = "shrub1_-1<0<180<190";
--	checkreference = "shrub1_170<180<280<300";
--	checkreference = "shrub1_280<290<550<600";

}

debug = 
{
	useParseContext = 0;

	dumpFilteredByCondition = 0;
	dumpFilteredByNeedRender = 0;
	dumpFilteredByHidden = 0;
	dumpInstancedObjects = 0;
	loggingParse = 0;

	switchoffDrawTerrainObject = 0;
	switchoffRenderTerrainObject = 0;
	switchoffEdm = 0;
	switchoffFetchSurface = 0;
	switchoffFetchSuperficial = 0;
	switchoffSurfaceDetails = 0;
	switchoffAssetRuntimeSurfaceDetails = 0;
	switchoffFetchUniqueScenes = 0;
	switchoffFetchRoadDetails = 0;
	switchoffFetchDistricts = 0;
	switchoffFetchSmokes = 0;
	switchoffFetchLights = 0;
	switchoffRenderLights = 0;
	switchoffRenderLockonTrees = 0;
	switchoffSomething = 0;
	switchoffVehicle = 0;
	switchoffDataFiles = 0;
	switchoffInstancers = 0;
	switchoffInstancerSubobjects = 0;
	switchoffParseInstances = 0;
	clipmapDebugTextures = 0;
	switchoffClipmapUpdates = 0;
	switchonLayerGpuTime = 0;
	roadNetworkView = false;

--	viewBoxesForSemantic = "Forest";
--	viewBoxesForSemantic = "Grass";
--	viewBoxesForSemantic = "Land";

--	switchoffReference = "grass_band";
--	switchoffReference = "stone1";
--	switchoffReference = "stone2";
--	switchoffReference = "stone3";
--	switchoffReference = "car_0";

--	switchonReference  = "car_01";

	blockTreesScale = 1.0;
	splineBlockTreesScale = 1.0;

	useAsynchGeometries = 1;

	testSmokeRender = 0;

	test1 = 0;
	test2 = 0;
	test3 = 0;
	test4 = 0;
	test5 = 0;
}

