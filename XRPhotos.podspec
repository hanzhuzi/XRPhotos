
Pod::Spec.new do |s|

  s.name         = "XRPhotos"
  s.version      = "1.0.4"
  s.summary      = "Based on a ` PhotosKit ` photo selection framework."
  s.homepage     = "https://github.com/hanzhuzi/XRPhotos"
  s.license      = 'MIT'
  s.author       = { "hanzhuzi" => "violet_buddhist@163.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/hanzhuzi/XRPhotos.git", :tag => "#{s.version}" }
  s.source_files  = "Source", "XRPhotos/Source/**/*.{h,m}"
  
  s.resource_bundles = {
      'XRPhotos' => ['XRPhotos/Source/XRPhotos.bundle/*.png']
  }
  
  s.ios.framework  = 'UIKit', 'Foundation'
  s.weak_frameworks = 'Photos'
  s.requires_arc = true
  
  s.dependency  'XRPhotoBrowser'
  s.dependency  'RSKImageCropper'
  s.dependency  'MBProgressHUD'
  
end
