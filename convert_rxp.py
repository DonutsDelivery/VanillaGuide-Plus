#!/usr/bin/env python3
"""
RestedXP to TurtleGuide Converter

Converts RestedXP guide format to TurtleGuide format.
Usage: python3 convert_rxp.py input.lua [output_dir]
"""

import re
import sys
import os
from pathlib import Path


def strip_formatting(text):
    """Remove RXP color codes and texture tags"""
    if not text:
        return ""
    # Remove texture tags |Tpath:size|t
    text = re.sub(r'\|T[^|]+\|t', '', text)
    # Remove color codes |cRXP_*_...|r
    text = re.sub(r'\|cRXP_\w+_([^|]*)\|r', r'\1', text)
    # Remove generic color codes
    text = re.sub(r'\|c[0-9a-fA-F]{8}([^|]*)\|r', r'\1', text)
    # Remove |r
    text = re.sub(r'\|r', '', text)
    # Clean up whitespace
    text = text.strip()
    return text


def parse_coords(line):
    """Parse coordinates from .goto Zone,x,y format"""
    match = re.search(r'\.goto\s+([^,]+),([0-9.]+),([0-9.]+)', line)
    if match:
        return match.group(1), float(match.group(2)), float(match.group(3))
    return None, None, None


def parse_quest_action(line):
    """Parse quest ID and name from .accept/.turnin lines"""
    match = re.search(r'\.(accept|turnin)\s+(\d+)[^>]*>>\s*(.+)', line)
    if match:
        action_type = match.group(1)
        qid = int(match.group(2))
        quest_name = match.group(3)
        # Clean up quest name
        quest_name = re.sub(r'^(Accept|Turn in)\s+', '', quest_name, flags=re.IGNORECASE)
        quest_name = strip_formatting(quest_name)
        return action_type, qid, quest_name
    return None, None, None


def parse_complete(line):
    """Parse .complete lines"""
    match = re.search(r'\.complete\s+(\d+),(\d+)\s*(?:--(.+))?', line)
    if match:
        qid = int(match.group(1))
        obj_idx = int(match.group(2))
        comment = strip_formatting(match.group(3)) if match.group(3) else None
        return qid, obj_idx, comment
    return None, None, None


def parse_step(step_lines, current_zone, current_class, current_race):
    """Parse a single step block"""
    result = {
        'action': None,
        'quest': None,
        'qid': None,
        'note': None,
        'coords': [],
        'zone': current_zone,
        'class': current_class,
        'race': current_race,
        'optional': False,
    }

    notes = []
    target_npc = None
    mob_name = None
    use_item = None

    for line in step_lines:
        line = line.strip()

        # Check for class/race filter
        filter_match = re.search(r'<<\s*(!?)(\w+(?:/\w+)*)', line)
        if filter_match:
            is_exclude = filter_match.group(1) == '!'
            filter_val = filter_match.group(2)
            classes = {'Warrior', 'Paladin', 'Hunter', 'Rogue', 'Priest', 'Shaman', 'Mage', 'Warlock', 'Druid'}
            races = {'Human', 'Dwarf', 'Gnome', 'NightElf', 'Orc', 'Troll', 'Tauren', 'Undead'}

            if filter_val in classes:
                result['class'] = ('!' + filter_val) if is_exclude else filter_val
            elif filter_val in races:
                result['race'] = ('!' + filter_val) if is_exclude else filter_val
            else:
                # Combined race like Orc/Troll
                result['race'] = filter_val

        # Parse commands
        if line.startswith('.goto'):
            zone, x, y = parse_coords(line)
            if zone and x and y:
                result['zone'] = zone
                result['coords'].append(f"{x:.1f}, {y:.1f}")

        elif line.startswith('.accept'):
            result['action'] = 'A'
            _, qid, quest = parse_quest_action(line)
            result['qid'] = qid
            result['quest'] = quest

        elif line.startswith('.turnin'):
            result['action'] = 'T'
            _, qid, quest = parse_quest_action(line)
            result['qid'] = qid
            result['quest'] = quest

        elif line.startswith('.complete'):
            result['action'] = 'C'
            qid, obj_idx, comment = parse_complete(line)
            result['qid'] = qid
            if comment:
                notes.append(comment)

        elif line.startswith('.train'):
            result['action'] = 't'
            match = re.search(r'>>\s*Train\s+(.+)', line)
            if match:
                result['quest'] = strip_formatting(match.group(1))

        elif line.startswith('.vendor'):
            match = re.search(r'>>(.+)', line)
            if match:
                notes.append(strip_formatting(match.group(1)))

        elif line.startswith('.target'):
            match = re.search(r'\.target\s+(.+)', line)
            if match:
                target_npc = strip_formatting(match.group(1))

        elif line.startswith('.mob'):
            match = re.search(r'\.mob\s+(.+)', line)
            if match:
                mob_name = strip_formatting(match.group(1))

        elif line.startswith('.home'):
            result['action'] = 'h'
            result['quest'] = result['zone'] or 'Inn'

        elif line.startswith('.hs'):
            result['action'] = 'H'
            result['quest'] = 'Hearthstone'

        elif line.startswith('.fp'):
            result['action'] = 'f'
            match = re.search(r'\.fp\s+(.+)', line)
            if match:
                result['quest'] = strip_formatting(match.group(1))

        elif line.startswith('.fly'):
            result['action'] = 'F'
            match = re.search(r'\.fly\s+(.+)', line)
            if match:
                result['quest'] = strip_formatting(match.group(1))

        elif line.startswith('.zone'):
            result['action'] = 'R'
            match = re.search(r'>>(.+)', line)
            if match:
                result['quest'] = strip_formatting(match.group(1))

        elif line.startswith('.xp'):
            match = re.search(r'\.xp\s+(\d+)', line)
            xp_note = re.search(r'>>(.+)', line)
            if match:
                result['action'] = 'G'
                if xp_note:
                    result['quest'] = strip_formatting(xp_note.group(1))
                else:
                    result['quest'] = f"Grind to level {match.group(1)}"

        elif line.startswith('.deathskip'):
            result['action'] = 'D'
            result['quest'] = 'Die and respawn'

        elif line.startswith('.use'):
            result['action'] = 'U'
            match = re.search(r'>>(.+)', line)
            if match:
                result['quest'] = strip_formatting(match.group(1))
            # Also capture item ID for |U| tag
            item_match = re.search(r'\.use\s+(\d+)', line)
            if item_match:
                use_item = item_match.group(1)

        elif line.startswith('>>'):
            note = strip_formatting(line[2:])
            if note:
                notes.append(note)

        elif line.startswith('+'):
            note = strip_formatting(line[1:])
            if note:
                notes.append(note)

        elif '#completewith' in line:
            result['optional'] = True

    # Build note
    note_parts = []
    if target_npc:
        note_parts.append(target_npc)
    if mob_name and result['action'] != 'C':
        note_parts.append(f"Kill {mob_name}")
    note_parts.extend(notes)
    if result['coords']:
        note_parts.append(f"({result['coords'][0]})")

    if note_parts:
        result['note'] = ' - '.join(note_parts)

    if use_item:
        result['use_item'] = use_item

    return result


def step_to_turtleguide(step):
    """Convert a parsed step to TurtleGuide format"""
    if not step['action'] or not step['quest']:
        # If we have notes but no action, make it a NOTE
        if step.get('note') and len(step['note']) > 0:
            step['action'] = 'N'
            step['quest'] = step['note']
            step['note'] = None
        else:
            return None

    parts = [step['action'], ' ', step['quest']]

    if step.get('qid'):
        parts.append(f" |QID|{step['qid']}|")

    if step.get('note'):
        parts.append(f" |N|{step['note']}|")

    if step.get('use_item'):
        parts.append(f" |U|{step['use_item']}|")

    if step.get('optional'):
        parts.append(" |O|")

    if step.get('class'):
        parts.append(f" |C|{step['class']}|")

    if step.get('race'):
        parts.append(f" |R|{step['race']}|")

    return ''.join(parts)


def convert_rxp_guide(content):
    """Convert RXP guide content to TurtleGuide format"""
    lines = content.split('\n')

    # Parse metadata
    guide_name = "Converted Guide"
    next_guide = ""
    faction = "Both"
    levels = None

    i = 0
    while i < len(lines):
        line = lines[i].strip()

        if line.startswith('#name'):
            guide_name = strip_formatting(line[5:].strip())
            # Extract level range
            match = re.search(r'(\d+)-(\d+)', guide_name)
            if match:
                levels = (int(match.group(1)), int(match.group(2)))
        elif line.startswith('#next'):
            next_guide = strip_formatting(line[5:].strip())
            # Handle multiple next guides (separated by semicolon) - use first one
            if ';' in next_guide:
                next_guide = next_guide.split(';')[0].strip()
        elif line.startswith('<<'):
            f = re.search(r'<<\s*(\w+)', line)
            if f and f.group(1) in ('Alliance', 'Horde'):
                faction = f.group(1)
        elif line.startswith('step'):
            break
        i += 1

    # Parse steps
    steps = []
    current_step = []
    current_zone = None
    current_class = None
    current_race = None

    while i < len(lines):
        line = lines[i]

        if line.strip().startswith('step'):
            # Process previous step
            if current_step:
                parsed = parse_step(current_step, current_zone, current_class, current_race)
                if parsed.get('zone'):
                    current_zone = parsed['zone']
                tg_line = step_to_turtleguide(parsed)
                if tg_line:
                    steps.append(tg_line)
            current_step = []
        else:
            # Update global filters
            filter_match = re.search(r'<<\s*(\w+)', line)
            if filter_match:
                f = filter_match.group(1)
                if f in {'Warrior', 'Paladin', 'Hunter', 'Rogue', 'Priest', 'Shaman', 'Mage', 'Warlock', 'Druid'}:
                    current_class = f
            current_step.append(line)
        i += 1

    # Process last step
    if current_step:
        parsed = parse_step(current_step, current_zone, current_class, current_race)
        tg_line = step_to_turtleguide(parsed)
        if tg_line:
            steps.append(tg_line)

    # Create safe filename from guide name
    safe_name = re.sub(r'[^\w\s-]', '', guide_name)
    safe_name = re.sub(r'\s+', '_', safe_name)

    # Clean up guide names (remove double spaces, etc.)
    guide_name = re.sub(r'\s+', ' ', guide_name).strip()
    if next_guide:
        next_guide = re.sub(r'\s+', ' ', next_guide).strip()
        # Add RXP/ prefix to next guide if it's part of the same series
        if not next_guide.startswith("RXP/"):
            next_guide = f"RXP/{next_guide}"

    # Build output
    output = []
    output.append("-- Converted from RestedXP format")
    output.append(f"-- Original guide: {guide_name}")
    output.append("")

    level_range = ""
    if levels:
        level_range = f" ({levels[0]}-{levels[1]})"

    output.append(f'TurtleGuide:RegisterGuide("RXP/{guide_name}", "{next_guide or ""}", "{faction}", function()')
    output.append("")
    output.append("return [[")
    output.append("")
    output.append(f"N {guide_name} |N|Converted from RestedXP guide|")
    output.append("")

    for step in steps:
        output.append(step)

    output.append("")
    output.append("]]")
    output.append("end)")

    return '\n'.join(output), safe_name, faction, levels


def extract_guides_from_file(content):
    """Extract individual guides from a file with multiple RegisterGuide calls"""
    guides = []

    # Try format: RXPGuides.RegisterGuide("name", [[...]])
    pattern1 = r'RXPGuides\.RegisterGuide\s*\(\s*"([^"]+)"\s*,\s*\[\[(.*?)\]\]\s*\)'
    matches = re.findall(pattern1, content, re.DOTALL)

    for name, guide_content in matches:
        guides.append((name, guide_content))

    # Try format: RXPGuides.RegisterGuide([[...]])
    if not matches:
        pattern2 = r'RXPGuides\.RegisterGuide\s*\(\s*\[\[(.*?)\]\]\s*\)'
        matches = re.findall(pattern2, content, re.DOTALL)
        for guide_content in matches:
            # Extract name from #name directive
            name_match = re.search(r'#name\s+(.+)', guide_content)
            name = name_match.group(1).strip() if name_match else "Unknown"
            guides.append((name, guide_content))

    # Fallback: treat whole file as one guide
    if not guides:
        guides.append(("Main", content))

    return guides


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 convert_rxp.py input.lua [output_dir]")
        print("  input.lua: RestedXP guide file")
        print("  output_dir: Output directory (default: ./Guides/RXP/)")
        sys.exit(1)

    input_file = sys.argv[1]
    output_dir = sys.argv[2] if len(sys.argv) > 2 else "./Guides/RXP/"

    # Read input file
    with open(input_file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Extract guides
    guides = extract_guides_from_file(content)

    os.makedirs(output_dir, exist_ok=True)

    for guide_name, guide_content in guides:
        try:
            converted, safe_name, faction, levels = convert_rxp_guide(guide_content)

            # Determine subfolder
            subfolder = os.path.join(output_dir, faction if faction != "Both" else "Both")
            os.makedirs(subfolder, exist_ok=True)

            # Create filename with level prefix
            if levels:
                filename = f"{levels[0]:02d}_{levels[1]:02d}_{safe_name}.lua"
            else:
                filename = f"{safe_name}.lua"

            output_path = os.path.join(subfolder, filename)

            with open(output_path, 'w', encoding='utf-8') as f:
                f.write(converted)

            print(f"Converted: {guide_name} -> {output_path}")

        except Exception as e:
            print(f"Error converting {guide_name}: {e}")

    print(f"\nConversion complete! Output in: {output_dir}")


if __name__ == "__main__":
    main()
