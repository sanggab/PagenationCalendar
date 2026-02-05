require 'xcodeproj'

project_path = 'PagenationCalendar.xcodeproj'
project = Xcodeproj::Project.open(project_path)

package_url = 'https://github.com/pointfreeco/swift-composable-architecture.git'
package_req = {:kind => :upToNextMajorVersion, :minimumVersion => '1.0.0'}

# Note: Xcodeproj gem's support for Swift Packages can be tricky.
# We explicitly create the package reference.
# Check if already exists
existing_ref = project.root_object.package_references.find { |ref| ref.repositoryURL == package_url }

if existing_ref
  puts "Package already exists."
else
  package_ref = Xcodeproj::Project::Object::XCRemoteSwiftPackageReference.new(project, project.generate_uuid)
  package_ref.repositoryURL = package_url
  package_ref.requirement = {
    'kind' => 'upToNextMajorVersion',
    'minimumVersion' => '1.0.0'
  }
  project.root_object.package_references << package_ref

  # Find the main target (usually the first native target)
  target = project.native_targets.first
  if target
    product_name = "ComposableArchitecture"

    dependency = target.project.new(Xcodeproj::Project::Object::XCSwiftPackageProductDependency)
    dependency.product_name = product_name
    dependency.package = package_ref

    target.package_product_dependencies << dependency

    project.save
    puts "Successfully added ComposableArchitecture to #{target.name}"
  else
    puts "Error: No native target found."
  end
end
