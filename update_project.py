#!/usr/bin/env python3
"""
Script to add Swift files to Xcode project.pbxproj
"""
import os
import re
import uuid

def generate_uuid():
    """Generate a 24-character hex string similar to Xcode UUIDs"""
    return ''.join(uuid.uuid4().hex[:24].upper())

def find_swift_files(base_path):
    """Find all Swift files in the project"""
    swift_files = []
    for root, dirs, files in os.walk(base_path):
        # Skip test files for now
        if 'Tests' in root:
            continue
        for file in files:
            if file.endswith('.swift'):
                rel_path = os.path.relpath(os.path.join(root, file), '.')
                swift_files.append(rel_path)
    return sorted(swift_files)

def read_project_file():
    """Read the current project.pbxproj"""
    with open('WinampSpotifyPlayer.xcodeproj/project.pbxproj', 'r') as f:
        return f.read()

def main():
    print("Finding Swift files...")
    swift_files = find_swift_files('WinampSpotifyPlayer')

    print(f"\nFound {len(swift_files)} Swift files:")
    for f in swift_files:
        print(f"  {f}")

    print("\nThis project requires adding files to Xcode manually or using xcodeproj gem.")
    print("Recommended approach: Use Xcode GUI or xcodebuild tools.")

if __name__ == '__main__':
    main()
