Pod::Spec.new do |s|
  s.name             = "HALOFramework"
  s.version          = "0.1.0"
  s.summary          = "A short description of test."
  s.description      = <<-DESC
                       An optional longer description of test

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://bitbucket.org/mobgen/halo-sdk-ios"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Borja Santos-Diez" => "borja.santos@mobgen.com" }
  # s.source           = { :git => "https://bitbucket.org/mobgen/halo-sdk-ios.git" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Source/**/*.{h,swift}'
  s.public_header_files = 'Source/**/*.h'
  s.frameworks = 'Foundation'
  #s.resource_bundles = {
  #  'test' => ['Pod/Assets/*.png']
  #}

end