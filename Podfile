# Uncomment this line to define a global platform for your project
platform :ios, '11.0'
# Comment this line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!
inhibit_all_warnings!
source 'https://github.com/CocoaPods/Specs.git'

def project_pods
  # Keychain
  pod 'SwiftKeychainWrapper', '~> 3.2.0'
  
  # Rest
  
  pod 'Alamofire', '~> 4.8.0'
  pod 'AlamofireObjectMapper', '~> 5.2'
end

target 'Task' do
  project_pods
end

