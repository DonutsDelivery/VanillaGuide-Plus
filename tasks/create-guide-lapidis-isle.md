# Create TurtleGuide: Lapidis Isle (48-53) - Alliance Zone

## Task
Create a leveling guide for **Lapidis Isle**, an Alliance zone in Turtle WoW (levels 48-53).

## Zone Info
- **Level Range:** 48-53
- **Faction:** Alliance
- **Location:** Eastern Kingdoms

## Core Principles: How to Order Quests

Order quests using THREE factors (in priority order):

1. **Prerequisites (Quest Chains)** - MUST be respected
   - Check pfQuest `["pre"]` field for prerequisite QIDs
   - Prerequisite TURNIN must come before dependent quest ACCEPT

2. **Level Requirements** - SHOULD be respected
   - Check pfQuest `["min"]` field for minimum level
   - Lower level quests before higher level quests

3. **Geographic Proximity** - OPTIMIZE for efficiency
   - Pick up all quests in a hub before leaving
   - Complete nearby objectives together
   - Turn in when passing through, not via special trips

## Instructions

1. **Research the zone online:**
   - Search for "Turtle WoW Lapidis Isle quests"
   - Use https://database.turtle-wow.org/ for quest IDs, NPCs, coordinates
   - Check https://turtle-wow.fandom.com/ for zone info

2. **Check pfQuest database:**

   **Files:** (See `docs/GUIDE_AUTHORING.md` for full structure)
   - `pfQuest-turtle/db/quests-turtle.lua` - Quest data with `["pre"]` and `["min"]`
   - `pfQuest-turtle/db/units-turtle.lua` - NPC coordinates
   - `pfQuest-turtle/db/enUS/quests.lua` - Quest names by ID
   - Quest IDs in 40000+ range

3. **Create guide file:**
   - `Guides/Alliance/48_53_Lapidis_Isle.lua`

4. **Register in `Guides/Alliance/Guides.xml`**

## Guide Format Reference

```lua
TurtleGuide:RegisterGuide("Lapidis Isle (48-53)", "Next Zone (Level)", "Alliance",function()
return [[

N Welcome to Lapidis Isle |N|Zone introduction.|

f Zone Hub |N|Get flight point (X, Y)| |Z|Lapidis Isle|
h Zone Hub |N|Set hearthstone| |Z|Lapidis Isle|

A Quest Name |QID|XXXXX| |N|NPC Name (X, Y)| |Z|Lapidis Isle|
C Quest Name |QID|XXXXX| |N|Objectives (X, Y)| |Z|Lapidis Isle|
T Quest Name |QID|XXXXX| |N|NPC Name (X, Y)| |Z|Lapidis Isle|

N Guide Complete |N|Continue to next zone.|

]]
end)
```

## Essential Tags
- `|QID|#####|` - Quest ID (REQUIRED)
- `|N|text|` - Note/instructions
- `|Z|Lapidis Isle|` - Zone name
- `|O|` - Optional quest

## Output Requirements
1. Complete guide with ALL zone quests and QIDs
2. Prerequisites before dependent quests
3. Register in Guides.xml
