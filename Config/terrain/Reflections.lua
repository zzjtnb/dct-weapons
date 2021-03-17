distance =
{
	distance10x10 = 20000.0;
	distanceLevel0 = 11000.0;
--	uniqueSceneFarDistance = 0;
--	uniqueSceneFarDistance = 5000;
	uniqueSceneFarDistance = 10000.0;
	smokesSceneFarDistance = 0.0;
	minimalSquareOnScreen = 50;
	minimalSquareOnScreenFull = 100;

	mapLodDistance0 = 2000;
	mapLodDistance1 = 4000;
	mapLodDistance2 = 6000;
	mapLodDistance3 = 8000;
}
--Old Noise 
land_noise =
{
	noisemin = 0.1;
	noisemax = 0.6;
	noise1front = 1000.0;
	noise1back = 10000.0;
	noise1top = 2500.0;
	noise1bottom = 2000.0;
	noise1PerSquare = 1.0;
	noise2PerSquare = 150.0;
}

land_detailNoise=
{
	Height = 300.0;
	Slope = 0.0;	
}

district =
{
	maxDistrictsAround = 100000;

	farDistance = 4000.0;
	farFullRenderDistance = 2000.0;
	nearFullRenderDistance = 0.0;
	nearDistance = 0.0;
	
	treesFarDistance = 1500.0;
	treesFarFullBlendRenderDistance = 1200.0;
	treesFarFullRenderDistance = 0.0;
	treeslodDistance = 0.0;
	heightFactor = 0;
	heightRandomFactor = 0;
	ajastfactor = 1;
	
	
	lampFarDistance = 10000.0;
	splineBlockFarDistance = 500.0;

--	renderType = "texture"; -- simple, texture, instance
	renderType = "simple"; -- simple, texture, instance
	
	lamp =
	{
		lampOn = 1;	
		maxSize = 8.4;
		staticSize = 4.0;
		spriteScale = 0.001;
		minDistance = 150.0;
		maxDistance = 10000.0;
		maxAlphaDistance = 400.0;
		minAlphaDistance = 0.0;
		minAlpha = 0.0;
		maxAlpha = 1.0;
		minBrightnessDistance = 0.0;
		maxBrightnessDistance = 8000.0;		-- must be <= lampFarDistance
		dsLightRadius = 60;
		dsLightBrightness = 4;
	};
}

flat_shadow =
{
	farDistance = 3000.0;
	fullFarDistance = 2000.0;
}

fog =
{
	front = 1000.0;
	back  = 70000.0;
}

layerfog =
{
	fog_begin = 0.0;
	fog_end = 1000.0;
	fog_strength = 10000.0;
	fog_color = {1.0, 1.0, 1.0};
}

infrared =
{
	landDetail = 0.8;
	landDarkness = 1.0;
	riverDarkness = 0.7;
	roadDarkness = 1.5;
	runwayDarkness = 1.7;
}

noise =
{
	noiseStartDistance = 3000.0;
	noiseEndDistance = 200.0;
	noiseMaxBlend = 0.7;
	noiseScale = 15.0;
	rampNoisePower = 0.8;
	rampNoiseScale = 17.0;
	smallNoiseStartDistance = 80.0;
	smallNoiseEndDistance = 1.0;
	smallNoiseMaxBlend = 0.6;
	smallNoiseScale = 450.0;		
}

lamp31 =
{
	lampOn = 1;	
	maxSize = 8.4;
	staticSize = 4.0;
	spriteScale = 0.001;
	minDistance = 150.0;
	maxDistance = 10000.0;
	maxAlphaDistance = 400.0;
	minAlphaDistance = 0.0;
	minAlpha = 0.0;
	maxAlpha = 1.0;
	minBrightnessDistance = 0.0;
	maxBrightnessDistance = 10000.0;
	dsLightRadius = 60;
	dsLightBrightness = 4;
}

lamp =
{
	lampOn = 1;	
	maxSize = 5.4;
	staticSize = 2.9;
	spriteScale = 0.0025;
	minDistance = 100.0;
	maxDistance = 3385.0;
	maxAlphaDistance = 1300.0;
	minAlphaDistance = 250.0;
	minAlpha = 0.36;
	maxAlpha = 0.26;
	minBrightnessDistance = 0.0;
	maxBrightnessDistance = 15000.0;
}

distanceBlend = 
{
	townNearDistance  = 4500.0;
	townFarDistance   = 7000.0;
	fieldNearDistance = 2000.0;
	fieldFarDistance  = 7000.0;
	waterNearDistance = 4000.0;
	waterFarDistance  = 10000.0;
	townLightNearDistance  = 9000.0;
	townLightFarDistance  = 10000.0;
}

fan = 
{
	read = 0; -- ������ ��������� �� ����� ������� (��� �������)
	
	pos = {-117, 0.3, 120};
	dir = {0, -1, 0};
	power = 8000;
	radius = 30;
	
	oscillator = 0.2;
	frequency = 15;
};

--hiddensemantics={0, 2, 5, 7, 9, 23, 26};
hiddensemantics={
	"Sea",
	"Lake", 
	"Island",
--	"Land",
	"Field",
	"Beach",
	"Plant",
	"Town",
	"River",
	"Channel",
	"Road",
	"Rail",
	"Runway",
--	"Building",
	"ELT",
	"SmallShit",
--	"Trees",
--	"Lamp",
	};
hiddenlayer={
--	0,
--	1,
--	2, 
--	3, 
--	4, 
--	5, 
--	6, 
--	18,
	19,		-- flat_shadows		
--	20,		-- houses
--	21,		-- trees
--	22,		-- pole
--	23,		-- lights
--	24
};
hiddenlevels={
--	0, 
--	1, 
--	2
	};
hiddencameras={
--	0, --near, 
--	1, --far
	};
debug = 
{
	switchoffDrawRoutine = 0;
	switchoffEdm = 0;
	switchoffFetchSurface = 0;
	switchoffFetchUniqueScenes = 0;
	switchoffFetchDistricts = 0;
	switchoffFetchLights = 0;
	switchoffRenderLights = 0;
}

	

function UpdateCamera( height, civillights)
	if civillights>0 then
--		district.treesFarDistance = 900;
--		district.treesFarFullBlendRenderDistance = 850.0;
--		district.treesFarFullRenderDistance = 800.0;
--		district.treeslodDistance = 0.0;
		else
--		district.treesFarDistance = 1500;
--		district.treesFarFullBlendRenderDistance = 1200.0;
--		district.treesFarFullRenderDistance = 1000.0;
--		district.treeslodDistance = 600.0;
		end
--	distance.uniqueSceneFarDistance = distance.uniqueSceneFarDistance - 1
end
