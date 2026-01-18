# TurtleGuide

A leveling guide addon for Turtle WoW (1.12 client) based on Joana's classic speedrun guides, with support for Turtle WoW custom zones.

## Features

- **Optimized leveling routes** based on [Joana's 1-60 Alliance/Horde guides](https://www.joanasworld.com/web-guides.php)
- **Race-based starting zones** - automatically selects your race's starting path
- **Shared optimized path** - all races merge into the same efficient route after level 12
- **Branch system** - temporarily switch to any zone guide, then return to the optimized path
- **Turtle WoW custom zones** - guides for all custom Turtle WoW content available via branching
- **Smart quest tracking** - automatically detects completed objectives and advances
- **TomTom integration** - waypoint arrows pointing to your current objective
- **pfQuest integration** - prerequisite detection and quest chain awareness
- **Manual navigation** - skip forward/backward through objectives with prev/next buttons

## How It Works

### The Optimized Route

TurtleGuide uses the same leveling route for (almost) all races within a faction. This is based on Joana's speedrun guides which prioritize XP efficiency over staying in "your" faction's zones.

**Alliance:** All races do their starting zone (1-12), then merge into:
- Darkshore (12-17) → Loch Modan (17-18) → Redridge (18-20) → and so on...

**Horde:** All races do their starting zone (1-12), then merge into:
- Barrens (12-20) → Stonetalon → Thousand Needles → and so on...

Yes, this means Humans travel to Darkshore at level 12. It's the most efficient path!

### Starting Zones by Race

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

### Branch System

Want to do a Turtle WoW custom zone or a different guide? Use the **Branch** feature:

1. Click the **Branch** button in the objectives panel
2. Select any zone guide from the categorized list
3. Complete the zone (or as much as you want)
4. Click **Return to Main** to go back to the optimized path

The addon will automatically find the right guide for your current level when you return.

**Categories in Branch Selector:**
- **Optimized Path** - The main Joana's guide zones
- **TurtleWoW Zones** - Custom Turtle WoW content (Gilneas, Balor, etc.)
- **Zone Guides** - Standard vanilla zone guides

## Turtle WoW Custom Zones

These zones are available via the Branch system:

| Zone | Level | Faction | Description |
|------|-------|---------|-------------|
| Thalassian Highlands | 1-10 | Alliance | High Elf starting zone |
| Blackstone Island | 1-10 | Horde | Goblin starting zone |
| Balor | 29-34 | Both | Haunted island with Stormwrought Castle |
| Grim Reaches | 33-38 | Both | Dragonmaw conflict east of Wetlands |
| Gilneas | 39-46 | Both | The walled kingdom with worgen threats |
| Icepoint Rock | 40-50 | Both | Tuskarr village in frozen lands |
| Lapidis Isle | 48-53 | Alliance | Tower of Lapidis questline |
| Gillijim's Isle | 48-53 | Horde | Maul'ogg ogre refuge |
| Tel'Abim | 54-60 | Both | Tropical banana island |

## Recommended Addons

| Addon | Description | Link |
|-------|-------------|------|
| **TomTom** | Waypoint arrow navigation | [GitHub](https://github.com/sweetgiorni/TomTom) |
| **pfQuest-turtle** | Quest database with map markers | [GitHub](https://github.com/shagu/pfQuest-turtle) |

## Installation

1. Download or clone this repository
2. Place the `TurtleGuide` folder in your `World of Warcraft/Interface/AddOns/` directory
3. Restart WoW or type `/reload` if already in-game
4. The guide will automatically load based on your character's race and level

## Usage

### Status Bar

The main status bar shows your current objective:
- **Checkbox** - Click to mark complete and advance
- **Prev/Next buttons** - Navigate between objectives
- **Click the bar** - Open the objectives panel

### Commands

| Command | Description |
|---------|-------------|
| `/tg` | Open options panel |
| `/tg next` | Skip to next objective |
| `/tg prev` | Go back to previous objective |
| `/tg goto <number>` | Jump to specific step |
| `/tg reset` | Reset current guide progress |

### Tips

- The addon automatically advances when you complete quest objectives
- Use the Branch system to do optional content without losing your place
- Right-click a guide in the Guide List to branch to it
- TomTom arrow updates automatically as you progress

## Credits

- Leveling routes based on [Joana's Vanilla WoW Guides](https://www.joanasworld.com/)
- Original TourGuide addon by Tekkub
- [VanillaGuide](https://github.com/isalcedo/VanillaGuide) addon structure
- Turtle WoW custom content by the Turtle WoW team
- pfQuest by Shagu

## License

This addon is provided as-is for the Turtle WoW community.
