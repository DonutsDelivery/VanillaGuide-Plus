# Create TurtleGuide: Northwind (28-34) - Alliance Zone

## Task
Create a leveling guide for **Northwind**, an Alliance zone in Turtle WoW (levels 28-34).

## Zone Info
- **Level Range:** 28-34
- **Faction:** Alliance
- **Location:** Eastern Kingdoms, north of Stormwind
- **Description:** Nestled in a vale north of Stormwind, this is the cradle of nobility within the human kingdom. The verdant hills are now riddled with vile fiends, and Lord Amberwood struggles to maintain order.

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
   - Search for "Turtle WoW Northwind quests" and "Turtle WoW Northwind zone guide"
   - Use https://database.turtle-wow.org/ to find quest IDs, NPC locations, and coordinates
   - Check https://turtle-wow.fandom.com/wiki/Northwind for zone overview
   - Look for quest chains and prerequisites

2. **Check pfQuest database for quest data:**

   **Files:** (See `docs/GUIDE_AUTHORING.md` for full structure)
   - `pfQuest-turtle/db/quests-turtle.lua` - Quest data with `["pre"]` and `["min"]`
   - `pfQuest-turtle/db/units-turtle.lua` - NPC coordinates
   - `pfQuest-turtle/db/enUS/quests.lua` - Quest names by ID

   Search for Northwind quest IDs (40000+ range)

3. **Create the guide file:**
   - File: `Guides/Alliance/28_34_Northwind.lua`
   - Follow the format in the reference guides below
   - Include all QIDs for smart quest tracking
   - Order quests so prerequisites come before dependent quests

4. **Register the guide:**
   - Add to `Guides/Alliance/Guides.xml`

## Reference: Guide Authoring Documentation

```markdown
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

## Essential Tags
| Tag | Description | Example |
|-----|-------------|---------|
| `QID` | Quest ID | `\|QID\|41187\|` |
| `N` | Note text | `\|N\|NPC at (45, 50)\|` |
| `Z` | Zone name | `\|Z\|Northwind\|` |
| `C` | Class restriction | `\|C\|Warrior\|` |
| `O` | Optional | `\|O\|` |

## Coordinates
Include in note: `(45.5, 32.8)` or multiple: `(45, 50) (48, 52)`

## Quest Chain Order
Prerequisites MUST come before dependent quests.
```

## Reference: Thalassian Highlands Guide Pattern

```lua
TurtleGuide:RegisterGuide("Thalassian Highlands (1-10)", "Darkshore (12-17)", "Alliance",function()
return [[

N Welcome to Thalassian Highlands |N|This is the High Elf starting zone.|
A Refugees no More |QID|41187| |N|Aerthand Skyshield in Brinthilien (48.3, 84.3)| |Z|Thalassian Highlands|
T Refugees no More |QID|41187| |N|Commander Anarileth in Brinthilien (48.6, 83.6)| |Z|Thalassian Highlands|
A Provisions for Refugees |QID|41188| |N|Commander Anarileth in Brinthilien (48.6, 83.6)| |Z|Thalassian Highlands|

C Provisions for Refugees |QID|41188| |N|Kill Young Thalassian Boars (46, 82) (50, 78)| |Z|Thalassian Highlands|
T Provisions for Refugees |QID|41188| |N|Commander Anarileth (48.6, 83.6)| |Z|Thalassian Highlands|
A Safety for Refugees |QID|41189| |N|Commander Anarileth (48.6, 83.6)| |Z|Thalassian Highlands|

-- Group nearby quests, minimize travel
A Thalassian Goulash |QID|41190| |N|Dalicia Sweetsilver (47.3, 84.2)| |Z|Thalassian Highlands|
A A Crown of Flowers |QID|41191| |N|Avenant (47.2, 79.1)| |Z|Thalassian Highlands|

H Alah'Thalas |N|Set your hearthstone at the inn| |Z|Thalassian Highlands|
f Alah'Thalas |N|Get the flight point| |Z|Thalassian Highlands|

N Guide Complete |N|Continue to next zone.|

]]
end)
```

## Reference: Vanilla Mid-Level Guide Pattern

```lua
TurtleGuide:RegisterGuide("Duskwood (28-29)", "Ashenvale (29-30)", "Alliance",function()
return [[

R Darkshire |N|Travel to Darkshire (75.8, 44.5)| |Z|Duskwood|
f Darkshire |N|Get the flight point (77.5, 44.4)| |Z|Duskwood|
h Darkshire |N|Set hearthstone at Innkeeper (73.8, 44.5)| |Z|Duskwood|

A The Night Watch (Part 1) |QID|56| |N|Commander Althea Ebonlocke (73.6, 46.9)| |Z|Duskwood|
A Deliveries to Sven |QID|164| |N|Madame Eva (75.9, 45.3)| |Z|Duskwood|

C The Night Watch (Part 1) |QID|56| |N|Kill 8 Skeletal Warriors and 6 Skeletal Mages (72, 36)| |Z|Duskwood|
T The Night Watch (Part 1) |QID|56| |N|Commander Althea Ebonlocke (73.6, 46.9)| |Z|Duskwood|
A The Night Watch (Part 2) |QID|57| |N|Commander Althea Ebonlocke (73.6, 46.9)| |Z|Duskwood|

]]
end)
```

## Output Requirements

1. Create complete guide file at `Guides/Alliance/28_34_Northwind.lua`
2. Include ALL quests in the zone with correct QIDs
3. Ensure prerequisite quests come before dependent quests
4. Add to `Guides/Alliance/Guides.xml`
5. Set appropriate "Next Zone" for level 34+ Alliance content
