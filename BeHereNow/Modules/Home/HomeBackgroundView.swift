//
//  HomeView.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 1/25/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit
import SnapKit

class HomeBackgroundView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.bhnLightBlue()
        
        var size: CGFloat = 230.0
        if DeviceType.IS_IPHONE_6P { size = 255.0 }
        if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 { size = 200.0 }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = 45.0
        
        let attributedString = NSAttributedString(string: "BE\nHERE\nNOW", attributes:[NSParagraphStyleAttributeName: paragraphStyle])
        
        let centerLabel = UILabel()
        centerLabel.backgroundColor = UIColor.whiteColor()
        centerLabel.clipsToBounds = true
        centerLabel.layer.cornerRadius = size/2.0
        centerLabel.numberOfLines = 3
        centerLabel.attributedText = attributedString
        centerLabel.font = UIFont(name: "Didot-Bold", size: 44.0)
        centerLabel.textAlignment = .Center
        centerLabel.textColor = UIColor.bhnDarkBlue()
        addSubview(centerLabel)
        centerLabel.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self)
            make.size.equalTo(CGSizeMake(size, size))
        }        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
