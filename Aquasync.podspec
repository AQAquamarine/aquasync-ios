Pod::Spec.new do |s|
  s.name         = "Aquasync"
  s.version      = "0.3.0"
  s.summary      = "Effortless client-backend synchronization."
  s.homepage     = "https://github.com/AQAquamarine/aquasync-ios"
  s.license      = "MIT"
  s.author       = { "kaiinui" => "lied.der.optik@gmail.com" }
  s.source       = { :git => "https://github.com/AQAquamarine/aquasync-ios.git", :tag => "v0.3.0" }
  s.source_files  = "Aquasync/Classes/**/*.{h,m}"
  s.requires_arc = true
  s.platform = "ios", '7.0'
  s.dependency "AFNetworking"
end

