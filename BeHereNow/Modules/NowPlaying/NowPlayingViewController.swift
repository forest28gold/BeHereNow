//
//  NowPlayingViewController.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/8/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation

class NowPlayingViewController: UIViewController {
    let viewModel: NowPlayingViewModel
    let audioManager: AudioManager

    let articleImageView = UIImageView()
    let articleLabel = UILabel()
    let episodeLabel = UILabel()
    let descriptionTextView = UITextView()
    let progressView = UIProgressView()
    
    let playedTimeLabel = UILabel()
    let remainingTimeLabel = UILabel()
    
    let nextArrowButton = UIButton()
    let previousArrowButton = UIButton()
    
    let playPauseButton = UIButton()
    
    init(audioManager anAudioManager: AudioManager) {
        audioManager = anAudioManager
        viewModel = NowPlayingViewModel(podcastIndex: audioManager.currentPodcastIndex, podcast: audioManager.currentPodcast)
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Externals.tagAnalyticsScreen("Now Playing")
        
        view.backgroundColor = UIColor.bhnLightBlue()
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didTapCloseButton))
        swipeGestureRecognizer.direction = .Down
        view.addGestureRecognizer(swipeGestureRecognizer)
        
        let topView = NowPlayingTopView()
        view.addSubview(topView)
        topView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(66.0)
        }
        
        let closeButton = UIButton()
        closeButton.addTarget(self, action: #selector(NowPlayingViewController.didTapCloseButton), forControlEvents: .TouchUpInside)
        view.addSubview(closeButton)
        
        closeButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(66.0)
            make.left.equalTo(view)
        }
        
        articleImageView.contentMode = .ScaleAspectFill
        articleImageView.clipsToBounds = true
        articleImageView.userInteractionEnabled = true
        view.addSubview(articleImageView)
        
        articleImageView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(view)
            make.height.equalTo(190.0)
            make.top.equalTo(topView.snp_bottom)
        }
        
        playPauseButton.addTarget(self, action: #selector(NowPlayingViewController.didTapPlayPauseButton), forControlEvents: .TouchUpInside)
        updatePlayPauseButton()
        articleImageView.addSubview(playPauseButton)
        playPauseButton.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(75.0, 75.0))
            make.centerX.equalTo(articleImageView)
            make.top.equalTo(articleImageView).offset(31.0)
        }
        
        let rewindButton = UIButton()
        rewindButton.setImage(UIImage(named: "RewindIcon"), forState: .Normal)
        rewindButton.addTarget(self, action: #selector(NowPlayingViewController.didTapRewindButton), forControlEvents: .TouchUpInside)
        articleImageView.addSubview(rewindButton)
        rewindButton.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(34.0, 34.0))
            make.centerY.equalTo(playPauseButton)
            make.centerX.equalTo(playPauseButton).offset(-82.0)
        }
        
        let forwardButton = UIButton()
        forwardButton.setImage(UIImage(named: "ForwardIcon"), forState: .Normal)
        forwardButton.addTarget(self, action: #selector(NowPlayingViewController.didTapForwardButton), forControlEvents: .TouchUpInside)
        articleImageView.addSubview(forwardButton)
        forwardButton.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(34.0, 34.0))
            make.centerY.equalTo(playPauseButton)
            make.centerX.equalTo(playPauseButton).offset(82.0)
        }
        
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.bhnLightBlue()
        bottomView.alpha = 0.8
        articleImageView.addSubview(bottomView)
        
        bottomView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(articleImageView)
            make.height.equalTo(54.0)
            make.bottom.equalTo(articleImageView).offset(-8.0)
        }
        
        let shareButton = UIButton()
        shareButton.setImage(UIImage(named: "WordsSourceIcon"), forState: .Normal)
        shareButton.addTarget(self, action: #selector(NowPlayingViewController.didTapShareButton), forControlEvents: .TouchUpInside)
        bottomView.addSubview(shareButton)
        
        shareButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bottomView).offset(16.0)
            make.left.equalTo(bottomView).offset(15.0)
            make.size.equalTo(CGSizeMake(25.0, 25.0))
        }
        
        articleLabel.font = UIFont(name:"BentonSans-Regular", size: 17.0)
        articleLabel.textColor = UIColor.bhnTextDarkBlue()
        bottomView.addSubview(articleLabel)
        
        articleLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(shareButton.snp_right).offset(10.0)
            make.top.equalTo(shareButton).offset(-1.0)
            make.right.equalTo(bottomView).offset(-20.0)
        }
        
        episodeLabel.font = UIFont(name:"BentonSans-Book", size: 12.0)
        episodeLabel.textColor = UIColor.bhnTextDarkBlue()
        bottomView.addSubview(episodeLabel)
        
        episodeLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(shareButton.snp_right).offset(10.0)
            make.bottom.equalTo(shareButton).offset(2.0)
            make.right.equalTo(bottomView).offset(-20.0)
        }
        
        progressView.trackTintColor = UIColor.bhnProgressView()
        progressView.progressTintColor = UIColor.bhnDarkBlue()
        progressView.userInteractionEnabled = true
        articleImageView.addSubview(progressView)
        
        progressView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bottomView.snp_bottom)
            make.width.equalTo(articleImageView)
            make.left.equalTo(articleImageView)
            make.height.equalTo(8.0)
        }
        
        let progressViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(NowPlayingViewController.didTapSlider(_:)))
        progressView.addGestureRecognizer(progressViewTapRecognizer)
        
        let progressViewPanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(NowPlayingViewController.didPanSlider(_:)))
        progressView.addGestureRecognizer(progressViewPanRecognizer)
        
        playedTimeLabel.font = UIFont(name:"BentonSans-Book", size: 10.0)
        playedTimeLabel.textColor = UIColor.bhnTextDarkBlue()
        view.addSubview(playedTimeLabel)
        
        playedTimeLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view).offset(5.0)
            make.top.equalTo(progressView.snp_bottom).offset(5.0)
        }
        
        remainingTimeLabel.font = UIFont(name:"BentonSans-Book", size: 10.0)
        remainingTimeLabel.textColor = UIColor.bhnTextDarkBlue()
        view.addSubview(remainingTimeLabel)
        
        remainingTimeLabel.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(view).offset(-5.0)
            make.top.equalTo(progressView.snp_bottom).offset(5.0)
        }
        
        descriptionTextView.font = UIFont(name:"BentonSans-Regular", size: 13.0)
        descriptionTextView.backgroundColor = UIColor.clearColor()
        descriptionTextView.textColor = UIColor.bhnTextDarkBlue()
        descriptionTextView.editable = false
        view.addSubview(descriptionTextView)
        
        descriptionTextView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view).offset(23.0)
            make.right.equalTo(view).offset(-23.0)
            make.top.equalTo(bottomView.snp_bottom).offset(33.0)
            make.bottom.equalTo(view).offset(-55.0)
        }
        
        nextArrowButton.addTarget(self, action: #selector(NowPlayingViewController.didTapNextButton), forControlEvents: .TouchUpInside)
        nextArrowButton.setImage(UIImage(named: "NextPodcastArrow"), forState: .Normal)
        view.addSubview(nextArrowButton)
        
        nextArrowButton.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(view).offset(-15.0)
            make.right.equalTo(view).offset(-30.0)
            make.size.equalTo(CGSizeMake(15.0, 19.0))
        }
        
        previousArrowButton.addTarget(self, action: #selector(NowPlayingViewController.didTapPreviousButton), forControlEvents: .TouchUpInside)
        previousArrowButton.setImage(UIImage(named: "PreviousPodcastArrow"), forState: .Normal)
        view.addSubview(previousArrowButton)
        
        previousArrowButton.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(view).offset(-15.0)
            make.left.equalTo(view).offset(30.0)
            make.size.equalTo(CGSizeMake(15.0, 19.0))
        }
        
        updateView()
        syncScrubber()
        
        let _ = audioManager.player.addPeriodicTimeObserverForInterval(CMTimeMakeWithSeconds(1, 1), queue: dispatch_get_main_queue()) { (CMTime) -> Void in
            self.syncScrubber()
        }
    }
    
    func updatePlayPauseButton() {
        if audioManager.isPlaying() {
            playPauseButton.setImage(UIImage(named: "PauseButton"), forState: .Normal)
        } else {
            playPauseButton.setImage(UIImage(named: "VideoPlayArrow"), forState: .Normal)
        }
    }
    
    func syncScrubber() {
        updatePlayPauseButton()
        
        let playedTime = audioManager.currentEpisodePlayedTime()
        let totalTime = audioManager.currentEpisodeDuration()

        let remainingTimeTotal = totalTime.total - playedTime.total
        let remainingMinutes = Int(remainingTimeTotal / 60)
        let remainingSeconds = Int(remainingTimeTotal % 60)
        
        let playedTimeText = String(format: "%02d:%02d", playedTime.minutes, playedTime.seconds)
        let remainingTimeText = String(format: "%02d:%02d", remainingMinutes, remainingSeconds)
        
        playedTimeLabel.text = playedTimeText
        remainingTimeLabel.text = remainingTimeText
        
        if totalTime.total > 0 {
            progressView.progress = Float(playedTime.total / totalTime.total)
        }
    }
    
    func didTapSlider(tapGestureRecognizer: UITapGestureRecognizer) {
        let location = tapGestureRecognizer.locationInView(progressView)
        let percent = location.x/progressView.frame.size.width
        progressView.progress = Float(percent)
        audioManager.skipToPercent(Double(percent))
        syncScrubber()
    }
    
    func didPanSlider(panGestureRecognizer: UIPanGestureRecognizer) {
        let location = panGestureRecognizer.locationInView(progressView)
        let percent = location.x/progressView.frame.size.width
        progressView.progress = Float(percent)
        
        if panGestureRecognizer.state == .Ended {
            audioManager.skipToPercent(Double(percent))
            syncScrubber()
        }
    }

    func didTapRewindButton() {
        audioManager.skipBackward()
    }
    
    func didTapForwardButton() {
        audioManager.skipFoward()
    }
    
    func didTapPlayPauseButton() {
        audioManager.playPause()
        
    }
    
    func didTapCloseButton() {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didTapNextButton() {
        audioManager.playNextTrack()
        viewModel.switchToNextPodcast()
        updateView()
        syncScrubber()
    }
    
    func didTapPreviousButton() {
        audioManager.playPreviousTrack()
        viewModel.switchToPreviousPodcast()
        updateView()
        syncScrubber()
        
        if viewModel.isFirstPodcast() {
            viewModel.loadPodcasts().observeCompleted({ () -> () in
                self.updateView()
            })
        }
    }
    
    func didTapShareButton() {
        Externals.tagAnalyticsEvent("Share - Podcast", attributes: nil)

        let shareString = "Be Here Now Podcast Ep " + viewModel.currentPodcast.episodeNumberString + ": " + viewModel.currentPodcast.title
        if let url = NSURL(string: viewModel.currentPodcast.url) {
            let activityViewController = UIActivityViewController(activityItems: [shareString, url], applicationActivities: nil)
            presentViewController(activityViewController, animated: true) { }
        }
    }
    
    func updateView() {
        articleImageView.image = nil
        if let podcastImageUrl = viewModel.podcastImageUrl() {
            articleImageView.af_setImageWithURL(podcastImageUrl)
        }
        articleLabel.text = viewModel.podcastTitle()
        episodeLabel.text = viewModel.episodeString()
        descriptionTextView.text = viewModel.podcastDescription()
        nextArrowButton.alpha = viewModel.isLastPodcast() ? 0.3 : 1.0
        nextArrowButton.enabled = !viewModel.isLastPodcast()
        previousArrowButton.alpha = viewModel.isFirstPodcast() ? 0.3 : 1.0
        previousArrowButton.enabled = !viewModel.isFirstPodcast()
    }
}
