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
  Kagome is a mecab clone written in go with portability in mind.
                       DESC
  s.homepage         = 'https://github.com/CaptainDario/kagome_dart'
  s.license          = { :type => "custom", :file => '../LICENSE' }
  s.author           = { 'CaptainDario' => 'daapplab@gmail.com' }
  #s.source           = { :http => 'https://github.com/CaptainDario/TfLite-Binaries/releases/download/r2.11/kagome_dart.xcframework.zip' }
  s.source           = { :path => '.'}
  s.static_framework = true

  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386 arm64' }
  #s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386 arm64' }
  s.swift_version = '5.0'

  s.preserve_paths = 'libkagome_dart.xcframework/**/*'
  #s.xcconfig = { 'OTHER_LDFLAGS' => '-l libkagome_dart' }
  #s.vendored_libraries  = "libkagome_dart.a"
  s.vendored_frameworks = "libkagome_dart.xcframework"
end
