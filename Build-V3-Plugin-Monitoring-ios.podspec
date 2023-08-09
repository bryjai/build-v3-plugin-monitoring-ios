#
# Be sure to run `pod lib lint Build-V3-Plugin-Monitoring-ios.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Build-V3-Plugin-Monitoring-ios'
  s.version          = '1.0.0'
  s.summary          = 'Build-V3-Plugin-Monitoring-ios is a Plugin to plug to the BuildSDK V3 in order to monitor the App.'

  s.description      = <<-DESC
  Build-V3-Plugin-Monitoring-ios is a Plugin to use with the BuildSDK. This plugin provides 2 implementations to log events on Firebase and/or directly on the console. The plugin exposes an API to customize the traces and implement your own layer of monitory.
                       DESC

  s.homepage         = 'https://github.com/bryjai/build-v3-plugin-monitoring-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jérôme Morissard' => 'jerome.morissard@bryj.ai' }
  s.source           = { :git => 'git@github.com:bryjai/build-v3-plugin-monitoring-ios.git', :branch => 'origin/feature/legacy-sdk-support' }

  s.ios.deployment_target = '11.1'
  s.swift_version = '5.0'

  s.source_files = ['Build-V3-Plugin-Monitoring-ios/Classes/*', 'Build-V3-Plugin-Monitoring-ios/Classes/*/**']

  s.resource_bundles = {
     'Build-V3-Plugin-Monitoring-ios' => ['Build-V3-Plugin-Monitoring-ios/Assets/*.js']
   }
  s.dependency 'FASDKBuild-ios', '>= 3.7.7'
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'}
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'FirebasePerformance'
end
