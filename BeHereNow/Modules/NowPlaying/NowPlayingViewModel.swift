//
//  NowPlayingViewModel.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/8/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import ReactiveCocoa

class NowPlayingViewModel {
    var currentPodcast: Podcast
    var currentPodcastIndex: Int
    
    init(podcastIndex: Int, podcast: Podcast?) {
        currentPodcastIndex = podcastIndex
        if let podcast = podcast {
            currentPodcast = podcast
        } else {
            currentPodcast = Podcast(title: "", url: "", imageUrl: "", dateString: "", duration: "", description: "")
        }
    }
    
    func loadPodcasts() -> Signal<String, NSError> {
        if let signal = ContentCache.sharedInstance.podcastSignal {
            return signal
        } else {
            return ContentCache.sharedInstance.loadPodcasts()
        }
    }
    
    func setCurrentPodcast() {
        currentPodcast = ContentCache.sharedInstance.podcasts[currentPodcastIndex]
    }
    
    func switchToNextPodcast() {
        if isLastPodcast() { return }
        
        currentPodcastIndex -= 1
        setCurrentPodcast()
    }
    
    func switchToPreviousPodcast() {
        if isFirstPodcast() { return }
        
        currentPodcastIndex += 1
        setCurrentPodcast()
    }
    
    func podcastTitle() -> String {
        return currentPodcast.title
    }
    
    func episodeString() -> String {
        return "Episode " + currentPodcast.episodeNumberString
    }
    
    func podcastImageUrl() -> NSURL? {
        return NSURL(string: currentPodcast.imageUrl)
    }
    
    func podcastDescription() -> String {
        return currentPodcast.description
    }
    
    func isFirstPodcast() -> Bool {
        return (currentPodcastIndex == ContentCache.sharedInstance.podcasts.count - 1)
    }
    
    func isLastPodcast() -> Bool {
        return ( currentPodcastIndex == 0 || currentPodcastIndex == -1)
    }
}
