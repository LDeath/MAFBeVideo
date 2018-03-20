#
#  Be sure to run `pod spec lint MAFZhuMuSDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "MAFBeVideo"
  s.version      = "0.0.7"
  s.summary      = "视频会议"
  s.description  = <<-DESC
农旗视频会议封装
                   DESC
  s.homepage     = "https://github.com/LDeath"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "高赛" => "395765302@qq.com" }
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/LDeath/MAFBeVideo.git", :tag => "#{s.version}" }
  s.source_files = 'MAFBeVideo/**/**/*'
  s.vendored_libraries = '/MAFBeVideo/VideoLib/*.a'

end
