//
//  ContentCache.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/4/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import Foundation
import ReactiveCocoa

class ContentCache {
    static let sharedInstance = ContentCache()

    var didDeleteDonations = false
    
    var user = User()
    
    var wisdom = [Wisdom]()
    var isLoadingWisdom = false
    var didLoadAllWisdom = false
    var wisdomSignal: Signal<String, NSError>?
    
    var articles = [Article]()
    var articlePage = 1
    var isLoadingArticles = false
    var didLoadAllArticles = false
    var articleSignal: Signal<String, NSError>?
    
    var videos = [Article]()
    var nextPageVideoToken = ""
    var isLoadingVideos = false
    var didLoadAllVideos = false
    var videoSignal: Signal<String, NSError>?
    
    var podcasts = [Podcast]()
    var podcastPage = 1
    var isLoadingPodcasts = false
    var didLoadAllPodcasts = false
    var podcastSignal: Signal<String, NSError>?
    
    var featuredPodcasts = [Podcast]()
    var featuredPodcastPage = 1
    var isLoadingFeaturedPodcasts = false
    var didLoadAllFeaturedPodcasts = false
    var featuredPodcastSignal: Signal<String, NSError>?
    
    var pushType: Section?
    var extraParam: String?
    var initialPushShown = false
    
    func setPushTypeToOpen(typeString: String, anExtraParam: String?) {
        if let anExtraParam = anExtraParam {
            extraParam = anExtraParam
        }
        switch (typeString) {
        case "wisdom": pushType = .Wisdom
        case "podcast": pushType = .Podcasts
        case "article": pushType = .Articles
        case "video": pushType = .Videos
        default: pushType = nil
        }
    }
    
    func preloadContent() {
        loadWisdom()
        loadArticles()
        loadVideos(nil)
        loadPodcasts()
        loadFeaturedPodcasts()
    }
    
    func loadWisdom() -> Signal<String, NSError> {
        isLoadingWisdom = true
        let itemsBeforeLoad = wisdom.count
        
        let newSignal = Signal<String, NSError> { sink in
            API.loadWordsOfWisdom(wisdom.count + 1).on(started: { () -> () in
                }, event: { (event: Event<Wisdom, NSError>) -> () in
                }, failed: { (error: NSError) -> () in
                    self.isLoadingWisdom = false
                }, completed: { () -> () in
                    sink.sendCompleted()
                    
                    if itemsBeforeLoad == self.wisdom.count { self.didLoadAllWisdom = true }
                    self.isLoadingWisdom = false
                    self.wisdomSignal = nil
                }, interrupted: { () -> () in
                }, terminated: { () -> () in
                }, disposed: { () -> () in
                }, next: { (wisdom: Wisdom) -> () in
                    ContentCache.sharedInstance.wisdom.append(wisdom)
            }).start()
        }
        wisdomSignal = newSignal
        return newSignal
    }
    
    
    func loadPodcasts() -> Signal<String, NSError> {
        isLoadingPodcasts = true
        let itemsBeforeLoad = ContentCache.sharedInstance.podcasts.count
        
        let newSignal = Signal<String, NSError> { sink in
            API.loadPodcasts(ContentCache.sharedInstance.podcastPage, featured: false).on(started: { () -> () in
                }, event: { (event: Event<Podcast, NSError>) -> () in
                }, failed: { (error: NSError) -> () in
                    self.isLoadingPodcasts = false
                }, completed: { () -> () in
                    sink.sendCompleted()
                    
                    self.podcastPage += 1
                    if itemsBeforeLoad == ContentCache.sharedInstance.podcasts.count { self.didLoadAllPodcasts = true }
                    self.isLoadingPodcasts = false
                    self.podcastSignal = nil
                }, interrupted: { () -> () in
                }, terminated: { () -> () in
                }, disposed: { () -> () in
                }, next: { (podcast: Podcast) -> () in
                    self.podcasts.append(podcast)
            }).start()
        }
        podcastSignal = newSignal
        return newSignal
    }
    
    func loadFeaturedPodcasts() -> Signal<String, NSError> {
        isLoadingFeaturedPodcasts = true
        let itemsBeforeLoad = ContentCache.sharedInstance.featuredPodcasts.count
        
        let newSignal = Signal<String, NSError> { sink in
            API.loadPodcasts(ContentCache.sharedInstance.podcastPage, featured: true).on(started: { () -> () in
                }, event: { (event: Event<Podcast, NSError>) -> () in
                }, failed: { (error: NSError) -> () in
                    self.isLoadingFeaturedPodcasts = false
                }, completed: { () -> () in
                    sink.sendCompleted()
                    
                    self.featuredPodcastPage += 1
                    if itemsBeforeLoad == ContentCache.sharedInstance.featuredPodcasts.count { self.didLoadAllFeaturedPodcasts = true }
                    self.isLoadingFeaturedPodcasts = false
                    self.featuredPodcastSignal = nil
                }, interrupted: { () -> () in
                }, terminated: { () -> () in
                }, disposed: { () -> () in
                }, next: { (podcast: Podcast) -> () in
                    self.featuredPodcasts.append(podcast)
            }).start()
        }
        featuredPodcastSignal = newSignal
        return newSignal
    }

    
    func loadArticles() -> Signal<String, NSError> {
        isLoadingArticles = true
        let itemsBeforeLoad = ContentCache.sharedInstance.articles.count
        
        let newSignal = Signal<String, NSError> { sink in
            API.loadArticles(articlePage).on(started: { () -> () in
                }, event: { (event: Event<Article, NSError>) -> () in
                }, failed: { (error: NSError) -> () in
                    self.isLoadingArticles = false
                }, completed: { () -> () in
                    sink.sendCompleted()
                    
                    self.articlePage += 1
                    if itemsBeforeLoad == self.articles.count { self.didLoadAllArticles = true }
                    self.isLoadingArticles = false
                    self.articleSignal = nil
                }, interrupted: { () -> () in
                }, terminated: { () -> () in
                }, disposed: { () -> () in
                }, next: { (article: Article) -> () in
                    self.articles.append(article)
            }).start()
        }
        articleSignal = newSignal
        return newSignal
    }

    func loadVideos(category: String?) -> Signal<String, NSError> {
        isLoadingVideos = true
        let itemsBeforeLoad = ContentCache.sharedInstance.videos.count
        
        let newSignal = Signal<String, NSError> { sink in
            API.loadVideos(self.nextPageVideoToken).on(started: { () -> () in
                }, event: { (event: Event<Content, NSError>) -> () in
                }, failed: { (error: NSError) -> () in
                    self.isLoadingVideos = false
                }, completed: { () -> () in
                    sink.sendCompleted()
                    
                    if itemsBeforeLoad == self.videos.count { self.didLoadAllVideos = true }
                    self.isLoadingVideos = false
                    self.videoSignal = nil
                }, interrupted: { () -> () in
                }, terminated: { () -> () in
                }, disposed: { () -> () in
                }, next: { (object: Content) -> () in
                    if let article = object as? Article {
                        self.videos.append(article)
                    }
                    if let nextPageToken = object as? NextPageToken {
                        self.nextPageVideoToken = nextPageToken.token
                    }
            }).start()
        }
        videoSignal = newSignal
        return newSignal
    }
}
