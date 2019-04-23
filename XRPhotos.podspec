#
#  Be sure to run `pod spec lint XRPhotos.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "XRPhotos"
  s.version      = "1.0.2"
  s.summary      = "Based on a ` PhotosKit ` photo selection framework."
  s.homepage     = "https://github.com/hanzhuzi/XRPhotos"
  s.license      = 'MIT'
  s.author       = { "hanzhuzi" => "violet_buddhist@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/hanzhuzi/XRPhotos.git", :tag => "#{s.version}" }
  s.source_files  = "Source", "XRPhotos/Source/**/*.{h,m}"
  s.resource_bundles = {
      'XRPhotos' => ['XRPhotos/Source/XRPhotos.bundle/*.png']
  }
  
  s.weak_frameworks = 'Photos'
  s.requires_arc = true
  
  s.dependency "MWPhotoBrowser", "~> 2.1.2"
  s.dependency "RSKImageCropper", "~> 2.2.1"
  
end
