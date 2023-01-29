# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'KreamWaffleApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for KreamWaffleApp
    pod 'RxSwift', '6.5.0'
    pod 'RxCocoa', '6.5.0'
    pod 'Alamofire'
    pod 'CHTCollectionViewWaterfallLayout'
    pod 'BetterSegmentedControl', '~> 2.0'
    pod 'Kingfisher', '~> 7.0'
    pod 'naveridlogin-sdk-ios'
    pod "ImageSlideshow/Alamofire"
    pod "ImageSlideshow/Kingfisher"
    pod 'ImageSlideshow', '~> 1.9.2'
    pod 'GoogleSignIn', '~> 5.0.2'
    pod 'YPImagePicker'
    pod 'SnapKit'
    use_frameworks!



end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
  end
end
