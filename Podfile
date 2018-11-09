source "ssh://git@git.sygic.com:7999/navi/cocoapods.git"
source "https://github.com/CocoaPods/Specs.git"

platform :ios, '10.0'
use_frameworks!
inhibit_all_warnings!

target "OnlineNaviSample" do
	project "OnlineNaviSample.xcodeproj"
	pod 'SwiftSVG', '~> 2.0'
end

#sygicnavi is without bitcode
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
            config.build_settings['GCC_OPTIMIZATION_LEVEL'] = '0'
            config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
			config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end
end
