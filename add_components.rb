#!/usr/bin/env ruby
# Registers new Core/Components Swift files in the Xcode project

require 'xcodeproj'

PROJECT_PATH = File.join(File.dirname(__FILE__), 'BlossomHubs', 'BlossomHubs.xcodeproj')

project = Xcodeproj::Project.open(PROJECT_PATH)
target  = project.targets.find { |t| t.name == 'BlossomHubs' }

# Find the Components group (uuid: 0DA1A1DE9AA1BAEDD191A34E)
components_group = project.main_group
  .recursive_children
  .find { |g| g.is_a?(Xcodeproj::Project::Object::PBXGroup) && g.path == 'Components' }

raise 'Components group not found' unless components_group

NEW_FILES = %w[
  BlossomCard.swift
  BlossomButton.swift
  VerifiedBadge.swift
  TagView.swift
  SectionHeader.swift
  EmptyStateView.swift
  LockedContentOverlay.swift
]

NEW_FILES.each do |filename|
  # Skip if already registered
  already_exists = components_group.children.any? { |c| c.respond_to?(:path) && c.path == filename }
  if already_exists
    puts "Already registered: #{filename}"
    next
  end

  ref = components_group.new_file(filename)
  ref.last_known_file_type = 'sourcecode.swift'
  target.source_build_phase.add_file_reference(ref)
  puts "Registered: #{filename}"
end

project.save
puts 'project.pbxproj saved.'
