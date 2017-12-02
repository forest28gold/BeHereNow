//
//  Constants.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 1/25/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit

enum Section: Int {
    case Wisdom = 0
    case Articles = 1
    case Videos = 2
    case Podcasts = 3
}

struct Constants {
    struct URLs {
        static let donationsUrl = "https://www.ramdass.org/mobile-donate/"
        static let contactEmail = "info@ramdass.org"
        static let wordsOfWisdomUrl = "http://rdappwow.blogspot.com/feeds/posts/default"
        static let feedUrl = "http://www.ramdass.org/feed"
        static let videosUrl = "https://www.googleapis.com/youtube/v3/search"
        static let videoPlaylistUrl = "https://www.googleapis.com/youtube/v3/playlistItems"
        static let podcastsUrl = "http://www.ramdass.org/category/podcast-episodes/feed"
        static let featuredPodcastsUrl = "http://www.ramdass.org/category/featured-podcasts/feed"
        static let youTubeKey = "AIzaSy--------------------------q9DPTq9PVkM"
        static let youTubeChannelId = "UCnX-------------------------SZkPtcg"
        static let storeUrl = "https://love-serve-remember.myshopify.com/"
    }
}

// Playlist request:
// https://www.googleapis.com/youtube/v3/playlistItems?key=AIzaSyAj9meXhshQd0VDCw7GLB6zq9DPTq9PVkM&playlistId=PL0N3CYqDABUKDBoX0iERueVbQbGydpu18&maxResults=10&part=snippet

// Playlists list:
// https://www.googleapis.com/youtube/v3/playlists?key=AIzaSyAj9meXhshQd0VDCw7GLB6zq9DPTq9PVkM&part=snippet&channelId=UCnXA5htGOTCxc67ASZkPtcg&maxResults=50

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.currentDevice().userInterfaceIdiom == .Pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}
