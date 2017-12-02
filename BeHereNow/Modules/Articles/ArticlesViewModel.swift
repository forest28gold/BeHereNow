//
//  ArticlesViewModel.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/4/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import ReactiveCocoa

enum ArticleType {
    case Article
    case Video
}

class ArticlesViewModel {
    let articleType: ArticleType
    
    init (articleType anArticleType: ArticleType) {
        articleType = anArticleType
    }
    
    func didDeleteDonations() -> Bool { return ContentCache.sharedInstance.didDeleteDonations }

    func isLoading() -> Bool {
        switch articleType {
        case .Article: return ContentCache.sharedInstance.isLoadingArticles
        case .Video: return ContentCache.sharedInstance.isLoadingVideos
        }
    }
    
    func didLoadAll() -> Bool {
        switch articleType {
        case .Article: return ContentCache.sharedInstance.didLoadAllArticles
        case .Video: return ContentCache.sharedInstance.didLoadAllVideos
        }
    }
    
    
    func loadArticles() -> Signal<String, NSError> {
        switch articleType {
        case .Article:
            if let signal = ContentCache.sharedInstance.articleSignal {
                return signal
            } else {
                return ContentCache.sharedInstance.loadArticles()
            }
        case .Video:
            if let signal = ContentCache.sharedInstance.videoSignal {
                return signal
            } else {
                return ContentCache.sharedInstance.loadVideos(nil)
            }
        }
    }
    
    
    func didCompleteInitialLoad() -> Bool {
        switch articleType {
        case .Article:
            return ContentCache.sharedInstance.articles.count > 0
        case .Video:
            return ContentCache.sharedInstance.videos.count > 0
        }
    }
    
    func numberOfRows() -> Int {
        switch articleType {
        case .Article:
            return ContentCache.sharedInstance.articles.count + (didDeleteDonations() ? 0 : 1)
        case .Video:
            return ContentCache.sharedInstance.videos.count + (didDeleteDonations() ? 0 : 1)
        }
    }
    
    func articleForRow(row: Int) -> Article {
        switch articleType {
        case .Article:
            return ContentCache.sharedInstance.articles[row - (didDeleteDonations() ? 0 : 1)]
        case .Video:
            return ContentCache.sharedInstance.videos[row - (didDeleteDonations() ? 0 : 1)]
        }
    }
    
    func placeholderImageForRow(row: Int) -> UIImage? {
        switch row % 3 {
        case 0: return UIImage(named: "PlaceholderBlue")
        case 1: return UIImage(named: "PlaceholderGreen")
        case 2: return UIImage(named: "PlaceholderOrange")
        default: return nil
        }
    }
}
