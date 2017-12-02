//
//  DonateTableViewCell.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/14/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit

class DonateTableViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.bhnDonateBackground().colorWithAlphaComponent(0.7)
        selectionStyle = .None
        
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
        
        let donateLabel = UILabel()
        addSubview(donateLabel)
        donateLabel.text = "Donate to Love Serve Remember"
        donateLabel.font = UIFont(name: "BentonSans-Book", size: 17.0)
        donateLabel.textColor = UIColor.bhnLightBlue()
        donateLabel.textAlignment = .Center
        donateLabel.backgroundColor = UIColor.bhnTextDarkBlue()
        donateLabel.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(290.0)
            make.centerX.equalTo(self)
            make.height.equalTo(38.0)
            make.top.equalTo(self).offset(15.0)
            make.bottom.equalTo(self).offset(-20.0)
        }
        
        let donateTopLine = UIView()
        donateTopLine.backgroundColor = UIColor.bhnProgressView()
        addSubview(donateTopLine)
        donateTopLine.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(donateLabel)
            make.top.equalTo(donateLabel).offset(-1.0)
            make.height.equalTo(1.0)
            make.centerX.equalTo(donateLabel)
        }
        
        let donateBottomLine = UIView()
        donateBottomLine.backgroundColor = UIColor.blackColor()
        addSubview(donateBottomLine)
        donateBottomLine.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(donateLabel)
            make.top.equalTo(donateLabel.snp_bottom)
            make.height.equalTo(1.0)
            make.centerX.equalTo(donateLabel)
        }
    }
    


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}
