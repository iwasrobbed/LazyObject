Pod::Spec.new do |spec|
  spec.name         = "LazyObject"
  spec.summary      = "Lazy JSON deserialization in Swift"
  spec.version      = "0.2.1"
  spec.homepage     = "https://github.com/iwasrobbed/LazyObject"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.authors      = { "Rob Phillips" => "rob@desideratalabs.co" }
  spec.source       = { :git => "https://github.com/iwasrobbed/LazyObject.git", :tag => "v" + spec.version.to_s }
  spec.source_files = "Source/**/*"
  spec.platform		= :ios, "9.0"
  spec.requires_arc = true
  spec.module_name = "LazyObject"
end