-- Routes.lua
-- Race-based leveling routes for TurtleGuide
-- Defines the zone progression for each race from 1-60
-- Uses Optimized guides from VanillaGuide quest order

local TurtleGuide = TurtleGuide

-- Shared Alliance progression after level 12 (all races merge into this path)
local AllianceSharedPath = {
	-- Level 12-20 progression
	{zone = "Darkshore", levels = "12-14", guide = "Optimized/Darkshore (12-14)"},
	{zone = "Darkshore", levels = "14-17", guide = "Optimized/Darkshore (14-17)"},
	{zone = "Loch Modan", levels = "17-18", guide = "Optimized/Loch Modan (17-18)"},
	{zone = "Redridge Mountains", levels = "18-20", guide = "Optimized/Redridge (18-20)"},
	-- Level 20-30 progression
	{zone = "Darkshore", levels = "20-21", guide = "Optimized/Darkshore (20-21)"},
	{zone = "Ashenvale", levels = "21-22", guide = "Optimized/Ashenvale (21-22)"},
	{zone = "Stonetalon Mountains", levels = "22-23", guide = "Optimized/Stonetalon (22-23)"},
	{zone = "Darkshore", levels = "23-24", guide = "Optimized/Darkshore (23-24)"},
	{zone = "Ashenvale", levels = "24-25", guide = "Optimized/Ashenvale (24-25)"},
	{zone = "Wetlands", levels = "25-27", guide = "Optimized/Wetlands (25-27)"},
	{zone = "Redridge Mountains", levels = "27-28", guide = "Optimized/Redridge (27-28)"},
	{zone = "Duskwood", levels = "28-29", guide = "Optimized/Duskwood (28-29)"},
	{zone = "Ashenvale", levels = "29-30", guide = "Optimized/Ashenvale (29-30)"},
	{zone = "Wetlands", levels = "30-30", guide = "Optimized/Wetlands (30-30)"},
	-- Level 30-40 progression
	{zone = "Hillsbrad Foothills", levels = "30-31", guide = "Optimized/Hillsbrad (30-31)"},
	{zone = "Alterac Mountains", levels = "31-31", guide = "Optimized/Alterac (31-31)"},
	{zone = "Arathi Highlands", levels = "31-32", guide = "Optimized/Arathi (31-32)"},
	{zone = "Stranglethorn Vale", levels = "32-32", guide = "Optimized/Stranglethorn (32-32)"},
	{zone = "Thousand Needles", levels = "32-33", guide = "Optimized/Thousand Needles (32-33)"},
	{zone = "Stonetalon Mountains", levels = "33-33", guide = "Optimized/Stonetalon (33-33)"},
	{zone = "Desolace", levels = "33-35", guide = "Optimized/Desolace (33-35)"},
	{zone = "Stranglethorn Vale", levels = "35-36", guide = "Optimized/Stranglethorn (35-36)"},
	{zone = "Alterac Mountains", levels = "36-37", guide = "Optimized/Alterac (36-37)"},
	{zone = "Arathi Highlands", levels = "37-38", guide = "Optimized/Arathi (37-38)"},
	{zone = "Dustwallow Marsh", levels = "38-38", guide = "Optimized/Dustwallow (38-38)"},
	{zone = "Stranglethorn Vale", levels = "38-40", guide = "Optimized/Stranglethorn (38-40)"},
	-- Level 40-50 progression
	{zone = "Badlands", levels = "40-41", guide = "Optimized/Badlands (40-41)"},
	{zone = "Swamp of Sorrows", levels = "41-41", guide = "Optimized/Swamp of Sorrows (41-41)"},
	{zone = "Desolace", levels = "41-42", guide = "Optimized/Desolace (41-42)"},
	{zone = "Stranglethorn Vale", levels = "42-43", guide = "Optimized/Stranglethorn (42-43)"},
	{zone = "Tanaris", levels = "43-43", guide = "Optimized/Tanaris (43-43)"},
	{zone = "Feralas", levels = "43-45", guide = "Optimized/Feralas (43-45)"},
	{zone = "Uldaman", levels = "45-46", guide = "Optimized/Uldaman (45-46)"},
	{zone = "The Hinterlands", levels = "46-47", guide = "Optimized/Hinterlands (46-47)"},
	{zone = "Feralas", levels = "47-47", guide = "Optimized/Feralas (47-47)"},
	{zone = "Tanaris", levels = "47-48", guide = "Optimized/Tanaris (47-48)"},
	{zone = "The Hinterlands", levels = "48-48", guide = "Optimized/Hinterlands (48-48)"},
	{zone = "Stranglethorn Vale", levels = "48-49", guide = "Optimized/Stranglethorn (48-49)"},
	{zone = "Blasted Lands", levels = "49-50", guide = "Optimized/Blasted Lands (49-50)"},
	-- Level 50-60 progression
	{zone = "Searing Gorge", levels = "50-51", guide = "Optimized/Searing Gorge (50-51)"},
	{zone = "Un'Goro Crater", levels = "51-52", guide = "Optimized/Un'Goro (51-52)"},
	{zone = "Azshara", levels = "52-53", guide = "Optimized/Azshara (52-53)"},
	{zone = "Felwood", levels = "53-54", guide = "Optimized/Felwood (53-54)"},
	{zone = "Winterspring", levels = "54-55", guide = "Optimized/Winterspring (54-55)"},
	{zone = "Burning Steppes", levels = "55-56", guide = "Optimized/Burning Steppes (55-56)"},
	{zone = "Silithus", levels = "56-57", guide = "Optimized/Silithus (56-57)"},
	{zone = "Western Plaguelands", levels = "57-58", guide = "Optimized/Western Plaguelands (57-58)"},
	{zone = "Eastern Plaguelands", levels = "58-59", guide = "Optimized/Eastern Plaguelands (58-59)"},
	{zone = "Winterspring", levels = "59-60", guide = "Optimized/Winterspring (59-60)"},
}

-- Shared Horde progression after level 12 (all races merge into this path after Barrens)
local HordeSharedPath = {
	-- Level 12-20 progression
	{zone = "The Barrens", levels = "12-15", guide = "Optimized/Barrens (12-15)"},
	{zone = "Stonetalon Mountains", levels = "15-16", guide = "Optimized/Stonetalon (15-16)"},
	{zone = "The Barrens", levels = "16-18", guide = "Optimized/Barrens (16-18)"},
	{zone = "The Barrens", levels = "18-20", guide = "Optimized/Barrens (18-20)"},
	-- Level 20-30 progression
	{zone = "Stonetalon Mountains", levels = "20-21", guide = "Optimized/Stonetalon Mountains (20-21)"},
	{zone = "Ashenvale", levels = "21-21", guide = "Optimized/Ashenvale (21-21)"},
	{zone = "Southern Barrens", levels = "22-23", guide = "Optimized/Southern Barrens (22-23)"},
	{zone = "Stonetalon Mountains", levels = "23-25", guide = "Optimized/Stonetalon Mountains (23-25)"},
	{zone = "Southern Barrens", levels = "25-25", guide = "Optimized/Southern Barrens (25-25)"},
	{zone = "Thousand Needles", levels = "25-26", guide = "Optimized/Thousand Needles (25-26)"},
	{zone = "Ashenvale", levels = "26-27", guide = "Optimized/Ashenvale (26-27)"},
	{zone = "Stonetalon Mountains", levels = "27-27", guide = "Optimized/Stonetalon Mountains (27-27)"},
	{zone = "Thousand Needles", levels = "27-29", guide = "Optimized/Thousand Needles (27-29)"},
	{zone = "Hillsbrad Foothills", levels = "29-30", guide = "Optimized/Hillsbrad Foothills (29-30)"},
	-- Level 30-40 progression
	{zone = "Alterac Mountains", levels = "30-30", guide = "Optimized/Alterac Mountains (30-30)"},
	{zone = "Arathi Highlands", levels = "30-30", guide = "Optimized/Arathi Highlands (30-30)"},
	{zone = "Stranglethorn Vale", levels = "30-31", guide = "Optimized/Stranglethorn Vale (30-31)"},
	{zone = "Thousand Needles", levels = "31-32", guide = "Optimized/Thousand Needles (31-32)"},
	{zone = "Desolace", levels = "32-34", guide = "Optimized/Desolace (32-34)"},
	{zone = "Stranglethorn Vale", levels = "34-36", guide = "Optimized/Stranglethorn Vale (34-36)"},
	{zone = "Arathi Highlands", levels = "36-37", guide = "Optimized/Arathi Highlands (36-37)"},
	{zone = "Alterac Mountains", levels = "37-37", guide = "Optimized/Alterac Mountains (37-37)"},
	{zone = "Thousand Needles", levels = "37-38", guide = "Optimized/Thousand Needles (37-38)"},
	{zone = "Dustwallow Marsh", levels = "38-38", guide = "Optimized/Dustwallow Marsh (38-38)"},
	{zone = "Stranglethorn Vale", levels = "38-40", guide = "Optimized/Stranglethorn Vale (38-40)"},
	-- Level 40-50 progression
	{zone = "Badlands", levels = "40-41", guide = "Optimized/Badlands (40-41)"},
	{zone = "Swamp of Sorrows", levels = "41-42", guide = "Optimized/Swamp of Sorrows (41-42)"},
	{zone = "Stranglethorn Vale", levels = "42-43", guide = "Optimized/Stranglethorn Vale (42-43)"},
	{zone = "Desolace", levels = "43-43", guide = "Optimized/Desolace (43-43)"},
	{zone = "Dustwallow Marsh", levels = "43-44", guide = "Optimized/Dustwallow Marsh (43-44)"},
	{zone = "Tanaris", levels = "44-45", guide = "Optimized/Tanaris (44-45)"},
	{zone = "Feralas", levels = "45-46", guide = "Optimized/Feralas (45-46)"},
	{zone = "Azshara", levels = "46-46", guide = "Optimized/Azshara (46-46)"},
	{zone = "The Hinterlands", levels = "46-47", guide = "Optimized/Hinterlands (46-47)"},
	{zone = "Stranglethorn Vale", levels = "47-47", guide = "Optimized/Stranglethorn Vale (47-47)"},
	{zone = "Searing Gorge", levels = "47-48", guide = "Optimized/Searing Gorge (47-48)"},
	{zone = "Swamp of Sorrows", levels = "48-48", guide = "Optimized/Swamp of Sorrows (48-48)"},
	{zone = "Feralas", levels = "48-49", guide = "Optimized/Feralas (48-49)"},
	{zone = "Tanaris", levels = "49-50", guide = "Optimized/Tanaris (49-50)"},
	-- Level 50-60 progression
	{zone = "Azshara", levels = "50-50", guide = "Optimized/Azshara (50-50)"},
	{zone = "The Hinterlands", levels = "50-51", guide = "Optimized/Hinterlands (50-51)"},
	{zone = "Blasted Lands", levels = "51-51", guide = "Optimized/Blasted Lands (51-51)"},
	{zone = "Un'Goro Crater", levels = "51-52", guide = "Optimized/Un'Goro Crater (51-52)"},
	{zone = "Burning Steppes", levels = "52-53", guide = "Optimized/Burning Steppes (52-53)"},
	{zone = "Azshara", levels = "53-54", guide = "Optimized/Azshara (53-54)"},
	{zone = "Felwood", levels = "54-54", guide = "Optimized/Felwood (54-54)"},
	{zone = "Winterspring", levels = "54-55", guide = "Optimized/Winterspring (54-55)"},
	{zone = "Felwood", levels = "55-55", guide = "Optimized/Felwood (55-55)"},
	{zone = "Silithus", levels = "55-55", guide = "Optimized/Silithus (55-55)"},
	{zone = "Western Plaguelands", levels = "55-56", guide = "Optimized/Western Plaguelands (55-56)"},
	{zone = "Eastern Plaguelands", levels = "56-57", guide = "Optimized/Eastern Plaguelands (56-57)"},
	{zone = "Western Plaguelands", levels = "57-58", guide = "Optimized/Western Plaguelands (57-58)"},
	{zone = "Winterspring", levels = "58-60", guide = "Optimized/Winterspring (58-60)"},
}

-- Helper function to merge starting zone with shared path
local function MergeRoutes(startingZones, sharedPath)
	local route = {}
	for _, zone in ipairs(startingZones) do
		table.insert(route, zone)
	end
	for _, zone in ipairs(sharedPath) do
		table.insert(route, zone)
	end
	return route
end

-- ============================================================================
-- Alliance Routes
-- ============================================================================

-- Human route - Elwynn Forest 1-10 → Westfall 10-12 → shared path
TurtleGuide:RegisterRoute("Human", MergeRoutes({
	{zone = "Elwynn Forest", levels = "1-10", guide = "Optimized/Elwynn Forest (1-10)"},
	{zone = "Westfall", levels = "10-12", guide = "Optimized/Westfall (10-12)"},
}, AllianceSharedPath))

-- Dwarf route - Dun Morogh 1-12 → shared path
TurtleGuide:RegisterRoute("Dwarf", MergeRoutes({
	{zone = "Dun Morogh", levels = "1-12", guide = "Optimized/Dun Morogh (1-12)"},
}, AllianceSharedPath))

-- Gnome route - Dun Morogh 1-12 → shared path (same as Dwarf)
TurtleGuide:RegisterRoute("Gnome", MergeRoutes({
	{zone = "Dun Morogh", levels = "1-12", guide = "Optimized/Dun Morogh (1-12)"},
}, AllianceSharedPath))

-- Night Elf route - Teldrassil 1-12 → shared path
TurtleGuide:RegisterRoute("NightElf", MergeRoutes({
	{zone = "Teldrassil", levels = "1-12", guide = "Optimized/Teldrassil (1-12)"},
}, AllianceSharedPath))

-- High Elf (Turtle WoW) - Thalassian Highlands 1-10 → shared path
TurtleGuide:RegisterRoute("HighElf", MergeRoutes({
	{zone = "Thalassian Highlands", levels = "1-10", guide = "Thalassian Highlands (1-10)"},
}, AllianceSharedPath))

-- ============================================================================
-- Horde Routes
-- ============================================================================

-- Orc route - Durotar 1-12 → shared path
TurtleGuide:RegisterRoute("Orc", MergeRoutes({
	{zone = "Durotar", levels = "1-12", guide = "Optimized/Durotar (1-12)"},
}, HordeSharedPath))

-- Troll route - Durotar 1-12 → shared path (same as Orc)
TurtleGuide:RegisterRoute("Troll", MergeRoutes({
	{zone = "Durotar", levels = "1-12", guide = "Optimized/Durotar (1-12)"},
}, HordeSharedPath))

-- Tauren route - Mulgore 1-12 → shared path
TurtleGuide:RegisterRoute("Tauren", MergeRoutes({
	{zone = "Mulgore", levels = "1-12", guide = "Optimized/Mulgore (1-12)"},
}, HordeSharedPath))

-- Undead route - Tirisfal Glades 1-12 → shared path
TurtleGuide:RegisterRoute("Undead", MergeRoutes({
	{zone = "Tirisfal Glades", levels = "1-12", guide = "Optimized/Tirisfal Glades (1-12)"},
}, HordeSharedPath))

-- Goblin (Turtle WoW) - Blackstone Island 1-10 → shared path
TurtleGuide:RegisterRoute("Goblin", MergeRoutes({
	{zone = "Blackstone Island", levels = "1-10", guide = "Blackstone Island (1-10)"},
}, HordeSharedPath))

-- ============================================================================
-- Debug Functions
-- ============================================================================

-- Print route info for debugging
function TurtleGuide:PrintCurrentRoute()
	local route = self.routes[self.db.char.currentroute]
	if not route then
		self:Print("No route selected")
		return
	end

	self:Print("Current route: " .. (self.db.char.currentroute or "None"))
	for i, zone in ipairs(route) do
		self:Print(string.format("  %d. %s (%s) - %s", i, zone.zone, zone.levels, zone.guide))
	end
end

-- Print all available routes
function TurtleGuide:PrintAllRoutes()
	self:Print("Available routes:")
	for name, route in pairs(self.routes) do
		self:Print(string.format("  %s: %d zones", name, table.getn(route)))
	end
end
