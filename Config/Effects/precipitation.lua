Rain =
{
	particleTexture = "raindropNormBlur3.dds",
	mistTexture = "normalSemiSphere2.tga",


	particlesMax = 1024*4, -- ���������� ������ � ������, ������ 1024
	mistParticlesMax = 256*1, -- ���������� ������ � ������, ������ 256
	
	verticalSpeed = {8, 14}, -- ��� | ���� ������������ �������� ������� ����� ��� ������ �����, �/�
	
	particlesCellSize = 15, -- ������ ���������� ������ � ������, �
	particlesVolumeDepth = 4, -- ������� ������ ������, ���������� ����� � ����� ���� = 2^(particlesVolumeDepth-1), particlesVolumeDepth > 1
	particleJitterFreq = {0.4, 0.4}, -- �������� ��������� ����������� �������� ������ � �������������� ���������, ��� | ����
	particleJitterVelocity = {0.045, 0.045}, -- �������� �������� ������ ����� � �������������� ���������, ��� | ����
	
	mistCellSize = 200,
	mistVolumeDepth = 3,
	mistJitterFreq = {0.3, 0.3},
	mistJitterVelocity = {2.5, 2.5},
	mistVerticalSpeedFactor = 0.4,
};

Snow =
{
	particleTexture = "normalSemiSphere2.tga",
	mistTexture = "normalSemiSphere2.tga",

	particlesMax = 1024*6,
	mistParticlesMax = 256*2,
	
	verticalSpeed = {0.15, 1.1},
	
	particlesCellSize = 15,
	particlesVolumeDepth = 4,
	particleJitterFreq = {0.2, 1},
	particleJitterVelocity = {0.15, 0.3},
	
	mistCellSize = 200,
	mistVolumeDepth = 3,
	mistJitterFreq = {0.3, 0.3},
	mistJitterVelocity = {2.5, 2.5},
	mistVerticalSpeedFactor = 0.4,
};
