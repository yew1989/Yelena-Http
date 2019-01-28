Pod::Spec.new do |s|
  s.name             = 'YLHttp'
  s.version          = '0.1.1'
  s.summary          = 'Yelena Http Tool Library.'

  s.description      = <<-DESC
  Yelena Http请求功能库 POST、GET、图片上传、文件下载、网络检测.
                       DESC

  s.homepage         = 'https://github.com/yew1989/Yelena-Http'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LinWei' => '18046053193@163.com' }
  s.source           = { :git => 'https://github.com/yew1989/Yelena-Http.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files   = 'YLHttp/YLHttp/Classes/**/*'

  # s.source_files = 'YLHttp/Classes/**/*'

  # s.resource_bundles = {
  #   'YLHttp' => ['YLHttp/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

  s.dependency 'YLCore'
  s.dependency 'AFNetworking'

end
