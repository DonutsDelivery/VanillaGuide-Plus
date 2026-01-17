# Create TurtleGuide: Grim Reaches (33-38) - Contested Zone

## Task
Create a leveling guide for **Grim Reaches**, a contested zone in Turtle WoW (levels 33-38).

## Zone Info
- **Level Range:** 33-38
- **Faction:** Both (Contested)
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
   - Search for "Turtle WoW Grim Reaches quests"
   - Use https://database.turtle-wow.org/ for quest IDs, NPCs, coordinates
   - Check https://turtle-wow.fandom.com/ for zone info

2. **Check pfQuest database:**

   **Files:** (See `docs/GUIDE_AUTHORING.md` for full structure)
   - `pfQuest-turtle/db/quests-turtle.lua` - Quest data with `["pre"]` and `["min"]`
   - `pfQuest-turtle/db/units-turtle.lua` - NPC coordinates
   - `pfQuest-turtle/db/enUS/quests.lua` - Quest names by ID
   - Quest IDs in 40000+ range

3. **Create guide file(s):**
   - `Guides/Alliance/33_38_Grim_Reaches.lua` and/or `Guides/Horde/33_38_Grim_Reaches.lua`

4. **Register in Guides.xml**

## Guide Format Reference

```lua
TurtleGuide:RegisterGuide("Grim Reaches (33-38)", "Next Zone (Level)", "Alliance",function()
return [[

N Welcome to Grim Reaches |N|Zone introduction.|

f Zone Hub |N|Get flight point (X, Y)| |Z|Grim Reaches|
h Zone Hub |N|Set hearthstone| |Z|Grim Reaches|

A Quest Name |QID|XXXXX| |N|NPC Name (X, Y)| |Z|Grim Reaches|
C Quest Name |QID|XXXXX| |N|Objectives (X, Y)| |Z|Grim Reaches|
T Quest Name |QID|XXXXX| |N|NPC Name (X, Y)| |Z|Grim Reaches|

N Guide Complete |N|Continue to next zone.|

]]
end)
```

## Essential Tags
- `|QID|#####|` - Quest ID (REQUIRED)
- `|N|text|` - Note/instructions
- `|Z|Grim Reaches|` - Zone name
- `|O|` - Optional quest

## Output Requirements
1. Complete guide with ALL zone quests and QIDs
2. Prerequisites before dependent quests
3. Register in Guides.xml
