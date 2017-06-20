Pod::Spec.new do |s|
s.name               = 'JYPageView'
s.version            = '1.0.0'
s.summary            = 'A paged View for ViewControllers'
s.homepage           = 'https://github.com/majinyu888/JYPageView'
s.license            = 'MIT'
s.platform           = 'ios'
s.author             = {'majinyu' => '511151071@163.com'}
s.ios.deployment_target = '8.0'
s.source             = {:git => 'https://github.com/majinyu888/JYPageView.git', :tag => s.version}
s.source_files       = 'JYPageView/*.{h,m}'
s.resources          = 'JYPageView/*.{png,xib,nib,bundle}'
s.requires_arc       = true
s.frameworks         = 'UIKit'
end

