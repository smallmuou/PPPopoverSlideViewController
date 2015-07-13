Pod::Spec.new do |s|
  s.name         = "PPPopoverSlideViewController"
  s.version      = "0.0.1"
  s.summary      = "侧边Popover，支持毛玻璃效果"

  s.description  = <<-DESC
                    侧边栏弹出view，支持毛玻璃效果.
                   DESC

  s.homepage     = "https://github.com/smallmuou/PPPopoverSlideViewController"
  # s.screenshots= "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = "MIT"
  s.author       = { "许文发" => "lvyexuwenfa100@126.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/smallmuou/PPPopoverSlideViewController", :tag => "0.0.1" }
  s.source_files = "PPPopoverSlideViewController/Classes/*.{h,m}"

  s.framework  = "Accelerate"
  s.requires_arc = true
end
