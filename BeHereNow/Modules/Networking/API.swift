//
//  API.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/2/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import Alamofire
import ReactiveCocoa
import SWXMLHash

class API {
    class func articleFromItemXML(elem: XMLIndexer) -> Article? {
        if let titleElement = elem["title"].element, let title = titleElement.text, let linkElement = elem["link"].element, let link = linkElement.text, let pubDateElement = elem["pubDate"].element, let dateString = pubDateElement.text, let imageElement = elem["media:thumbnail"].element, let imageUrl = imageElement.attributes["url"], let descriptionElement = elem["description"].element, let description = descriptionElement.text {
            
            // Remove articles that are actually podcasts
            if let categoryElement = elem["category"].element, let categoryText = categoryElement.text {
                if categoryText == "Podcast Episodes" { return nil }
            } else {
                for elem in elem["category"].all {
                    if let categoryElement = elem.element, let categoryText = categoryElement.text {
                        if categoryText == "Podcast Episodes" { return nil }
                    }
                }
            }
            
            var fullImageUrl: NSString?
            let scanner = NSScanner(string: description)
            scanner.scanUpToString("img src=\"", intoString: nil)
            scanner.scanString("img src=\"", intoString: nil)
            scanner.scanUpToString("\"", intoString: &fullImageUrl)
            
            if let fullImageUrl = fullImageUrl {
                return Article(title: title, url: link, imageUrl: String(fullImageUrl), dateString: dateString, author: "", isVideo: false)
            } else {
                return Article(title: title, url: link, imageUrl: imageUrl, dateString: dateString, author: "", isVideo: false)
            }
        } else {
            return nil
        }
    }
    
    class func podcastFromItemXML(elem: XMLIndexer) -> Podcast? {
        if let titleElement = elem["title"].element, let title = titleElement.text, let linkElement = elem["enclosure"].element, let link = linkElement.attributes["url"], let pubDateElement = elem["pubDate"].element, let dateString = pubDateElement.text, let imageElement = elem["media:thumbnail"].element, let imageUrl = imageElement.attributes["url"], let durationElement = elem["itunes:duration"].element, let durationString = durationElement.text, descriptionElement = elem["itunes:summary"].element, let description = descriptionElement.text {
            return Podcast(title: title, url: link, imageUrl: imageUrl, dateString: dateString, duration: durationString, description: description)
        } else {
            return nil
        }
    }
    
    class func videoFromItemJSON(item: [String: AnyObject]) -> Article? {
        if let snippet = item["snippet"] as? [String: AnyObject] {
            if let title = snippet["title"] as? String, let idDict = item["id"] as? [String: AnyObject], let videoId = idDict["videoId"] as? String, let thumbnailsDict = snippet["thumbnails"] as? [String: AnyObject], let highDict = thumbnailsDict["high"] as? [String: AnyObject], let imageUrl = highDict["url"] as? String, let publishedAt = snippet["publishedAt"] as? String
            {
                let video = Article(title: title, url: "https://www.youtube.com/watch?v=" + videoId, imageUrl: imageUrl, dateString: publishedAt, author: "", isVideo: true)
                return video
            }
        }
        return nil
    }
    
    class func playListVideoFromItemJSON(item: [String: AnyObject]) -> Article? {
        if let snippet = item["snippet"] as? [String: AnyObject] {
            if let title = snippet["title"] as? String, let idDict = snippet["resourceId"] as? [String: AnyObject], let videoId = idDict["videoId"] as? String, let thumbnailsDict = snippet["thumbnails"] as? [String: AnyObject], let highDict = thumbnailsDict["high"] as? [String: AnyObject], let imageUrl = highDict["url"] as? String, let publishedAt = snippet["publishedAt"] as? String
            {
                let video = Article(title: title, url: "https://www.youtube.com/watch?v=" + videoId, imageUrl: imageUrl, dateString: publishedAt, author: "", isVideo: true)
                return video
            }
        }
        return nil
    }
    
    class func loadWordsOfWisdom(skip: Int) -> SignalProducer<Wisdom, NSError> {
        return SignalProducer { sink, disposable in
            print("API: [START] Load Wisdom")
            Alamofire.request(.GET, Constants.URLs.wordsOfWisdomUrl, parameters: ["alt": "json", "start-index": "\(skip)", "max-results": "20"])
                .responseJSON { response in
                    print("API: [END] Load Wisdom")
                    if let JSON = response.result.value as? [String: AnyObject], let feed = JSON["feed"] as? [String: AnyObject], let entries = feed["entry"] as? [[String: AnyObject]] {
                        for entry in entries {
                            print(entry)
                            if let contentDictionary = entry["content"] as? [String: AnyObject], let content = contentDictionary["$t"] as? String, let titleDictionary = entry["title"] as? [String: AnyObject], let title = titleDictionary["$t"] as? String, let publishedDictionary = entry["published"] as? [String: AnyObject], let dateString = publishedDictionary["$t"] as? String {
                                var link = ""
                                if let linkArray = entry["link"] as? [[String: AnyObject]] {
                                    linkArray.forEach { dictionary in
                                        if let typeString = dictionary["type"] as? String {
                                            if typeString == "text/html" {
                                                if let linkString = dictionary["href"] as? String { link = linkString }
                                            }
                                        }
                                    }
                                }
                                let strippedContent = FormattingHelper.stripHTML(content)                                
                                
                                sink.sendNext(Wisdom(quoteString: strippedContent, title: title, dateString: dateString, link: link))
                            }
                        }
                    }
                    sink.sendCompleted()
            }
        }
    }
    
    class func loadArticles(page: Int) -> SignalProducer<Article, NSError> {
        return SignalProducer { sink, disposable in
            print("API: [START] Load Articles page \(page)")
            Alamofire.request(.GET, Constants.URLs.feedUrl, parameters: ["paged": page])
                .response { (request, response, data, error) in
                    print("API: [END] Load Articles")
                    if let data = data {
                        let xml = SWXMLHash.parse(data)
                        for elem in xml["rss"]["channel"]["item"] {
                            if let article = articleFromItemXML(elem) { sink.sendNext(article) }
                        }
                    }
                    sink.sendCompleted()
            }
        }
    }
    
    class func loadVideos(pageToken: String) -> SignalProducer<Content, NSError> {
        return SignalProducer { sink, disposable in //
            var requestParams = ["order": "date", "part": "snippet", "channelId": Constants.URLs.youTubeChannelId, "maxResults": "50", "key": Constants.URLs.youTubeKey]
            if pageToken.characters.count > 0 { requestParams["pageToken"] = pageToken }
            print("API: [START] Load Videos")
            Alamofire.request(.GET, Constants.URLs.videosUrl, parameters: requestParams)
                .responseJSON { response in
                    print("API: [END] Load Videos")
                    if let JSON = response.result.value as? [String: AnyObject], let items = JSON["items"] as? [[String: AnyObject]] {
                        if let nextPageTokenString = JSON["nextPageToken"] as? String {
                            let nextPageToken = NextPageToken(token: nextPageTokenString)
                            sink.sendNext(nextPageToken)
                        }
                        for item in items {
                            if let video = API.videoFromItemJSON(item) { sink.sendNext(video) }
                        }
                    }
                    sink.sendCompleted()
            }
        }
    }
    
    class func loadPlaylistVideos(playlistId: String) -> SignalProducer<Content, NSError> {
        return SignalProducer { sink, disposable in //
            let requestParams = ["order": "date", "part": "snippet", "playlistId": playlistId, "maxResults": "50", "key": Constants.URLs.youTubeKey]
            print("API: [START] Load Playlist Videos")
            Alamofire.request(.GET, Constants.URLs.videoPlaylistUrl, parameters: requestParams)
                .responseJSON { response in
                    print("API: [END] Load Playlist Videos")
                    if let JSON = response.result.value as? [String: AnyObject], let items = JSON["items"] as? [[String: AnyObject]] {
                        if let nextPageTokenString = JSON["nextPageToken"] as? String {
                            let nextPageToken = NextPageToken(token: nextPageTokenString)
                            sink.sendNext(nextPageToken)
                        }
                        for item in items {
                            if let video = API.playListVideoFromItemJSON(item) {
                                sink.sendNext(video)
                            }
                        }
                    }
                    sink.sendCompleted()
            }
        }
    }
    
    class func loadPodcasts(page: Int, featured: Bool) -> SignalProducer<Podcast, NSError> {
        return SignalProducer { sink, disposable in
            print("API: [START] Load Podcasts (Featured: " + (featured ?  "YES " : "NO") + "\"")
            
            let url = featured ? Constants.URLs.featuredPodcastsUrl : Constants.URLs.podcastsUrl
            
            Alamofire.request(.GET, url, parameters: ["paged": page, "posts_per_page": "20"])
                .response { (request, response, data, error) in
                    print("API: [END] Load Podcasts")
                    if let data = data {
                        let xml = SWXMLHash.parse(data)
                        for elem in xml["rss"]["channel"]["item"] {
                            if let podcast = podcastFromItemXML(elem) { sink.sendNext(podcast) }
                        }
                    }
                    sink.sendCompleted()
            }
        }
    }
    
    class func loadCategoryItems(category: String, page: Int) -> SignalProducer<Content, NSError> {
        return SignalProducer { sink, disposable in
            print("API: [START] Load Category: " + category + " Page \(page)")
            Alamofire.request(.GET, Constants.URLs.feedUrl, parameters: ["paged": page, "tag": category])
                .response { (request, response, data, error) in
                    print("API: [END] Load Category: " + category)
                    if let data = data {
                        let xml = SWXMLHash.parse(data)
                        for elem in xml["rss"]["channel"]["item"] {
                            if let article = articleFromItemXML(elem) { sink.sendNext(article) }
                            if let podcast = podcastFromItemXML(elem) { sink.sendNext(podcast) }
                        }
                    }
                    sink.sendCompleted()
            }
        }
    }
}
