Pod::Spec.new do |s|
  s.name             = 'singular_flutter_sdk'
  s.version          = '1.9.0'
  s.summary          = 'Singular flutter plugin project.'
  s.description      = <<-DESC
Singular's flutter plugin project.
                       DESC
  s.homepage         = 'https://www.singular.net/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Singular Labs' => 'support@singular.net'}
  s.source           = { :git => "https://github.com/singular-labs/Singular-Flutter-SDK.git", :tag => s.version.to_s }
  s.source_files = 'singular_flutter_sdk/Sources/singular_flutter_sdk/**/*.{h,m,mm,c}'
  s.public_header_files = 'singular_flutter_sdk/Sources/singular_flutter_sdk/include/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'
  s.ios.dependency 'Singular-SDK', '12.14.2'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
