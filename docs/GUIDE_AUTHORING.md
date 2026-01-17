# TurtleGuide - Guide Authoring Documentation

This document explains how to create leveling guides for TurtleGuide addon.

## Core Principles: How to Order Quests

Guides must be organized using THREE factors:

### 1. Prerequisites (Quest Chains)
Quests that require completing other quests first MUST come after their prerequisites.
- Check pfQuest database `["pre"]` field for prerequisite QIDs
- Example: If Quest B requires Quest A, then A's TURNIN must come before B's ACCEPT

### 2. Level Requirements
Order quests by their minimum level requirements.
- Lower level quests come before higher level quests
- Check pfQuest database `["min"]` field for minimum level
- Group quests of similar level together

### 3. Geographic Proximity
Minimize travel time by grouping nearby quests together.
- Pick up all quests in a hub before leaving
- Complete objectives in the same area together
- Turn in quests when passing through, not via special trips
- Use coordinates to plan efficient routes

### Balancing the Three Factors

```
PRIORITY ORDER:
1. Prerequisites - MUST be respected (game enforced)
2. Level requirements - SHOULD be respected (difficulty)
3. Proximity - OPTIMIZE within above constraints (efficiency)
```

**Example workflow:**
1. List all quests in the zone with their QIDs
2. Look up prerequisites and minimum levels in pfQuest
3. Build dependency graph (what requires what)
4. Group by geographic area
5. Order groups by level, respecting prerequisites within each group

## File Structure

Guides are Lua files located in:
- `Guides/Alliance/` - Alliance faction guides
- `Guides/Horde/` - Horde faction guides

Files should be named with the pattern: `{startLevel}_{endLevel}_{ZoneName}.lua`

Example: `01_10_Thalassian_Highlands.lua`

## Basic Guide Template

```lua
TurtleGuide:RegisterGuide("Zone Name (Level-Range)", "Next Zone (Level-Range)", "Faction", function()

return [[

-- Guide steps go here

]]
end)
```

### Parameters:
1. **Guide Name**: Display name with level range, e.g., "Darkshore (12-17)"
2. **Next Zone**: The guide that follows this one, e.g., "Loch Modan (17-18)"
3. **Faction**: "Alliance", "Horde", or "Both"
4. **Function**: Returns the guide text as a multi-line string

## Action Types

Each line starts with a single-letter action code:

| Code | Action | Description |
|------|--------|-------------|
| `A` | ACCEPT | Accept a quest |
| `C` | COMPLETE | Complete quest objectives |
| `T` | TURNIN | Turn in a quest |
| `N` | NOTE | Information/instruction note |
| `R` | RUN | Travel to a location |
| `H` | HEARTH | Use hearthstone |
| `h` | SETHEARTH | Set hearthstone location |
| `F` | FLY | Take a flight path |
| `f` | GETFLIGHTPOINT | Discover a flight point |
| `B` | BUY | Purchase an item |
| `b` | BOAT | Take a boat |
| `K` | KILL | Kill mobs (non-quest) |
| `G` | GRIND | Grind mobs for XP |
| `U` | USE | Use an item |
| `t` | TRAIN | Train at a trainer |
| `D` | DIE | Die (spirit rez) |
| `P` | PET | Pet-related action |

## Tag System

Tags provide metadata and are enclosed in `|TAG|value|` format.

### Essential Tags

| Tag | Description | Example |
|-----|-------------|---------|
| `QID` | Quest ID from database | `\|QID\|41187\|` |
| `N` | Note/instruction text | `\|N\|Talk to the NPC at (45, 50)\|` |
| `Z` | Zone name override | `\|Z\|Thalassian Highlands\|` |

### Conditional Tags

| Tag | Description | Example |
|-----|-------------|---------|
| `C` | Class restriction | `\|C\|Warrior\|` or `\|C\|Mage,Warlock\|` |
| `R` | Race restriction | `\|R\|Human\|` or `\|R\|Dwarf,Gnome\|` |
| `O` | Optional quest | `\|O\|` |
| `T` | In-town objective | `\|T\|` |

### Item Tags

| Tag | Description | Example |
|-----|-------------|---------|
| `L` | Loot item ID and quantity | `\|L\|12345 10\|` |
| `U` | Use item ID | `\|U\|6948\|` |

### Special Tags

| Tag | Description | Example |
|-----|-------------|---------|
| `LV` | Level requirement | `\|LV\|10\|` |
| `PRE` | Prerequisite quest name | `\|PRE\|Previous Quest\|` |
| `S` | Skip follow-up flag | `\|S\|` |
| `SZ` | Subzone name | `\|SZ\|Brinthilien\|` |
| `OBJ` | Object ID | `\|OBJ\|12345\|` |
| `AYG` | "As You Go" reference | `\|AYG\|41190\|` |

## Coordinates

Include coordinates in the note text using the format `(X, Y)` or `(X.X, Y.Y)`:

```
A Quest Name |QID|12345| |N|NPC Name in Town (45.5, 32.8)| |Z|Zone Name|
```

Multiple coordinates for mob grinding areas:
```
C Kill Quest |QID|12345| |N|Kill 10 mobs in this area (45, 50) (48, 52) (42, 48)| |Z|Zone Name|
```

## Quest Chains and Prerequisites

### Correct Ordering

Quests must be ordered so prerequisites come BEFORE the quests that require them:

```lua
-- CORRECT: Quest A turnin before Quest B accept
A Quest A |QID|100|
C Quest A |QID|100|
T Quest A |QID|100|
A Quest B |QID|101|  -- Quest B requires Quest A

-- WRONG: Quest B accept before Quest A turnin
A Quest B |QID|101|  -- ERROR: Prerequisites not met!
A Quest A |QID|100|
```

### Finding Prerequisites

Use the pfQuest database to find quest prerequisites:
1. Look up the quest in pfQuest-turtle's `db/quests-turtle.lua`
2. Check the `["pre"]` field for prerequisite QIDs
3. Ensure those quests appear earlier in your guide

Example from pfQuest database:
```lua
[41215] = {
    ["pre"] = { 41214 },  -- Requires quest 41214 first
    ...
}
```

### Cross-Zone Prerequisites

If a quest requires completing something in another zone:
1. Note it clearly in the guide
2. The addon will warn players automatically (if pfQuest is installed)

## Complete Example

From `01_10_Thalassian_Highlands.lua`:

```lua
TurtleGuide:RegisterGuide("Thalassian Highlands (1-10)", "Darkshore (12-17)", "Alliance", function()

return [[

N Welcome to Thalassian Highlands |N|This is the High Elf starting zone.|

A Refugees no More |QID|41187| |N|Aerthand Skyshield in Brinthilien (48.3, 84.3)| |Z|Thalassian Highlands|
T Refugees no More |QID|41187| |N|Commander Anarileth in Brinthilien (48.6, 83.6)| |Z|Thalassian Highlands|
A Provisions for Refugees |QID|41188| |N|Commander Anarileth in Brinthilien (48.6, 83.6)| |Z|Thalassian Highlands|

A Plain Letter |QID|41230| |N|Brinthilien trainer area| |C|Warrior| |Z|Thalassian Highlands|
A Feathered Letter |QID|41231| |N|Brinthilien trainer area| |C|Hunter| |Z|Thalassian Highlands|

C Provisions for Refugees |QID|41188| |N|Kill Young Thalassian Boars (46, 82) (50, 78)| |Z|Thalassian Highlands|
T Provisions for Refugees |QID|41188| |N|Commander Anarileth (48.6, 83.6)| |Z|Thalassian Highlands|

H Alah'Thalas |N|Set your hearthstone at Tiriel's inn| |Z|Thalassian Highlands|

R Alah'Thalas Docks |N|Travel to the docks (62, 17.9)| |Z|Thalassian Highlands|
B Boat to Auberdine |N|Take the boat to Darkshore|

N Guide Complete |N|Continue to Darkshore (12-17).|

]]
end)
```

## Registering Your Guide

After creating the guide file, add it to the appropriate `Guides.xml`:

```xml
<Ui xmlns="http://www.blizzard.com/wow/ui/">
    <Script file="01_10_Thalassian_Highlands.lua"/>
    <Script file="12_17_Darkshore.lua"/>
    <!-- Add your new guide here -->
</Ui>
```

## Research Resources

When creating guides for Turtle WoW custom zones:

1. **Turtle WoW Database**: https://database.turtle-wow.org/
   - Search for quests, NPCs, items by zone
   - Get quest IDs, coordinates, requirements

2. **Turtle WoW Wiki**: https://turtle-wow.fandom.com/
   - Zone overviews and lore
   - Custom content documentation

3. **pfQuest-turtle Database**: `/Interface/AddOns/pfQuest-turtle/db/`
   - `quests-turtle.lua` - Quest data with prerequisites
   - `units-turtle.lua` - NPC locations
   - Quest IDs in 40000+ range are Turtle WoW custom

4. **In-Game Exploration**:
   - Use `/way` commands with TomTom
   - Use pfQuest to show available quests on map

## pfQuest Database Structure

The pfQuest database files contain all quest data you need for guide creation.

### File Locations
```
/Interface/AddOns/pfQuest-turtle/db/
├── quests-turtle.lua      # Quest data (prereqs, levels, objectives)
├── units-turtle.lua       # NPC data (locations, coordinates)
├── objects-turtle.lua     # Object data (quest objects)
├── items-turtle.lua       # Item data
└── enUS/                  # Localized quest/NPC names
    └── quests.lua
```

### Quest Data Structure (`quests-turtle.lua`)
```lua
pfDB["quests"]["data"] = {
  [41187] = {                    -- Quest ID
    ["min"] = 1,                 -- Minimum level required
    ["lvl"] = 5,                 -- Quest level (difficulty)
    ["pre"] = { 41186 },         -- Prerequisite quest IDs (array)
    ["race"] = 255,              -- Race bitmask (255 = all)
    ["class"] = 255,             -- Class bitmask (255 = all)
    ["start"] = {
      ["U"] = { 12345 },         -- Unit (NPC) IDs that give quest
      ["O"] = { 67890 },         -- Object IDs that give quest
      ["I"] = { 11111 },         -- Item IDs that start quest
    },
    ["end"] = {
      ["U"] = { 12346 },         -- Unit (NPC) IDs to turn in
    },
    ["obj"] = {
      ["U"] = { 54321, 54322 },  -- Units to kill
      ["I"] = { 22222 },         -- Items to collect
      ["O"] = { 33333 },         -- Objects to interact with
    },
  },
}
```

### Key Fields for Guide Creation
| Field | Description | Use |
|-------|-------------|-----|
| `["min"]` | Minimum player level | Order quests by level |
| `["pre"]` | Array of prerequisite QIDs | Ensure prereqs come first |
| `["start"]["U"]` | NPC IDs that give quest | Look up NPC location |
| `["end"]["U"]` | NPC IDs for turn-in | Look up NPC location |
| `["obj"]` | Objective targets | Describe what to kill/collect |

### Unit/NPC Data Structure (`units-turtle.lua`)
```lua
pfDB["units"]["data"] = {
  [12345] = {                    -- Unit (NPC) ID
    ["coords"] = {
      [1] = { 45.5, 32.8, 0 },   -- x, y, zone_index
      [2] = { 46.2, 33.1, 0 },   -- multiple spawn points
    },
  },
}
```

### Quest Names (`enUS/quests.lua`)
```lua
pfDB["quests"]["loc"] = {
  [41187] = "Refugees no More",  -- QID -> Quest Name
  [41188] = "Provisions for Refugees",
}
```

### Example: Looking Up Quest Data
To create a guide entry for quest 41188:

1. Find quest in `quests-turtle.lua`:
   ```lua
   [41188] = {
     ["min"] = 1,
     ["pre"] = { 41187 },  -- Requires 41187 first!
     ["start"] = { ["U"] = { 50001 } },
     ["end"] = { ["U"] = { 50001 } },
   }
   ```

2. Find NPC location in `units-turtle.lua`:
   ```lua
   [50001] = {
     ["coords"] = { [1] = { 48.6, 83.6, 42 } },  -- Zone 42
   }
   ```

3. Find quest name in `enUS/quests.lua`:
   ```lua
   [41188] = "Provisions for Refugees",
   ```

4. Create guide entry:
   ```
   A Provisions for Refugees |QID|41188| |N|Commander Anarileth (48.6, 83.6)| |Z|Thalassian Highlands|
   ```

## Best Practices

1. **Always include QIDs** - Enables smart skip and prerequisite checking
2. **Use precise coordinates** - Helps TomTom navigation
3. **Specify zone with |Z|** - Prevents wrong-zone waypoints
4. **Group nearby quests** - Minimize travel time
5. **Note class/race restrictions** - Use |C| and |R| tags
6. **Mark optional quests** - Use |O| tag
7. **Test your guide** - Play through it on a character

## Troubleshooting

- **Guide not loading**: Check Guides.xml includes your file
- **Quest not auto-completing**: Verify QID is correct
- **Wrong coordinates**: Use /way in-game to verify
- **Prerequisites warning**: Check pfQuest database for quest chains
