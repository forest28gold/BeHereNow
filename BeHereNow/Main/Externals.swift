//
//  Externals.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 1/24/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

struct ServiceIDs {
    static let OneSignalKey = "839ee-------------------------------118d10f19"
    static let LocalyticsKey = "be77e57----------------------------------3b-005cf8cbabd8"
}

class Externals {
    class func initExternals(launchOptions: [NSObject: AnyObject]?) {
        Localytics.integrate(ServiceIDs.LocalyticsKey)
        let application = UIApplication.sharedApplication()
        if application.applicationState == .Background { Localytics.openSession() }
                
        let URLCache = NSURLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
        NSURLCache.setSharedURLCache(URLCache)
        
        _ = OneSignal(launchOptions: launchOptions, appId: ServiceIDs.OneSignalKey, handleNotification: { (message, additionalData, isActive) in
            NSLog("OneSignal Notification opened:\nMessage: %@", message)
            
            if additionalData != nil {
                NSLog("additionalData: %@", additionalData)
                // Check for and read any custom values you added to the notification
                // This done with the "Additonal Data" section the dashbaord.
                // OR setting the 'data' field on our REST API.
                
                if let type = additionalData["type"] as? String {
                    if let extraParam = additionalData["identifier"] as? String {
                        ContentCache.sharedInstance.setPushTypeToOpen(type, anExtraParam: extraParam)
                    } else {
                        ContentCache.sharedInstance.setPushTypeToOpen(type, anExtraParam: nil)
                    }
                    
                    if (ContentCache.sharedInstance.initialPushShown) {
                        let windows = UIApplication.sharedApplication().windows
                        if windows.count > 0 {
                            let window = windows[0]
                            if let rootNavigationController = window.rootViewController as? UINavigationController {
                                let viewControllers = rootNavigationController.viewControllers
                                if viewControllers.count > 0 {
                                    let viewController = viewControllers[0]
                                    if let homeViewController = viewController as? HomeViewController {
                                        homeViewController.presentCachedPushNotification()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            }, autoRegister: false)
        
        OneSignal.defaultClient().enableInAppAlertNotification(true)
        Externals.updatePushTags()
    }

    class func updatePushTags() {
        OneSignal.defaultClient().sendTags(
            ["wisdom" : ContentCache.sharedInstance.user.wisdomPushEnabled ? "on" : "off",
            "articles" : ContentCache.sharedInstance.user.articlesPushEnabled ? "on" : "off",
            "videos" : ContentCache.sharedInstance.user.videosPushEnabled ? "on" : "off",
            "podcasts" : ContentCache.sharedInstance.user.podcastsPushEnabled ? "on" : "off",
            "events" : ContentCache.sharedInstance.user.eventsPushEnabled ? "on" : "off",
            "isYaron": "on"])
    }
    
    class func registerForPush() {
        OneSignal.defaultClient().registerForPushNotifications()
    }
    
    class func tagAnalyticsEvent(eventName: String, attributes: [String: AnyObject]?) {
        if let attributes = attributes {
            Localytics.tagEvent(eventName, attributes: attributes)
        } else {
            Localytics.tagEvent(eventName)
        }
    }
    
    class func tagAnalyticsScreen(screenName: String) {
        Localytics.tagScreen(screenName)
    }
}
