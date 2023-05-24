release_tag_name = 'flutter_chia_rust_utils-v0.0.61+1' # generated; do not edit
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_chia_rust_utils.podspec` to validate before publishing.
#
framework_name = 'BlsFlutter.xcframework'
remote_zip_name = "#{framework_name}.zip"
url = "https://github.com/MarvinQuevedo/flutter_chia_rust_utils/releases/download/#{release_tag_name}/#{remote_zip_name}"  
local_zip_name = "#{release_tag_name}.zip"
`
mkdir -p Frameworks
cd Frameworks
rm -rf #{framework_name}
if [ ! -f #{local_zip_name} ]
then
  curl -L #{url} -o #{local_zip_name}
fi
unzip #{local_zip_name}
cd -
`
Pod::Spec.new do |s|
  s.name             = 'flutter_chia_rust_utils'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'
  s.static_framework = true
  s.vendored_frameworks = "Frameworks/#{framework_name}"
  s.pod_target_xcconfig = { 'STRIP_STYLE' => 'non-global'  }

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386 arm64' } 
  s.user_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
