Pod::Spec.new do |s|
  s.name         = "XNavigationBarHUD"
  s.version      = "1.0.0"
  s.summary      = "An easy way to use navigationBarHUD”
  s.homepage     = "http://www.xayoung.cn”
  s.license      = "MIT"
  s.authors      = { ‘xayoung’ => ‘xayoung01@gmail.com'}
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/xayoung/XNavigationBarHUD.git", :tag => s.version }
  s.source_files = 'XNavigationBarHUD', 'XNavigationBarHUD/**/*.{h,m}'
  s.resource     = 'XNavigationBarHUD/XNavigationBarHUD.bundle'
  s.requires_arc = true
end