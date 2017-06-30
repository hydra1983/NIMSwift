Pod::Spec.new do |s|
s.name = 'NIMSwift'
s.version = '0.1.0'
s.license= { :type => "MIT", :file => "LICENSE" }
s.summary = 'NIMSwift is a Swift module for subViews to uiview.'
s.homepage = 'https://github.com/neteaseapp/NIMSwift'
s.authors = { 'chengfei.heng' => 'hengchengfei@sina.com' }
s.source = { :git => 'https://github.com/neteaseapp/NIMSwift.git', :tag => "0.1.0"  }
s.ios.deployment_target = '8.0' #支持的版本号
s.source_files = "NIMSwift/Classes/*.swift", "NIMSwift/Classes/**/*.swift"  #包含的source文件
end
