platform :ios, '10.0'

use_frameworks!

def available_pods
    inhibit_all_warnings!
    pod 'Firebase'
    pod 'Firebase/Auth'
    pod 'Firebase/Database'
    pod 'Firebase/Storage'
    pod 'Firebase/DynamicLinks'
    pod 'FBSDKCoreKit'
    pod 'FBSDKShareKit'
    pod 'FBSDKLoginKit'
    pod 'Stripe', '~> 13.0.3'
    pod 'Alamofire'
    pod 'ReachabilitySwift'
    pod 'IQKeyboardManagerSwift'
    pod 'CodableFirebase'
end

target 'Brewiskey' do
    available_pods
end

target 'BrewiskeyTests' do
    available_pods
end

