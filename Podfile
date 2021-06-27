target 'DailyLogs' do
  use_frameworks!
  
  pod 'SwiftLint'
  
  pod 'RxSwift', '6.2.0'
  pod 'RxCocoa', '6.2.0'
  
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    end
  end
end
