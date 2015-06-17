#
# Be sure to run `pod lib lint test.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MoMOS"
  s.version          = "0.1.0"
  s.summary          = "A short description of test."
  s.description      = <<-DESC
                       An optional longer description of test

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://bitbucket.org/mobgen/momos-sdk-ios"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Borja Santos-Díez" => "borja.santos@mobgen.com" }
  # s.source           = { :git => "https://bitbucket.org/mobgen/momos-sdk-ios.git" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'MoMOSFramework/**/*.{h,swift}'
  s.public_header_files = 'MoMOSFramework/**/*.h'
  s.frameworks = 'Foundation'
  #s.resource_bundles = {
  #  'test' => ['Pod/Assets/*.png']
  #}

  s.subspec 'Core' do |core|
  	core.source_files = 'MoMOSFramework/MoMOSCore/*.{h,swift}'
  end

  s.subspec 'Networking' do |net|
  	net.source_files = 'MoMOSFramework/MoMOSNetworking/*.{h,swift}'
  	net.dependency 'MoMOS/Core'
  end

  # s.subspec 'Push' do |p|
  # 	p.source_files = 'MoMOSFramework/**/*.{h,swift}'
  # 	p.dependency 'MoMOS/Networking'
  # end

  # s.subspec 'Storage' do |st|
  # 	st.source_files = 'MoMOSFramework/**/*.{h,swift}'
  # 	st.dependency 'MoMOS/Core'
  # end

end
