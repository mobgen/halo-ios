Pod::Spec.new do |spec|
  spec.name             = 'HALO-SDK'
  spec.module_name      = 'Halo'
  spec.version          = '2.2.0'
  spec.summary          = 'HALO iOS SDK'
  spec.homepage         = 'https://mobgen.github.io/halo-documentation/ios_home.html'
  spec.license          = 'Apache License, Version 2.0'
  spec.author           = { 'Borja Santos-Diez' => 'borja.santos@mobgen.com' }
  spec.source           = { :git => 'https://github.com/mobgen/halo-ios.git', :tag => '2.2.0' }

  spec.platforms        = { :ios => '8.0' }
  spec.requires_arc     = true

  spec.frameworks       = 'Foundation'
  spec.default_subspec  = 'Swift'

  spec.subspec 'Swift' do |swift|
    swift.source_files  = 'Sources/**/*.swift', 'Libraries/**/*.swift' 
  end

  spec.subspec 'ObjC' do |objc|
    objc.dependency 'HALO-SDK/Swift'
    objc.source_files         = 'HaloObjC/**/*.{h,swift}'
    objc.public_header_files  = 'HaloObjC/**/*.h'
  end

end