//
//  NowPlayingTopView.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/10/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit
import SnapKit

class NowPlayingTopView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.bhnLightBlue()
        
        let statusBarView = UIView()
        statusBarView.backgroundColor = UIColor.bhnLightBlue().colorWithAlphaComponent(0.7)
        addSubview(statusBarView)
        statusBarView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.width.equalTo(self)
            make.left.equalTo(self)
            make.height.equalTo(20.0)
        }
        
        let playingNowLabel = UILabel()
        playingNowLabel.text = "PLAYING NOW"
        playingNowLabel.font = UIFont(name: "Didot-Bold", size: 14.0)
        playingNowLabel.textAlignment = .Center
        playingNowLabel.textColor = UIColor.bhnDarkBlue()
        addSubview(playingNowLabel)
        
        playingNowLabel.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self)
        }
        
        let arrowImageView = UIImageView(image: UIImage(named: "NowPlayingArrow"))
        addSubview(arrowImageView)
        
        arrowImageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(playingNowLabel.snp_bottom).offset(2.0)
            make.centerX.equalTo(playingNowLabel)
            make.size.equalTo(CGSizeMake(18.0, 9.0))
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
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
