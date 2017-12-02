//
//  ArticlesViewController.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/4/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit

class ArticlesViewController: UIViewController {
    let viewModel: ArticlesViewModel
    var tableView = UITableView()
    
    init(articleType: ArticleType) {
        viewModel = ArticlesViewModel(articleType: articleType)
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        switch (viewModel.articleType) {
        case .Article:
            Externals.tagAnalyticsScreen("Articles")
        case .Video:
            Externals.tagAnalyticsScreen("Videos")
        }
        
        view.backgroundColor = UIColor.bhnLightBlue()

        tableView.backgroundColor = UIColor.clearColor()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.whiteColor()
        tableView.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        tableView.showsVerticalScrollIndicator = false
        tableView.registerClass(ArticleTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.registerClass(DonateTableViewCell.self, forCellReuseIdentifier: "DonateCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsMultipleSelectionDuringEditing = false
        view.addSubview(tableView)
        
        let tableFooterView = UIView()
        tableView.tableFooterView = tableFooterView
        
        tableFooterView.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(1.0)
            make.width.equalTo(tableView)
        }
        
        tableView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(view)
            make.center.equalTo(view)
        }
        
        if !viewModel.didCompleteInitialLoad() {
            loadNextArticlesPage()
            tableView.alpha = 0.0
        } else {
            tableView.alpha = 1.0
            view.backgroundColor = UIColor.clearColor()
        }
    }
    
    func loadNextArticlesPage() {
        viewModel.loadArticles().observeCompleted { () -> () in
            self.tableView.reloadData()
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.tableView.alpha = 1.0
            })
        }
    }
    
    func didTapShareButton(button: UIButton) {
        let article = viewModel.articleForRow(button.tag)
        if article.isVideo {
            Externals.tagAnalyticsEvent("Share - Video", attributes: nil)
        } else {
            Externals.tagAnalyticsEvent("Share - Article", attributes: nil)
        }

        if let url = NSURL(string: article.url) {
            let activityViewController = UIActivityViewController(activityItems: [article.title, url], applicationActivities: nil)
            presentViewController(activityViewController, animated: true) { }
        }
    }
}

extension ArticlesViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 && !viewModel.didDeleteDonations() {
            let cell = tableView.dequeueReusableCellWithIdentifier("DonateCell", forIndexPath: indexPath) as! DonateTableViewCell
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ArticleTableViewCell
        cell.configureForArticle(viewModel.articleForRow(indexPath.row), hidePlayIcon: (viewModel.articleType == .Article), placeholderImage: viewModel.placeholderImageForRow(indexPath.row) )
        
        cell.shareButton.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
        cell.shareButton.addTarget(self, action: #selector(ArticlesViewController.didTapShareButton(_:)), forControlEvents: .TouchUpInside)
        cell.shareButton.tag = indexPath.row

        return cell
    }
    
}

extension ArticlesViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 && !viewModel.didDeleteDonations() {
            Externals.tagAnalyticsEvent("Tap Donation Banner", attributes: nil)
            if let url = NSURL(string: Constants.URLs.donationsUrl) {
                UIApplication.sharedApplication().openURL(url)
            }
        } else {
            let article = viewModel.articleForRow(indexPath.row)
            if (article.isVideo) {
                Externals.tagAnalyticsEvent("Video View", attributes: nil)
            } else {
                Externals.tagAnalyticsEvent("Article View", attributes: nil)
            }
            navigationController?.pushViewController(WebViewController(url: article.url), animated: true)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 && !viewModel.didDeleteDonations() { return 73.0 }
        
        return 183.0
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "LATER"
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return (indexPath.row == 0 && !viewModel.didDeleteDonations())
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        ContentCache.sharedInstance.didDeleteDonations = true
        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
    }
}

extension ArticlesViewController: UIScrollViewDelegate {
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
            loadNextArticlesPage()
        }
    }
}
