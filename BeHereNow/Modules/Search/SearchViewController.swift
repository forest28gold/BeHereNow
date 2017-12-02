//
//  SearchViewController.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/25/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit

protocol SearchViewDelegate {
    func searchViewControllerShouldPresentPodcast(searchViewController: SearchViewController, podcast: Podcast)
    func searchViewControllerShouldPresentArticle(searchViewController: SearchViewController, article: Article)
}


class SearchViewController: UIViewController {
    var delegate: SearchViewDelegate?
    
    let viewModel = SearchViewModel()
    let topicsTableView = UITableView()
    let resultsTableView = UITableView()
    var visualEffectView: UIVisualEffectView?
    let topMenuView = TopMenuView(frame: CGRectZero, withCloseButton: true)
    let loadingLabel = UILabel()
    
    let searchLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                    
        Externals.tagAnalyticsScreen("Search")
        
        topMenuView.delegate = self
        view.addSubview(topMenuView)
        
        topMenuView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view)
            make.height.equalTo(67.0)
            make.centerX.equalTo(view)
            make.width.equalTo(view)
        }
        
        let mainView = UIView()
        mainView.backgroundColor = UIColor.bhnSearchBlue()
        view.addSubview(mainView)

        mainView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view).offset(67.0)
            make.bottom.equalTo(view)
            make.width.equalTo(view)
        }
        
        searchLabel.text = "SEARCH"
        searchLabel.font = UIFont(name: "Didot-Bold", size: 25.0)
        searchLabel.textAlignment = .Center
        searchLabel.textColor = UIColor.bhnSearchTitleBlue()
        mainView.addSubview(searchLabel)
        
        searchLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(mainView)
            make.top.equalTo(mainView).offset(4.0)
        }
        
        let storeLabel = UILabel()
        storeLabel.text = "STORE"
        storeLabel.font = UIFont(name: "Didot-Bold", size: 25.0)
        storeLabel.textAlignment = .Center
        storeLabel.textColor = UIColor.bhnSearchTitleBlue()
        mainView.addSubview(storeLabel)
        
        storeLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(mainView)
            make.bottom.equalTo(mainView).offset(-60.0)
        }
        
        topicsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        topicsTableView.dataSource = self
        topicsTableView.delegate = self
        topicsTableView.separatorStyle = .None
        topicsTableView.backgroundColor = UIColor.bhnTopicBlue()
        topicsTableView.showsVerticalScrollIndicator = false
        mainView.addSubview(topicsTableView)
        
        topicsTableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(searchLabel.snp_bottom).offset(10.0)
            make.left.equalTo(view).offset(15.0)
            make.right.equalTo(view).offset(-15.0)
            make.bottom.equalTo(storeLabel.snp_top).offset(-90.0)
        }
        
        let tableOverlayView = UIView()
        tableOverlayView.backgroundColor = UIColor.bhnTopicBlue().colorWithAlphaComponent(0.8)
        tableOverlayView.userInteractionEnabled = false
        mainView.addSubview(tableOverlayView)
        
        tableOverlayView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(topicsTableView)
            make.centerX.equalTo(topicsTableView)
            make.bottom.equalTo(topicsTableView)
            make.top.equalTo(topicsTableView).offset(40.0)
        }
        
        let tableOverlayTopLine = UIView()
        tableOverlayTopLine.backgroundColor = UIColor.bhnTextDarkBlue()
        tableOverlayView.addSubview(tableOverlayTopLine)
        
        tableOverlayTopLine.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(tableOverlayView)
            make.centerX.equalTo(tableOverlayView)
            make.top.equalTo(tableOverlayView)
            make.height.equalTo(1.0)
        }
        
        let tableOverlayBottomLine = UIView()
        tableOverlayBottomLine.backgroundColor = UIColor.bhnDarkBlue()
        tableOverlayView.addSubview(tableOverlayBottomLine)
        
        tableOverlayBottomLine.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(tableOverlayView)
            make.centerX.equalTo(tableOverlayView)
            make.top.equalTo(tableOverlayView).offset(1.0)
            make.height.equalTo(1.0)
        }
        
        let topLine = UIView()
        topLine.backgroundColor = UIColor.bhnLightBlue()
        mainView.addSubview(topLine)
        
        topLine.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(topicsTableView).offset(-1.0)
            make.width.equalTo(topicsTableView)
            make.centerX.equalTo(view)
            make.height.equalTo(1.0)
        }
        
        let vertBlackLineView = UIView()
        vertBlackLineView.backgroundColor = UIColor.blackColor()
        mainView.addSubview(vertBlackLineView)
        
        vertBlackLineView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(topicsTableView.snp_bottom)
            make.width.equalTo(1.0)
            make.centerX.equalTo(view)
            make.height.equalTo(25.0)
        }
        
        let horiBlackLineView = UIView()
        horiBlackLineView.backgroundColor = UIColor.blackColor()
        mainView.addSubview(horiBlackLineView)
        
        horiBlackLineView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(topicsTableView.snp_bottom)
            make.width.equalTo(topicsTableView)
            make.centerX.equalTo(view)
            make.height.equalTo(1.0)
        }
        
        let searchButton = UIButton()
        searchButton.backgroundColor = UIColor.bhnTopicBlue()
        searchButton.setTitle("Search", forState: .Normal)
        searchButton.setTitleColor(UIColor.bhnLightBlue(), forState: .Normal)
        searchButton.addTarget(self, action: #selector(SearchViewController.didTapSearchButton), forControlEvents: .TouchUpInside)
        mainView.addSubview(searchButton)
        
        searchButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(storeLabel).offset(-65.0)
            make.left.equalTo(view).offset(15.0)
            make.right.equalTo(view).offset(-15.0)
            make.height.equalTo(38.0)
        }
        
        let searchButtonBlackLine = UIView()
        searchButtonBlackLine.backgroundColor = UIColor.blackColor()
        mainView.addSubview(searchButtonBlackLine)
        
        searchButtonBlackLine.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(searchButton.snp_bottom)
            make.width.equalTo(topicsTableView)
            make.centerX.equalTo(view)
            make.height.equalTo(1.0)
        }
        
        let searchTopLine = UIView()
        searchTopLine.backgroundColor = UIColor.bhnLightBlue()
        mainView.addSubview(searchTopLine)
        
        searchTopLine.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(searchButton).offset(-1.0)
            make.width.equalTo(topicsTableView)
            make.centerX.equalTo(view)
            make.height.equalTo(1.0)
        }
        
        let storeButton = UIButton()
        storeButton.backgroundColor = UIColor.bhnTopicBlue()
        storeButton.setTitle("Shop Now", forState: .Normal)
        storeButton.setTitleColor(UIColor.bhnLightBlue(), forState: .Normal)
        storeButton.addTarget(self, action: #selector(SearchViewController.didTapStoreButton), forControlEvents: .TouchUpInside)
        mainView.addSubview(storeButton)
        
        storeButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(storeLabel.snp_bottom).offset(6.0)
            make.left.equalTo(view).offset(15.0)
            make.right.equalTo(view).offset(-15.0)
            make.height.equalTo(38.0)
        }
        
        let storeButtonBlackLine = UIView()
        storeButtonBlackLine.backgroundColor = UIColor.blackColor()
        mainView.addSubview(storeButtonBlackLine)
        
        storeButtonBlackLine.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(storeButton.snp_bottom)
            make.width.equalTo(topicsTableView)
            make.centerX.equalTo(view)
            make.height.equalTo(1.0)
        }
        
        let storeTopLine = UIView()
        storeTopLine.backgroundColor = UIColor.bhnLightBlue()
        mainView.addSubview(storeTopLine)
        
        storeTopLine.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(storeButton).offset(-1.0)
            make.width.equalTo(topicsTableView)
            make.centerX.equalTo(view)
            make.height.equalTo(1.0)
        }
        
        resultsTableView.registerClass(SearchTableViewCell.self, forCellReuseIdentifier: "Cell")
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        resultsTableView.separatorStyle = .None
        resultsTableView.backgroundColor = UIColor.bhnTopicBlue()
        resultsTableView.showsVerticalScrollIndicator = false
        resultsTableView.alpha = 0.0
        mainView.addSubview(resultsTableView)
        
        resultsTableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(searchLabel.snp_bottom).offset(54.0)
            make.left.equalTo(view).offset(15.0)
            make.right.equalTo(view).offset(-15.0)
            make.bottom.equalTo(view)
        }
        
        loadingLabel.font = UIFont(name: "BentonSans-Medium", size: 20.0)
        loadingLabel.alpha = 0.0
        loadingLabel.textColor = UIColor.bhnLightBlue()
        resultsTableView.addSubview(loadingLabel)
        
        loadingLabel.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(resultsTableView).offset(-40.0)
            make.centerX.equalTo(resultsTableView)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        topicsTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: viewModel.numberOfTopics()/2, inSection: 0), atScrollPosition: .Top, animated: true)
    }
    
    func didTapStoreButton() {
        if let url = NSURL(string: Constants.URLs.storeUrl) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func didTapSearchButton() {
        if let _ = viewModel.searchTopic { return }
        
        if topicsTableView.visibleCells.count > 0 {
            let topVisibleCell = topicsTableView.visibleCells[0]
            if let indexPath = topicsTableView.indexPathForCell(topVisibleCell) {
                viewModel.searchTopic = viewModel.topicForRow(indexPath.row + 1)
                searchLabel.text = "SEARCH RESULTS"
                topicsTableView.userInteractionEnabled = false
                
                Externals.tagAnalyticsEvent("Topic Search", attributes: ["Topic" : viewModel.topicForRow(indexPath.row)])
                
                viewModel.loadSearchResults(viewModel.topicForRow(indexPath.row)).observeCompleted { () -> () in
                    if let _ = self.viewModel.searchTopic {
                        self.resultsTableView.reloadData()
                        if self.viewModel.numberOfResults() == 0 {
                            self.loadingLabel.text = "NO RESULTS FOUND"
                        } else {
                            self.loadingLabel.alpha = 0.0
                        }
                    } else {
                        return
                    }
                }
                
                topMenuView.setMenuButtonAsBack(true)
                
                self.loadingLabel.text = "LOADING.."
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.resultsTableView.alpha = 1.0
                    self.loadingLabel.alpha = 1.0
                })
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == resultsTableView {
            return viewModel.numberOfResults()
        }
        return viewModel.numberOfTopics() + Int(tableView.bounds.size.height/44.0)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == resultsTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SearchTableViewCell
            let searchResult = viewModel.searchObjectAtRow(indexPath.row)
            cell.configureForContent(searchResult, isLast: viewModel.isRowLast(indexPath.row))

            return cell
        }
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
        if let textLabel = cell.textLabel {
            textLabel.text = viewModel.topicForRow(indexPath.row)
            textLabel.textAlignment = .Center
            textLabel.textColor = UIColor.bhnLightBlue()
            textLabel.backgroundColor = UIColor.clearColor()
        }
        cell.selectionStyle = .None
        cell.backgroundColor = UIColor.bhnTopicBlue()

        return cell
    }
}



extension SearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == resultsTableView {
            if let delegate = delegate {
                let object = viewModel.searchObjectAtRow(indexPath.row)
                if let object = object as? Podcast {
                    delegate.searchViewControllerShouldPresentPodcast(self, podcast: object)
                    Externals.tagAnalyticsEvent("Podcast Listen", attributes: nil)
                }
                if let object = object as? Article {
                    delegate.searchViewControllerShouldPresentArticle(self, article: object)
                    if (object.isVideo) {
                        Externals.tagAnalyticsEvent("Video View", attributes: nil)
                    } else {
                        Externals.tagAnalyticsEvent("Article View", attributes: nil)
                    }
                    
                }
            }
        }
    }
    
    func loadNextSearchResultsPage() {
        if let searchTopic = viewModel.searchTopic {
            if viewModel.didLoadAllVideos && !viewModel.didLoadAllArticles {
                viewModel.isLoadingSearchResults = true

                viewModel.loadArticles(searchTopic).observeCompleted({ () -> () in
                    self.viewModel.isLoadingSearchResults = false
                    if let _ = self.viewModel.searchTopic {
                        self.resultsTableView.reloadData()
                    }
                })
            } else {
                
                viewModel.loadSearchResults(searchTopic).observeCompleted { () -> () in
                    if let _ = self.viewModel.searchTopic {
                        self.resultsTableView.reloadData()
                    }
                }
            }
        }
    }
}

extension SearchViewController: TopMenuDelegate {
    func topMenuDidTapCloseSearchButton(topMenu: TopMenuView) {
        if let _ = viewModel.searchTopic {
            self.topMenuView.setMenuButtonAsBack(false)
            self.searchLabel.text = "SEARCH"
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.resultsTableView.alpha = 0.0
                self.loadingLabel.alpha = 0.0
                }, completion: { (Bool) -> Void in
                    self.viewModel.searchTopic = nil
                    self.viewModel.resetSearch()
                    self.resultsTableView.reloadData()
                    self.topicsTableView.userInteractionEnabled = true
                })
            
            return
        } else {
            willMoveToParentViewController(nil)
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.view.alpha = 0.0
                }) { (Bool) -> Void in
                    self.view.removeFromSuperview()
                    self.removeFromParentViewController()
            }
        }
    }
    
    func topMenuDidTapMenuButton(topMenu: TopMenuView) {
        
    }
    
    func topMenuDidSwipeDown(topMenu: TopMenuView) {
    
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == resultsTableView {
            return 65.0
        }
        return 44.0
    }
}

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate { focusTableView() }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        focusTableView()
    }
    
    func focusTableView() {
        if let pathForCenterCell = topicsTableView.indexPathForRowAtPoint(CGPointMake(CGRectGetMidX(topicsTableView.bounds), CGRectGetMinY(topicsTableView.bounds))) {
            topicsTableView.scrollToRowAtIndexPath(pathForCenterCell, atScrollPosition: .Top, animated: true)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if let pathForCenterCell = topicsTableView.indexPathForRowAtPoint(CGPointMake(CGRectGetMidX(topicsTableView.bounds), CGRectGetMinY(topicsTableView.bounds))) {
            topicsTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: viewModel.topics.count*500 + pathForCenterCell.row % viewModel.topics.count, inSection: 0), atScrollPosition: .Top, animated: false)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if viewModel.isLoadingSearchResults || (viewModel.didLoadAllArticles && viewModel.didLoadAllVideos) { return }
        
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let contentSize = scrollView.contentSize
        let inset = scrollView.contentInset;
        let y = offset.y + bounds.size.height - inset.bottom
        let h = contentSize.height
        
        let reload_distance: CGFloat = 20.0
        if( y > h + reload_distance) {
            loadNextSearchResultsPage()
        }
    }
}
