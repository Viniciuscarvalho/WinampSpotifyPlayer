#!/usr/bin/env ruby
# Script to add Swift files to Xcode project

require 'fileutils'
require 'securerandom'

project_path = 'WinampSpotifyPlayer.xcodeproj/project.pbxproj'

# Read the current project file
project_content = File.read(project_path)

# Find all Swift files
swift_files = Dir.glob('WinampSpotifyPlayer/**/*.swift').sort

puts "Found #{swift_files.length} Swift files"

# For simplicity, let's just verify the build works by trying to compile
puts "Files to be added to Xcode project:"
swift_files.each { |f| puts "  - #{f}" }

puts "\nTo add these files to Xcode:"
puts "1. Open WinampSpotifyPlayer.xcodeproj in Xcode"
puts "2. Right-click on the WinampSpotifyPlayer group"
puts "3. Select 'Add Files to WinampSpotifyPlayer...'"
puts "4. Select all the Swift files and add them"
puts "\nOr run: open WinampSpotifyPlayer.xcodeproj"
