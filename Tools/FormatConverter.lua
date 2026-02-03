-- ==========================================================
-- TurtleGuide Format Converter
-- Converts between TurtleGuide string format and QuestShell+ Lua table format
-- Usage: Run with Lua 5.1+ or embed in WoW addon for runtime conversion
-- ==========================================================

local FormatConverter = {}

-- Action type mappings
local ACTION_TO_TYPE = {
    A = "ACCEPT",
    C = "COMPLETE",
    T = "TURNIN",
    K = "KILL",
    R = "RUN",
    H = "HEARTH",
    h = "SETHEARTH",
    G = "GRIND",
    F = "FLY",
    f = "GETFP",
    N = "NOTE",
    B = "BUY",
    b = "BOAT",
    U = "USE",
    P = "PET",
    D = "DIE",
    t = "TRAIN",
}

local TYPE_TO_ACTION = {}
for k, v in pairs(ACTION_TO_TYPE) do
    TYPE_TO_ACTION[v] = k
end

-- ==========================================================
-- TurtleGuide -> QuestShell+ Conversion
-- ==========================================================

-- Parse coordinates from note text: "(42.5, 68.3)" or "(42.5,68.3)"
local function parseCoords(text)
    if not text then return nil end
    local x, y = text:match("%(([%d%.]+)%s*,%s*([%d%.]+)%)")
    if x and y then
        return { x = tonumber(x), y = tonumber(y) }
    end
    return nil
end

-- Extract NPC name from note (heuristic: text before "in" or "at")
local function parseNPC(note)
    if not note then return nil end
    -- Pattern: "NPC Name in Location" or "NPC Name at Location"
    local npc = note:match("^([^%(]+)%s+[ia][nt]%s+")
    if npc then
        npc = npc:gsub("%s+$", "") -- trim trailing space
        return { name = npc }
    end
    return nil
end

-- Parse a single TurtleGuide line into QuestShell+ format
function FormatConverter.lineToTable(line)
    if not line or line == "" then return nil end

    -- Skip empty lines and comments
    line = line:match("^%s*(.-)%s*$") -- trim
    if line == "" or line:match("^%-%-") then return nil end

    -- Parse: "A Quest Name |TAG|value| |TAG|value|..."
    local action, rest = line:match("^(%a)%s+(.+)$")
    if not action or not ACTION_TO_TYPE[action] then
        return nil
    end

    local step = {
        type = ACTION_TO_TYPE[action]
    }

    -- Extract quest name (everything before first |)
    local questName = rest:match("^([^|]+)")
    if questName then
        questName = questName:match("^%s*(.-)%s*$") -- trim
        if questName ~= "" then
            step.title = questName
        end
    end

    -- Parse tags
    local tags = rest:match("|.+$") or ""

    -- |QID|123|
    local qid = tags:match("|QID|(%d+)|")
    if qid then step.questId = tonumber(qid) end

    -- |N|note text|
    local note = tags:match("|N|([^|]+)|?")
    if note then
        step.note = note
        -- Extract coords from note
        local coords = parseCoords(note)
        if coords then step.coords = coords end
        -- Try to extract NPC
        local npc = parseNPC(note)
        if npc then step.npc = npc end
    end

    -- |C|Class| (class filter)
    local class = tags:match("|C|([^|]+)|")
    if class then step.class = class end

    -- |R|Race| (race filter)
    local race = tags:match("|R|([^|]+)|")
    if race then step.race = race end

    -- |Z|Zone| (zone)
    local zone = tags:match("|Z|([^|]+)|")
    if zone then step.zone = zone end

    -- |O| (optional)
    if tags:match("|O|") then step.optional = true end

    -- |PRE|123| (prerequisite)
    local prereq = tags:match("|PRE|(%d+)|")
    if prereq then step.prereq = tonumber(prereq) end

    -- |LEAD|123| (lead-in)
    local leadin = tags:match("|LEAD|(%d+)|")
    if leadin then step.leadin = tonumber(leadin) end

    -- |L|itemId qty| (loot)
    local lootId, lootQty = tags:match("|L|(%d+)%s*(%d*)|")
    if lootId then
        step.loot = {
            itemId = tonumber(lootId),
            qty = tonumber(lootQty) or 1
        }
    end

    return step
end

-- Convert entire TurtleGuide guide string to QuestShell+ format
function FormatConverter.guideToTables(guideString, metadata)
    metadata = metadata or {}
    local steps = {}

    for line in guideString:gmatch("[^\r\n]+") do
        local step = FormatConverter.lineToTable(line)
        if step then
            table.insert(steps, step)
        end
    end

    return {
        title = metadata.title or "Converted Guide",
        faction = metadata.faction,
        minLevel = metadata.minLevel,
        maxLevel = metadata.maxLevel,
        next = metadata.next,
        nextKey = metadata.nextKey,
        steps = steps
    }
end

-- ==========================================================
-- QuestShell+ -> TurtleGuide Conversion
-- ==========================================================

-- Format coordinates for TurtleGuide
local function formatCoords(coords)
    if not coords or not coords.x or not coords.y then return "" end
    return string.format("(%.2f, %.2f)", coords.x, coords.y)
end

-- Convert a single QuestShell+ step to TurtleGuide line
function FormatConverter.tableToLine(step)
    if not step or not step.type then return nil end

    local action = TYPE_TO_ACTION[step.type]
    if not action then return nil end

    local parts = { action }

    -- Quest/step name
    if step.title then
        table.insert(parts, " " .. step.title)
    elseif step.type == "NOTE" then
        table.insert(parts, " Note")
    else
        table.insert(parts, " Step")
    end

    local tags = {}

    -- |QID|
    if step.questId then
        table.insert(tags, string.format("|QID|%d|", step.questId))
    end

    -- |N| (note with coords)
    if step.note then
        local noteText = step.note
        -- Append coords if not already in note
        if step.coords and not noteText:match("%([%d%.]+%s*,%s*[%d%.]+%)") then
            noteText = noteText .. " " .. formatCoords(step.coords)
        end
        table.insert(tags, string.format("|N|%s|", noteText))
    elseif step.coords then
        -- No note but has coords - create minimal note
        local noteText = formatCoords(step.coords)
        if step.npc and step.npc.name then
            noteText = step.npc.name .. " " .. noteText
        end
        table.insert(tags, string.format("|N|%s|", noteText))
    end

    -- |C| (class)
    if step.class then
        table.insert(tags, string.format("|C|%s|", step.class))
    elseif step.classes then
        table.insert(tags, string.format("|C|%s|", table.concat(step.classes, ", ")))
    end

    -- |R| (race)
    if step.race then
        table.insert(tags, string.format("|R|%s|", step.race))
    elseif step.races then
        table.insert(tags, string.format("|R|%s|", table.concat(step.races, ", ")))
    end

    -- |Z| (zone)
    if step.zone then
        table.insert(tags, string.format("|Z|%s|", step.zone))
    end

    -- |O| (optional)
    if step.optional then
        table.insert(tags, "|O|")
    end

    -- |PRE| (prerequisite)
    if step.prereq then
        table.insert(tags, string.format("|PRE|%d|", step.prereq))
    elseif step.prereqs then
        for _, p in ipairs(step.prereqs) do
            table.insert(tags, string.format("|PRE|%d|", p))
        end
    end

    -- |LEAD| (lead-in)
    if step.leadin then
        table.insert(tags, string.format("|LEAD|%d|", step.leadin))
    end

    -- |L| (loot)
    if step.loot then
        local lootStr = tostring(step.loot.itemId)
        if step.loot.qty and step.loot.qty > 1 then
            lootStr = lootStr .. " " .. step.loot.qty
        end
        table.insert(tags, string.format("|L|%s|", lootStr))
    end

    -- Combine
    if #tags > 0 then
        table.insert(parts, " ")
        table.insert(parts, table.concat(tags, " "))
    end

    return table.concat(parts)
end

-- Convert entire QuestShell+ guide to TurtleGuide format
function FormatConverter.tablesToGuide(guide)
    if not guide or not guide.steps then return "" end

    local lines = {}

    for _, step in ipairs(guide.steps) do
        local line = FormatConverter.tableToLine(step)
        if line then
            table.insert(lines, line)
        end
    end

    return table.concat(lines, "\n")
end

-- ==========================================================
-- Lua Code Generation (for creating .lua guide files)
-- ==========================================================

local function luaEscape(str)
    if not str then return '""' end
    str = str:gsub('\\', '\\\\')
    str = str:gsub('"', '\\"')
    str = str:gsub('\n', '\\n')
    return '"' .. str .. '"'
end

local function indent(level)
    return string.rep("  ", level)
end

-- Generate Lua code for a step table
function FormatConverter.stepToLuaCode(step, indentLevel)
    indentLevel = indentLevel or 2
    local parts = {}
    local ind = indent(indentLevel)

    table.insert(parts, ind .. "{ ")

    local fields = {}

    -- type (always first)
    table.insert(fields, 'type=' .. luaEscape(step.type))

    -- title
    if step.title then
        table.insert(fields, 'title=' .. luaEscape(step.title))
    end

    -- questId
    if step.questId then
        table.insert(fields, 'questId=' .. step.questId)
    end

    -- coords
    if step.coords then
        table.insert(fields, string.format('coords={x=%.2f, y=%.2f}', step.coords.x, step.coords.y))
    end

    -- npc
    if step.npc and step.npc.name then
        table.insert(fields, 'npc={name=' .. luaEscape(step.npc.name) .. '}')
    end

    -- note
    if step.note then
        table.insert(fields, 'note=' .. luaEscape(step.note))
    end

    -- class
    if step.class then
        table.insert(fields, 'class=' .. luaEscape(step.class))
    end

    -- race
    if step.race then
        table.insert(fields, 'race=' .. luaEscape(step.race))
    end

    -- zone
    if step.zone then
        table.insert(fields, 'zone=' .. luaEscape(step.zone))
    end

    -- optional
    if step.optional then
        table.insert(fields, 'optional=true')
    end

    -- prereq
    if step.prereq then
        table.insert(fields, 'prereq=' .. step.prereq)
    end

    -- leadin
    if step.leadin then
        table.insert(fields, 'leadin=' .. step.leadin)
    end

    -- loot
    if step.loot then
        table.insert(fields, string.format('loot={itemId=%d, qty=%d}',
            step.loot.itemId, step.loot.qty or 1))
    end

    table.insert(parts, table.concat(fields, ', '))
    table.insert(parts, ' },')

    return table.concat(parts)
end

-- Generate full Lua guide file from QuestShell+ format
function FormatConverter.guideToLuaFile(guide, varName)
    varName = varName or "QuestShellGuides"

    local lines = {
        "-- =========================",
        "-- " .. (guide.title or "Guide"),
        "-- Generated by TurtleGuide Format Converter",
        "-- =========================",
        "",
        varName .. " = " .. varName .. " or {}",
        "",
        varName .. "[" .. luaEscape(guide.key or guide.title or "guide") .. "] = {",
    }

    -- Metadata
    if guide.title then
        table.insert(lines, "  title = " .. luaEscape(guide.title) .. ",")
    end
    if guide.faction then
        table.insert(lines, "  faction = " .. luaEscape(guide.faction) .. ",")
    end
    if guide.minLevel then
        table.insert(lines, "  minLevel = " .. guide.minLevel .. ",")
    end
    if guide.maxLevel then
        table.insert(lines, "  maxLevel = " .. guide.maxLevel .. ",")
    end
    if guide.next then
        table.insert(lines, "  next = " .. luaEscape(guide.next) .. ",")
    end
    if guide.nextKey then
        table.insert(lines, "  nextKey = " .. luaEscape(guide.nextKey) .. ",")
    end

    -- Steps
    table.insert(lines, "")
    table.insert(lines, "  steps = {")

    for _, step in ipairs(guide.steps or {}) do
        table.insert(lines, FormatConverter.stepToLuaCode(step, 2))
    end

    table.insert(lines, "  }")
    table.insert(lines, "}")

    return table.concat(lines, "\n")
end

-- ==========================================================
-- File conversion helpers (for standalone Lua execution)
-- ==========================================================

-- Read a TurtleGuide file and convert to QuestShell+ Lua file
function FormatConverter.convertFile(inputPath, outputPath, metadata)
    local inFile = io.open(inputPath, "r")
    if not inFile then
        return nil, "Could not open input file: " .. inputPath
    end

    local content = inFile:read("*all")
    inFile:close()

    -- Extract the guide string from TurtleGuide format
    -- TurtleGuide wraps guides in: TurtleGuide:RegisterGuide("name", "faction", function() return [[...]] end)
    local guideString = content:match("%[%[(.-)%]%]")
    if not guideString then
        -- Try without wrapper (raw guide content)
        guideString = content
    end

    -- Extract metadata from filename if not provided
    if not metadata then
        metadata = {}
        local filename = inputPath:match("([^/\\]+)%.lua$")
        if filename then
            local minLvl, maxLvl, zone = filename:match("(%d+)_(%d+)_(.+)")
            if minLvl and maxLvl and zone then
                metadata.minLevel = tonumber(minLvl)
                metadata.maxLevel = tonumber(maxLvl)
                metadata.title = zone:gsub("_", " ") .. " (" .. minLvl .. "-" .. maxLvl .. ")"
            end
        end
    end

    -- Convert
    local guide = FormatConverter.guideToTables(guideString, metadata)
    guide.key = "QS_" .. (metadata.title or "Guide"):gsub("[%s%(%)%-]", "_")

    local luaCode = FormatConverter.guideToLuaFile(guide)

    if outputPath then
        local outFile = io.open(outputPath, "w")
        if not outFile then
            return nil, "Could not open output file: " .. outputPath
        end
        outFile:write(luaCode)
        outFile:close()
    end

    return luaCode
end

-- ==========================================================
-- Export
-- ==========================================================

return FormatConverter
