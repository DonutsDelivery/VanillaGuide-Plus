#!/usr/bin/env lua
-- ==========================================================
-- Batch Guide Converter
-- Converts TurtleGuide format files to QuestShell+ format
-- Usage: lua convert_guides.lua <input_dir> <output_dir>
-- ==========================================================

package.path = package.path .. ";?.lua"
local FormatConverter = require("FormatConverter")

local function scanDir(dir)
    local files = {}
    local p = io.popen('find "' .. dir .. '" -name "*.lua" -type f 2>/dev/null')
    if p then
        for file in p:lines() do
            table.insert(files, file)
        end
        p:close()
    end
    return files
end

local function ensureDir(path)
    os.execute('mkdir -p "' .. path .. '"')
end

local function getFilename(path)
    return path:match("([^/\\]+)$")
end

local function getRelativePath(file, baseDir)
    return file:sub(#baseDir + 2)
end

-- Faction detection from path
local function detectFaction(path)
    if path:lower():match("/horde/") then return "Horde" end
    if path:lower():match("/alliance/") then return "Alliance" end
    return nil
end

-- Parse guide metadata from TurtleGuide file
local function parseGuideMetadata(content, filepath)
    local metadata = {}

    -- Try to extract from RegisterGuide call
    local name = content:match('RegisterGuide%("([^"]+)"')
    local faction = content:match('RegisterGuide%("[^"]+"%s*,%s*"([^"]+)"')

    if name then
        metadata.title = name
    end

    if faction then
        metadata.faction = faction
    else
        metadata.faction = detectFaction(filepath)
    end

    -- Extract level range from filename
    local filename = getFilename(filepath)
    local minLvl, maxLvl, zone = filename:match("(%d+)_(%d+)_(.+)%.lua")
    if minLvl and maxLvl then
        metadata.minLevel = tonumber(minLvl)
        metadata.maxLevel = tonumber(maxLvl)
        if not metadata.title then
            metadata.title = zone:gsub("_", " ") .. " (" .. minLvl .. "-" .. maxLvl .. ")"
        end
    end

    return metadata
end

-- Convert a single file
local function convertFile(inputPath, outputPath)
    local inFile = io.open(inputPath, "r")
    if not inFile then
        print("  ERROR: Could not open " .. inputPath)
        return false
    end

    local content = inFile:read("*all")
    inFile:close()

    -- Extract guide string
    local guideString = content:match("%[%[(.-)%]%]")
    if not guideString then
        print("  SKIP: No guide content found in " .. inputPath)
        return false
    end

    -- Parse metadata
    local metadata = parseGuideMetadata(content, inputPath)

    -- Convert
    local guide = FormatConverter.guideToTables(guideString, metadata)

    -- Generate key from filename
    local filename = getFilename(inputPath):gsub("%.lua$", "")
    guide.key = "QS_" .. filename

    local luaCode = FormatConverter.guideToLuaFile(guide, "QuestShellGuides")

    -- Write output
    local outFile = io.open(outputPath, "w")
    if not outFile then
        print("  ERROR: Could not write " .. outputPath)
        return false
    end
    outFile:write(luaCode)
    outFile:close()

    print("  OK: " .. getFilename(inputPath) .. " -> " .. getFilename(outputPath))
    return true
end

-- Main
local function main(args)
    if #args < 2 then
        print("Usage: lua convert_guides.lua <input_dir> <output_dir>")
        print("")
        print("Converts TurtleGuide format .lua files to QuestShell+ format.")
        print("")
        print("Example:")
        print("  lua convert_guides.lua ../Guides/Optimized ./QuestShellPlus")
        return 1
    end

    local inputDir = args[1]
    local outputDir = args[2]

    print("TurtleGuide -> QuestShell+ Converter")
    print("====================================")
    print("Input:  " .. inputDir)
    print("Output: " .. outputDir)
    print("")

    local files = scanDir(inputDir)
    if #files == 0 then
        print("No .lua files found in " .. inputDir)
        return 1
    end

    print("Found " .. #files .. " files to convert:")
    print("")

    local success = 0
    local failed = 0

    for _, file in ipairs(files) do
        local relPath = getRelativePath(file, inputDir)
        local outPath = outputDir .. "/" .. relPath

        -- Ensure output directory exists
        local outDir = outPath:match("(.+)/[^/]+$")
        if outDir then
            ensureDir(outDir)
        end

        if convertFile(file, outPath) then
            success = success + 1
        else
            failed = failed + 1
        end
    end

    print("")
    print("====================================")
    print("Converted: " .. success .. " files")
    if failed > 0 then
        print("Failed:    " .. failed .. " files")
    end

    return failed > 0 and 1 or 0
end

os.exit(main(arg))
