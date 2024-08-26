#
# Be sure to run `pod lib lint Build-V3-Plugin-Monitoring-ios.podspec' to ensure this is a valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Build-V3-Plugin-Monitoring-ios'
  s.version          = '1.0.2'
  s.summary          = 'Build-V3-Plugin-Monitoring-ios is a plugin capable of monitoring the app performance.'
  s.description      = <<-DESC
  Build-V3-Plugin-Monitoring-ios is a plugin capable of monitoring the app performance.
  This plugin provides 2 implementations to log events on Firebase and/or directly on the console. It also exposes an API to customize the traces and implement your own layer of monitory.
                       DESC
  s.homepage         = 'https://github.com/bryjai/build-v3-plugin-monitoring-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jérôme Morissard' => 'jerome.morissard@bryj.ai' }
  s.source           = { :git => 'git@github.com:bryjai/build-v3-plugin-monitoring-ios.git', :tag => s.version.to_s }
  s.ios.deployment_target = '14.0'
  s.swift_version = '5.0'
  s.source_files = 'Build-V3-Plugin-Monitoring-ios/Classes/**/*'
  s.resource_bundles = {'Build-V3-Plugin-Monitoring-ios' => ['Build-V3-Plugin-Monitoring-ios/Assets/*.{js}', 'PrivacyInfo.xcprivacy']}
  s.dependency 'FASDKBuild-ios', '>= 3.9.5'
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'}
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
