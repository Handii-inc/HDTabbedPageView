#
# Be sure to run `pod lib lint HDTabbedPageView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HDTabbedPageView'
  s.version          = '0.1.0'
  s.summary          = 'Tabbed page view controller.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Tabbed page view controller with easy to use.'
  s.homepage         = 'https://github.com/Handii-inc/HDTabbedPageView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Handii, Inc.' => 'github@handii.co.jp' }
  s.source           = { :git => 'https://github.com/Handii-inc/HDTabbedPageView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'HDTabbedPageView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'HDTabbedPageView' => ['HDTabbedPageView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
