platform :ios, '8.0'

use_frameworks!

target 'BeHereNow' do
    pod 'Localytics',  '~> 3.7'
    pod 'Google/Analytics'
    pod 'SnapKit'
    pod 'ReactiveCocoa', '~> 4.0.0-RC.1'
    pod 'Alamofire', '~> 3.0'
    pod 'AlamofireImage', '~> 2.0'
    pod 'SWXMLHash', '~> 2.1.0' 
    pod 'DateTools'
    pod 'OneSignal'
end

post_install do |installer|
    plist_buddy = "/usr/libexec/PlistBuddy"
    installer.pods_project.targets.each do |target|
        plist = "Pods/Target Support Files/#{target}/Info.plist"
        original_version = `#{plist_buddy} -c "Print CFBundleShortVersionString" "#{plist}"`.strip
        changed_version = original_version[/(\d+\.){1,2}(\d+)?/]
        unless original_version == changed_version
            puts "Fix version of Pod #{target}: #{original_version} => #{changed_version}"
            `#{plist_buddy} -c "Set CFBundleShortVersionString #{changed_version}" "Pods/Target Support Files/#{target}/Info.plist"`
        end
    end
end
