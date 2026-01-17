# Create TurtleGuide: Hyjal (58-60) - Contested Zone

## Task
Create a leveling guide for **Hyjal**, a contested zone in Turtle WoW (levels 58-60).

## Zone Info
- **Level Range:** 58-60
- **Faction:** Both (Contested)
- **Location:** Kalimdor
- **Description:** The sacred mountain of Mount Hyjal, site of Nordrassil, with high-level quests.

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
   - Search for "Turtle WoW Hyjal quests" and "Turtle WoW Mount Hyjal"
   - Use https://database.turtle-wow.org/ for quest IDs, NPCs, coordinates
   - Check https://turtle-wow.fandom.com/ for zone info

2. **Check pfQuest database:**

   **Files:** (See `docs/GUIDE_AUTHORING.md` for full structure)
   - `pfQuest-turtle/db/quests-turtle.lua` - Quest data with `["pre"]` and `["min"]`
   - `pfQuest-turtle/db/units-turtle.lua` - NPC coordinates
   - `pfQuest-turtle/db/enUS/quests.lua` - Quest names by ID
   - Quest IDs in 40000+ range

3. **Create guide file(s):**
   - `Guides/Alliance/58_60_Hyjal.lua` and/or `Guides/Horde/58_60_Hyjal.lua`

4. **Register in Guides.xml**

## Guide Format Reference

```lua
TurtleGuide:RegisterGuide("Hyjal (58-60)", "No Guide", "Alliance",function()
return [[

N Welcome to Hyjal |N|Zone introduction. This is end-game content.|

f Zone Hub |N|Get flight point (X, Y)| |Z|Hyjal|
h Zone Hub |N|Set hearthstone| |Z|Hyjal|

A Quest Name |QID|XXXXX| |N|NPC Name (X, Y)| |Z|Hyjal|
C Quest Name |QID|XXXXX| |N|Objectives (X, Y)| |Z|Hyjal|
T Quest Name |QID|XXXXX| |N|NPC Name (X, Y)| |Z|Hyjal|

N Guide Complete |N|Congratulations on reaching level 60!|

]]
end)
```

## Essential Tags
- `|QID|#####|` - Quest ID (REQUIRED)
- `|N|text|` - Note/instructions
- `|Z|Hyjal|` - Zone name
- `|O|` - Optional quest

## Output Requirements
1. Complete guide with ALL zone quests and QIDs
2. Prerequisites before dependent quests
3. Register in Guides.xml
