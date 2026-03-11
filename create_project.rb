#!/usr/bin/env ruby
# Creates the BlossomHubs.xcodeproj Xcode project programmatically
# Run with: ~/.gem/ruby/2.6.0/bin/xcodeproj exec ruby create_project.rb

require 'xcodeproj'

PROJECT_ROOT = File.dirname(__FILE__)
PROJECT_NAME = 'BlossomHubs'
BUNDLE_ID    = 'com.blossom.hubs-prototype'
SWIFT_VERSION = '6.0'  # Swift 6 (Xcode will use latest 6.x)
DEPLOYMENT_TARGET = '26.0'

project_path = File.join(PROJECT_ROOT, PROJECT_NAME, "#{PROJECT_NAME}.xcodeproj")
project = Xcodeproj::Project.new(project_path)

# ── App target ────────────────────────────────────────────────────────────────
target = project.new_target(:application, PROJECT_NAME, :ios, DEPLOYMENT_TARGET)

# ── File groups ───────────────────────────────────────────────────────────────
main_group = project.main_group

# BlossomHubs root group
app_group = main_group.new_group(PROJECT_NAME, PROJECT_NAME)

# App group
app_subfolder = app_group.new_group('App', 'App')

# Features/TabBar group
features_group = app_group.new_group('Features', 'Features')
tabbar_group   = features_group.new_group('TabBar', 'TabBar')

# Core/Theme group
core_group  = app_group.new_group('Core', 'Core')
theme_group = core_group.new_group('Theme', 'Theme')

# Assets group
assets_group = app_group.new_group('Assets.xcassets', 'Assets.xcassets')

# Products group (already exists)
products_group = project.products_group

# ── Add source files ──────────────────────────────────────────────────────────
def add_swift_file(group, relative_path, target)
  ref = group.new_file(relative_path)
  ref.last_known_file_type = 'sourcecode.swift'
  target.source_build_phase.add_file_reference(ref)
  ref
end

add_swift_file(app_subfolder,  'App/BlossomHubsApp.swift', target)
add_swift_file(app_subfolder,  'App/ContentView.swift',    target)
add_swift_file(tabbar_group,   'Features/TabBar/TabItem.swift', target)
add_swift_file(theme_group,    'Core/Theme/BlossomTheme.swift', target)

# Assets catalog
assets_ref = app_group.new_file('Assets.xcassets')
assets_ref.last_known_file_type = 'folder.assetcatalog'
target.resources_build_phase.add_file_reference(assets_ref)

# Info.plist (resource, not compiled)
info_ref = app_group.new_file('Info.plist')
info_ref.last_known_file_type = 'text.plist.xml'

# ── Build configurations ──────────────────────────────────────────────────────
project.build_configuration_list.build_configurations.each do |project_config|
  project_config.build_settings['ALWAYS_SEARCH_USER_PATHS'] = 'NO'
  project_config.build_settings['CLANG_ANALYZER_NONNULL']   = 'YES'
  project_config.build_settings['SWIFT_VERSION']            = SWIFT_VERSION
  project_config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = DEPLOYMENT_TARGET
end

# Target-level build settings
target.build_configuration_list.build_configurations.each do |config|
  s = config.build_settings

  s['PRODUCT_NAME']              = PROJECT_NAME
  s['PRODUCT_BUNDLE_IDENTIFIER'] = BUNDLE_ID
  s['INFOPLIST_FILE']            = "#{PROJECT_NAME}/Info.plist"
  s['SWIFT_VERSION']             = SWIFT_VERSION
  s['IPHONEOS_DEPLOYMENT_TARGET'] = DEPLOYMENT_TARGET

  # Swift Strict Concurrency = Complete
  s['SWIFT_STRICT_CONCURRENCY'] = 'complete'

  # Swift 6 mode
  s['SWIFT_LANGUAGE_VERSION'] = '6'

  # Standard settings
  s['ASSETCATALOG_COMPILER_APPICON_NAME']    = 'AppIcon'
  s['ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME'] = 'AccentColor'
  s['CODE_SIGN_STYLE']   = 'Automatic'
  s['DEVELOPMENT_TEAM']  = ''
  s['ENABLE_PREVIEWS']   = 'YES'
  s['SWIFT_EMIT_LOC_STRINGS'] = 'YES'
  s['TARGETED_DEVICE_FAMILY'] = '1'

  # Warnings as errors (helps catch concurrency issues fast)
  s['GCC_TREAT_WARNINGS_AS_ERRORS'] = 'NO'
  s['SWIFT_TREAT_WARNINGS_AS_ERRORS'] = 'NO'

  if config.name == 'Debug'
    s['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
    s['MTL_ENABLE_DEBUG_INFO']    = 'INCLUDE_SOURCE'
    s['ONLY_ACTIVE_ARCH']         = 'YES'
    s['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = 'DEBUG'
    s['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
  else
    s['DEBUG_INFORMATION_FORMAT'] = 'dwarf-with-dsym'
    s['MTL_ENABLE_DEBUG_INFO']    = 'NO'
    s['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
    s['COPY_PHASE_STRIP']         = 'NO'
    s['VALIDATE_PRODUCT']         = 'YES'
  end
end

# ── SPM package dependency (ComponentsKit) ────────────────────────────────────
# Add package reference to the project
pkg_ref = project.root_object.package_references.build_settings rescue nil

# Use xcodeproj's XCRemoteSwiftPackageReference
pkg = project.new(Xcodeproj::Project::Object::XCRemoteSwiftPackageReference)
pkg.repositoryURL = 'https://github.com/componentskit/ComponentsKit.git'
pkg.requirement = {
  'kind' => 'upToNextMajorVersion',
  'minimumVersion' => '1.6.1'
}
project.root_object.package_references ||= []
project.root_object.package_references << pkg

# Add ComponentsKit product to target
pkg_product_dep = project.new(Xcodeproj::Project::Object::XCSwiftPackageProductDependency)
pkg_product_dep.package = pkg
pkg_product_dep.product_name = 'ComponentsKit'

target.package_product_dependencies ||= []
target.package_product_dependencies << pkg_product_dep

# Add to frameworks build phase
frameworks_phase = target.frameworks_build_phase
framework_ref = project.new(Xcodeproj::Project::Object::PBXBuildFile)
framework_ref.product_ref = pkg_product_dep
frameworks_phase.files << framework_ref

# ── Save ──────────────────────────────────────────────────────────────────────
project.save
puts "Created: #{project_path}"
puts "Done!"
