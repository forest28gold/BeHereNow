//
//  MenuViewController.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 1/25/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit
import SnapKit
import MessageUI

protocol MenuViewControllerDelegate {
    func menuViewControllerDidTapNowPlaying(menuViewController: MenuViewController)
    func isNowPlayingEnabled() -> Bool
}

class MenuViewController: UIViewController {
    var delegate: MenuViewControllerDelegate?
    var viewsToHide = [UIView]()
    var centerView = UIView()
    let closeButtonImageView = UIImageView()


    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var size: CGFloat = 230.0
        if DeviceType.IS_IPHONE_6P { size = 255.0 }
        if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 { size = 200.0 }
        
        let animation = CABasicAnimation(keyPath:"cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = size/2
        animation.toValue = (view.frame.width - 50.0)/2
        animation.duration = 0.5
        centerView.layer.addAnimation(animation, forKey: "cornerRadius")
        centerView.layer.cornerRadius = (view.frame.width - 50.0)/2
        
        centerView.snp_remakeConstraints { (make) -> Void in
            make.center.equalTo(view)
            make.left.equalTo(view).offset(25.0)
            make.right.equalTo(view).offset(-25.0)
            make.height.equalTo(centerView.snp_width)
        }
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }) { (Bool) -> Void in
//                self.closeButtonImageView.startAnimating()
        }
        
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.bhnLightBlue().colorWithAlphaComponent(0.75)
        
        Externals.tagAnalyticsScreen("Menu")
        
        setupCenterView()
        setupButtons()
        setupCloseButton()
    }
    
    func setupCenterView() {
        var size: CGFloat = 230.0
        if DeviceType.IS_IPHONE_6P { size = 255.0 }
        if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 { size = 200.0 }

        centerView.backgroundColor = UIColor.whiteColor()
        centerView.layer.cornerRadius = size/2
        view.addSubview(centerView)
        
        centerView.snp_makeConstraints{ (make) -> Void in
            make.center.equalTo(view)
            make.size.equalTo(CGSizeMake(size, size))
            
        }
    }
    
    func setupButtons() {
        let nowPlayingButton = createButtonAndLabel("NowPlayingIcon", title: "Playing\nNow", selector: "didTapNowPlayingButton")
        nowPlayingButton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.top.equalTo(centerView).offset(15.0)
        }

        let settingsButton = createButtonAndLabel("SettingsIcon", title: "Settings", selector: "didTapSettingsButton")
        settingsButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(centerView).offset(30.0)
            make.centerY.equalTo(view)
        }

        let contactButton = createButtonAndLabel("ContactIcon", title: "Contact", selector: "didTapContactButton")
        contactButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(centerView).offset(-30.0)
            make.centerY.equalTo(view)
        }

        let donateButton = createButtonAndLabel("DonateIcon", title: "Donate", selector: "didTapDonateButton")
        donateButton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 {
                make.bottom.equalTo(centerView).offset(35.0)
            } else {
                make.bottom.equalTo(centerView).offset(-35.0)
            }
        }
    }
    
    func createButtonAndLabel(iconName: String, title: String, selector: String) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: iconName), forState: .Normal)
        button.backgroundColor = UIColor.bhnButtonBlue()
        button.layer.cornerRadius = 35.0
        if selector.characters.count > 0 { button.addTarget(self, action: Selector(selector), forControlEvents: .TouchUpInside) }
        centerView.addSubview(button)
        viewsToHide.append(button)

        button.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(70.0, 70.0))
        }
        
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "BentonSans-Regular", size: 14.0)
        label.textColor = UIColor.bhnTextDarkBlue()
        label.numberOfLines = 0
        label.sizeToFit()
        label.textAlignment = .Center
        centerView.addSubview(label)
        viewsToHide.append(label)
        
        label.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(button)
            make.top.equalTo(button.snp_bottom).offset(8.0)
        }
        
        if let delegate = delegate {
            if delegate.isNowPlayingEnabled() == false && selector == "didTapNowPlayingButton" {
                button.alpha = 0.3
                label.alpha = 0.3
            }
        }
        
        return button
    }
    
    func setupCloseButton() {
        var animationImages = [UIImage]()
        for i in 1...4 {
            if let image = UIImage(named: "CloseAnimation\(i)") { animationImages.append(image) }
        }
        
        closeButtonImageView.image = UIImage(named: "MenuCloseIcon")
        closeButtonImageView.userInteractionEnabled = true
        closeButtonImageView.contentMode = .Center
        closeButtonImageView.animationImages = animationImages
        closeButtonImageView.animationDuration = 0.5
        closeButtonImageView.startAnimating()
        closeButtonImageView.animationRepeatCount = 1
        view.addSubview(closeButtonImageView)
        
        closeButtonImageView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(85.0, 62.0))
            make.centerX.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        let closeButton = UIButton()
        closeButton.addTarget(self, action: #selector(MenuViewController.didTapCloseButton), forControlEvents: .TouchUpInside)
        closeButtonImageView.addSubview(closeButton)
        
        closeButton.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(closeButtonImageView)
            make.center.equalTo(closeButtonImageView)
        }
    }
    
    func didTapCloseButton() {
        var size: CGFloat = 230.0
        if DeviceType.IS_IPHONE_6P { size = 255.0 }
        if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 { size = 200.0 }
        
        let animation = CABasicAnimation(keyPath:"cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = (view.frame.width - 50.0)/2
        animation.toValue = size/2
        animation.duration = 0.5
        centerView.layer.addAnimation(animation, forKey: "cornerRadius")
        centerView.layer.cornerRadius = size/2
        
        centerView.snp_remakeConstraints { (make) -> Void in
            make.center.equalTo(view)
            make.size.equalTo(CGSizeMake(size, size))
        }
        
        willMoveToParentViewController(nil)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            for view in self.viewsToHide {
                view.alpha = 0.0
            }
            self.view.alpha = 0.0
            self.view.layoutIfNeeded()
            }) { (Bool) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        }
    }
    
    func didTapDonateButton() {
        Externals.tagAnalyticsEvent("Menu - Tap Donate Button", attributes: nil)
        if let url = NSURL(string: Constants.URLs.donationsUrl) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func didTapNowPlayingButton() {
        Externals.tagAnalyticsEvent("Menu - Tap Now Playing Button", attributes: nil)
        if let delegate = delegate {
            delegate.menuViewControllerDidTapNowPlaying(self)
        }
    }
    
    func didTapSettingsButton() {
        Externals.tagAnalyticsEvent("Menu - Tap Settings Button", attributes: nil)
        
        let viewController = SettingsViewController()

        addChildViewController(viewController)
        viewController.view.frame = view.bounds
        viewController.view.alpha = 0.0
        view.addSubview(viewController.view)
        UIView.animateWithDuration(0.5) { () -> Void in
            viewController.view.alpha = 1.0
        }
        viewController.didMoveToParentViewController(self)

    }
    
    func didTapContactButton() {
        Externals.tagAnalyticsEvent("Menu - Tap Contact Us Button", attributes: nil)

        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.setToRecipients([Constants.URLs.contactEmail])
        mailComposeViewController.mailComposeDelegate = self
        self.presentViewController(mailComposeViewController, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        centerView.layer.cornerRadius = centerView.bounds.size.width/2
    }
}

extension MenuViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
