//
//  PodcastViewModel.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/7/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import ReactiveCocoa

class PodcastViewModel {
    func loadPodcasts() -> Signal<String, NSError> {
        if let signal = ContentCache.sharedInstance.podcastSignal {
            return signal
        } else {
            return ContentCache.sharedInstance.loadPodcasts()
        }
    }
    
    func loadFeaturedPodcasts() -> Signal<String, NSError> {
        if let signal = ContentCache.sharedInstance.featuredPodcastSignal {
            return signal
        } else {
            return ContentCache.sharedInstance.loadFeaturedPodcasts()
        }
    }
    
    func didCompleteInitialLoad() -> Bool {
        return ContentCache.sharedInstance.podcasts.count > 0
    }
    
    func didCompleteInitialFeaturedLoad() -> Bool {
        return ContentCache.sharedInstance.featuredPodcasts.count > 0
    }
    
    func numberOfRows() -> Int {
        return ContentCache.sharedInstance.podcasts.count
    }
    
    func podcastForRow(row: Int) -> Podcast {
        return ContentCache.sharedInstance.podcasts[row]
    }
    
    func featuredPocastForRow(row: Int) -> Podcast {
        return ContentCache.sharedInstance.featuredPodcasts[row]
    }
    
    func placeholderImageForRow(row: Int) -> UIImage? {
        switch row % 3 {
        case 0: return UIImage(named: "PodcastPlaceholderBlue")
        case 1: return UIImage(named: "PodcastPlaceholderGreen")
        case 2: return UIImage(named: "PodcastPlaceholderOrange")
        default: return nil
        }
    }
    
    func numberOfFeaturesPodcasts() -> Int {
        return ContentCache.sharedInstance.featuredPodcasts.count
    }
    
    func isLoading() -> Bool {
        return ContentCache.sharedInstance.isLoadingPodcasts
    }
    
    func didLoadAll() -> Bool {
        return ContentCache.sharedInstance.didLoadAllPodcasts
    }
    
    func isLoadingFeatured() -> Bool {
        return ContentCache.sharedInstance.isLoadingFeaturedPodcasts
    }
    
    func didLoadAllFeatured() -> Bool {
        return ContentCache.sharedInstance.didLoadAllFeaturedPodcasts
    }
}
