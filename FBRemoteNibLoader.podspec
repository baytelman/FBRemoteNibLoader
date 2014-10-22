#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "FBRemoteNibLoader"
  s.version          = File.read('VERSION')
  s.summary          = "iOS library that allows to fetch remote .xib compiled and compresed files, and to load UIViewControllers from fetched .xibs"
  s.description      = <<-DESC
                        iOS library that allows to fetch remote .xib compiled and compresed files, and to load UIViewControllers from fetched .xibs

                        FBRemoteNibLoader lets you fetch updated versions of NIB files without having to update your app in the AppStore

                        This doesn't include any compiled source code, so it should be fine by Apple guidelines. 
                       DESC
  s.homepage         = "http://github.com/baytelman/FBRemoteNibLoader"
  #s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Felipe Baytelman" => "felipe.baytelman@gmail.com" }
  s.source           = { :git => "https://github.com/baytelman/FBRemoteNibLoader.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/baytelman'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files  = 'FBRemoteNibLoader', 'Classes/**/*.{h,m}'
  # s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'SBYZipArchive', '~> 0.3'
end
