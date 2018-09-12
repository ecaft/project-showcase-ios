# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, ’10.0’
use_frameworks!

target 'project-showcase-ios' do
  # Pods for project-showcase-ios
  pod ‘SnapKit’, ‘~> 4.0.0’
  pod "SwiftyJSON"
  pod "Firebase/Core"
  pod "Firebase/Database"
  pod "Firebase/Storage”
  pod "ImageScrollView"
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end
end
