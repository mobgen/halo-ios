Pod::Spec.new do |spec|
  spec.name             = 'HaloSDK'
  spec.module_name      = 'Halo'
  spec.version          = '2.6.0'
  spec.summary          = 'HALO iOS SDK'
  spec.homepage         = 'https://mobgen.github.io/halo-documentation/ios_home.html'
  spec.license          = 'Apache License, Version 2.0'
  spec.author           = { 'Juan Soilan Lopez' => 'juan.soilan@mobgen.com' }
  spec.source           = { :git => 'https://github.com/mobgen/halo-ios.git', :tag => '2.6.0' }
  spec.source_files     = 'Source/**/*.swift', 'Libraries/**/*.swift'


  spec.platforms        = { :ios => '8.0' }
  spec.requires_arc     = true
  spec.frameworks       = 'Foundation', 'SystemConfiguration'
  spec.libraries        = 'sqlite3', 'z'

end
