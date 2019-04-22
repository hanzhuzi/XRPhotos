#
#  Be sure to run `pod spec lint XRPhotos.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "XRPhotos"
  s.version      = "1.0"
  s.summary      = "Based on a ` PhotosKit ` photo selection framework."
  s.homepage     = "https://github.com/hanzhuzi/XRPhotos"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license    = { :type => 'MIT', :file => 'LICENSE'}
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  s.author             = { "hanzhuzi" => "violet_buddhist@163.com" }
  
  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  
  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :git => "https://github.com/hanzhuzi/XRPhotos.git", :tag => "#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files  = "Source", "XRPhotos/Source/**/*.{h,m}"

  # s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.resources = "XRPhotos/Source/XRPhotos.bundle/*.png"

  s.requires_arc = true

  s.dependency "MWPhotoBrowser", "~> 2.1.2"
  s.dependency "RSKImageCropper", "~> 2.2.1"
  
end
