# Create TurtleGuide: Balor (29-34) - Contested Zone

## Task
Create a leveling guide for **Balor**, a contested zone in Turtle WoW (levels 29-34).

## Zone Info
- **Level Range:** 29-34
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
   - Search for "Turtle WoW Balor quests" and "Turtle WoW Balor zone"
   - Use https://database.turtle-wow.org/ to find quest IDs, NPC locations, coordinates
   - Check https://turtle-wow.fandom.com/ for zone overview
   - Look for quest chains and prerequisites

2. **Check pfQuest database:**

   **Files:** (See `docs/GUIDE_AUTHORING.md` for full structure)
   - `pfQuest-turtle/db/quests-turtle.lua` - Quest data with `["pre"]` and `["min"]`
   - `pfQuest-turtle/db/units-turtle.lua` - NPC coordinates
   - `pfQuest-turtle/db/enUS/quests.lua` - Quest names by ID

   Search for Balor quest IDs (40000+ range)

3. **Create guide file(s):**
   - `Guides/Alliance/29_34_Balor.lua` and/or `Guides/Horde/29_34_Balor.lua`

4. **Register in Guides.xml**

## Guide Format Reference

```lua
TurtleGuide:RegisterGuide("Balor (29-34)", "Next Zone (Level)", "Alliance",function()
return [[

N Welcome to Balor |N|Zone introduction and overview.|

f Zone Hub |N|Get the flight point (X, Y)| |Z|Balor|
h Zone Hub |N|Set hearthstone| |Z|Balor|

A Quest Name |QID|XXXXX| |N|NPC Name at location (X, Y)| |Z|Balor|
C Quest Name |QID|XXXXX| |N|Objectives description (X, Y)| |Z|Balor|
T Quest Name |QID|XXXXX| |N|NPC Name (X, Y)| |Z|Balor|

N Guide Complete |N|Continue to next zone.|

]]
end)
```

## Essential Tags
- `|QID|#####|` - Quest ID (REQUIRED)
- `|N|text|` - Note/instructions
- `|Z|Balor|` - Zone name
- `|O|` - Optional quest
- `|C|Class|` - Class restriction
- `|R|Race|` - Race restriction

## Output Requirements
1. Complete guide with ALL zone quests and QIDs
2. Prerequisites before dependent quests
3. Register in Guides.xml
