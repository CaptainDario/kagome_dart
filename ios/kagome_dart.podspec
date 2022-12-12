#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint kagome_dart.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'kagome_dart'
  s.version          = '1.0.0'
  s.summary          = 'Simple dart bindings to the kagome lexical analyzer.'
  s.description      = <<-DESC
  Simple dart bindings to the kagome lexical analyzer.
                       DESC
  s.homepage         = 'https://github.com/CaptainDario/kagome_dart'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'CaptainDario' => 'daapplab@gmail.com' }
  s.source           = { :path => '.' }
  #s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.preserve_paths = 'kagome_dart.xcframework/**/*'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework kagome_dart' }
  s.ios.vendored_frameworks = "**/kagome_dart.xcframework"
end
