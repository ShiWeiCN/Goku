Pod::Spec.new do |s|
  s.name = 'Goku'
  s.version = '2.0.0'
  s.license = 'MIT'
  s.summary = '😊 Goku is an alert view written by swift 4.2, support both action sheet and alert view style.'
  s.homepage = 'https://github.com/shiwei93/Goku'
  s.authors = { 'shiwei93' => 'stayfocusjs@gmail.com'}
  s.source = { :git => 'https://github.com/shiwei93/Goku.git', :tag => s.version }
  s.ios.deployment_target = '9.0'
  s.ios.frameworks = 'UIKit', 'Foundation'
  s.source_files = 'Source/**/*.swift'
  s.swift_version = '4.2'
end
