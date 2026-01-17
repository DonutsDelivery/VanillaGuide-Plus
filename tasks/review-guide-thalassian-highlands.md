# Review & Optimize: Thalassian Highlands (1-10) Guide

## Task
Review and optimize the existing Thalassian Highlands guide based on the three core principles: prerequisites, level requirements, and geographic proximity.

## Existing Guide Location
`Guides/Alliance/01_10_Thalassian_Highlands.lua`

## Review Checklist

### 1. Verify Prerequisites (MUST be correct)

For each quest with a QID, check pfQuest database for prerequisites:

```lua
-- In pfQuest-turtle/db/quests-turtle.lua, find entries like:
[41188] = {
  ["pre"] = { 41187 },  -- This quest requires 41187 first
}
```

**Verify:**
- [ ] Every quest's TURNIN comes before any quest that has it as a `["pre"]`
- [ ] No ACCEPT appears before its prerequisite's TURNIN
- [ ] Document any out-of-order quests found

### 2. Verify Level Requirements (SHOULD be respected)

Check minimum levels in pfQuest:

```lua
[41188] = {
  ["min"] = 1,   -- Minimum player level
  ["lvl"] = 5,   -- Quest difficulty level
}
```

**Verify:**
- [ ] Lower `["min"]` quests come before higher `["min"]` quests
- [ ] Quests are grouped by similar level ranges
- [ ] No level 8+ quests appear before level 5 quests (example)

### 3. Optimize Geographic Proximity (efficiency)

**Check for:**
- [ ] All quests in a hub are picked up before leaving
- [ ] Objectives in the same area are completed together
- [ ] Turn-ins happen when passing through, not via backtracking
- [ ] Travel steps (R) are minimized

**Hub locations in Thalassian Highlands:**
- Brinthilien (starting area, ~48, 84)
- Thaumarium (winery, ~52, 64)
- Silver Covenant Camp (~44, 57)
- Anasterian Park (~55, 46)
- Ballador's Chapel (~44, 50)
- Alah'Thalas (city, ~55, 38)

### 4. Check for Missing Elements

- [ ] All quests have QID tags
- [ ] All locations have coordinates
- [ ] Zone tags (|Z|) are present
- [ ] Class-specific quests have |C| tags
- [ ] Optional quests have |O| tags

## pfQuest Database Files

**Location:** `/home/user/Programs/WoW/Interface/AddOns/pfQuest-turtle/db/`

| File | Contents |
|------|----------|
| `quests-turtle.lua` | Quest data: `["pre"]`, `["min"]`, `["lvl"]`, `["start"]`, `["end"]` |
| `units-turtle.lua` | NPC coordinates: `["coords"] = { { x, y, zone } }` |
| `enUS/quests.lua` | Quest names: `[QID] = "Quest Name"` |

**Quest IDs for Thalassian Highlands:** 41187-41231 range

## Step-by-Step Review Process

1. **Extract all QIDs from the guide:**
   ```bash
   grep -oP 'QID\|\K\d+' Guides/Alliance/01_10_Thalassian_Highlands.lua | sort -u
   ```

2. **Look up each QID in pfQuest database:**
   - Note `["pre"]` prerequisites
   - Note `["min"]` minimum levels
   - Build dependency graph

3. **Create a quest order table:**
   | QID | Quest Name | Min Lvl | Prerequisites | Guide Position |
   |-----|------------|---------|---------------|----------------|
   | 41187 | Refugees no More | ? | ? | Line 6 |
   | 41188 | Provisions for Refugees | ? | ? | Line 8 |
   | ... | ... | ... | ... | ... |

4. **Identify issues:**
   - Prerequisites out of order
   - Level requirements violated
   - Inefficient travel patterns

5. **Propose optimizations:**
   - Reorder quests if needed
   - Group hub pickups
   - Combine travel steps

## Output Requirements

1. **Create a report** listing:
   - Any prerequisite violations found
   - Any level ordering issues
   - Suggested proximity optimizations
   - Specific line numbers to change

2. **Update the guide file** with optimizations:
   - Fix any prerequisite ordering issues
   - Improve quest grouping by location
   - Add any missing tags (QID, coordinates, etc.)

3. **Verify changes** don't break existing functionality

## Reference: Core Principles

```
PRIORITY ORDER:
1. Prerequisites - MUST be respected (game enforced)
2. Level requirements - SHOULD be respected (difficulty)
3. Proximity - OPTIMIZE within above constraints (efficiency)
```

## Example Optimization

**Before (inefficient):**
```
A Quest A |QID|100| |N|NPC in Town (50, 50)|
C Quest A |QID|100| |N|Kill mobs (60, 70)|
T Quest A |QID|100| |N|NPC in Town (50, 50)|
A Quest B |QID|101| |N|NPC in Town (50, 50)|  -- Should pick up with Quest A!
C Quest B |QID|101| |N|Kill mobs (60, 70)|    -- Same area as Quest A!
T Quest B |QID|101| |N|NPC in Town (50, 50)|
```

**After (optimized):**
```
A Quest A |QID|100| |N|NPC in Town (50, 50)|
A Quest B |QID|101| |N|NPC in Town (50, 50)|  -- Pick up both at once
C Quest A |QID|100| |N|Kill mobs (60, 70)|
C Quest B |QID|101| |N|Kill mobs (60, 70)|    -- Complete both in same area
T Quest A |QID|100| |N|NPC in Town (50, 50)|
T Quest B |QID|101| |N|NPC in Town (50, 50)|  -- Turn in both at once
```
