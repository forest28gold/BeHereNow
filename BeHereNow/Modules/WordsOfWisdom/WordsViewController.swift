//
//  WordsViewController.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/1/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit

class WordsViewController: UIViewController {
    let viewModel = WordsViewModel()
    
    var tableView = UITableView()
    
    override func viewDidLoad() {
        Externals.tagAnalyticsScreen("Words of Wisdom")

        view.backgroundColor = UIColor.bhnLightBlue()

        tableView.backgroundColor = UIColor.clearColor()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.whiteColor()
        tableView.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        tableView.showsVerticalScrollIndicator = false
        tableView.registerClass(WordsTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.registerClass(DonateTableViewCell.self, forCellReuseIdentifier: "DonateCell")
        tableView.estimatedRowHeight = 183.0
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
            tableView.alpha = 0.0
            loadNextWisdomPage()
        } else {
            tableView.alpha = 1.0
            view.backgroundColor = UIColor.clearColor()
        }
    }
    
    func loadNextWisdomPage() {
        viewModel.loadWisdom().observeCompleted { () -> () in
            self.tableView.reloadData()
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.tableView.alpha = 1.0
                self.view.backgroundColor = UIColor.clearColor()
            })
        }
    }
    
    func didTapShareButton(button: UIButton) {
        Externals.tagAnalyticsEvent("Share - Words of Wisdom", attributes: nil)

        let wisdom = viewModel.wisdomForRow(button.tag)
        let shareString = wisdom.quote + " -" + wisdom.author
        if let url = NSURL(string: wisdom.link) {
            let activityViewController = UIActivityViewController(activityItems: [shareString, url], applicationActivities: nil)
            presentViewController(activityViewController, animated: true) { }
        } else {
            let activityViewController = UIActivityViewController(activityItems: [shareString], applicationActivities: nil)
            presentViewController(activityViewController, animated: true) { }
        }
    }
}

extension WordsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 && !viewModel.didDeleteDonations() {
            let cell = tableView.dequeueReusableCellWithIdentifier("DonateCell", forIndexPath: indexPath) as! DonateTableViewCell
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! WordsTableViewCell
        cell.configureForWisdom(viewModel.wisdomForRow(indexPath.row), row: indexPath.row)

        cell.shareButton.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
        cell.shareButton.addTarget(self, action: #selector(WordsViewController.didTapShareButton(_:)), forControlEvents: .TouchUpInside)
        cell.shareButton.tag = indexPath.row
        
        return cell
    }
}

extension WordsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "LATER"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 && !viewModel.didDeleteDonations() {
            Externals.tagAnalyticsEvent("Tap Donation Banner", attributes: nil)
            if let url = NSURL(string: Constants.URLs.donationsUrl) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return (indexPath.row == 0 && !viewModel.didDeleteDonations())
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        ContentCache.sharedInstance.didDeleteDonations = true
        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
    }
}

extension WordsViewController: UIScrollViewDelegate {
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
            loadNextWisdomPage()
        }
    }
}
