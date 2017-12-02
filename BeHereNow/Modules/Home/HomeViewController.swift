//
//  HomeViewController.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 1/24/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    let viewModel = HomeViewModel()
    
    let homeBackgroundView = HomeBackgroundView()
    let homeView = HomeView()
    let bottomMenuView = BottomMenuView()
    let topMenuView = TopMenuView(frame: CGRectZero, withCloseButton: false)
    let audioManager = AudioManager()
    var containedViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioManager.setupNotifications()
        
        view.addSubview(homeBackgroundView)
        homeBackgroundView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(view)
            make.center.equalTo(view)
        }
        
        homeView.delegate = self
        homeView.alpha = 0.0
        view.addSubview(homeView)
        
        homeView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(view)
            make.center.equalTo(view)
        }
        
        view.addSubview(bottomMenuView)
        bottomMenuView.alpha = 0.0
        bottomMenuView.delegate = self
        bottomMenuView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view.snp_bottom).offset(-65.0)
            make.bottom.equalTo(view)
            make.width.equalTo(view)
        }
        
        view.addSubview(topMenuView)
        topMenuView.delegate = self
        topMenuView.alpha = 0.0
        topMenuView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view)
            make.height.equalTo(65.0)
            make.left.equalTo(view)
            make.width.equalTo(view)
        }
        
        presentIntro()
    }

    func presentCachedPushNotification() {
        ContentCache.sharedInstance.initialPushShown = true

        if let pushType = ContentCache.sharedInstance.pushType {
            let extraParam = ContentCache.sharedInstance.extraParam

            ContentCache.sharedInstance.pushType = nil
            ContentCache.sharedInstance.extraParam = nil
            
            if let _ = viewModel.latestContentForType(pushType) {
                presentPushViewForType(pushType, extraParam: extraParam)
            } else {
                viewModel.loadSignal(pushType).observeCompleted({ () -> () in
                    self.presentPushViewForType(pushType, extraParam: extraParam)
                })
            }
        }
    }
    
    func presentIntro() {
        let introImageView = UIImageView(frame: view.bounds)
        introImageView.contentMode = .ScaleAspectFill
        introImageView.image = introImage()
        view.addSubview(introImageView)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let secondImageView = UIImageView(frame: self.view.bounds)
                secondImageView.contentMode = .ScaleAspectFill
                secondImageView.image = UIImage(named: "IntroScreen")
                self.view.insertSubview(secondImageView, belowSubview: introImageView)
                UIView.animateWithDuration(2.0, animations: { () -> Void in
                    introImageView.alpha = 0.0
                    }) { (Bool) in
                        UIView.animateWithDuration(2.0, animations: { () -> Void in
                            secondImageView.alpha = 0.0
                            }) { (Bool) in
                                UIView.animateWithDuration(2.0, animations: { () -> Void in
                                    self.homeView.alpha = 1.0
                                    }) { (Bool) in
                                        self.presentCachedPushNotification()
                                        Externals.registerForPush()
                                }
                        }
                }
            })
        }
    }
    
    func introImage() -> UIImage? {
        if DeviceType.IS_IPHONE_6P { return UIImage(named: "LaunchImage-800-Portrait-736h@3x") }
        if DeviceType.IS_IPHONE_6 { return UIImage(named: "LaunchImage-800-667h@2x") }
        if DeviceType.IS_IPHONE_5 { return UIImage(named: "LaunchImage-700-568h@2x.png") }
        return UIImage(named: "LaunchImage-700@2x.png")
    }
    
    func presentPushViewForType(contentType: Section, extraParam: String?) {
        var article: Article?
        if contentType == .Videos { article = viewModel.videoForParamOrLatest(extraParam) }
        if contentType == .Articles { article = viewModel.articleForParamOrLatest(extraParam) }
        let podcastIndex = viewModel.podcastIndexForParamOrLatest(extraParam)
        
        let pushView = PushView(frame: CGRectZero, contentType: contentType, wisdom: viewModel.latestWisdom(), podcastIndex: podcastIndex, article: article)
        pushView.delegate = self
        pushView.alpha = 0.0
        view.addSubview(pushView)
        pushView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(view)
            make.center.equalTo(view)
        }
        UIView.animateWithDuration(0.5) { () -> Void in
            pushView.alpha = 1.0
        }
    }

    func presentFullScreenViewController(viewController: UIViewController) {
        addChildViewController(viewController)
        viewController.view.frame = view.bounds
        viewController.view.alpha = 0.0
        view.addSubview(viewController.view)
        UIView.animateWithDuration(0.5) { () -> Void in
            viewController.view.alpha = 1.0
        }
        viewController.didMoveToParentViewController(self)
    }
    
    func presentPartialScreenViewController(viewController: UIViewController) {
        addChildViewController(viewController)
        if let containedViewController = containedViewController {
            view.insertSubview(viewController.view, belowSubview: containedViewController.view)
        } else {
            viewController.view.alpha = 0.0
            view.addSubview(viewController.view)
        }
        
        let previousViewController = containedViewController
        containedViewController = viewController
        
        viewController.view.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view).offset(65.0)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view).offset(-65.0)
        }
        
        viewController.didMoveToParentViewController(self)

        UIView.animateWithDuration(0.5) { () -> Void in
            viewController.view.alpha = 1.0
            self.bottomMenuView.alpha = 1.0
            self.topMenuView.alpha = 1.0
        }
        if let previousViewController = previousViewController {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                previousViewController.view.alpha = 0.0
                }, completion: { (Bool) -> Void in
                    previousViewController.willMoveToParentViewController(nil)
                    previousViewController.view.removeFromSuperview()
                    previousViewController.removeFromParentViewController()
            })
        } else {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.homeView.updateViews(true)
            })
        }
    }
    
    func hideContainedViewController() {
        if let containedViewController = containedViewController {
            containedViewController.willMoveToParentViewController(nil)
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                containedViewController.view.alpha = 0.0
                }, completion: { (Bool) -> Void in
                    containedViewController.willMoveToParentViewController(nil)
                    containedViewController.view.removeFromSuperview()
                    containedViewController.removeFromParentViewController()
                    self.containedViewController = nil
            })
        }
    }
    
    func presentViewForSection(section: Section) {
        if (bottomMenuView.alpha == 0.0) {
            bottomMenuView.updateSelectedTab(section.rawValue)
        }
        
        switch (section) {
        case .Wisdom: presentPartialScreenViewController(WordsViewController())
        case .Articles: presentPartialScreenViewController(ArticlesViewController(articleType: .Article))
        case .Videos: presentPartialScreenViewController(ArticlesViewController(articleType: .Video))
        case .Podcasts:
            let podcastViewController = PodcastViewController()
            podcastViewController.delegate = self
            presentPartialScreenViewController(podcastViewController)
        }
    }
    
    func presentNowPlayingViewController() {
        if isNowPlayingEnabled() {
            presentViewController(NowPlayingViewController(audioManager: audioManager), animated: true, completion: nil)
        }
    }
    
    func presentMenu() {
        let menuViewController = MenuViewController()
        menuViewController.delegate = self
        presentFullScreenViewController(menuViewController)
    }
    
    func presentSearchViewController() {
        let searchViewController = SearchViewController()
        searchViewController.delegate = self
        presentFullScreenViewController(searchViewController)
    }
}


extension HomeViewController: PodcastViewControllerDelegate {
    func podcastViewControllerDidSelectPodcastAtIndex(podcastViewController: PodcastViewController, index: Int) {
        audioManager.playPodcastAtIndex(index)
        presentNowPlayingViewController()
    }
    
    func podcastViewControllerDidSelectPodcast(podcastViewController: PodcastViewController, podcast: Podcast) {
        audioManager.playPodcast(podcast)
        presentNowPlayingViewController()
    }
}

extension HomeViewController: HomeViewDelegate {
    func homeViewDidSelectSection(homeView: HomeView, section: Section) {
        presentViewForSection(section)
    }
    
    func homeViewMenuButtonWasTapped(homeView: HomeView) {
        presentSearchViewController()
    }
    
    func homeViewThreeDotMenuButtonWasTapped(homeView: HomeView) {
        presentMenu()
    }
}

extension HomeViewController: MenuViewControllerDelegate {
    func menuViewControllerDidTapNowPlaying(menuViewController: MenuViewController) {
        presentNowPlayingViewController()
    }

    func isNowPlayingEnabled() -> Bool {
        if let _ = audioManager.currentPodcast {
            return true
        } else {
            return false
        }
    }
}

extension HomeViewController: BottomMenuDelegate {
    func bottomMenuDidSelectSection(bottomMenu: BottomMenuView, section: Section) {
        presentViewForSection(section)
    }
    
    func bottomMenuThreeDotsIconWasTapped(bottomMenu: BottomMenuView) {
        presentMenu()
    }
}

extension HomeViewController: TopMenuDelegate {
    func topMenuDidTapMenuButton(topMenu: TopMenuView) {
        presentSearchViewController()
    }
    
    func topMenuDidTapCloseSearchButton(topMenu: TopMenuView) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func topMenuDidSwipeDown(topMenu: TopMenuView) {
        hideContainedViewController()
        homeView.updateViews(false)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.bottomMenuView.alpha = 0.0
            self.topMenuView.alpha = 0.0
            }) { (Bool) -> Void in
                
        }
        
    }
}

extension HomeViewController: PushViewDelegate {
    func pushViewShouldPresentActivityViewControllerWithItems(pushView: PushView, activityItems: [AnyObject]) {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        presentViewController(activityViewController, animated: true) { }
    }
    
    func pushViewShouldPresentArticle(pushView: PushView, article: Article) {
        let articleViewController = WebViewController(url: article.url)
        navigationController?.pushViewController(articleViewController, animated: true)
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            pushView.alpha = 0.0
            }) { (Bool) in
                pushView.removeFromSuperview()
        }
    }
    
    func pushViewShouldPresentPodcast(pushView: PushView, podcastIndex: Int) {
        self.audioManager.playPodcastAtIndex(podcastIndex)
        self.presentNowPlayingViewController()
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            pushView.alpha = 0.0
            }) { (Bool) in
                pushView.removeFromSuperview()
        }
    }
}

extension HomeViewController: SearchViewDelegate {
    func searchViewControllerShouldPresentPodcast(searchViewController: SearchViewController, podcast: Podcast) {
        self.audioManager.playPodcast(podcast)
        self.presentNowPlayingViewController()
    }

    func searchViewControllerShouldPresentArticle(searchViewController: SearchViewController, article: Article) {
        let articleViewController = WebViewController(url: article.url)
        navigationController?.pushViewController(articleViewController, animated: true)
    }
}
