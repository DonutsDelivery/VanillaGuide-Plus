# Create TurtleGuide: Scarlet Enclave (55-60) - Contested Zone

## Task
Create a leveling guide for **Scarlet Enclave**, a contested zone in Turtle WoW (levels 55-60).

## Zone Info
- **Level Range:** 55-60
- **Faction:** Both (Contested)
- **Location:** Eastern Kingdoms
- **Description:** A Scarlet Crusade stronghold with challenging end-game content.

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
   - Search for "Turtle WoW Scarlet Enclave quests"
   - Use https://database.turtle-wow.org/ for quest IDs, NPCs, coordinates
   - Check https://turtle-wow.fandom.com/ for zone info

2. **Check pfQuest database:**

   **Files:** (See `docs/GUIDE_AUTHORING.md` for full structure)
   - `pfQuest-turtle/db/quests-turtle.lua` - Quest data with `["pre"]` and `["min"]`
   - `pfQuest-turtle/db/units-turtle.lua` - NPC coordinates
   - `pfQuest-turtle/db/enUS/quests.lua` - Quest names by ID
   - Quest IDs in 40000+ range

3. **Create guide file(s):**
   - `Guides/Alliance/55_60_Scarlet_Enclave.lua` and/or `Guides/Horde/55_60_Scarlet_Enclave.lua`

4. **Register in Guides.xml**

## Guide Format Reference

```lua
TurtleGuide:RegisterGuide("Scarlet Enclave (55-60)", "Next Zone (Level)", "Alliance",function()
return [[

N Welcome to Scarlet Enclave |N|Zone introduction.|

f Zone Hub |N|Get flight point (X, Y)| |Z|Scarlet Enclave|
h Zone Hub |N|Set hearthstone| |Z|Scarlet Enclave|

A Quest Name |QID|XXXXX| |N|NPC Name (X, Y)| |Z|Scarlet Enclave|
C Quest Name |QID|XXXXX| |N|Objectives (X, Y)| |Z|Scarlet Enclave|
T Quest Name |QID|XXXXX| |N|NPC Name (X, Y)| |Z|Scarlet Enclave|

N Guide Complete |N|You have reached level 60!|

]]
end)
```

## Essential Tags
- `|QID|#####|` - Quest ID (REQUIRED)
- `|N|text|` - Note/instructions
- `|Z|Scarlet Enclave|` - Zone name
- `|O|` - Optional quest

## Output Requirements
1. Complete guide with ALL zone quests and QIDs
2. Prerequisites before dependent quests
3. Register in Guides.xml
