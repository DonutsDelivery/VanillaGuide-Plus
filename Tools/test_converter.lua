#!/usr/bin/env lua
-- Quick test of the format converter

package.path = package.path .. ";?.lua"
local FormatConverter = require("FormatConverter")

-- Test TurtleGuide line parsing
local testLines = {
    'A Cutting Teeth |QID|788| |N|Gornek in The Den (42.08, 68.35)|',
    'T Your Place In The World |QID|4641| |N|Gornek in Valley of Trials (42.08, 68.35)|',
    'C Lazy Peons |QID|5441| |N|Use Blackjack on sleeping Peons (42.1, 59.7)|',
    'A Vile Familiars |QID|1485| |N|Ruzan in Valley of Trials (42.61, 68.79)| |C|Warlock|',
    'A Etched Parchment |QID|3087| |N|Gornek in The Den (42.08, 68.35)| |C|Hunter| |R|Orc|',
    'N Ghost Howl |QID|770| |N|OPTIONAL: Look for Ghost Howl rare spawn| |O|',
    'T Back to Thunder Bluff |QID|5932| |N|Turak Runetotem (76.6, 27.6)| |Z|Thunder Bluff| |C|Druid|',
    'A Dark Storms |QID|806| |N|Orgnil Soulscar (52.28, 43.22)| |PRE|823|',
}

print("Testing TurtleGuide -> QuestShell+ conversion:")
print("==============================================")

for _, line in ipairs(testLines) do
    local step = FormatConverter.lineToTable(line)
    if step then
        print("\nInput:  " .. line)
        print("Output: " .. FormatConverter.stepToLuaCode(step, 0))
    end
end

print("\n\nTesting QuestShell+ -> TurtleGuide conversion:")
print("==============================================")

local testSteps = {
    { type="ACCEPT", title="Cutting Teeth", questId=788, coords={x=42.08, y=68.35}, npc={name="Gornek"}, note="Gornek in The Den" },
    { type="COMPLETE", title="Lazy Peons", questId=5441, coords={x=42.1, y=59.7}, note="Use Blackjack on sleeping Peons" },
    { type="ACCEPT", title="Vile Familiars", questId=1485, coords={x=42.61, y=68.79}, class="Warlock", note="Ruzan in Valley of Trials" },
    { type="NOTE", note="OPTIONAL: Look for Ghost Howl rare spawn", questId=770, optional=true },
    { type="TURNIN", title="Back to Thunder Bluff", questId=5932, coords={x=76.6, y=27.6}, zone="Thunder Bluff", class="Druid" },
    { type="ACCEPT", title="Dark Storms", questId=806, coords={x=52.28, y=43.22}, prereq=823 },
}

for _, step in ipairs(testSteps) do
    local line = FormatConverter.tableToLine(step)
    print("\nInput:  type=" .. step.type .. ", title=" .. (step.title or step.note or ""))
    print("Output: " .. line)
end

print("\n\nTest complete!")
