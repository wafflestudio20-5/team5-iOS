# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'KreamWaffleApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for KreamWaffleApp
    pod 'RxSwift', '6.5.0'
    pod 'RxCocoa', '6.5.0'
    pod 'Alamofire'
    pod 'ChartsRealm'
    pod 'CHTCollectionViewWaterfallLayout'
    pod 'BetterSegmentedControl', '~> 2.0'
    pod 'Kingfisher', '~> 7.0'

post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
            config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
            config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
        end
    end
end

end
