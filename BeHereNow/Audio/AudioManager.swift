//
//  AudioManager.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/9/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation
import MediaPlayer
import ReactiveCocoa

class AudioManager: NSObject {
    var currentPodcastIndex = 0
    var currentPodcast: Podcast?
    
    var player = AVPlayer()
    
    let signal: Signal<String, NoError>
    let sink: Observer<String, NoError>
    
    var didActiveSession = false
    
    private var myContext = 0
    
    override init () {
        (signal, sink) = Signal<String, NoError>.pipe()
    }
    
    func activeSession() {
        didActiveSession = true
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
                print("AVAudioSession is Active")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func setupNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AudioManager.itemDidFinishPlaying(_:)), name:AVPlayerItemDidPlayToEndTimeNotification, object: nil)
        
        let skipForwardCommand = MPRemoteCommandCenter.sharedCommandCenter().skipForwardCommand
        skipForwardCommand.enabled = true
        skipForwardCommand.preferredIntervals = [15]
        skipForwardCommand.addTarget(self, action: #selector(AudioManager.skipFoward))

        let skipBackwardCommand = MPRemoteCommandCenter.sharedCommandCenter().skipBackwardCommand
        skipBackwardCommand.enabled = true
        skipBackwardCommand.preferredIntervals = [15]
        skipBackwardCommand.addTarget(self, action: #selector(AudioManager.skipBackward))
        
        MPRemoteCommandCenter.sharedCommandCenter().pauseCommand.addTarget(self, action: #selector(AudioManager.playPause))
        MPRemoteCommandCenter.sharedCommandCenter().playCommand.addTarget(self, action: #selector(AudioManager.playPause))
    }
    
    func playPodcastAtIndex(podcastIndex: Int) {
        if !didActiveSession { activeSession() }
        
        currentPodcastIndex = podcastIndex
        currentPodcast = ContentCache.sharedInstance.podcasts[podcastIndex]
        playSelectedPodcast()
    }
    
    func playPodcast(podcast: Podcast) {
        if !didActiveSession { activeSession() }
        
        currentPodcastIndex = -1
        currentPodcast = podcast
        playSelectedPodcast()
    }


    func playSelectedPodcast() {
        if let currentPodcast = currentPodcast, url = NSURL(string: currentPodcast.url) {
            let songInfo = [
                MPMediaItemPropertyTitle: currentPodcast.title,
                MPMediaItemPropertyArtist: "Ram Dass Here and Now"
            ]
            MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = songInfo
            NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    let albumArt = MPMediaItemArtwork(image: image)
                    let songInfo = [
                        MPMediaItemPropertyTitle: currentPodcast.title,
                        MPMediaItemPropertyArtist: "Ram Dass Here and Now",
                        MPMediaItemPropertyArtwork: albumArt
                    ]
                    MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = songInfo
                }
            }.resume()

            if let _ = player.currentItem {
                player.pause()
                player.seekToTime(CMTimeMake(0, 60))
                
                let asset = AVURLAsset(URL: url, options: nil)
                let keys = ["playable"]
                let playerItem = ObservedPlayerItem(asset: asset, observer: self, context: &myContext)
                
                asset.loadValuesAsynchronouslyForKeys(keys) { () -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.player.replaceCurrentItemWithPlayerItem(playerItem)
                        self.player.play()
                    })
                }
            } else {
                player = AVPlayer(URL: url)
                player.play()
                let _ = player.addPeriodicTimeObserverForInterval(CMTimeMakeWithSeconds(1, 1), queue: dispatch_get_main_queue()) { (CMTime) -> Void in
                    self.updateMediaCenter()
                }
            }
        }
    }

    func itemDidFinishPlaying(notification: NSNotification) {
        playNextTrack()
    }

    func playNextTrack() {
        if currentPodcastIndex == 0 { return }
        playPodcastAtIndex(currentPodcastIndex - 1)
    }
    
    func playPreviousTrack() {
        if currentPodcastIndex == ContentCache.sharedInstance.podcasts.count - 1 { return }
        playPodcastAtIndex(currentPodcastIndex + 1)
    }
    
    func skipFoward() {
        let targetTime = CMTimeMakeWithSeconds(player.currentTime().seconds + 15.0, 60)
        player.seekToTime(targetTime)
    }
    
    func skipBackward() {
        let targetTime = CMTimeMakeWithSeconds(player.currentTime().seconds - 15.0, 60)
        player.seekToTime(targetTime)
    }
    
    func skipToPercent(percent: Double) {
        if let currentItem = player.currentItem {
            let targetTime = CMTimeMakeWithSeconds(currentItem.duration.seconds*percent, 60)
            player.seekToTime(targetTime)
        }
    }
    
    func playPause() {
        if isPlaying() {
            player.pause()
        } else {            
            player.play()
        }
    }
    
    func isPlaying() -> Bool {
        return player.rate != 0.0
    }
    
    func updateMediaCenter() {
        if let currentPodcast = currentPodcast, let currentItem = player.currentItem {
            let songInfo: [String: NSObject] = [
                MPMediaItemPropertyTitle: currentPodcast.title,
                MPMediaItemPropertyArtist: "Ram Dass Here and Now",
                MPNowPlayingInfoPropertyPlaybackRate: player.rate,
                MPMediaItemPropertyPlaybackDuration: CMTimeGetSeconds(currentItem.duration),
                MPNowPlayingInfoPropertyElapsedPlaybackTime: CMTimeGetSeconds(currentItem.currentTime())
            ]
            MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = songInfo
        }
    }
    
    func currentEpisodeDuration() -> (minutes: Int, seconds: Int, total: Double) {
        if let currentItem = player.currentItem {
            let duration = CMTimeGetSeconds(currentItem.duration)
            if (duration.isNaN) {
                return (0, 0, 0)
            }
            
            let totalMinutes = Int(duration / 60)
            let totalSeconds = Int(duration % 60)
            
            return (totalMinutes, totalSeconds, duration)
        }
        return (0, 0, 0)
    }
    
    func currentEpisodePlayedTime() -> (minutes: Int, seconds: Int, total: Double) {
        if let currentItem = player.currentItem {
            let duration = CMTimeGetSeconds(currentItem.duration)
            if (duration.isNaN) {
                return (0, 0, 0)
            }
            
            let currentTime = CMTimeGetSeconds(player.currentTime())
            
            let playedMinutes = Int(currentTime / 60)
            let playedSeconds = Int(currentTime % 60)
            
            return (playedMinutes, playedSeconds, currentTime)
        } else {
            return (0, 0, 0)
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &myContext {
            if let player = object as? AVPlayer {
                switch (player.status) {
                case .ReadyToPlay: playbackDidStart()
                case .Failed: playbackDidFail()
                default: break
                }
            }
            if let playerItem = object as? AVPlayerItem {
                switch playerItem.status {
                case .ReadyToPlay: playbackDidStart()
                case .Failed: playbackDidFail()
                default: break
                }
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func playbackDidStart() {
        sink.sendNext("playbackDidStart")
    }
    
    func playbackDidFail() {
        sink.sendNext("playbackDidFail")
    }

    deinit {
        player.removeObserver(self, forKeyPath: "status", context: &myContext)
        if let item = player.currentItem {
            item.removeObserver(self, forKeyPath: "status", context: &myContext)
        }
    }
}
