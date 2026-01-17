# Create TurtleGuide: Gilneas (39-46) - Contested Zone

## Task
Create a leveling guide for **Gilneas**, a contested zone in Turtle WoW (levels 39-46).

## Zone Info
- **Level Range:** 39-46
- **Faction:** Both (Contested)
- **Location:** Eastern Kingdoms
- **Description:** The isolated kingdom of Gilneas, cut off from the world by the Greymane Wall. Now accessible with new questlines for both factions.

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
   - Search for "Turtle WoW Gilneas quests" and "Turtle WoW Gilneas zone"
   - Use https://database.turtle-wow.org/ to find quest IDs, NPC locations, and coordinates
   - Check https://turtle-wow.fandom.com/wiki/Gilneas for zone overview
   - Look for quest chains and prerequisites
   - Note any faction-specific quests

2. **Check pfQuest database for quest data:**
   - Search for Gilneas quest IDs (likely in 40000+ range)
   - Note the `["pre"]` field for prerequisite quests
   - Check `["race"]` field for faction restrictions

3. **Create TWO guide files (one per faction):**
   - `Guides/Alliance/39_46_Gilneas.lua`
   - `Guides/Horde/39_46_Gilneas.lua`
   - Or one guide with faction-specific tags if quests are shared

4. **Register the guide(s):**
   - Add to appropriate `Guides.xml` file(s)

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
| `f` | GETFLIGHTPOINT | Discover flight point |

## Essential Tags
| Tag | Description | Example |
|-----|-------------|---------|
| `QID` | Quest ID | `\|QID\|41187\|` |
| `N` | Note text | `\|N\|NPC at (45, 50)\|` |
| `Z` | Zone name | `\|Z\|Gilneas\|` |
| `O` | Optional | `\|O\|` |

## Faction Tags (for shared guides)
Use these to make steps faction-specific:
- Alliance only: Include `\|R\|Human,Dwarf,NightElf,Gnome,HighElf\|`
- Horde only: Include `\|R\|Orc,Troll,Tauren,Undead,Goblin\|`
```

## Reference: Thalassian Highlands Guide Pattern

```lua
TurtleGuide:RegisterGuide("Thalassian Highlands (1-10)", "Darkshore (12-17)", "Alliance",function()
return [[

N Welcome to Thalassian Highlands |N|This is the High Elf starting zone.|
A Refugees no More |QID|41187| |N|Aerthand Skyshield in Brinthilien (48.3, 84.3)| |Z|Thalassian Highlands|
T Refugees no More |QID|41187| |N|Commander Anarileth in Brinthilien (48.6, 83.6)| |Z|Thalassian Highlands|

-- Class-specific quests use |C| tag
A Plain Letter |QID|41230| |N|Brinthilien trainer area| |C|Warrior| |Z|Thalassian Highlands|
A Feathered Letter |QID|41231| |N|Brinthilien trainer area| |C|Hunter| |Z|Thalassian Highlands|

]]
end)
```

## Reference: Contested Zone Pattern (Stranglethorn)

```lua
TurtleGuide:RegisterGuide("Stranglethorn (32-33)", "Thousand Needles (33-34)", "Alliance",function()
return [[

R Booty Bay |N|Travel to Booty Bay (27.1, 77.3)| |Z|Stranglethorn Vale|
f Booty Bay |N|Get the flight point (27.5, 77.8)| |Z|Stranglethorn Vale|
h Booty Bay |N|Set hearthstone at Innkeeper (27.1, 77.3)| |Z|Stranglethorn Vale|

-- Neutral quests available to both factions
A Singing Blue Shards |QID|605| |N|Crank Fizzlebub in Booty Bay (27.1, 77.3)| |Z|Stranglethorn Vale|
A Scaring Shaky |QID|606| |N|"Sea Wolf" MacKinley (27.9, 77.1)| |Z|Stranglethorn Vale|

C Singing Blue Shards |QID|605| |N|Kill Basilisks for 10 Blue Crystals (29, 67)| |Z|Stranglethorn Vale|
T Singing Blue Shards |QID|605| |N|Crank Fizzlebub (27.1, 77.3)| |Z|Stranglethorn Vale|

]]
end)
```

## Output Requirements

1. Create guide file(s) for Gilneas
2. Include ALL quests in the zone with correct QIDs
3. Ensure prerequisite quests come before dependent quests
4. Handle faction-specific content appropriately
5. Add to appropriate `Guides.xml`
6. Set appropriate "Next Zone" for level 46+ content
