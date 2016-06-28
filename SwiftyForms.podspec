#
# Be sure to run `pod lib lint SwiftyForms.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
	s.name             = 'SwiftyForms'
	s.version          = '0.3.0'
	s.summary          = 'Swifty way to create forms in iOS'

	s.description      = <<-DESC
		TODO: Add long description of the pod here.
                       DESC

	s.homepage         = 'https://github.com/gkaimakas/SwiftyForms'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
	s.license          = { :type => 'MIT', :file => 'LICENSE' }
	s.author           = { 'gkaimakas' => 'gkaimakas@gmail.com' }
	s.source           = { :git => 'https://github.com/gkaimakas/SwiftyForms.git', :tag => s.version.to_s }

	s.ios.deployment_target = '9.0'

	s.source_files = 'SwiftyForms/Classes/**/*'

	s.dependency 'SwiftValidators', '~>3.0.0'
end
