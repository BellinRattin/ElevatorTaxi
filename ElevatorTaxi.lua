--------------------------
--     Elevator Taxi    --
-- a BellinRattin addon --
--    Public Domain    	--
--------------------------

-- all the songs the addon can play
-- All song are under Creative Commons CC-BY-3.0 or CC-BY-4.0 
-- full license breakdown available in LICENSE.txt in Sounds folder
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

-- local reference for some game functions
local UnitOnTaxi = UnitOnTaxi
local PlayMusic = PlayMusic
local StopMusic = StopMusic
local math_random = math.random

-- to not play the same song twice in a row
local last = -1
-- to know if a song is playing
local playing = false

-- main function. Check if player is flying in a taxi and choose a song to play
local function SetMusic()
	-- check if player is currenty on a taxi
	local playerOnTaxi = UnitOnTaxi("player") and true or false
	-- if yes
	if playerOnTaxi then
		local chosen = 0
		while chosen == 0 do
			-- choose a random song
			chosen = math_random(#Sounds)
			-- check if chosen song is enabled (value #3 in Sounds) and if it's not the same as last one
			chosen = (Sounds[chosen][3] and not(chosen == last)) and chosen or 0
		end
		-- play the choosen song 
		-- will replace currently playing music (the game background one too)
		PlayMusic(Sounds[chosen][1])
		-- remember this song to not repeat twice in a row
		last = chosen
		-- set playing flag to true
		playing = true
		-- timer to remember the addon to choose a new song when the current one ends
		C_Timer.After(Sounds[chosen][2], SetMusic, 1)
	-- if no
	else
		-- check if a song is playing
		if playing then
			-- stop the music [the obscure effect of StopMusic() function]
			-- works only for the addon started music, will not interrupt the game background music
			StopMusic()
			-- set playing flag to false
			playing = false
		end
	end
end

-- A hidden frame to register and handle events
local frame = CreateFrame("Frame")
frame:RegisterEvent("LOADING_SCREEN_DISABLED")
frame:RegisterEvent("UNIT_FLAGS")
frame:SetScript("OnEvent", function(self, event, ...)

	-- if player /reload mid flight or log-in while on taxi
	if event == "LOADING_SCREEN_DISABLED" then
		C_Timer.After(1, SetMusic)

	-- if player flag OnTaxi change
	elseif event == "UNIT_FLAGS" then
		SetMusic()
	end
end)