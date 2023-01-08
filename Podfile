# Uncomment the next line to define a global platform for your project
# platform :ios, '15.0'

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
    pod 'naveridlogin-sdk-ios'
    pod 'ImageSlideshow', '~> 1.9.0'
    pod 'ImageSlideshow/Kingfisher'
    pod 'ImageSlideshow/Alamofire'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
end