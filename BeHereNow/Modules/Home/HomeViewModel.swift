//
//  HomeViewModel.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/11/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import ReactiveCocoa

class HomeViewModel {
    func loadSignal(contentType: Section) -> Signal<String, NSError> {
        switch contentType {
        case .Wisdom:
            if let signal = ContentCache.sharedInstance.wisdomSignal {
                return signal
            } else {
                return ContentCache.sharedInstance.loadWisdom()
            }
        case .Videos:
            if let signal = ContentCache.sharedInstance.videoSignal {
                return signal
            } else {
                return ContentCache.sharedInstance.loadVideos(nil)
            }
        case .Articles:
            if let signal = ContentCache.sharedInstance.articleSignal {
                return signal
            } else {
                return ContentCache.sharedInstance.loadArticles()
            }
        case .Podcasts:
            if let signal = ContentCache.sharedInstance.podcastSignal {
                return signal
            } else {
                return ContentCache.sharedInstance.loadPodcasts()
            }
        }
    }
    
    func latestContentForType(contentType: Section) -> Content? {
        switch contentType {
        case .Wisdom: return latestWisdom()
        case .Articles: return latestArticle()
        case .Videos: return latestVideo()
        case .Podcasts: return latestPodcast()
        }
    }
    
    func randomSection() -> Section {
        let randomIndex = Int(arc4random_uniform(4))
        if let section = Section(rawValue: randomIndex) { return section }
        return .Wisdom
    }
    
    func videoForParamOrLatest(param: String?) -> Article? {
        if let param = param {
            for video in ContentCache.sharedInstance.videos {
                if video.url == param {
                    return video
                }
            }
            if ContentCache.sharedInstance.videos.count == 0 { return nil }
            return ContentCache.sharedInstance.videos[0]
        } else {
            if ContentCache.sharedInstance.videos.count == 0 { return nil }
            return ContentCache.sharedInstance.videos[0]
        }
    }
    
    func articleForParamOrLatest(param: String?) -> Article? {
        if let param = param {
            for article in ContentCache.sharedInstance.articles {
                if article.url == param {
                    return article
                }
            }
            if ContentCache.sharedInstance.articles.count == 0 { return nil }
            return ContentCache.sharedInstance.articles[0]
        } else {
            if ContentCache.sharedInstance.articles.count == 0 { return nil }
            return ContentCache.sharedInstance.articles[0]
        }
    }
    
    func podcastIndexForParamOrLatest(param: String?) -> Int? {
        if ContentCache.sharedInstance.podcasts.count == 0 { return nil }

        if let param = param {
            for i in 0...ContentCache.sharedInstance.podcasts.count - 1 {
                let podcast = ContentCache.sharedInstance.podcasts[i]
                if podcast.episodeNumberString == param {
                    return i
                }
            }
            return 0
        } else {
            return 0
        }
    }
    
    func latestWisdom() -> Wisdom? {
        if ContentCache.sharedInstance.wisdom.count == 0 { return nil }
        return ContentCache.sharedInstance.wisdom[0]
    }
    
    func latestVideo() -> Article? {
        if ContentCache.sharedInstance.videos.count == 0 { return nil }
        return ContentCache.sharedInstance.videos[0]
    }
    
    func latestArticle() -> Article? {
        if ContentCache.sharedInstance.articles.count == 0 { return nil }
        return ContentCache.sharedInstance.articles[0]
    }

    func latestPodcast() -> Podcast? {
        if ContentCache.sharedInstance.podcasts.count == 0 { return nil }
        return ContentCache.sharedInstance.podcasts[0]
    }
    
    func latestPodcastIndex() -> Int? {
        if ContentCache.sharedInstance.podcasts.count == 0 { return nil }
        return 0
    }
}
