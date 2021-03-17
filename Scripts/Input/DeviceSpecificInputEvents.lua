local deviceSpecificInputEvents = {}

local function addEvent(value, key, deviceName)
	local deviceNames
	
	if deviceName == "VR Controller" then
		deviceNames = {"Oculus Touch", "WMR Holographic Controller", "VIVE Controller", "FakeVR Controller"}
	else
		deviceNames = {deviceName}
	end
	
	for i, deviceName in ipairs(deviceNames) do
		local deviceEvents = deviceSpecificInputEvents[deviceName]
		
		if not deviceEvents then
			deviceEvents = {}
			deviceSpecificInputEvents[deviceName] = deviceEvents
		end
		
		if deviceEvents[key] then
			print("deviceEvents[" .. key .. "] for device " .. deviceName .. " already exists!")
		end
		
		deviceEvents[key] = value
	end
end

-- device specific event names
-- this event names should be translated in input.po files!
-- for localization purposes this file must repeat InputEvents.lua file structure!
addEvent("Button A"						, "JOY_BTN1"			, "Controller (Xbox 360 Wireless Receiver for Windows)")
addEvent("Button B"						, "JOY_BTN2"			, "Controller (Xbox 360 Wireless Receiver for Windows)")
addEvent("Button X"						, "JOY_BTN3"			, "Controller (Xbox 360 Wireless Receiver for Windows)")
addEvent("Button Y"						, "JOY_BTN4"			, "Controller (Xbox 360 Wireless Receiver for Windows)")
addEvent("Left Bumper"					, "JOY_BTN5"			, "Controller (Xbox 360 Wireless Receiver for Windows)")
addEvent("Right Bumper"					, "JOY_BTN6"			, "Controller (Xbox 360 Wireless Receiver for Windows)")
addEvent("Back"							, "JOY_BTN7"			, "Controller (Xbox 360 Wireless Receiver for Windows)")
addEvent("Start"						, "JOY_BTN8"			, "Controller (Xbox 360 Wireless Receiver for Windows)")
addEvent("Left Trigger"					, "JOY_LEFT_TRIGGER"	, "Controller (Xbox 360 Wireless Receiver for Windows)")
addEvent("Right Trigger"				, "JOY_RIGHT_TRIGGER"	, "Controller (Xbox 360 Wireless Receiver for Windows)")
			
addEvent("Left Stick X"					, "JOY_X"				, "Controller (Xbox 360 Wireless Receiver for Windows)")
addEvent("Left Stick Y"					, "JOY_Y"				, "Controller (Xbox 360 Wireless Receiver for Windows)")
			
addEvent("Right Stick X"				, "JOY_RX"				, "Controller (Xbox 360 Wireless Receiver for Windows)")
addEvent("Right Stick Y"				, "JOY_RY"				, "Controller (Xbox 360 Wireless Receiver for Windows)")
			
addEvent("D-pad Up"						, "JOY_BTN_POV1_U"		, "Controller (Xbox 360 Wireless Receiver for Windows)")
addEvent("D-pad Up Right"				, "JOY_BTN_POV1_UR"		, "Controller (Xbox 360 Wireless Receiver for Windows)")
addEvent("D-pad Right"					, "JOY_BTN_POV1_R"		, "Controller (Xbox 360 Wireless Receiver for Windows)")
addEvent("D-pad Down Right"				, "JOY_BTN_POV1_DR"		, "Controller (Xbox 360 Wireless Receiver for Windows)")
addEvent("D-pad Down"					, "JOY_BTN_POV1_D"		, "Controller (Xbox 360 Wireless Receiver for Windows)")
addEvent("D-pad Down Left"				, "JOY_BTN_POV1_DL"		, "Controller (Xbox 360 Wireless Receiver for Windows)")
addEvent("D-pad Left"					, "JOY_BTN_POV1_L"		, "Controller (Xbox 360 Wireless Receiver for Windows)")
addEvent("D-pad Up Left"				, "JOY_BTN_POV1_UL"		, "Controller (Xbox 360 Wireless Receiver for Windows)")

addEvent("Left: Trigger"				, "JOY_BTN1"			, "VR Controller")
addEvent("Right: Trigger"				, "JOY_BTN2"			, "VR Controller")
addEvent("Left: Button X"				, "JOY_BTN3"			, "VR Controller")
addEvent("Right: Button A"				, "JOY_BTN4"			, "VR Controller")
addEvent("Left: Button Y"				, "JOY_BTN5"			, "VR Controller")
addEvent("Right: Button B"				, "JOY_BTN6"			, "VR Controller")
addEvent("Left: Menu"					, "JOY_BTN7"			, "VR Controller")
addEvent("Right: Menu"					, "JOY_BTN8"			, "VR Controller")

addEvent("Stick: Trigger"				, "JOY_BTN11"			, "VR Controller")
addEvent("Throttle: Trigger"			, "JOY_BTN12"			, "VR Controller")
addEvent("Stick: Button A-X"			, "JOY_BTN13"			, "VR Controller")
addEvent("Throttle: Button A-X"			, "JOY_BTN14"			, "VR Controller")
addEvent("Stick: Button B-Y"			, "JOY_BTN15"			, "VR Controller")
addEvent("Throttle: Button B-Y"			, "JOY_BTN16"			, "VR Controller")
addEvent("Stick: Menu"					, "JOY_BTN17"			, "VR Controller")
addEvent("Throttle: Menu"				, "JOY_BTN18"			, "VR Controller")

addEvent("Left: Touch Pad Up"			, "JOY_BTN_POV1_U"		, "VR Controller")
addEvent("Left: Touch Pad Right"		, "JOY_BTN_POV1_R"		, "VR Controller")
addEvent("Left: Touch Pad Down"			, "JOY_BTN_POV1_D"		, "VR Controller")
addEvent("Left: Touch Pad Left"			, "JOY_BTN_POV1_L"		, "VR Controller")
														
addEvent("Right: Touch Pad Up"			, "JOY_BTN_POV2_U"		, "VR Controller")
addEvent("Right: Touch Pad Right"		, "JOY_BTN_POV2_R"		, "VR Controller")
addEvent("Right: Touch Pad Down"		, "JOY_BTN_POV2_D"		, "VR Controller")
addEvent("Right: Touch Pad Left"		, "JOY_BTN_POV2_L"		, "VR Controller")

addEvent("Stick: Touch Pad Up"			, "JOY_BTN_POV3_U"		, "VR Controller")
addEvent("Stick: Touch Pad Right"		, "JOY_BTN_POV3_R"		, "VR Controller")
addEvent("Stick: Touch Pad Down"		, "JOY_BTN_POV3_D"		, "VR Controller")
addEvent("Stick: Touch Pad Left"		, "JOY_BTN_POV3_L"		, "VR Controller")
														
addEvent("Throttle: Touch Pad Up"		, "JOY_BTN_POV4_U"		, "VR Controller")
addEvent("Throttle: Touch Pad Right"	, "JOY_BTN_POV4_R"		, "VR Controller")
addEvent("Throttle: Touch Pad Down"		, "JOY_BTN_POV4_D"		, "VR Controller")
addEvent("Throttle: Touch Pad Left"		, "JOY_BTN_POV4_L"		, "VR Controller")

addEvent("Left: Touch Pad X"			, "JOY_X"				, "VR Controller")
addEvent("Left: Touch Pad Y"			, "JOY_Y"				, "VR Controller")
	
addEvent("Right: Touch Pad X"			, "JOY_RX"				, "VR Controller")
addEvent("Right: Touch Pad Y"			, "JOY_RY"				, "VR Controller")	

addEvent("Stick: Touch Pad X"			, "JOY_VX"				, "VR Controller")
addEvent("Stick: Touch Pad Y"			, "JOY_VY"				, "VR Controller")
	
addEvent("Throttle: Touch Pad X"		, "JOY_VRX"				, "VR Controller")
addEvent("Throttle: Touch Pad Y"		, "JOY_VRY"				, "VR Controller")

addEvent("Left: Joystick X"				, "JOY_AX"				, "VR Controller")
addEvent("Left: Joystick Y"				, "JOY_AY"				, "VR Controller")

addEvent("Right: Joystick X"			, "JOY_ARX"				, "VR Controller")
addEvent("Right: Joystick Y"			, "JOY_ARY"				, "VR Controller")

addEvent("Stick: Joystick X"			, "JOY_FX"				, "VR Controller")
addEvent("Stick: Joystick Y"			, "JOY_FY"				, "VR Controller")

addEvent("Throttle: Joystick X"			, "JOY_FRX"				, "VR Controller")
addEvent("Throttle: Joystick Y"			, "JOY_FRY"				, "VR Controller")

return deviceSpecificInputEvents
