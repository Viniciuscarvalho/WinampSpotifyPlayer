#!/usr/bin/env python3
"""
Add all Swift files to Xcode project target
Safely modifies WinampSpotifyPlayer.xcodeproj/project.pbxproj
"""

import os
import uuid
import re
from pathlib import Path

# Paths
PROJECT_DIR = Path(__file__).parent
XCODEPROJ = PROJECT_DIR / "WinampSpotifyPlayer.xcodeproj" / "project.pbxproj"
SOURCE_DIR = PROJECT_DIR / "WinampSpotifyPlayer"

def generate_uuid():
    """Generate Xcode-style 24-character UUID"""
    return uuid.uuid4().hex[:24].upper()

def find_swift_files():
    """Find all Swift files in WinampSpotifyPlayer directory"""
    swift_files = []
    for root, dirs, files in os.walk(SOURCE_DIR):
        # Skip hidden directories and build directories
        dirs[:] = [d for d in dirs if not d.startswith('.') and d not in ['build', 'DerivedData']]

        for file in files:
            if file.endswith('.swift'):
                full_path = Path(root) / file
                rel_path = full_path.relative_to(SOURCE_DIR)
                swift_files.append((file, str(rel_path)))

    return sorted(swift_files, key=lambda x: x[1])

def read_pbxproj():
    """Read the project.pbxproj file"""
    with open(XCODEPROJ, 'r', encoding='utf-8') as f:
        return f.read()

def write_pbxproj(content):
    """Write the project.pbxproj file"""
    with open(XCODEPROJ, 'w', encoding='utf-8') as f:
        f.write(content)

def find_files_already_in_project(content):
    """Find Swift files already referenced in project"""
    # Look for file references
    existing_files = set()
    pattern = r'path = ([^;]+\.swift);'
    matches = re.findall(pattern, content)
    for match in matches:
        existing_files.add(match)
    return existing_files

def find_target_id(content):
    """Find the WinampSpotifyPlayer target ID"""
    # Find the target section
    pattern = r'/\* WinampSpotifyPlayer \*/ = \{[^}]+isa = PBXNativeTarget[^}]+buildPhases = \([^)]+([A-F0-9]{24})'
    match = re.search(pattern, content)
    if match:
        return match.group(1)
    return None

def find_sources_build_phase(content, target_id):
    """Find the Sources build phase ID for the target"""
    # Look for PBXSourcesBuildPhase
    pattern = r'([A-F0-9]{24}) /\* Sources \*/ = \{[^}]+isa = PBXSourcesBuildPhase'
    matches = re.findall(pattern, content)
    return matches[0] if matches else None

def add_file_to_project(content, filename, filepath):
    """Add a Swift file to the project"""
    file_ref_id = generate_uuid()
    build_file_id = generate_uuid()

    # Find the PBXFileReference section
    file_ref_section_start = content.find('/* Begin PBXFileReference section */')
    if file_ref_section_start == -1:
        print("❌ Could not find PBXFileReference section")
        return content

    file_ref_section_end = content.find('/* End PBXFileReference section */', file_ref_section_start)

    # Create file reference entry
    file_ref_entry = f'\t\t{file_ref_id} /* {filename} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {filename}; sourceTree = "<group>"; }};\n'

    # Insert before the end of PBXFileReference section
    content = content[:file_ref_section_end] + file_ref_entry + content[file_ref_section_end:]

    # Find the PBXBuildFile section
    build_file_section_start = content.find('/* Begin PBXBuildFile section */')
    if build_file_section_start == -1:
        print("❌ Could not find PBXBuildFile section")
        return content

    build_file_section_end = content.find('/* End PBXBuildFile section */', build_file_section_start)

    # Create build file entry
    build_file_entry = f'\t\t{build_file_id} /* {filename} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_id} /* {filename} */; }};\n'

    # Insert before the end of PBXBuildFile section
    content = content[:build_file_section_end] + build_file_entry + content[build_file_section_end:]

    return content, file_ref_id, build_file_id

def add_to_sources_build_phase(content, build_file_id, filename):
    """Add file to Sources build phase"""
    # Find the Sources build phase
    sources_pattern = r'(\/\* Sources \*\/ = \{[^}]+files = \([^)]+)'
    match = re.search(sources_pattern, content)

    if match:
        insertion_point = match.end()
        entry = f'\n\t\t\t\t{build_file_id} /* {filename} in Sources */,'
        content = content[:insertion_point] + entry + content[insertion_point:]

    return content

def main():
    print("🔍 Finding Swift files...")
    swift_files = find_swift_files()
    print(f"Found {len(swift_files)} Swift files on disk")

    print("\n📖 Reading Xcode project...")
    content = read_pbxproj()

    print("🔍 Checking which files are already in project...")
    existing_files = find_files_already_in_project(content)
    print(f"Found {len(existing_files)} Swift files already in project")

    # Filter out files that are already in the project
    files_to_add = [(name, path) for name, path in swift_files if name not in existing_files]

    if not files_to_add:
        print("\n✅ All Swift files are already in the project!")
        return

    print(f"\n➕ Need to add {len(files_to_add)} files to project:")
    for name, path in files_to_add[:10]:  # Show first 10
        print(f"  • {path}")
    if len(files_to_add) > 10:
        print(f"  ... and {len(files_to_add) - 10} more")

    print("\n⚠️  WARNING: This script will modify your Xcode project file.")
    print("Creating backup...")

    # Create backup
    backup_path = XCODEPROJ.parent / "project.pbxproj.backup"
    with open(backup_path, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"✅ Backup created at: {backup_path}")

    print("\n🔧 Adding files to project...")

    modified_content = content
    added_count = 0

    for filename, filepath in files_to_add:
        try:
            modified_content, file_ref_id, build_file_id = add_file_to_project(modified_content, filename, filepath)
            modified_content = add_to_sources_build_phase(modified_content, build_file_id, filename)
            added_count += 1
            print(f"  ✓ Added {filename}")
        except Exception as e:
            print(f"  ✗ Failed to add {filename}: {e}")

    if added_count > 0:
        print(f"\n💾 Writing modified project file...")
        write_pbxproj(modified_content)
        print(f"✅ Successfully added {added_count} files to Xcode project!")
        print("\n🎯 Next steps:")
        print("  1. Open Xcode: open WinampSpotifyPlayer.xcodeproj")
        print("  2. Clean build folder (⌘+Shift+K)")
        print("  3. Build project (⌘+B)")
        print("\n⚠️  If Xcode shows errors, restore from backup:")
        print(f"  cp '{backup_path}' '{XCODEPROJ}'")
    else:
        print("\n❌ No files were added")

if __name__ == "__main__":
    main()
