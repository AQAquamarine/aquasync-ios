Pod::Spec.new do |s|
  s.name         = "aquasync"
  s.version      = "0.0.1"
  s.summary      = "Aquasync iOS client implementation"
  s.description  = "An effortless synchronization library!"
  s.homepage     = "https://github.com/AQAquamarine/aquasync-ios"
  s.license      = "MIT"
  s.author       = { "Aquamarine" => "lied.der.optik@gmail.com" }
  s.source       = { :git => "https://github.com/AQAquamarine/aquasync-ios.git", :commit => "3f7c09aebcbd98975e313df49fe0595847efe42b" }
  s.source_files  = "**/*.{h,m}"
  #s.exclude_files = "Classes/Exclude"
  s.requires_arc = true
  s.platform = "ios", '7.0'
  s.dependency "AFNetworking", "~> 2.3"
  s.dependency "ReactiveCocoa", "~> 2.3"
  s.dependency "AFNetworking-RACExtensions", "~> 0.1"
  s.dependency "Realm", "~> 0.81"
end
