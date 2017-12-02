//
//  PodcastViewController.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/7/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit
import SnapKit

protocol PodcastViewControllerDelegate {
    func podcastViewControllerDidSelectPodcastAtIndex(podcastViewController: PodcastViewController, index: Int)
    func podcastViewControllerDidSelectPodcast(podcastViewController: PodcastViewController, podcast: Podcast)
}

class PodcastViewController: UIViewController {
    var delegate: PodcastViewControllerDelegate?
    
    let viewModel = PodcastViewModel()
    
    let tableView = UITableView()
    var podcastTopView: PodcastsTopView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Externals.tagAnalyticsScreen("Podcasts")

        view.backgroundColor = UIColor.bhnPodcastBlue()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorColor = UIColor.whiteColor()
        tableView.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        tableView.registerClass(PodcastTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        
        tableView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(view)
            make.center.equalTo(view)
        }
        
        podcastTopView = PodcastsTopView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 60.0 + view.bounds.size.width/2), viewModel: viewModel)
        podcastTopView.delegate = self
        tableView.tableHeaderView = podcastTopView
                
        if !viewModel.didCompleteInitialLoad() {
            loadNextPodcastsPage()
        }
        
        if !viewModel.didCompleteInitialFeaturedLoad() {
            loadNextFeaturedPocastsPage()
        }
        
        let topWhiteLine = UIView()
        topWhiteLine.backgroundColor = UIColor.whiteColor()
        view.addSubview(topWhiteLine)
        topWhiteLine.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(0.5)
        }
        
        let bottomWhiteLine = UIView()
        bottomWhiteLine.backgroundColor = UIColor.whiteColor()
        view.addSubview(bottomWhiteLine)
        bottomWhiteLine.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(view)
            make.left.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(0.5)
        }
    }
    
    func loadNextPodcastsPage() {
        viewModel.loadPodcasts().observeCompleted { () -> () in
            self.tableView.reloadData()
        }
    }
    
    func loadNextFeaturedPocastsPage() {
        viewModel.loadFeaturedPodcasts().observeCompleted { () -> () in
            self.podcastTopView.collectionView.reloadData()
        }
    }
}

extension PodcastViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PodcastTableViewCell
        cell.configureForPodcast(viewModel.podcastForRow(indexPath.row))
        return cell
    }
}


extension PodcastViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let delegate = delegate {
            delegate.podcastViewControllerDidSelectPodcastAtIndex(self, index: indexPath.row)
            Externals.tagAnalyticsEvent("Podcast Listen", attributes: nil)
        }
    }
}

extension PodcastViewController: PodcastsTopViewDelegate {
    func podcastsTopViewDidSelectIndex(podcastsTopView: PodcastsTopView, index: Int) {
        if let delegate = delegate {
            let podcast = viewModel.featuredPocastForRow(index)
            delegate.podcastViewControllerDidSelectPodcast(self, podcast: podcast)
            Externals.tagAnalyticsEvent("Podcast Listen", attributes: nil)
        }
    }
    
    func podcastsTopViewDidScrollToEnd(podcastsTopView: PodcastsTopView) {
        loadNextFeaturedPocastsPage()
    }

}

extension PodcastViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if viewModel.isLoading() || viewModel.didLoadAll() { return }
        
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let contentSize = scrollView.contentSize
        let inset = scrollView.contentInset;
        let y = offset.y + bounds.size.height - inset.bottom
        let h = contentSize.height
        
        let reload_distance: CGFloat = 20.0
        if( y > h + reload_distance) {
            loadNextPodcastsPage()
        }
    }
}
