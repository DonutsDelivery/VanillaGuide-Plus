-- Routes.lua
-- Race-based leveling routes for TurtleGuide
-- Defines the zone progression for each race from 1-60

local TurtleGuide = TurtleGuide

-- Alliance Routes
TurtleGuide:RegisterRoute("Human", {
	{zone = "Elwynn Forest", levels = "1-12", guide = "Elwynn Forest (1-12)"},
	{zone = "Westfall", levels = "12-17", guide = "Westfall (12-17)"},
	{zone = "Loch Modan", levels = "17-18", guide = "Loch Modan (17-18)"},
	{zone = "Redridge Mountains", levels = "18-20", guide = "Redridge Mountains (18-20)"},
	{zone = "Darkshore", levels = "20-21", guide = "Darkshore (20-21)"},
	{zone = "Ashenvale", levels = "21-22", guide = "Ashenvale (21-22)"},
	{zone = "Stonetalon Mountains", levels = "22-23", guide = "Stonetalon Mountains (22-23)"},
	{zone = "Darkshore", levels = "23-24", guide = "Darkshore (23-24)"},
	{zone = "Ashenvale", levels = "24-24", guide = "Ashenvale (24-24)"},
	{zone = "Wetlands", levels = "24-27", guide = "Wetlands (24-27)"},
	{zone = "Redridge Mountains", levels = "27-28", guide = "Redridge Mountains (27-28)"},
	{zone = "Duskwood", levels = "28-29", guide = "Duskwood (28-29)"},
	{zone = "Ashenvale", levels = "29-30", guide = "Ashenvale (29-30)"},
	{zone = "Wetlands", levels = "30-31", guide = "Wetlands (30-31)"},
	{zone = "Hillsbrad Foothills", levels = "31-32", guide = "Hillsbrad Foothills (31-32)"},
	{zone = "Stranglethorn Vale", levels = "32-33", guide = "Stranglethorn Vale (32-33)"},
	{zone = "Thousand Needles", levels = "33-34", guide = "Thousand Needles (33-34)"},
	{zone = "Desolace", levels = "34-35", guide = "Desolace (34-35)"},
	{zone = "Stranglethorn Vale", levels = "36-37", guide = "Stranglethorn Vale (36-37)"},
	{zone = "Alterac Mountains", levels = "37-37", guide = "Alterac Mountains (37-37)"},
	{zone = "Arathi Highlands", levels = "37-38", guide = "Arathi Highlands (37-38)"},
	{zone = "Dustwallow Marsh", levels = "38-39", guide = "Dustwallow Marsh (38-39)"},
	{zone = "Stranglethorn Vale", levels = "39-40", guide = "Stranglethorn Vale (39-40)"},
	{zone = "Badlands", levels = "40-41", guide = "Badlands (40-41)"},
	{zone = "Swamp of Sorrows", levels = "41-42", guide = "Swamp of Sorrows (41-42)"},
	{zone = "Stranglethorn Vale", levels = "42-43", guide = "Stranglethorn Vale (42-43)"},
	{zone = "Desolace", levels = "43-43", guide = "Desolace (43-43)"},
	{zone = "Tanaris", levels = "43-44", guide = "Tanaris (43-44)"},
	{zone = "Feralas", levels = "44-46", guide = "Feralas (44-46)"},
	{zone = "Azshara", levels = "46-46", guide = "Azshara (46-46)"},
	{zone = "The Hinterlands", levels = "46-46", guide = "Hinterlands (46-46)"},
	{zone = "Stranglethorn Vale", levels = "46-47", guide = "Stranglethorn Vale (46-47)"},
	{zone = "Searing Gorge", levels = "47-48", guide = "Searing Gorge (47-48)"},
	{zone = "Feralas", levels = "48-49", guide = "Feralas (48-49)"},
	{zone = "Tanaris", levels = "49-50", guide = "Tanaris (49-50)"},
	{zone = "The Hinterlands", levels = "50-50", guide = "Hinterlands (50-50)"},
	{zone = "Blasted Lands", levels = "50-51", guide = "Blasted Lands (50-51)"},
	{zone = "Un'Goro Crater", levels = "51-52", guide = "Un'Goro Crater (51-52)"},
	{zone = "Azshara", levels = "52-53", guide = "Azshara (52-53)"},
	{zone = "Felwood", levels = "53-54", guide = "Felwood (53-54)"},
	{zone = "Winterspring", levels = "54-55", guide = "Winterspring (54-55)"},
	{zone = "Burning Steppes", levels = "55-56", guide = "Burning Steppes (55-56)"},
	{zone = "Felwood", levels = "55-56", guide = "Felwood (55-56)"},
	{zone = "Western Plaguelands", levels = "56-57", guide = "Western Plaguelands (56-57)"},
	{zone = "Eastern Plaguelands", levels = "57-58", guide = "Eastern Plaguelands (57-58)"},
	{zone = "Western Plaguelands", levels = "57-58", guide = "Western Plaguelands (57-58)"},
	{zone = "Silithus", levels = "58-59", guide = "Silithus (58-59)"},
	{zone = "Winterspring", levels = "59-60", guide = "Winterspring (59-60)"},
})

TurtleGuide:RegisterRoute("Dwarf", {
	{zone = "Dun Morogh", levels = "1-11", guide = "Dun Morogh (1-11)"},
	{zone = "Loch Modan", levels = "11-17", guide = "Loch Modan (11-17)"},
	{zone = "Westfall", levels = "17-17", guide = "Westfall (17-17)"},
	{zone = "Redridge Mountains", levels = "17-20", guide = "Redridge Mountains (17-20)"},
	{zone = "Darkshore", levels = "20-21", guide = "Darkshore (20-21)"},
	{zone = "Ashenvale", levels = "21-22", guide = "Ashenvale (21-22)"},
	{zone = "Stonetalon Mountains", levels = "22-23", guide = "Stonetalon Mountains (22-23)"},
	{zone = "Darkshore", levels = "23-24", guide = "Darkshore (23-24)"},
	{zone = "Wetlands", levels = "24-27", guide = "Wetlands (24-27)"},
	{zone = "Redridge Mountains", levels = "27-28", guide = "Redridge Mountains (27-28)"},
	{zone = "Duskwood", levels = "28-29", guide = "Duskwood (28-29)"},
	{zone = "Ashenvale", levels = "29-30", guide = "Ashenvale (29-30)"},
	{zone = "Wetlands", levels = "30-31", guide = "Wetlands (30-31)"},
	{zone = "Hillsbrad Foothills", levels = "31-32", guide = "Hillsbrad Foothills (31-32)"},
	{zone = "Stranglethorn Vale", levels = "32-60", guide = "Stranglethorn Vale (32-33)"},
})

TurtleGuide:RegisterRoute("Gnome", {
	{zone = "Dun Morogh", levels = "1-11", guide = "Dun Morogh (1-11)"},
	{zone = "Loch Modan", levels = "11-17", guide = "Loch Modan (11-17)"},
	{zone = "Westfall", levels = "17-17", guide = "Westfall (17-17)"},
	{zone = "Redridge Mountains", levels = "17-20", guide = "Redridge Mountains (17-20)"},
	{zone = "Darkshore", levels = "20-21", guide = "Darkshore (20-21)"},
	{zone = "Ashenvale", levels = "21-22", guide = "Ashenvale (21-22)"},
	{zone = "Stonetalon Mountains", levels = "22-23", guide = "Stonetalon Mountains (22-23)"},
	{zone = "Darkshore", levels = "23-24", guide = "Darkshore (23-24)"},
	{zone = "Wetlands", levels = "24-27", guide = "Wetlands (24-27)"},
	{zone = "Redridge Mountains", levels = "27-28", guide = "Redridge Mountains (27-28)"},
	{zone = "Duskwood", levels = "28-29", guide = "Duskwood (28-29)"},
	{zone = "Ashenvale", levels = "29-30", guide = "Ashenvale (29-30)"},
	{zone = "Wetlands", levels = "30-31", guide = "Wetlands (30-31)"},
	{zone = "Hillsbrad Foothills", levels = "31-32", guide = "Hillsbrad Foothills (31-32)"},
	{zone = "Stranglethorn Vale", levels = "32-60", guide = "Stranglethorn Vale (32-33)"},
})

TurtleGuide:RegisterRoute("NightElf", {
	{zone = "Teldrassil", levels = "1-12", guide = "Teldrassil (1-12)"},
	{zone = "Darkshore", levels = "12-17", guide = "Darkshore (12-17)"},
	{zone = "Loch Modan", levels = "17-18", guide = "Loch Modan (17-18)"},
	{zone = "Redridge Mountains", levels = "18-20", guide = "Redridge Mountains (18-20)"},
	{zone = "Darkshore", levels = "20-21", guide = "Darkshore (20-21)"},
	{zone = "Ashenvale", levels = "21-22", guide = "Ashenvale (21-22)"},
	{zone = "Stonetalon Mountains", levels = "22-23", guide = "Stonetalon Mountains (22-23)"},
	{zone = "Darkshore", levels = "23-24", guide = "Darkshore (23-24)"},
	{zone = "Ashenvale", levels = "24-24", guide = "Ashenvale (24-24)"},
	{zone = "Wetlands", levels = "24-27", guide = "Wetlands (24-27)"},
	{zone = "Redridge Mountains", levels = "27-28", guide = "Redridge Mountains (27-28)"},
	{zone = "Duskwood", levels = "28-29", guide = "Duskwood (28-29)"},
	{zone = "Ashenvale", levels = "29-30", guide = "Ashenvale (29-30)"},
	{zone = "Wetlands", levels = "30-31", guide = "Wetlands (30-31)"},
	{zone = "Hillsbrad Foothills", levels = "31-32", guide = "Hillsbrad Foothills (31-32)"},
	{zone = "Stranglethorn Vale", levels = "32-60", guide = "Stranglethorn Vale (32-33)"},
})

-- Horde Routes
TurtleGuide:RegisterRoute("Orc", {
	{zone = "Durotar", levels = "1-12", guide = "Durotar (1-12)"},
	{zone = "The Barrens", levels = "12-20", guide = "Barrens (12-20)"},
	{zone = "Stonetalon Mountains", levels = "20-22", guide = "Stonetalon Mountains (20-22)"},
	{zone = "Southern Barrens", levels = "22-23", guide = "Southern Barrens (22-23)"},
	{zone = "Stonetalon Mountains", levels = "23-25", guide = "Stonetalon Mountains (23-25)"},
	{zone = "Southern Barrens", levels = "25-25", guide = "Southern Barrens (25-25)"},
	{zone = "Thousand Needles", levels = "25-26", guide = "Thousand Needles (25-26)"},
	{zone = "Ashenvale", levels = "26-27", guide = "Ashenvale (26-27)"},
	{zone = "Stonetalon Mountains", levels = "27-27", guide = "Stonetalon Mountains (27-27)"},
	{zone = "Thousand Needles", levels = "27-29", guide = "Thousand Needles (27-29)"},
	{zone = "Hillsbrad Foothills", levels = "29-30", guide = "Hillsbrad Foothills (29-30)"},
	{zone = "Arathi Highlands", levels = "30-30", guide = "Arathi Highlands (30-30)"},
	{zone = "Stranglethorn Vale", levels = "30-31", guide = "Stranglethorn Vale (30-31)"},
	{zone = "Thousand Needles", levels = "31-32", guide = "Thousand Needles (31-32)"},
	{zone = "Desolace", levels = "32-34", guide = "Desolace (32-34)"},
	{zone = "Stranglethorn Vale", levels = "34-36", guide = "Stranglethorn Vale (34-36)"},
	{zone = "Alterac Mountains", levels = "36-37", guide = "Alterac Mountains (36-37)"},
	{zone = "Arathi Highlands", levels = "37-38", guide = "Arathi Highlands (37-38)"},
	{zone = "Thousand Needles", levels = "37-38", guide = "Thousand Needles (37-38)"},
	{zone = "Dustwallow Marsh", levels = "38-38", guide = "Dustwallow Marsh (38-38)"},
	{zone = "Stranglethorn Vale", levels = "38-40", guide = "Stranglethorn Vale (38-40)"},
	{zone = "Badlands", levels = "40-41", guide = "Badlands (40-41)"},
	{zone = "Swamp of Sorrows", levels = "41-42", guide = "Swamp of Sorrows (41-42)"},
	{zone = "Stranglethorn Vale", levels = "42-43", guide = "Stranglethorn Vale (42-43)"},
	{zone = "Dustwallow Marsh", levels = "43-44", guide = "Dustwallow Marsh (43-44)"},
	{zone = "Desolace", levels = "44-44", guide = "Desolace (44-44)"},
	{zone = "Tanaris", levels = "44-45", guide = "Tanaris (44-45)"},
	{zone = "Feralas", levels = "45-46", guide = "Feralas (45-46)"},
	{zone = "Azshara", levels = "46-47", guide = "Azshara (46-47)"},
	{zone = "The Hinterlands", levels = "47-47", guide = "Hinterlands (47-47)"},
	{zone = "Stranglethorn Vale", levels = "47-47", guide = "Stranglethorn Vale (47-47)"},
	{zone = "Searing Gorge", levels = "47-48", guide = "Searing Gorge (47-48)"},
	{zone = "Swamp of Sorrows", levels = "48-49", guide = "Swamp of Sorrows (48-49)"},
	{zone = "Dustwallow Marsh", levels = "49-49", guide = "Dustwallow Marsh (49-49)"},
	{zone = "Feralas", levels = "49-50", guide = "Feralas (49-50)"},
	{zone = "Tanaris", levels = "49-50", guide = "Tanaris (49-50)"},
	{zone = "Azshara", levels = "50-50", guide = "Azshara (50-50)"},
	{zone = "The Hinterlands", levels = "50-51", guide = "Hinterlands (50-51)"},
	{zone = "Blasted Lands", levels = "51-51", guide = "Blasted Lands (51-51)"},
	{zone = "Un'Goro Crater", levels = "51-53", guide = "Un'Goro Crater (51-53)"},
	{zone = "Burning Steppes", levels = "53-54", guide = "Burning Steppes (53-54)"},
	{zone = "Felwood", levels = "54-54", guide = "Felwood (54-54)"},
	{zone = "Winterspring", levels = "54-55", guide = "Winterspring (54-55)"},
	{zone = "Felwood", levels = "55-56", guide = "Felwood (55-56)"},
	{zone = "Western Plaguelands", levels = "56-56", guide = "Western Plaguelands (56-56)"},
	{zone = "Eastern Plaguelands", levels = "56-57", guide = "Eastern Plaguelands (56-57)"},
	{zone = "Western Plaguelands", levels = "57-58", guide = "Western Plaguelands (57-58)"},
	{zone = "Silithus", levels = "58-59", guide = "Silithus (58-59)"},
	{zone = "Winterspring", levels = "59-60", guide = "Winterspring (59-60)"},
})

TurtleGuide:RegisterRoute("Troll", {
	{zone = "Durotar", levels = "1-12", guide = "Durotar (1-12)"},
	{zone = "The Barrens", levels = "12-20", guide = "Barrens (12-20)"},
	{zone = "Stonetalon Mountains", levels = "20-22", guide = "Stonetalon Mountains (20-22)"},
	{zone = "Southern Barrens", levels = "22-23", guide = "Southern Barrens (22-23)"},
	{zone = "Stonetalon Mountains", levels = "23-25", guide = "Stonetalon Mountains (23-25)"},
	{zone = "Southern Barrens", levels = "25-25", guide = "Southern Barrens (25-25)"},
	{zone = "Thousand Needles", levels = "25-26", guide = "Thousand Needles (25-26)"},
	{zone = "Ashenvale", levels = "26-27", guide = "Ashenvale (26-27)"},
	{zone = "Stonetalon Mountains", levels = "27-27", guide = "Stonetalon Mountains (27-27)"},
	{zone = "Thousand Needles", levels = "27-29", guide = "Thousand Needles (27-29)"},
	{zone = "Hillsbrad Foothills", levels = "29-30", guide = "Hillsbrad Foothills (29-30)"},
	{zone = "Arathi Highlands", levels = "30-30", guide = "Arathi Highlands (30-30)"},
	{zone = "Stranglethorn Vale", levels = "30-60", guide = "Stranglethorn Vale (30-31)"},
})

TurtleGuide:RegisterRoute("Tauren", {
	{zone = "Mulgore", levels = "1-12", guide = "Mulgore (1-12)"},
	{zone = "The Barrens", levels = "12-20", guide = "Barrens (12-20)"},
	{zone = "Stonetalon Mountains", levels = "20-22", guide = "Stonetalon Mountains (20-22)"},
	{zone = "Southern Barrens", levels = "22-23", guide = "Southern Barrens (22-23)"},
	{zone = "Stonetalon Mountains", levels = "23-25", guide = "Stonetalon Mountains (23-25)"},
	{zone = "Southern Barrens", levels = "25-25", guide = "Southern Barrens (25-25)"},
	{zone = "Thousand Needles", levels = "25-26", guide = "Thousand Needles (25-26)"},
	{zone = "Ashenvale", levels = "26-27", guide = "Ashenvale (26-27)"},
	{zone = "Stonetalon Mountains", levels = "27-27", guide = "Stonetalon Mountains (27-27)"},
	{zone = "Thousand Needles", levels = "27-29", guide = "Thousand Needles (27-29)"},
	{zone = "Hillsbrad Foothills", levels = "29-30", guide = "Hillsbrad Foothills (29-30)"},
	{zone = "Arathi Highlands", levels = "30-30", guide = "Arathi Highlands (30-30)"},
	{zone = "Stranglethorn Vale", levels = "30-60", guide = "Stranglethorn Vale (30-31)"},
})

TurtleGuide:RegisterRoute("Undead", {
	{zone = "Tirisfal Glades", levels = "1-12", guide = "Tirisfal Glades (1-12)"},
	{zone = "Silverpine Forest", levels = "12-20", guide = "Silverpine Forest (12-20)"},
	{zone = "The Barrens", levels = "20-20", guide = "Barrens (20-20)"},
	{zone = "Stonetalon Mountains", levels = "20-22", guide = "Stonetalon Mountains (20-22)"},
	{zone = "Southern Barrens", levels = "22-23", guide = "Southern Barrens (22-23)"},
	{zone = "Stonetalon Mountains", levels = "23-25", guide = "Stonetalon Mountains (23-25)"},
	{zone = "Southern Barrens", levels = "25-25", guide = "Southern Barrens (25-25)"},
	{zone = "Thousand Needles", levels = "25-26", guide = "Thousand Needles (25-26)"},
	{zone = "Ashenvale", levels = "26-27", guide = "Ashenvale (26-27)"},
	{zone = "Stonetalon Mountains", levels = "27-27", guide = "Stonetalon Mountains (27-27)"},
	{zone = "Thousand Needles", levels = "27-29", guide = "Thousand Needles (27-29)"},
	{zone = "Hillsbrad Foothills", levels = "29-30", guide = "Hillsbrad Foothills (29-30)"},
	{zone = "Arathi Highlands", levels = "30-30", guide = "Arathi Highlands (30-30)"},
	{zone = "Stranglethorn Vale", levels = "30-60", guide = "Stranglethorn Vale (30-31)"},
})

-- Print route info for debugging
function TurtleGuide:PrintCurrentRoute()
	local route = self.routes[self.db.char.currentroute]
	if not route then
		self:Print("No route selected")
		return
	end

	self:Print("Current route: " .. (self.db.char.currentroute or "None"))
	for i, zone in ipairs(route) do
		self:Print(string.format("  %d. %s (%s)", i, zone.zone, zone.levels))
	end
end
