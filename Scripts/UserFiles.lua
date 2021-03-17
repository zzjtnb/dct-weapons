--TODO ��� ��������� ������� ��� ������������� ���������������� ������
--� �������� VFS
--���� ��� VFS, �� ����� ��������� userfiles � edCore

local lfs = require('lfs')

userMissionPath = lfs.writedir()..'Missions\\'
userTrackPath = lfs.writedir()..'Tracks\\'
userCampaignPath = lfs.writedir() .. 'Missions\\Campaigns\\'
userMoviePath = lfs.writedir() .. 'Movies\\'
userMgPath = lfs.writedir() .. 'MG\\'
userOptionsPresetsPath = lfs.writedir() .. 'Config\\OptionsPresets\\'

local function findUserLocation()	
	local locations = lfs.locations()
	if locations then
		for i, location in ipairs(locations) do		
			if location.path == userMissionPath then
				return true
			end
		end
	end
	return false
end

function initLocations()
	function _(str) return str end
	lfs.add_location(_('My Missions'), userMissionPath)
end

if not __EMBEDDED__ and findUserLocation() == false then
    initLocations()
end
