//
//  SettingsViewController.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/24/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    let mainView = UIView()
    let labels = ["Words of Wisdom", "Articles", "Videos", "Podcasts", "Events"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Externals.tagAnalyticsScreen("Settings")
        
        mainView.backgroundColor = UIColor.whiteColor()
        view.addSubview(mainView)
        mainView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view)
            make.bottom.equalTo(view).offset(-65.0)
            make.width.equalTo(view)
        }

        setupSettingsButton()
        setupCloseButton()
        setupPushNotificationTitle()
        for i in 0...4 { setupSwitchForIndex(i) }
    }
    
    func setupSwitchForIndex(index: Int) {
        let switchView = UIView()
        switchView.backgroundColor = UIColor.bhnButtonBlue()
        mainView.addSubview(switchView)
        
        switchView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(170.0 + 39.0*CGFloat(index))
            make.left.equalTo(mainView).offset(15.0)
            make.right.equalTo(mainView).offset(-15.0)
            make.height.equalTo(39.0)
        }
        
        let label = UILabel()
        label.text = labels[index]
        label.font = UIFont(name: "BentonSans-Book", size: 16.0)
        label.textColor = UIColor.bhnDarkBlue()
        switchView.addSubview(label)
        
        label.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(14.0)
            make.top.equalTo(13.0)
        }

        let topLine = UIView()
        topLine.backgroundColor = UIColor.whiteColor()
        switchView.addSubview(topLine)
        
        topLine.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(switchView)
            make.left.equalTo(switchView)
            make.height.equalTo(1.0)
            make.top.equalTo(switchView)
        }

        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.bhnDarkBlue()
        switchView.addSubview(bottomLine)
        
        bottomLine.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(switchView)
            make.left.equalTo(switchView)
            make.height.equalTo(0.5)
            make.bottom.equalTo(switchView)
        }
        
        let optionSwitch = UISwitch()
        optionSwitch.tag = index
        optionSwitch.addTarget(self, action: #selector(SettingsViewController.switchDidChange(_:)), forControlEvents: .ValueChanged)
        optionSwitch.tintColor = UIColor.bhnLightBlue()
        optionSwitch.onTintColor = UIColor.bhnTextDarkBlue()
        optionSwitch.on = initialValueForSwitchAtIndex(index)
        switchView.addSubview(optionSwitch)
        
        optionSwitch.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(switchView).offset(4.0)
            make.right.equalTo(switchView).offset(-10.0)
        }

    }
    
    func initialValueForSwitchAtIndex(index: Int) -> Bool {
        switch (index) {
        case 0: return ContentCache.sharedInstance.user.wisdomPushEnabled
        case 1: return ContentCache.sharedInstance.user.articlesPushEnabled
        case 2: return ContentCache.sharedInstance.user.videosPushEnabled
        case 3: return ContentCache.sharedInstance.user.podcastsPushEnabled
        case 4: return ContentCache.sharedInstance.user.eventsPushEnabled
        default: return true
        }
    }
    
    func switchDidChange(aSwitch: UISwitch) {
        switch (aSwitch.tag) {
        case 0: ContentCache.sharedInstance.user.wisdomPushEnabled = aSwitch.on
        case 1: ContentCache.sharedInstance.user.articlesPushEnabled = aSwitch.on
        case 2: ContentCache.sharedInstance.user.videosPushEnabled = aSwitch.on
        case 3: ContentCache.sharedInstance.user.podcastsPushEnabled = aSwitch.on
        case 4: ContentCache.sharedInstance.user.eventsPushEnabled = aSwitch.on
        default: break
        }
        ContentCache.sharedInstance.user.save()
        Externals.updatePushTags()
    }
    
    
    func setupPushNotificationTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "PUSH NOTIFICATIONS"
        titleLabel.font = UIFont(name: "Didot-Bold", size: 25.0)
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.bhnTextDarkBlue()
        mainView.addSubview(titleLabel)
        
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(mainView)
            make.top.equalTo(mainView).offset(130.0)
        }
    }
    
    func setupCloseButton() {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "MenuCloseIcon"), forState: .Normal)
        closeButton.addTarget(self, action: #selector(SettingsViewController.didTapCloseButton), forControlEvents: .TouchUpInside)
        view.addSubview(closeButton)
        
        closeButton.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(85.0, 62.0))
            make.centerX.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
    
    func setupSettingsButton() {
        let settingsButton = createButtonAndLabel("SettingsIcon", title: "Settings", selector: "didTapSettingsButton")
        settingsButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(mainView).offset(35.0)
            make.centerX.equalTo(view)
        }
    }
    
    func createButtonAndLabel(iconName: String, title: String, selector: String) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: iconName), forState: .Normal)
        button.backgroundColor = UIColor.bhnButtonBlue()
        button.layer.cornerRadius = 35.0
        if selector.characters.count > 0 { button.addTarget(self, action: Selector(selector), forControlEvents: .TouchUpInside) }
        mainView.addSubview(button)
        
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
        mainView.addSubview(label)
        
        label.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(button)
            make.top.equalTo(button.snp_bottom).offset(8.0)
        }
        
        return button
    }
    
    func didTapCloseButton() {
        willMoveToParentViewController(nil)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.alpha = 0.0
            }) { (Bool) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        }
    }
}
