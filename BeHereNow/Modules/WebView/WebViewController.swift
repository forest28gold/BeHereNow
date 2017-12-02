//
//  WebViewController.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/4/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit
import SnapKit

class WebViewController: UIViewController {
    let viewModel: WebViewModel
    
    init(url: String) {
        viewModel = WebViewModel(url: url)
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        let webView = UIWebView()
        view.addSubview(webView)
        
        Externals.tagAnalyticsScreen("Web View")
        
        if let url = NSURL(string: viewModel.url) { webView.loadRequest(NSURLRequest(URL: url)) }
        
        webView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(view)
            make.center.equalTo(view)
        }
        
        let backButton = UIButton()
        backButton.addTarget(self, action: #selector(WebViewController.backButtonWasTapped), forControlEvents: .TouchUpInside)
        backButton.setImage(UIImage(named: "WebViewBackButton"), forState: .Normal)
        view.addSubview(backButton)
        
        backButton.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(93.0, 37.0))
            make.left.equalTo(view)
            make.top.equalTo(view).offset(26.0)
        }
    }
    
    func backButtonWasTapped() {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
}
