--------------------------
--     Elevator Taxi    --
-- a BellinRattin addon --
--    Public Domain    	--
--------------------------

local Base = [[Interface\AddOns\ElevatorTaxi\Sounds\]]
local Sounds = {
	{Base..[[64 Sundays.mp3]], 141, true},
	{Base..[[Acid Trumpet.mp3]],208, true},
	{Base..[[Bossa Antigua.mp3]],283, true},
	{Base..[[Bossa Bossa.mp3]],167, true},
	{Base..[[Casa Bossa Nova.mp3]],242, true},
	{Base..[[George Street Shuffle.mp3]],268, true},
	{Base..[[I Knew a Guy.mp3]],266, true},
	{Base..[[Lobby Time.mp3]],193, true},
	{Base..[[Local Forecast - Elevator.mp3]],189, true},
	{Base..[[Romantic.mp3]],236, true},
	{Base..[[The Elevator Bossa Nova.mp3]],254, true},
	{Base..[[The Jazz Piano.mp3]],160, true},
	{Base..[[The Lounge.mp3]],256, true},
}

local UnitOnTaxi = UnitOnTaxi
local PlayMusic = PlayMusic
local PlayMusic = PlayMusic
local math_random = math.random

local playerOnTaxi = false

local last = -1
local function SetMusic()
	if playerOnTaxi then
		local chosen = 0
		while chosen == 0 do
			chosen = math_random(#Sounds)
			chosen = (Sounds[chosen][3] and not(chosen == last)) and chosen or 0
		end
		PlayMusic(Sounds[chosen][1])
		last = chosen
		C_Timer.After(Sounds[chosen][2], SetMusic, 1)
	else
		StopMusic()
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
frame:RegisterEvent("LOADING_SCREEN_DISABLED")

frame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_MOUNT_DISPLAY_CHANGED" then
		playerOnTaxi = UnitOnTaxi("player") and true or false
		SetMusic()
	elseif event == "LOADING_SCREEN_DISABLED" then
		playerOnTaxi = UnitOnTaxi("player") and true or false
		C_Timer.After(1, SetMusic)
	end
end)