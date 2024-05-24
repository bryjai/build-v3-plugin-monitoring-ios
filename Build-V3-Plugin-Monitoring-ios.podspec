#
# Be sure to run `pod lib lint Build-V3-Plugin-Monitoring-ios.podspec' to ensure this is a valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Build-V3-Plugin-Monitoring-ios'
  s.version          = '1.0.1'
  s.summary          = 'Build-V3-Plugin-Monitoring-ios is a Plugin to plug to the BuildSDK V3 in order to monitor the App.'
  s.description      = <<-DESC
  Build-V3-Plugin-Monitoring-ios is a Plugin to use with the BuildSDK. This plugin provides 2 implementations to log events on Firebase and/or directly on the console. The plugin exposes an API to customize the traces and implement your own layer of monitory.
                       DESC
  s.homepage         = 'https://github.com/bryjai/build-v3-plugin-monitoring-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jérôme Morissard' => 'jerome.morissard@bryj.ai' }
  s.source           = { :git => 'git@github.com:bryjai/build-v3-plugin-monitoring-ios.git', :tag => s.version.to_s }
  s.ios.deployment_target = '14.0'
  s.swift_version = '5.0'
  s.default_subspec = 'Core'
  s.dependency 'FASDKBuild-ios', '>= 3.9.5'
  s.subspec 'Core' do |sp|
    sp.source_files = 'Build-V3-Plugin-Monitoring-ios/Classes/Core/**/*'
    sp.resource_bundles = {'Build-V3-Plugin-Monitoring-ios' => ['Build-V3-Plugin-Monitoring-ios/Assets/*.{js}', 'PrivacyInfo.xcprivacy']}
  end
  s.subspec 'GROWTracer' do |sp|
    sp.source_files = ['Build-V3-Plugin-Monitoring-ios/Classes/TracesManagers/GROWPerformanceTracesManager.swift']
    sp.dependency 'Build-V3-Plugin-Monitoring-ios/Core'
    sp.dependency 'GROW'
  end
  s.subspec 'FirebaseTracer' do |sp|
    sp.source_files = ['Build-V3-Plugin-Monitoring-ios/Classes/TracesManagers/FirebasePerformanceTracesManager.swift']
    sp.dependency 'Build-V3-Plugin-Monitoring-ios/Core'
    sp.dependency 'FirebasePerformance', '10.25.0'
  end
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'}
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
