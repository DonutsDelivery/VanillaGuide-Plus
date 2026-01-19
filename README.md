# TurtleGuide

A leveling guide addon for Turtle WoW (1.12 client) based on [Joana's classic speedrun guides](https://www.joanasworld.com/), with support for Turtle WoW custom zones.

## Features

- **Optimized leveling routes** from Joana's 1-60 guides
- **Race-based starting zones** - automatically selects your race's starting path
- **Shared optimized path** - all races merge into the same route after level 12
- **Branch system** - temporarily switch to any zone guide, then return to the optimized path
- **Turtle WoW custom zones** - guides for all custom content available via branching
- **Smart quest tracking** - automatically detects completed objectives and advances
- **TomTom integration** - waypoint arrows pointing to your current objective
- **pfQuest integration** - prerequisite detection and quest chain awareness
- **Manual navigation** - skip forward/backward through objectives with prev/next buttons

## Starting Zones

| Alliance | Starting Zone | Levels |
|----------|---------------|--------|
| Human | Elwynn Forest → Westfall | 1-10 → 10-12 |
| Dwarf/Gnome | Dun Morogh | 1-12 |
| Night Elf | Teldrassil | 1-12 |
| High Elf | Thalassian Highlands | 1-10 |

| Horde | Starting Zone | Levels |
|-------|---------------|--------|
| Orc/Troll | Durotar | 1-12 |
| Tauren | Mulgore | 1-12 |
| Undead | Tirisfal Glades | 1-12 |
| Goblin | Blackstone Island | 1-10 |

## Alliance Optimized Path (12-60)

All Alliance races follow this path after their starting zone:

| Levels | Zone |
|--------|------|
| 12-14 | Darkshore |
| 14-17 | Darkshore |
| 17-18 | Loch Modan |
| 18-20 | Redridge Mountains |
| 20-21 | Darkshore |
| 21-22 | Ashenvale |
| 22-23 | Stonetalon Mountains |
| 23-24 | Darkshore |
| 24-25 | Ashenvale |
| 25-27 | Wetlands |
| 27-28 | Redridge Mountains |
| 28-29 | Duskwood |
| 29-30 | Ashenvale |
| 30-30 | Wetlands |
| 30-31 | Hillsbrad Foothills |
| 31-31 | Alterac Mountains |
| 31-32 | Arathi Highlands |
| 32-32 | Stranglethorn Vale |
| 32-33 | Thousand Needles |
| 33-33 | Stonetalon Mountains |
| 33-35 | Desolace |
| 35-36 | Stranglethorn Vale |
| 36-37 | Alterac Mountains |
| 37-38 | Arathi Highlands |
| 38-38 | Dustwallow Marsh |
| 38-40 | Stranglethorn Vale |
| 40-41 | Badlands |
| 41-41 | Swamp of Sorrows |
| 41-42 | Desolace |
| 42-43 | Stranglethorn Vale |
| 43-43 | Tanaris |
| 43-45 | Feralas |
| 45-46 | Uldaman |
| 46-47 | The Hinterlands |
| 47-47 | Feralas |
| 47-48 | Tanaris |
| 48-48 | The Hinterlands |
| 48-49 | Stranglethorn Vale |
| 49-50 | Blasted Lands |
| 50-51 | Searing Gorge |
| 51-52 | Un'Goro Crater |
| 52-53 | Azshara |
| 53-54 | Felwood |
| 54-55 | Winterspring |
| 55-56 | Burning Steppes |
| 56-57 | Silithus |
| 57-58 | Western Plaguelands |
| 58-59 | Eastern Plaguelands |
| 59-60 | Winterspring |

## Horde Optimized Path (12-60)

All Horde races follow this path after their starting zone:

| Levels | Zone |
|--------|------|
| 12-15 | The Barrens |
| 15-16 | Stonetalon Mountains |
| 16-18 | The Barrens |
| 18-20 | The Barrens |
| 20-21 | Stonetalon Mountains |
| 21-21 | Ashenvale |
| 22-23 | Southern Barrens |
| 23-25 | Stonetalon Mountains |
| 25-25 | Southern Barrens |
| 25-26 | Thousand Needles |
| 26-27 | Ashenvale |
| 27-27 | Stonetalon Mountains |
| 27-29 | Thousand Needles |
| 29-30 | Hillsbrad Foothills |
| 30-30 | Alterac Mountains |
| 30-30 | Arathi Highlands |
| 30-31 | Stranglethorn Vale |
| 31-32 | Thousand Needles |
| 32-34 | Desolace |
| 34-36 | Stranglethorn Vale |
| 36-37 | Arathi Highlands |
| 37-37 | Alterac Mountains |
| 37-38 | Thousand Needles |
| 38-38 | Dustwallow Marsh |
| 38-40 | Stranglethorn Vale |
| 40-41 | Badlands |
| 41-42 | Swamp of Sorrows |
| 42-43 | Stranglethorn Vale |
| 43-43 | Desolace |
| 43-44 | Dustwallow Marsh |
| 44-45 | Tanaris |
| 45-46 | Feralas |
| 46-46 | Azshara |
| 46-47 | The Hinterlands |
| 47-47 | Stranglethorn Vale |
| 47-48 | Searing Gorge |
| 48-48 | Swamp of Sorrows |
| 48-49 | Feralas |
| 49-50 | Tanaris |
| 50-50 | Azshara |
| 50-51 | The Hinterlands |
| 51-51 | Blasted Lands |
| 51-52 | Un'Goro Crater |
| 52-53 | Burning Steppes |
| 53-54 | Azshara |
| 54-54 | Felwood |
| 54-55 | Winterspring |
| 55-55 | Felwood |
| 55-55 | Silithus |
| 55-56 | Western Plaguelands |
| 56-57 | Eastern Plaguelands |
| 57-58 | Western Plaguelands |
| 58-60 | Winterspring |

## Branch System

Use the **Branch** feature to temporarily switch to any zone guide:

1. Click the **Branch** button in the objectives panel
2. Select a zone guide from the categorized list
3. Complete the zone (or as much as you want)
4. Click **Return to Main** to go back to the optimized path at your current level

**Categories:**
- **Optimized Path** - Joana's guide zones
- **TurtleWoW Zones** - Custom Turtle WoW content
- **Zone Guides** - Standard vanilla zone guides

## Turtle WoW Custom Zones

Available via branching:

| Zone | Level | Faction |
|------|-------|---------|
| Thalassian Highlands | 1-10 | Alliance |
| Blackstone Island | 1-10 | Horde |
| Balor | 29-34 | Both |
| Grim Reaches | 33-38 | Both |
| Gilneas | 39-46 | Both |
| Icepoint Rock | 40-50 | Both |
| Lapidis Isle | 48-53 | Alliance |
| Gillijim's Isle | 48-53 | Horde |
| Tel'Abim | 54-60 | Both |

## Recommended Addons

| Addon | Description | Link |
|-------|-------------|------|
| **TomTom** | Waypoint arrow navigation | [GitHub](https://github.com/sweetgiorni/TomTom) |
| **pfQuest-turtle** | Quest database with map markers | [GitHub](https://github.com/shagu/pfQuest-turtle) |

## How It Works

### The Status Bar

When you log in, a small status bar appears near your quest tracker showing your current objective:

```
[✓] [<] [icon] [15/120] Kill 8 Grell Earring [?] [>]
 │    │    │       │              │            │   │
 │    │    │       │              │            │   └─ Next: Skip to next objective
 │    │    │       │              │            └─ [?] indicates there's a note (hover for details)
 │    │    │       │              └─ The objective description
 │    │    │       └─ Step number / Total steps in current guide
 │    │    └─ Icon shows objective type (see below)
 │    └─ Prev: Go back to previous objective
 └─ Checkbox: Mark complete when checked
```

**Click the status bar** to open the full objectives panel with more details.

### Reading Objectives

Each objective has an **action type** shown by its icon:

| Icon | Code | Action | Meaning |
|------|------|--------|---------|
| 📜 | A | ACCEPT | Pick up a quest from an NPC |
| ⚔️ | C | COMPLETE | Do the quest objectives (kill, collect, etc.) |
| 📜 | T | TURNIN | Turn in a completed quest |
| 🏃 | R | RUN | Travel to a location |
| 🦅 | F | FLY | Take a flight path |
| 🦅 | f | GETFLIGHTPOINT | Discover a new flight path |
| 🏠 | H | HEARTH | Use your hearthstone |
| 🏠 | h | SETHEARTH | Set your hearthstone location |
| ⛵ | b | BOAT | Take a boat or zeppelin |
| 💀 | K | KILL | Grind mobs (not for a quest) |
| 📝 | N | NOTE | Important information or tip |
| 🛒 | B | BUY | Purchase items from a vendor |
| 📦 | U | USE | Use an item |
| 📖 | t | TRAIN | Visit a class trainer |

**Objective tags** in the panel:
- **(Optional)** - Can be skipped without breaking the guide
- **[?]** - Has additional notes (hover to see)
- Orange text on the right shows quest progress or notes

### Navigating the Guide

**Automatic progression:**
- The addon tracks your quest log and automatically advances when you accept, complete, or turn in quests
- Travel objectives (RUN, FLY, BOAT) auto-complete when you arrive at the destination (if TomTom is installed)

**Manual navigation:**
- **< / >** buttons: Move backward/forward one step
- **>>** button: Mark current step complete and advance
- **Checkboxes**: Click to manually mark any step complete/incomplete
- `/tg next` / `/tg prev`: Keyboard shortcuts for navigation
- `/tg goto 50`: Jump directly to step 50

**Smart skip on guide load:**
- When loading a guide, TurtleGuide scans your quest log and automatically skips to where you left off
- If you have quests in progress, it finds the right step

### The Branch System

The **Branch** feature lets you temporarily leave the optimized path to do other content:

1. Click **Branch** in the objectives panel
2. Select any zone guide (TurtleWoW zones, vanilla zones, etc.)
3. Complete as much as you want
4. Click **Return Main** to go back

**When you return:**
- TurtleGuide finds the appropriate step in the optimized path based on your level
- Your progress in the branch is saved if you want to return later
- A green `[Branch]` indicator shows when you're off the main path

**Example workflow:**
```
Level 35, doing Joana's route in Stranglethorn Vale
  ↓
Branch to Gilneas (TurtleWoW zone) for custom content
  ↓
Do some quests, get to level 37
  ↓
Click "Return Main" → Resumes at level 37 section of optimized path
```

### Waypoints & Map Integration

With **TomTom** installed:
- Arrow points to your current objective
- Coordinates from the guide are automatically mapped
- Travel objectives auto-complete when you arrive

With **pfQuest** installed:
- Quest giver/turn-in locations are automatically looked up
- Prerequisite chains are detected to warn about missing requirements

## Installation

1. Download or clone this repository
2. Place the `TurtleGuide` folder in `World of Warcraft/Interface/AddOns/`
3. Type `/reload` in-game or restart WoW

## Commands

| Command | Description |
|---------|-------------|
| `/tg` | Open options panel |
| `/tg next` | Skip to next objective |
| `/tg prev` | Go back to previous objective |
| `/tg goto <n>` | Jump to step number |
| `/tg reset` | Reset current guide progress |

## Credits

- Leveling routes: [Joana's Vanilla WoW Guides](https://www.joanasworld.com/)
- Original TourGuide addon: Tekkub
- [VanillaGuide](https://github.com/isalcedo/VanillaGuide) addon structure
- Turtle WoW content: Turtle WoW team
- pfQuest: Shagu
