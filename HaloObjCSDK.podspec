Pod::Spec.new do |spec|
  spec.name             = 'HaloObjCSDK'
  spec.module_name      = 'HaloObjC'
  spec.version          = '2.3.0'
  spec.summary          = 'HALO iOS SDK (Objective-C)'
  spec.homepage         = 'https://mobgen.github.io/halo-documentation/ios_home.html'
  spec.license          = 'Apache License, Version 2.0'
  spec.author           = { 'Borja Santos-Diez' => 'borja.santos@mobgen.com' }
  spec.source           = { :git => 'https://github.com/mobgen/halo-ios.git', :tag => '2.3.0' }

  spec.platforms        = { :ios => '8.0' }
  spec.requires_arc     = true

  spec.source_files         = 'HaloObjC/**/*.{h,swift}'
  spec.public_header_files  = 'HaloObjC/**/*.h'
 
  spec.dependency 'HaloSDK'

end