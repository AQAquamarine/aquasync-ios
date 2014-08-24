Pod::Spec.new do |s|
  s.name         = "aquasync"
  s.version      = "0.1.0"
  s.summary      = "Aquasync iOS client implementation"
  s.description  = "An effortless synchronization library!"
  s.homepage     = "https://github.com/AQAquamarine/aquasync-ios"
  s.license      = "MIT"
  s.author       = { "Aquamarine" => "lied.der.optik@gmail.com" }
  s.source       = { :git => "https://github.com/AQAquamarine/aquasync-ios.git", :tag => "v0.1.0" }
  s.source_files  = "**/*.{h,m}"
  #s.exclude_files = "Classes/Exclude"
  s.requires_arc = true
  s.platform = "ios", '7.0'
  s.dependency "AFNetworking", "~> 2.3"
  s.dependency "ReactiveCocoa", "~> 2.3"
  s.dependency "AFNetworking-RACExtensions", "~> 0.1"
  s.dependency "ObjectiveRecord", "~> "1.5"
end
