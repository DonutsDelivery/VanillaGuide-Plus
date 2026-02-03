# QuestShell+ Format Specification

An extended QuestShell format that combines the structured Lua table syntax with all TurtleGuide features.

## Why QuestShell+?

| Feature | TurtleGuide | QuestShell | QuestShell+ |
|---------|:-----------:|:----------:|:-----------:|
| Structured syntax | ❌ | ✅ | ✅ |
| Easy for contributors | ❌ | ✅ | ✅ |
| IDE support | ❌ | ✅ | ✅ |
| Zone tags | ✅ | ❌ | ✅ |
| Optional markers | ✅ | ❌ | ✅ |
| Prerequisites | ✅ | ❌ | ✅ |
| Race filtering | ✅ | ❌ | ✅ |
| Loot tracking | ✅ | ❌ | ✅ |

## Step Types

| Type | Description |
|------|-------------|
| `ACCEPT` | Accept a quest |
| `TURNIN` | Turn in a quest |
| `COMPLETE` | Complete quest objective |
| `KILL` | Kill mobs (non-quest) |
| `RUN` | Run to location |
| `HEARTH` | Use hearthstone |
| `SETHEARTH` | Set hearthstone location |
| `GRIND` | Grind mobs for XP |
| `FLY` | Take flight path |
| `GETFP` | Discover flight point |
| `NOTE` | General note/instruction |
| `BUY` | Buy items |
| `BOAT` | Take boat/zeppelin |
| `USE` | Use item |
| `PET` | Pet-related action |
| `DIE` | Die and respawn |
| `TRAIN` | Train skills |

## Field Reference

### Core Fields
```lua
{
  type = "ACCEPT",           -- Required: step type (see above)
  title = "Quest Name",      -- Quest name (required for A/T/C)
  questId = 123,             -- Quest ID number
  coords = { x=42.5, y=68.3 }, -- Coordinates
  note = "Description",      -- Step description/instructions
}
```

### NPC Information
```lua
{
  npc = { name = "Gornek" }, -- NPC name for accept/turnin
}
```

### Filtering (NEW in QuestShell+)
```lua
{
  class = "Warrior",         -- Single class filter
  classes = {"Warrior", "Paladin"}, -- Multiple classes (OR)
  race = "Orc",              -- Single race filter
  races = {"Orc", "Troll"},  -- Multiple races (OR)
  zone = "Durotar",          -- Display zone name
  optional = true,           -- Mark as optional quest
}
```

### Quest Chain Support (NEW in QuestShell+)
```lua
{
  prereq = 123,              -- Prerequisite quest ID
  prereqs = {123, 456},      -- Multiple prerequisites (all required)
  leadin = 789,              -- Lead-in quest ID
}
```

### Loot Tracking (NEW in QuestShell+)
```lua
{
  loot = { itemId = 12345, qty = 5 }, -- Track loot item
}
```

### Item Usage
```lua
{
  itemId = 12345,            -- Item to use
  itemName = "Item Name",    -- Display name
}
```

## Complete Example

```lua
QuestShellGuides["QS_Durotar_1_12"] = {
  title = "Durotar (1-12)",
  faction = "Horde",
  minLevel = 1,
  maxLevel = 12,
  next = "The Barrens (12-20)",
  nextKey = "QS_The_Barrens_12_20",

  steps = {
    -- Basic quest
    { type="ACCEPT", title="Your Place In The World", questId=4641,
      coords={x=43.29, y=68.61}, npc={name="Kaltunk"},
      note="Kaltunk in Valley of Trials" },

    -- Class-specific quest
    { type="ACCEPT", title="Vile Familiars", questId=1485,
      coords={x=42.61, y=68.79}, npc={name="Ruzan"},
      class="Warlock", note="Ruzan in Valley of Trials" },

    -- Race-specific quest
    { type="ACCEPT", title="Etched Parchment", questId=3087,
      coords={x=42.08, y=68.35}, npc={name="Gornek"},
      class="Hunter", race="Orc", note="Gornek in The Den" },

    -- Quest with prerequisite
    { type="ACCEPT", title="Dark Storms", questId=806,
      coords={x=52.28, y=43.22}, npc={name="Orgnil Soulscar"},
      prereq=823, note="Requires Report to Orgnil" },

    -- Optional quest
    { type="ACCEPT", title="The Demon Scarred Cloak", questId=770,
      note="Rare drop from Ghost Howl", optional=true },

    -- Quest in different zone
    { type="TURNIN", title="Back to Thunder Bluff", questId=5932,
      coords={x=76.6, y=27.6}, npc={name="Turak Runetotem"},
      zone="Thunder Bluff", class="Druid" },

    -- Loot tracking
    { type="COMPLETE", title="Rites of the Earthmother", questId=776,
      coords={x=49, y=19}, loot={itemId=4844, qty=1},
      note="Kill Arra'chea for Horn" },
  }
}
```

## Mapping from TurtleGuide Format

| TurtleGuide | QuestShell+ |
|-------------|-------------|
| `A Quest Name` | `type="ACCEPT", title="Quest Name"` |
| `T Quest Name` | `type="TURNIN", title="Quest Name"` |
| `C Quest Name` | `type="COMPLETE", title="Quest Name"` |
| `R Location` | `type="RUN", title="Location"` |
| `N Note text` | `type="NOTE", note="Note text"` |
| `H Location` | `type="HEARTH", title="Location"` |
| `h Location` | `type="SETHEARTH", title="Location"` |
| `F Destination` | `type="FLY", title="Destination"` |
| `f Flight Point` | `type="GETFP", title="Flight Point"` |
| `\|QID\|123\|` | `questId=123` |
| `\|N\|note\|` | `note="note"` |
| `\|C\|Warrior\|` | `class="Warrior"` |
| `\|R\|Orc\|` | `race="Orc"` |
| `\|Z\|Durotar\|` | `zone="Durotar"` |
| `\|O\|` | `optional=true` |
| `\|PRE\|123\|` | `prereq=123` |
| `\|LEAD\|123\|` | `leadin=123` |
| `\|L\|12345 5\|` | `loot={itemId=12345, qty=5}` |
| `(42.5, 68.3)` | `coords={x=42.5, y=68.3}` |
