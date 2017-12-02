//
//  TopMenuView.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/11/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit
import SnapKit

protocol TopMenuDelegate {
    func topMenuDidTapMenuButton(topMenu: TopMenuView)
    func topMenuDidTapCloseSearchButton(topMenu: TopMenuView)
    func topMenuDidSwipeDown(topMenu: TopMenuView)
}

class TopMenuView: UIView {
    var delegate: TopMenuDelegate?
    
    let menuButton = UIButton()
    
    init(frame: CGRect, withCloseButton: Bool) {
        super.init(frame: frame)
        backgroundColor = UIColor.bhnLightBlue()
        
        if withCloseButton {
            menuButton.setImage(UIImage(named: "PushCloseButton"), forState: .Normal)
            menuButton.addTarget(self, action: #selector(TopMenuView.closeButtonWasTapped), forControlEvents: .TouchUpInside)
            
            addSubview(menuButton)
            menuButton.snp_makeConstraints { (make) -> Void in
                make.centerX.equalTo(self)
                make.top.equalTo(self).offset(32.0)
                make.size.equalTo(CGSizeMake(62.0, 38.0))
            }
        } else {
            let statusBarView = UIView()
            statusBarView.backgroundColor = UIColor.bhnLightBlue().colorWithAlphaComponent(0.7)
            addSubview(statusBarView)
            statusBarView.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(self)
                make.width.equalTo(self)
                make.left.equalTo(self)
                make.height.equalTo(25.0)
            }
            
            let playingNowLabel = UILabel()
            playingNowLabel.text = "MBER BE HERE NOW REMEMBER BE HERE NOW REMEMBER BE HERE NOW REMEMBER BE HERE NOW REMEMBER BE HERE NOW REMEMBER BE"
            playingNowLabel.font = UIFont(name: "Didot-Bold", size: 14.0)
            playingNowLabel.textAlignment = .Center
            playingNowLabel.textColor = UIColor.bhnDarkBlue()
            addSubview(playingNowLabel)
            
            playingNowLabel.snp_makeConstraints { (make) -> Void in
                make.center.equalTo(self)
            }
            
            menuButton.setImage(UIImage(named: "MenuButton"), forState: .Normal)
            menuButton.addTarget(self, action: #selector(TopMenuView.menuButtonWasTapped), forControlEvents: .TouchUpInside)
            
            addSubview(menuButton)
            menuButton.snp_makeConstraints { (make) -> Void in
                make.centerX.equalTo(self)
                make.top.equalTo(self).offset(32.0)
                make.size.equalTo(CGSizeMake(62.0, 40.0))
            }
            
            let blueCoverArea = UIView()
            blueCoverArea.backgroundColor = UIColor.bhnLightBlue()
            insertSubview(blueCoverArea, belowSubview: playingNowLabel)
            blueCoverArea.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(playingNowLabel)
                make.bottom.equalTo(self).offset(-1.0)
                make.width.equalTo(self)
                make.centerX.equalTo(self)
            }
            
            let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(TopMenuView.didSwipeDown))
            swipeGestureRecognizer.direction = .Down
            addGestureRecognizer(swipeGestureRecognizer)
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didSwipeDown() {
        if let delegate = delegate {
            delegate.topMenuDidSwipeDown(self)
        }
    }
    
    func menuButtonWasTapped() {
        if let delegate = delegate {
            delegate.topMenuDidTapMenuButton(self)
        }
    }
    
    func closeButtonWasTapped() {
        if let delegate = delegate {
            delegate.topMenuDidTapCloseSearchButton(self)
        }
    }
    
    func setMenuButtonAsBack(asBack: Bool) {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.menuButton.alpha = 0.0
            }) { (Bool) -> Void in
                if (asBack) {
                    self.menuButton.setImage(UIImage(named: "BackButton"), forState: .Normal)
                } else {
                    self.menuButton.setImage(UIImage(named: "PushCloseButton"), forState: .Normal)
                }
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.menuButton.alpha = 1.0
                })
        }
    }
    
    override func drawRect(rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            CGContextSetStrokeColorWithColor(context, UIColor(white: 1.0, alpha: 0.7).CGColor)

            // DrawingHelper.strokeLine(context, fromX: 0.0, fromY: rect.size.height, toX: rect.size.width, toY: rect.size.height)
            
            CGContextSetStrokeColorWithColor(context, UIColor(white: 1.0, alpha: 0.7).CGColor)
            
            DrawingHelper.strokeLine(context, fromX: rect.size.width*0.03, fromY: 0.0, toX: rect.size.width*0.11, toY: rect.size.height)
            DrawingHelper.strokeLine(context, fromX: rect.size.width*0.11, fromY: 0.0, toX: rect.size.width*0.11, toY: rect.size.height)
            DrawingHelper.strokeLine(context, fromX: rect.size.width*0.19, fromY: 0.0, toX: rect.size.width*0.11, toY: rect.size.height)
            
            DrawingHelper.strokeLine(context, fromX: rect.size.width*0.97, fromY: 0.0, toX: rect.size.width*0.89, toY: rect.size.height)
            DrawingHelper.strokeLine(context, fromX: rect.size.width*0.89, fromY: 0.0, toX: rect.size.width*0.89, toY: rect.size.height)
            DrawingHelper.strokeLine(context, fromX: rect.size.width*0.81, fromY: 0.0, toX: rect.size.width*0.89, toY: rect.size.height)
            
            DrawingHelper.strokeLine(context, fromX: rect.size.width*0.5, fromY: 0.0, toX: rect.size.width*0.5, toY: rect.size.height/2)
        }
    }
}
