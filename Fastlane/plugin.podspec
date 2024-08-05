Pod::Spec.new do |spec|
  spec.name         = '@plugin_name@'
  spec.version      = '@plugin_version@'
  spec.summary      = 'Plugin for the Build SDK.'
  spec.description  = <<-DESC
  @plugin_name@
                      DESC
  spec.homepage     = 'https://bryj.ai/'
  spec.license      = { :type => 'Commercial', :text => 'See https://www.bryj.ai' }
  spec.author       = 'Bryj'
  spec.source       = { :http => '@xc_sdk_zip_s3_url@' }
  spec.platform     = :ios, '14.0'
  spec.swift_version = '5.0'
  spec.vendored_frameworks = '@xc_sdk_framework@'
  @xc_dependencies@
  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'}
  spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
