-- RXPConverter.lua
-- Converts RestedXP guide format to TurtleGuide format
-- Can be used standalone or called from within the addon

local RXPConverter = {}

-- TurtleGuide action mappings
local actionMap = {
	accept = "A",
	turnin = "T",
	complete = "C",
	goto = "R",    -- Run to location
	fly = "F",
	fp = "f",      -- Get flight point
	hs = "H",      -- Hearth
	home = "h",    -- Set hearth
	vendor = "B",  -- Buy (or use N for note)
	train = "t",
	trainer = "t",
	zone = "R",    -- Travel to zone
	collect = "C", -- Collect items (part of quest)
	kill = "K",    -- Kill mobs (grind)
	use = "U",
	deathskip = "D", -- Die intentionally
}

-- Strip RXP color codes and textures
local function stripFormatting(text)
	if not text then return "" end
	-- Remove texture tags |Tpath:size|t
	text = string.gsub(text, "|T[^|]+|t", "")
	-- Remove color codes |cRXP_WARN_...|r, |cRXP_ENEMY_...|r, etc.
	text = string.gsub(text, "|cRXP_WARN_([^|]*)|r", "%1")
	text = string.gsub(text, "|cRXP_ENEMY_([^|]*)|r", "%1")
	text = string.gsub(text, "|cRXP_FRIENDLY_([^|]*)|r", "%1")
	text = string.gsub(text, "|cRXP_LOOT_([^|]*)|r", "%1")
	text = string.gsub(text, "|cRXP_PICK_([^|]*)|r", "%1")
	text = string.gsub(text, "|cRXP_BUY_([^|]*)|r", "%1")
	text = string.gsub(text, "|c%x%x%x%x%x%x%x%x([^|]*)|r", "%1")
	-- Remove any remaining |r
	text = string.gsub(text, "|r", "")
	-- Trim whitespace
	text = string.gsub(text, "^%s+", "")
	text = string.gsub(text, "%s+$", "")
	return text
end

-- Parse coordinates from .goto Zone,x,y format
local function parseCoords(line)
	local zone, x, y = string.match(line, "%.goto%s+([^,]+),([%d%.]+),([%d%.]+)")
	if zone and x and y then
		return zone, tonumber(x), tonumber(y)
	end
	return nil, nil, nil
end

-- Parse quest ID and name from .accept/.turnin lines
local function parseQuestAction(line)
	-- Format: .accept QID >>Quest Name or .accept QID,reward >>Quest Name
	local qid, questName = string.match(line, "%.%w+%s+(%d+)[^>]*>>%s*(.+)")
	if qid and questName then
		-- Clean up quest name - remove "Accept ", "Turn in ", etc.
		questName = string.gsub(questName, "^Accept%s+", "")
		questName = string.gsub(questName, "^Turn in%s+", "")
		questName = stripFormatting(questName)
		return tonumber(qid), questName
	end
	return nil, nil
end

-- Parse .complete lines
local function parseComplete(line)
	-- Format: .complete QID,objectiveIndex --Comment
	local qid, objIdx, comment = string.match(line, "%.complete%s+(%d+),(%d+)%s*%-%-(.+)")
	if not qid then
		qid, objIdx = string.match(line, "%.complete%s+(%d+),(%d+)")
	end
	if qid then
		return tonumber(qid), tonumber(objIdx), comment and stripFormatting(comment)
	end
	return nil, nil, nil
end

-- Parse class/race filters
local function parseFilter(line)
	-- << Class or << !Class or << Race
	local exclude, filter = string.match(line, "<<%s*(!?)(%w+)")
	if filter then
		return filter, exclude == "!"
	end
	-- Also handle << Class/Race combined
	filter = string.match(line, "<<%s*([%w/]+)")
	return filter, false
end

-- Parse a single step block
local function parseStep(stepLines, currentZone, currentClass, currentRace)
	local result = {
		action = nil,
		quest = nil,
		qid = nil,
		note = nil,
		coords = nil,
		zone = currentZone,
		class = currentClass,
		race = currentRace,
		optional = false,
		sticky = false,
	}

	local notes = {}
	local coords = {}
	local targetNPC = nil
	local mobName = nil

	for _, line in ipairs(stepLines) do
		line = string.gsub(line, "^%s+", "")

		-- Check for class/race filter on this step
		local filter, isExclude = parseFilter(line)
		if filter then
			-- Determine if it's a class or race
			local classes = {Warrior=1, Paladin=1, Hunter=1, Rogue=1, Priest=1, Shaman=1, Mage=1, Warlock=1, Druid=1}
			local races = {Human=1, Dwarf=1, Gnome=1, NightElf=1, Orc=1, Troll=1, Tauren=1, Undead=1}
			if classes[filter] then
				result.class = isExclude and ("!" .. filter) or filter
			elseif races[filter] then
				result.race = isExclude and ("!" .. filter) or filter
			else
				-- Could be combined like Orc/Troll
				result.race = filter
			end
		end

		-- Parse commands
		if string.find(line, "^%.goto") then
			local zone, x, y = parseCoords(line)
			if zone and x and y then
				result.zone = zone
				table.insert(coords, string.format("%.1f, %.1f", x, y))
			end
		elseif string.find(line, "^%.accept") then
			result.action = "A"
			result.qid, result.quest = parseQuestAction(line)
		elseif string.find(line, "^%.turnin") then
			result.action = "T"
			result.qid, result.quest = parseQuestAction(line)
		elseif string.find(line, "^%.complete") then
			result.action = "C"
			local qid, objIdx, comment = parseComplete(line)
			result.qid = qid
			if comment then
				table.insert(notes, comment)
			end
		elseif string.find(line, "^%.train") then
			result.action = "t"
			local skill = string.match(line, ">>%s*Train%s+(.+)")
			if skill then
				result.quest = stripFormatting(skill)
			end
		elseif string.find(line, "^%.vendor") then
			local vendorNote = string.match(line, ">>(.+)")
			if vendorNote then
				table.insert(notes, stripFormatting(vendorNote))
			end
		elseif string.find(line, "^%.target") then
			targetNPC = string.match(line, "^%.target%s+(.+)")
			if targetNPC then
				targetNPC = stripFormatting(targetNPC)
			end
		elseif string.find(line, "^%.mob") then
			mobName = string.match(line, "^%.mob%s+(.+)")
			if mobName then
				mobName = stripFormatting(mobName)
			end
		elseif string.find(line, "^%.home") then
			result.action = "h"
			result.quest = result.zone or "Inn"
		elseif string.find(line, "^%.hs") then
			result.action = "H"
			result.quest = "Hearthstone"
		elseif string.find(line, "^%.fp") then
			result.action = "f"
			local fpName = string.match(line, "^%.fp%s+(.+)")
			if fpName then
				result.quest = stripFormatting(fpName)
			end
		elseif string.find(line, "^%.fly") then
			result.action = "F"
			local dest = string.match(line, "^%.fly%s+(.+)")
			if dest then
				result.quest = stripFormatting(dest)
			end
		elseif string.find(line, "^%.zone") then
			result.action = "R"
			local zoneNote = string.match(line, ">>(.+)")
			if zoneNote then
				result.quest = stripFormatting(zoneNote)
			end
		elseif string.find(line, "^%.xp") then
			local level = string.match(line, "^%.xp%s+(%d+)")
			local xpNote = string.match(line, ">>(.+)")
			if level then
				result.action = "G"  -- Grind
				result.quest = xpNote and stripFormatting(xpNote) or ("Grind to level " .. level)
			end
		elseif string.find(line, "^%.deathskip") then
			result.action = "D"
			result.quest = "Die and respawn"
		elseif string.find(line, "^%.collect") then
			-- .collect ItemID,qty
			local itemNote = string.match(line, ">>(.+)")
			if itemNote then
				table.insert(notes, stripFormatting(itemNote))
			end
		elseif string.find(line, "^%.use") then
			result.action = "U"
			local useItem = string.match(line, ">>(.+)")
			if useItem then
				result.quest = stripFormatting(useItem)
			end
		elseif string.find(line, "^>>") then
			-- Note/instruction text
			local noteText = string.match(line, "^>>(.+)")
			if noteText then
				table.insert(notes, stripFormatting(noteText))
			end
		elseif string.find(line, "^%+") then
			-- Additional note
			local noteText = string.match(line, "^%+(.+)")
			if noteText then
				table.insert(notes, stripFormatting(noteText))
			end
		elseif string.find(line, "^#completewith") then
			result.optional = true
		elseif string.find(line, "^#sticky") then
			result.sticky = true
		end
	end

	-- Build note from collected info
	local noteparts = {}
	if targetNPC then
		table.insert(noteparts, targetNPC)
	end
	if mobName and result.action ~= "C" then
		table.insert(noteparts, "Kill " .. mobName)
	end
	for _, n in ipairs(notes) do
		table.insert(noteparts, n)
	end
	if coords[1] then
		table.insert(noteparts, "(" .. coords[1] .. ")")
	end

	if table.getn(noteparts) > 0 then
		result.note = table.concat(noteparts, " - ")
	end

	return result
end

-- Convert a single step to TurtleGuide format
local function stepToTurtleGuide(step)
	if not step.action or not step.quest then
		-- If we have a note but no action, make it a NOTE
		if step.note and string.len(step.note) > 0 then
			step.action = "N"
			step.quest = step.note
			step.note = nil
		else
			return nil
		end
	end

	local parts = {step.action, " ", step.quest}

	if step.qid then
		table.insert(parts, " |QID|")
		table.insert(parts, step.qid)
		table.insert(parts, "|")
	end

	if step.note then
		table.insert(parts, " |N|")
		table.insert(parts, step.note)
		table.insert(parts, "|")
	end

	if step.optional then
		table.insert(parts, " |O|")
	end

	if step.class then
		table.insert(parts, " |C|")
		table.insert(parts, step.class)
		table.insert(parts, "|")
	end

	if step.race then
		table.insert(parts, " |R|")
		table.insert(parts, step.race)
		table.insert(parts, "|")
	end

	return table.concat(parts)
end

-- Main conversion function
function RXPConverter.Convert(rxpGuide)
	local lines = {}
	local currentZone = nil
	local currentClass = nil
	local currentRace = nil
	local guideName = "Converted Guide"
	local nextGuide = nil
	local faction = "Both"

	-- Split into lines
	local guideLines = {}
	for line in string.gmatch(rxpGuide, "[^\r\n]+") do
		table.insert(guideLines, line)
	end

	-- Parse header and metadata
	local i = 1
	while i <= table.getn(guideLines) do
		local line = guideLines[i]

		if string.find(line, "^#name") then
			guideName = stripFormatting(string.match(line, "^#name%s+(.+)"))
		elseif string.find(line, "^#next") then
			nextGuide = stripFormatting(string.match(line, "^#next%s+(.+)"))
		elseif string.find(line, "^<<") then
			local f = string.match(line, "^<<%s*(%w+)")
			if f == "Alliance" or f == "Horde" then
				faction = f
			end
		elseif string.find(line, "^step") then
			break
		end
		i = i + 1
	end

	-- Parse steps
	local steps = {}
	local currentStep = {}

	while i <= table.getn(guideLines) do
		local line = guideLines[i]

		if string.find(line, "^step") then
			-- Process previous step
			if table.getn(currentStep) > 0 then
				local parsed = parseStep(currentStep, currentZone, currentClass, currentRace)
				if parsed.zone then currentZone = parsed.zone end
				local tgLine = stepToTurtleGuide(parsed)
				if tgLine then
					table.insert(steps, tgLine)
				end
			end
			currentStep = {}
		else
			-- Update global filters
			local filter = string.match(line, "^<<%s*(%w+)")
			if filter then
				local classes = {Warrior=1, Paladin=1, Hunter=1, Rogue=1, Priest=1, Shaman=1, Mage=1, Warlock=1, Druid=1}
				if classes[filter] then
					currentClass = filter
				end
			end
			table.insert(currentStep, line)
		end
		i = i + 1
	end

	-- Process last step
	if table.getn(currentStep) > 0 then
		local parsed = parseStep(currentStep, currentZone, currentClass, currentRace)
		local tgLine = stepToTurtleGuide(parsed)
		if tgLine then
			table.insert(steps, tgLine)
		end
	end

	-- Build TurtleGuide format output
	local output = {}
	table.insert(output, "-- Converted from RestedXP format")
	table.insert(output, "-- Original guide: " .. guideName)
	table.insert(output, "")
	table.insert(output, string.format('TurtleGuide:RegisterGuide("RXP/%s", "%s", "%s", function()',
		guideName, nextGuide or "", faction))
	table.insert(output, "")
	table.insert(output, "return [[")
	table.insert(output, "")
	table.insert(output, "N " .. guideName .. " |N|Converted from RestedXP guide|")
	table.insert(output, "")

	for _, step in ipairs(steps) do
		table.insert(output, step)
	end

	table.insert(output, "")
	table.insert(output, "]]")
	table.insert(output, "end)")

	return table.concat(output, "\n"), guideName, faction
end

-- Parse guide registration from RXP format
function RXPConverter.ParseGuideHeader(rxpGuide)
	local info = {
		name = nil,
		faction = "Both",
		class = nil,
		race = nil,
		next = nil,
		levels = nil,
	}

	for line in string.gmatch(rxpGuide, "[^\r\n]+") do
		if string.find(line, "^#name") then
			info.name = stripFormatting(string.match(line, "^#name%s+(.+)"))
			-- Try to extract level range from name
			local minLvl, maxLvl = string.match(info.name, "(%d+)%-(%d+)")
			if minLvl and maxLvl then
				info.levels = {tonumber(minLvl), tonumber(maxLvl)}
			end
		elseif string.find(line, "^#next") then
			info.next = stripFormatting(string.match(line, "^#next%s+(.+)"))
		elseif string.find(line, "^#defaultfor") then
			info.race = string.match(line, "^#defaultfor%s+(%w+)")
		elseif string.find(line, "^<<%s*Warrior") or string.find(line, "^<< Warrior") then
			info.class = "Warrior"
		elseif string.find(line, "^<<") then
			local f = string.match(line, "^<<%s*(%w+)")
			if f == "Alliance" or f == "Horde" then
				info.faction = f
			end
		elseif string.find(line, "^step") then
			break
		end
	end

	return info
end

-- Export for use in addon
if TurtleGuide then
	TurtleGuide.RXPConverter = RXPConverter
end

return RXPConverter
