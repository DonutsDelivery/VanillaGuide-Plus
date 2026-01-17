# TurtleGuide - Zone Guide Creation Tasks

These task files are designed to be used with Claude Code (Opus 4.5) to create leveling guides for Turtle WoW custom zones.

## How to Use

1. Open Claude Code in the TurtleGuide addon directory
2. Use the task file as a prompt:
   ```
   Read tasks/create-guide-blackstone-island.md and follow its instructions
   ```
3. Claude will research the zone online and create the guide

## Available Tasks

### Starting Zones (1-10)
| Task File | Zone | Faction | Status |
|-----------|------|---------|--------|
| `create-guide-blackstone-island.md` | Blackstone Island (1-10) | Horde | Pending |
| *(Thalassian Highlands already complete)* | Thalassian Highlands (1-10) | Alliance | **Complete** |

### Mid-Level Zones (28-46)
| Task File | Zone | Faction | Status |
|-----------|------|---------|--------|
| `create-guide-northwind.md` | Northwind (28-34) | Alliance | Pending |
| `create-guide-balor.md` | Balor (29-34) | Both | Pending |
| `create-guide-grim-reaches.md` | Grim Reaches (33-38) | Both | Pending |
| `create-guide-gilneas.md` | Gilneas (39-46) | Both | Pending |
| `create-guide-icepoint-rock.md` | Icepoint Rock (40-50) | Both | Pending |

### High-Level Zones (48-60)
| Task File | Zone | Faction | Status |
|-----------|------|---------|--------|
| `create-guide-lapidis-isle.md` | Lapidis Isle (48-53) | Alliance | Pending |
| `create-guide-gillijims-isle.md` | Gillijim's Isle (48-53) | Horde | Pending |
| `create-guide-telabim.md` | Tel'Abim (54-60) | Both | Pending |
| `create-guide-scarlet-enclave.md` | Scarlet Enclave (55-60) | Both | Pending |
| `create-guide-hyjal.md` | Hyjal (58-60) | Both | Pending |

## Reference Files

- **Guide Authoring Docs:** `docs/GUIDE_AUTHORING.md`
- **Example Alliance Guide:** `Guides/Alliance/01_10_Thalassian_Highlands.lua`
- **Example Vanilla Guide:** `Guides/Alliance/12_17_Darkshore.lua`

## Resources

- **Turtle WoW Database:** https://database.turtle-wow.org/
- **Turtle WoW Wiki:** https://turtle-wow.fandom.com/
- **pfQuest Database:** `../pfQuest-turtle/db/quests-turtle.lua`
- **Zone Level Chart:** https://turtle-wow.fandom.com/wiki/Zone_Level_Chart

## Notes

- Always use Opus 4.5 model for best results with research tasks
- Each task includes instructions to search online for quest data
- Quest IDs for Turtle WoW custom content are typically 40000+
- Check pfQuest database for prerequisite data (`["pre"]` field)
- Contested zones may need separate Alliance/Horde guides
