# VanillaGuide-Plus (TurtleGuide)

A comprehensive leveling guide addon for Turtle WoW (1.12 client) with full support for custom Turtle WoW zones.

## Features

- **Step-by-step leveling guides** for Alliance and Horde from 1-60
- **Full Turtle WoW custom zone coverage** including all new zones
- **Smart quest tracking** - automatically detects completed quests and advances
- **TomTom integration** - waypoint arrows pointing to your current objective
- **pfQuest integration** - prerequisite detection and quest chain awareness
- **Race-based routing** - starting zone selection based on your character's race
- **Manual navigation** - skip forward/backward through objectives as needed

## Recommended Addons

For the best experience, install these companion addons:

| Addon | Description | Link |
|-------|-------------|------|
| **TomTom** | Waypoint arrow navigation - shows direction and distance to objectives | [GitHub](https://github.com/sweetgiorni/TomTom) |
| **pfQuest-turtle** | Quest database with map markers - enables prerequisite detection | [GitHub](https://github.com/shagu/pfQuest-turtle) |

These addons are optional but highly recommended. TomTom provides the navigation arrow, and pfQuest-turtle enables smart quest chain detection.

## Installation

1. Download or clone this repository
2. Place the `TurtleGuide` folder in your `World of Warcraft/Interface/AddOns/` directory
3. Restart WoW or type `/reload` if already in-game
4. The guide will automatically load based on your character's race and level

## Supported Zones

### Turtle WoW Custom Zones

| Zone | Level | Faction | Description |
|------|-------|---------|-------------|
| Thalassian Highlands | 1-10 | Alliance | High Elf starting zone |
| Blackstone Island | 1-10 | Horde | Goblin starting zone |
| Northwind | 28-34 | Alliance | SI:7 investigation storyline |
| Balor | 29-34 | Both | Haunted island with Stormwrought Castle |
| Grim Reaches | 33-38 | Both | Dragonmaw conflict east of Wetlands |
| Gilneas | 39-46 | Both | The walled kingdom with worgen threats |
| Icepoint Rock | 40-50 | Both | Tuskarr village in frozen lands |
| Lapidis Isle | 48-53 | Alliance | Tower of Lapidis questline |
| Gillijim's Isle | 48-53 | Horde | Maul'ogg ogre refuge |
| Tel'Abim | 54-60 | Both | Tropical banana island |
| Scarlet Enclave | 55-60 | Both | Elite Scarlet Crusade zone |
| Hyjal | 58-60 | Both | World Tree and Emerald Sanctum |

### Vanilla Zones

Full coverage of all vanilla leveling zones for both factions from 1-60.

## Usage

### Basic Commands

| Command | Description |
|---------|-------------|
| `/tg` | Open the options panel |
| `/tg next` | Skip to next objective |
| `/tg prev` | Go back to previous objective |
| `/tg goto <number>` | Jump to specific step |
| `/tg reset` | Reset current guide progress |
| `/tg rescan` | Re-scan quest log for completed quests |

### Interface

- **Status Frame** - Shows current objective with checkbox (click to mark complete)
- **Objectives Panel** - Press the expand button to see upcoming steps
- **Guide List** - Access via `/tg` to switch between guides

### Tips

- The addon automatically advances when you complete quests
- Use `/tg next` to skip optional quests you want to ignore
- With pfQuest-turtle installed, the addon warns about missing prerequisites
- TomTom arrow updates automatically as you progress

## For Guide Authors

See [docs/GUIDE_AUTHORING.md](docs/GUIDE_AUTHORING.md) for complete documentation on creating and editing guides.

### Quick Reference

```lua
TurtleGuide:RegisterGuide("Zone Name (Level-Range)", "Next Zone (Level)", "Faction", function()
return [[

A Quest Name |QID|12345| |N|NPC Name (45.5, 32.8)| |Z|Zone Name|
C Quest Name |QID|12345| |N|Kill mobs (50, 40)| |Z|Zone Name|
T Quest Name |QID|12345| |N|NPC Name (45.5, 32.8)| |Z|Zone Name|

]]
end)
```

### Action Codes

| Code | Action | Code | Action |
|------|--------|------|--------|
| `A` | Accept quest | `T` | Turn in quest |
| `C` | Complete objectives | `N` | Note/instruction |
| `R` | Run to location | `H` | Use hearthstone |
| `f` | Get flight point | `F` | Take flight |
| `h` | Set hearthstone | `B` | Buy item |

### Essential Tags

| Tag | Purpose | Example |
|-----|---------|---------|
| `QID` | Quest ID | `\|QID\|41187\|` |
| `N` | Note text | `\|N\|Kill 10 mobs (50, 40)\|` |
| `Z` | Zone name | `\|Z\|Gilneas\|` |
| `C` | Class filter | `\|C\|Warrior,Paladin\|` |
| `R` | Race filter | `\|R\|Human\|` |
| `O` | Optional | `\|O\|` |

## Contributing

Contributions are welcome! To add or improve guides:

1. Fork the repository
2. Create your guide following the format in `docs/GUIDE_AUTHORING.md`
3. Test in-game to verify quest IDs and coordinates
4. Submit a pull request

## Credits

- Original TourGuide addon by Tekkub
- Turtle WoW custom content by the Turtle WoW team
- pfQuest by Shagu
- Guide contributions by the community

## License

This addon is provided as-is for the Turtle WoW community.
