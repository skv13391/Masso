# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Masso' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Masso

 pod 'Alamofire','~> 4.7'
  pod 'SwiftyJSON'
  pod 'SkyFloatingLabelTextField', '~> 3.8.0'
  pod 'NVActivityIndicatorView','~> 4.8.0'
  pod 'RAMAnimatedTabBarController','~> 5.1.0'
  pod 'Kingfisher', '~> 5.13.0'
  pod 'SwipeMenuViewController'
  pod 'JTAppleCalendar', '~> 7.0'
  pod 'ListPlaceholder'
  pod 'SkeletonView'
  pod 'IQKeyboardManagerSwift'
  pod 'SwiftGifOrigin'
  pod 'Segmentio'
  pod 'Cosmos', '~> 22.1'
  pod 'OpalImagePicker'
  pod 'SwiftyGif'
pod 'SwiftGifOrigin'
pod 'SideMenu'
pod 'MaterialComponents/TextControls+FilledTextAreas'
pod 'MaterialComponents/TextControls+FilledTextFields'
pod 'MaterialComponents/TextControls+OutlinedTextAreas'
pod 'MaterialComponents/TextControls+OutlinedTextFields'
pod 'Toast-Swift', '~> 5.0.0'
pod 'FirebaseAnalytics'
pod 'FirebaseMessaging'
pod 'Firebase/Crashlytics'
pod 'FirebaseFirestore'
pod 'FirebaseAuth'
pod 'CocoaMQTT'


  target 'MassoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MassoUITests' do
    # Pods for testing
  end
  
  post_install do |installer|
     installer.pods_project.build_configurations.each do |config|
         config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
         config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
     end
   end

end
