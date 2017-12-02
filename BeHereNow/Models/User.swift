//
//  User.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/25/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit

struct UserDefaultKeys {
    static let WisdomPushEnabledKey = "Wis------------------y"
    static let ArticlesPushEnabledKey = "Art---------------ey"
    static let VideosPushEnabledKey = "Vid---------------ey"
    static let PodcastsPushEnabledKey = "Pod----------------y"
    static let EventsPushEnabledKey = "E----------------------ey"
}

class User {
    var wisdomPushEnabled: Bool
    var articlesPushEnabled: Bool
    var videosPushEnabled: Bool
    var podcastsPushEnabled: Bool
    var eventsPushEnabled: Bool
    
    init() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let wisdomValue = userDefaults.objectForKey(UserDefaultKeys.WisdomPushEnabledKey) as? Bool {
            wisdomPushEnabled = wisdomValue
        } else {
            wisdomPushEnabled = true
        }
        
        if let articlesValue = userDefaults.objectForKey(UserDefaultKeys.ArticlesPushEnabledKey) as? Bool {
            articlesPushEnabled = articlesValue
        } else {
            articlesPushEnabled = true
        }
        
        if let videosValue = userDefaults.objectForKey(UserDefaultKeys.VideosPushEnabledKey) as? Bool {
            videosPushEnabled = videosValue
        } else {
            videosPushEnabled = true
        }
        
        if let podcastsValue = userDefaults.objectForKey(UserDefaultKeys.PodcastsPushEnabledKey) as? Bool {
            podcastsPushEnabled = podcastsValue
        } else {
            podcastsPushEnabled = true
        }
        
        if let eventsValue = userDefaults.objectForKey(UserDefaultKeys.EventsPushEnabledKey) as? Bool {
            eventsPushEnabled = eventsValue
        } else {
            eventsPushEnabled = true
        }
    }
    
    func save() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(wisdomPushEnabled, forKey: UserDefaultKeys.WisdomPushEnabledKey)
        userDefaults.setValue(articlesPushEnabled, forKey: UserDefaultKeys.ArticlesPushEnabledKey)
        userDefaults.setValue(videosPushEnabled, forKey: UserDefaultKeys.VideosPushEnabledKey)
        userDefaults.setValue(podcastsPushEnabled, forKey: UserDefaultKeys.PodcastsPushEnabledKey)
        userDefaults.setValue(eventsPushEnabled, forKey: UserDefaultKeys.EventsPushEnabledKey)
        userDefaults.synchronize()        
    }
}
