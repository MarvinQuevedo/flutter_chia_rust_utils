release_tag_name = 'flutter_chia_rust_utils-v0.0.59+5' # generated; do not edit
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_chia_rust_utils.podspec` to validate before publishing.
#

# We cannot distribute the XCFramework alongside the library directly,
# so we have to fetch the correct version here.
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
  s.source_files     = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.static_framework = true
  s.vendored_frameworks = "Frameworks/#{framework_name}"
  s.dependency 'FlutterMacOS'
  s.pod_target_xcconfig = { 'STRIP_STYLE' => 'non-global' }  # ...  'OTHER_LDFLAGS' => '-lObjC' 

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
