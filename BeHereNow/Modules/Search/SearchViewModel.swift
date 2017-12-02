//
//  SearchViewModel.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/25/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import Foundation
import ReactiveCocoa

class SearchViewModel {
    let topics: [String: String] = [
        "Artículos en Español": "PL0N----------------xFKEotgCR", //v
        "Attachment" : "PL0----------------nd6lF2Vz", // v
        "Awareness/Mindfulness": "PL0N3-----------------ff3jZ", //v
        "Compassion": "PL0N-----------------------takE4r", //v
        "Conscious Aging": "PL0N---------------------hMzZ2I_U3un", //v
        "Consciousness": "PL0N3----------------VbQbGydpu18", //v
        "Cultivation": "PL0N3CYqDAB------------------y1MeQ", //v
        "Death & Dying": "PL0N3CYqDA-------------------mpXIFKNXpL",//v
        "Disturbing Emotions": "PL0N3CY----------------VjExM4NZs",//v
        "Faith & Trust": "PL0-----------------UEeX4GNWe",//v
        "Forgiveness": "PL0-----------------jqXUbeulEo", //v
        "Life Perspective": "PL0N3CYq---------------------O5pAf7",//v
        "Loving Awareness": "PL0-------------------------67L-nl",//v
        "Loving Kindness": "PL0N3---------------------0mdXGbjF-4CQc", //v
        "Meditation": "PL0N3CYq----------------------wvvIFLsa",
        "Neem Karoli Baba": "PL--------------------kK6HdTz9-p",
        "Psychedelics": "PL------------------LLwC1j9", //v
        "Relationships": "PL0N3CYq--------------------6vcyQP",
        "Spiritual Practices": "PL0-------------------------vXoppcZvRIxI",
        "Surrender": "PL0N3C----------------------IWDSgR2",
        "The Guru": "PL0N3CY----------------------d7QiBWvupd",
        "The Soul": "PL--------------------jy-umHpu0R",
        "The Witness": "PL0N-------------------ITITogiSKc4K",
        "Unconditional Love": "PL0N3C----------------------8GgjKj7"
    ]
    
    var searchTopic: String?
    
    var searchResults = [Content]()
    var lastLoadedCategory = ""
    var isLoadingSearchResults = false
    
    var articlesPage = 1
    var didLoadAllArticles = false
    var articlesLoaded = 0
    
    var nextPageVideoToken = ""
    var didLoadAllVideos = false
    var videosLoaded = 0
    
    func topicForRow(row: Int) -> String {
        let topicsArray = Array(topics.keys)
        
        let actualRow = row % topicsArray.count
        if actualRow >= topicsArray.count { return "" }
        return topicsArray[actualRow]
    }
    
    func numberOfTopics() -> Int {
        return topics.count*1000
    }
    
    func numberOfResults() -> Int {
        print (searchResults.count)
        return searchResults.count
    }
    
    func resetSearch() {
        print("Removing all results")
        
        searchResults.removeAll()
        
        articlesPage = 1
        didLoadAllArticles = false
        articlesLoaded = 0
        
        nextPageVideoToken = ""
        didLoadAllVideos = false
        videosLoaded = 0
    }
    
    func contentObjectDate(contentObject: AnyObject) -> NSDate {
        if let article = contentObject as? Article {
            return article.date
        }
        if let podcast = contentObject as? Podcast {
            return podcast.date
        }
        return NSDate()
    }
    
    func loadSearchResults(category: String) -> Signal<(String, String), NSError> {
        if lastLoadedCategory != category { resetSearch() }
        
        lastLoadedCategory = category
        isLoadingSearchResults = true
        
        let loadArticlesSignal = loadArticles(category)
        var playlistId = ""
        if let unwrappedPlaylistId = topics[category] { playlistId = unwrappedPlaylistId }
        let loadVideosSignal = loadPlaylistVideos(playlistId)
        let signal = combineLatest(loadVideosSignal, loadArticlesSignal)
        signal.observeCompleted { () -> () in
            self.isLoadingSearchResults = false
            
        }
        signal.observeFailed { (NSError) -> () in
            self.isLoadingSearchResults = false
        }
        
        return signal
    }
    
    func loadArticles(category: String) -> Signal<String, NSError> {
        let itemsBeforeLoad = self.articlesLoaded
        
        let actualCategory = category.stringByReplacingOccurrencesOfString("&", withString: " ")
            .stringByReplacingOccurrencesOfString("/", withString: " ")
            .stringByReplacingOccurrencesOfString("   ", withString: " ")
            .stringByReplacingOccurrencesOfString("  ", withString: " ")
            .stringByReplacingOccurrencesOfString(" ", withString: "_")        
        
        return Signal<String, NSError> { sink in
            API.loadCategoryItems(actualCategory, page: self.articlesPage).on(started: { () -> () in
                }, event: { (event: Event<Content, NSError>) -> () in
                }, failed: { (error: NSError) -> () in
                }, completed: { () -> () in
                    sink.sendCompleted()
                    
                    self.articlesPage += 1
                    if itemsBeforeLoad == self.articlesLoaded { self.didLoadAllArticles = true }
                }, interrupted: { () -> () in
                }, terminated: { () -> () in
                }, disposed: { () -> () in
                }, next: { (article: Content) -> () in
                    self.articlesLoaded += 1
                    self.searchResults.append(article)
                    if let article = article as? Article {
                        print("Article: " + article.title)
                    }
                    if let article = article as? Podcast {
                        print("Podcast: " + article.title)
                    }
            }).start()
        }
    }
    
    func loadPlaylistVideos(playlistId: String) -> Signal<String, NSError> {
        return Signal<String, NSError> { sink in
            API.loadPlaylistVideos(playlistId).on(started: { () -> () in
                }, event: { (event: Event<Content, NSError>) -> () in
                }, failed: { (error: NSError) -> () in
                }, completed: { () -> () in
                    sink.sendCompleted()
                    self.didLoadAllVideos = true
                }, interrupted: { () -> () in
                }, terminated: { () -> () in
                }, disposed: { () -> () in
                }, next: { (object: Content) -> () in
                    if let article = object as? Article {
                        self.videosLoaded += 1
                        self.searchResults.append(article)
                    }
                    if let nextPageToken = object as? NextPageToken {
                        self.nextPageVideoToken = nextPageToken.token
                    }
            }).start()
        }
        
    }
    
    func titleForSearchResultAtRow(row: Int) -> String {
        let object = searchResults[row]
        if let object = object as? Article { return object.title }
        if let object = object as? Podcast { return object.title }
        
        return ""
    }
    
    func searchObjectAtRow(row: Int) -> Content {
        return searchResults[row]
    }
    
    func isRowLast(row: Int) -> Bool {
        return searchResults.count - 1 == row
    }
    
}
