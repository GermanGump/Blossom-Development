#!/usr/bin/env ruby
# Phase 2 Plan 01: Register Inter fonts and BlossomFont.swift in project.pbxproj

require 'xcodeproj'

project_path = 'BlossomHubs/BlossomHubs.xcodeproj'
project = Xcodeproj::Project.open(project_path)
target = project.targets.first

# Navigate to BlossomHubs group
app_group = project.main_group['BlossomHubs']

# -------------------------------------------------------
# Step 1: Add Inter .otf font files to BlossomHubs group
#         and register them in the Resources build phase
# -------------------------------------------------------
font_files = ['Inter-Regular.otf', 'Inter-Medium.otf', 'Inter-SemiBold.otf']

font_files.each do |font_name|
  # Check if reference already exists
  existing = app_group.files.find { |f| f.path == font_name }
  if existing
    puts "Font reference already exists: #{font_name}"
    font_ref = existing
  else
    font_ref = app_group.new_file(font_name)
    font_ref.last_known_file_type = 'file'
    puts "Added file reference: #{font_name}"
  end

  # Check if already in resources build phase
  already_in_resources = target.resources_build_phase.files.any? do |bf|
    bf.file_ref&.path == font_name
  end

  unless already_in_resources
    target.resources_build_phase.add_file_reference(font_ref)
    puts "Added to resources build phase: #{font_name}"
  else
    puts "Already in resources build phase: #{font_name}"
  end
end

# -------------------------------------------------------
# Step 2: Add BlossomFont.swift to Core/Theme group
#         and register in Sources build phase
# -------------------------------------------------------
core_group = app_group['Core']
theme_group = core_group['Theme']

blossom_font_path = 'Core/Theme/BlossomFont.swift'
existing_font_swift = theme_group.files.find { |f| f.path == 'BlossomFont.swift' }

if existing_font_swift
  puts "BlossomFont.swift reference already exists"
  font_swift_ref = existing_font_swift
else
  font_swift_ref = theme_group.new_file('BlossomFont.swift')
  font_swift_ref.last_known_file_type = 'sourcecode.swift'
  puts "Added file reference: BlossomFont.swift"
end

already_in_sources = target.source_build_phase.files.any? do |bf|
  bf.file_ref&.path == 'BlossomFont.swift'
end

unless already_in_sources
  target.source_build_phase.add_file_reference(font_swift_ref)
  puts "Added to sources build phase: BlossomFont.swift"
else
  puts "Already in sources build phase: BlossomFont.swift"
end

project.save
puts "\nproject.pbxproj saved successfully."

# Verify
puts "\n--- Verification ---"
puts "Resources build phase font files:"
target.resources_build_phase.files.each do |bf|
  path = bf.file_ref&.path rescue nil
  puts "  #{path}" if path&.include?('Inter')
end

puts "Sources build phase BlossomFont:"
target.source_build_phase.files.each do |bf|
  path = bf.file_ref&.path rescue nil
  puts "  #{path}" if path == 'BlossomFont.swift'
end
