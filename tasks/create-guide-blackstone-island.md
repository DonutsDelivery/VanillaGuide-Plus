# Create TurtleGuide: Blackstone Island (1-10) - Goblin Starting Zone

## Task
Create a leveling guide for **Blackstone Island**, the Goblin starting zone in Turtle WoW (levels 1-10, Horde faction).

## Core Principles: How to Order Quests

Order quests using THREE factors (in priority order):

1. **Prerequisites (Quest Chains)** - MUST be respected
   - Check pfQuest `["pre"]` field for prerequisite QIDs
   - Prerequisite TURNIN must come before dependent quest's ACCEPT

2. **Level Requirements** - SHOULD be respected
   - Check pfQuest `["min"]` field for minimum level
   - Lower level quests before higher level quests

3. **Geographic Proximity** - OPTIMIZE for efficiency
   - Pick up all quests in a hub before leaving
   - Complete nearby objectives together
   - Turn in when passing through, not via special trips

## Instructions

1. **Research the zone online:**
   - Search for "Turtle WoW Blackstone Island quests" and "Turtle WoW Goblin starting zone"
   - Use https://database.turtle-wow.org/ to find quest IDs, NPC locations, and coordinates
   - Check https://turtle-wow.fandom.com/wiki/Blackstone_Island for zone overview
   - Look for quest chains and prerequisites

2. **Check pfQuest database for quest data:**

   **File locations:**
   ```
   /home/user/Programs/WoW/Interface/AddOns/pfQuest-turtle/db/
   ├── quests-turtle.lua    # Quest data (prereqs, levels)
   ├── units-turtle.lua     # NPC coordinates
   └── enUS/quests.lua      # Quest names by ID
   ```

   **Quest data structure:**
   ```lua
   [41187] = {
     ["min"] = 1,              -- Minimum level required
     ["lvl"] = 5,              -- Quest level
     ["pre"] = { 41186 },      -- Prerequisite quest IDs
     ["start"] = { ["U"] = { 12345 } },  -- NPC ID that gives quest
     ["end"] = { ["U"] = { 12346 } },    -- NPC ID for turn-in
   }
   ```

   **NPC coordinates:**
   ```lua
   [12345] = {
     ["coords"] = { [1] = { 45.5, 32.8, 42 } },  -- x, y, zone
   }
   ```

   - Search for Blackstone Island quest IDs (likely in 40000+ range)
   - Note `["pre"]` for prerequisites, `["min"]` for level requirements

3. **Create the guide file:**
   - File: `Guides/Horde/01_10_Blackstone_Island.lua`
   - Follow the format in the reference guides below
   - Include all QIDs for smart quest tracking
   - Order quests so prerequisites come before dependent quests

4. **Register the guide:**
   - Add to `Guides/Horde/Guides.xml`

## Reference: Guide Authoring Documentation

```markdown
# TurtleGuide - Guide Authoring Documentation

## File Structure
Guides are Lua files in `Guides/Alliance/` or `Guides/Horde/`
Named: `{startLevel}_{endLevel}_{ZoneName}.lua`

## Basic Template
```lua
TurtleGuide:RegisterGuide("Zone Name (Level-Range)", "Next Zone (Level-Range)", "Faction", function()
return [[
-- Guide steps here
]]
end)
```

## Action Types
| Code | Action | Description |
|------|--------|-------------|
| `A` | ACCEPT | Accept a quest |
| `C` | COMPLETE | Complete quest objectives |
| `T` | TURNIN | Turn in a quest |
| `N` | NOTE | Information note |
| `R` | RUN | Travel to location |
| `H` | HEARTH | Use hearthstone |
| `h` | SETHEARTH | Set hearthstone |
| `F` | FLY | Take flight path |
| `f` | GETFLIGHTPOINT | Discover flight point |
| `B` | BUY | Purchase item |
| `b` | BOAT | Take a boat |
| `K` | KILL | Kill mobs |
| `G` | GRIND | Grind for XP |
| `U` | USE | Use an item |
| `t` | TRAIN | Train skills |

## Essential Tags
| Tag | Description | Example |
|-----|-------------|---------|
| `QID` | Quest ID | `\|QID\|41187\|` |
| `N` | Note text | `\|N\|NPC at (45, 50)\|` |
| `Z` | Zone name | `\|Z\|Blackstone Island\|` |
| `C` | Class restriction | `\|C\|Warrior\|` |
| `R` | Race restriction | `\|R\|Goblin\|` |
| `O` | Optional | `\|O\|` |
| `L` | Loot item | `\|L\|12345 10\|` |

## Coordinates
Include in note: `(45.5, 32.8)` or multiple: `(45, 50) (48, 52)`

## Quest Chain Order
Prerequisites MUST come before dependent quests:
```lua
T Quest A |QID|100|  -- Turn in first
A Quest B |QID|101|  -- Then accept (requires Quest A)
```
```

## Reference: Thalassian Highlands Guide (Alliance Starting Zone)

```lua
TurtleGuide:RegisterGuide("Thalassian Highlands (1-10)", "Darkshore (12-17)", "Alliance",function()

return [[

N Welcome to Thalassian Highlands |N|This is the High Elf starting zone. You will complete quests in Brinthilien, then travel to Alah'Thalas and surrounding areas before heading to Darkshore.|
A Refugees no More |QID|41187| |N|Aerthand Skyshield in Brinthilien (48.3, 84.3)| |Z|Thalassian Highlands|
T Refugees no More |QID|41187| |N|Commander Anarileth in Brinthilien (48.6, 83.6)| |Z|Thalassian Highlands|
A Provisions for Refugees |QID|41188| |N|Commander Anarileth in Brinthilien (48.6, 83.6)| |Z|Thalassian Highlands|

A Plain Letter |QID|41230| |N|Brinthilien trainer area| |C|Warrior| |Z|Thalassian Highlands|
A Feathered Letter |QID|41231| |N|Brinthilien trainer area| |C|Hunter| |Z|Thalassian Highlands|
A Shady Letter |QID|41229| |N|Brinthilien trainer area| |C|Rogue| |Z|Thalassian Highlands|
A Blessed Elegant Letter |QID|41228| |N|Brinthilien trainer area| |C|Priest| |Z|Thalassian Highlands|
A Magically Sealed Letter |QID|41226| |N|Brinthilien trainer area| |C|Mage| |Z|Thalassian Highlands|
A Elegant Letter |QID|41227| |N|Brinthilien trainer area| |C|Paladin| |Z|Thalassian Highlands|

T Plain Letter |QID|41230| |N|Valanos Dawnfire in Brinthilien| |C|Warrior| |Z|Thalassian Highlands|
T Feathered Letter |QID|41231| |N|Rubinah Longstrider in Brinthilien| |C|Hunter| |Z|Thalassian Highlands|
T Shady Letter |QID|41229| |N|Leela the Shadow in Brinthilien| |C|Rogue| |Z|Thalassian Highlands|
T Blessed Elegant Letter |QID|41228| |N|Maelah Sunsworn in Brinthilien| |C|Priest| |Z|Thalassian Highlands|
T Magically Sealed Letter |QID|41226| |N|Ala'shor Frostfire in Brinthilien| |C|Mage| |Z|Thalassian Highlands|
T Elegant Letter |QID|41227| |N|Lor'thas in Brinthilien| |C|Paladin| |Z|Thalassian Highlands|

A Thalassian Goulash |QID|41190| |N|Dalicia Sweetsilver in Brinthilien (47.3, 84.2)| |Z|Thalassian Highlands|
A A Crown of Flowers |QID|41191| |N|Avenant in Brinthilien (47.2, 79.1)| |Z|Thalassian Highlands|

C Provisions for Refugees |QID|41188| |N|Kill Young Thalassian Boars and collect 10 Young Thalassian Boar Flanks (46, 82) (50, 78)| |Z|Thalassian Highlands|
T Provisions for Refugees |QID|41188| |N|Commander Anarileth in Brinthilien (48.6, 83.6)| |Z|Thalassian Highlands|
A Safety for Refugees |QID|41189| |N|Commander Anarileth in Brinthilien (48.6, 83.6)| |Z|Thalassian Highlands|

-- ... continues with more quests in logical order ...

N Guide Complete |N|You have completed the Thalassian Highlands guide. Continue to Darkshore (12-17).|

]]
end)
```

## Reference: Vanilla Guide Pattern (Darkshore 12-17)

```lua
TurtleGuide:RegisterGuide("Darkshore (12-17)", "Loch Modan (17-18)", "Alliance",function()

return [[

N Level 12 Required |N|You need to be at least level 12 to continue this guide|

R Auberdine |QID|3524| |N|Travel to Auberdine (36.61, 45.59)|
F Auberdine |QID|3524| |N|Grab flight path (36.4, 45.5)|
A Washed Ashore (Part 1) |QID|3524| |N|Gwennyth Bly'Leggonde in Auberdine (36.61, 45.59)|

H Auberdine |QID|963| |N|Set hearthstone at Innkeeper (37, 44.1)|
A Cave Mushrooms |QID|947| |N|Barithras Moonshade in Auberdine (37.32, 43.66)|

N As you go... |AYG|3524| |QID|983| |N|Kill Crawlers along the beach for 6 Crawler Leg|
C Washed Ashore (Part 1) |QID|3524| |N|Find Sea Creature Bones (36.40, 50.87)|

T Washed Ashore (Part 1) |QID|3524| |N|Gwennyth Bly'Leggonde (36.61, 45.59)|
A Washed Ashore (Part 2) |QID|4681| |N|Gwennyth Bly'Leggonde (36.61, 45.59)|

]]
end)
```

## Output Requirements

1. Create complete guide file at `Guides/Horde/01_10_Blackstone_Island.lua`
2. Include ALL quests in the zone with correct QIDs
3. Ensure prerequisite quests come before dependent quests
4. Add to `Guides/Horde/Guides.xml`
5. The "Next Zone" should be an appropriate 10-20 Horde zone (e.g., "Durotar (1-12)" or "The Barrens (10-25)")
