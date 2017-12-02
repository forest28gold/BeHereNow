//
//  PushViewModel.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/23/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import Foundation

class PushViewModel {
    let contentType: Section
    
    let wisdom: Wisdom?
    let article: Article?
    let podcast: Podcast?
    let podcastIndex: Int?
    
    init(contentType aContentType:Section, wisdom aWisdom: Wisdom?,podcastIndex aPodcastIndex: Int?, article anArticle: Article?) {
        podcastIndex  = aPodcastIndex
        if let podcastIndex = podcastIndex {
            podcast = ContentCache.sharedInstance.podcasts[podcastIndex]
        } else {
            podcast = nil
        }
        contentType = aContentType
        article = anArticle
        wisdom = aWisdom
    }
    
    func dateForContent() -> NSDate {
        switch (contentType) {
        case .Articles, .Videos: if let article = article { return article.date }
        case .Podcasts: if let podcast = podcast { return podcast.date }
        case .Wisdom: if let wisdom = wisdom { return wisdom.date }
        }
        
        return NSDate()
    }
    
    func contentTypeString() -> String {
        switch (contentType) {
        case .Articles: return "ARTICLE"
        case .Wisdom: return "WORDS OF WISDOM"
        case .Podcasts: return "PODCAST"
        case .Videos: return "VIDEO"
        }
    }
    
    func imageUrl() -> String {
        switch (contentType) {
        case .Articles, .Videos: if let article = article { return article.imageUrl }
        case .Podcasts: if let podcast = podcast { return podcast.imageUrl }
        default: return ""
        }
        return ""
    }
    
    func contentTitle() -> String {
        switch (contentType) {
        case .Articles, .Videos: if let article = article { return article.title }
        case .Podcasts: if let podcast = podcast { return podcast.title }
        default: return ""
        }
        return ""
    }
}
