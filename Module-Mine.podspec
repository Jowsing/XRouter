#
# Be sure to run `pod lib lint XRouter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Module-Mine'
  s.version          = '1.0.0'
  s.summary          = 'A short description of Module-Mine.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
                       
  s.homepage         = 'https://github.com/jowsing/Module-Mine'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jowsing' => 'jowsing169@gmail.com' }
  s.source           = { :git => 'https://github.com/jowsing/Module-Mine.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'Module-Mine/**/*'

  s.info_plist = {
    'CFBundleIdentifier' => 'pods.local.modules.mine'
  }
  
  s.dependency 'X-Router'
  s.dependency 'Base'
  
end
