#
# Be sure to run `pod lib lint EYNetwork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EYNetwork'
  s.version          = '0.3.0'
  s.summary          = '基于RAC的网络请求封装'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
网络请求封装，包含AFN 的rac扩展，以及request的封装
                       DESC

  s.homepage         = 'https://github.com/wowbby/EYNetwork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wowbby' => '116676237@qq.com' }
  s.source           = { :git => 'https://github.com/wowbby/EYNetwork.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.default_subspec = 'Network'

  #s.source_files = 'EYNetwork/Classes/Network/*'
  #
  # s.resource_bundles = {
  #   'EYNetwork' => ['EYNetwork/Assets/*.png']
  # }
  s.subspec 'Network' do |ss|
      ss.source_files = 'EYNetwork/Classes/Network/*.{h,m}'
      ss.dependency 'AFNetworking', '~> 3.2.1'
      ss.dependency 'ReactiveObjC'
      end
  s.subspec 'Client' do |ss|
      ss.source_files = 'EYNetwork/Classes/Client/*.{h,m}'
      ss.dependency 'EYNetwork/Network'
      ss.subspec 'Agent' do |sss|
          sss.source_files = 'EYNetwork/Classes/Client/Agent/*.{h,m}'
          sss.dependency 'EYNetwork/Client/Request'
          end
      ss.subspec 'Request' do |sss|
          sss.source_files = 'EYNetwork/Classes/Client/Request/*.{h,m}'
          sss.dependency 'EYNetwork/Client/Utils'
          sss.dependency 'EYNetwork/Client/Cache'
          end
      ss.subspec 'Cache' do |sss|
          sss.source_files = 'EYNetwork/Classes/Client/Cache/*.{h,m}'
          end
      ss.subspec 'Utils' do |sss|
          sss.source_files = 'EYNetwork/Classes/Client/Utils/*.{h,m}'
          end
      end

  #s.public_header_files = 'EYNetwork/Classes/EYNetwork.h'
  # s.frameworks = 'UIKit', 'MapKit'
end
