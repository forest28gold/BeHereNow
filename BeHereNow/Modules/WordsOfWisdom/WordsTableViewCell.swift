//
//  WordsTableViewCell.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/3/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit

class WordsTableViewCell: UITableViewCell {
    let dateLabel = UILabel()
    let quoteLabel = UILabel()
    let authorLabel = UILabel()
    let authorImageView = UIImageView()
    let shareButton = UIButton()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.clipsToBounds = true
        selectionStyle = .None
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
        
        contentView.snp_makeConstraints { (make) -> Void in
            make.height.greaterThanOrEqualTo(200.0)
            make.width.equalTo(self)
        }

        dateLabel.font = UIFont(name:"BentonSans-Regular", size: 11.5)
        dateLabel.textColor = UIColor.bhnTextDarkBlue()
        contentView.addSubview(dateLabel)
        
        dateLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(24.0)
            make.left.equalTo(contentView).offset(15.0)
        }
        
        contentView.addSubview(authorImageView)
        authorImageView.contentMode = .ScaleAspectFill
        authorImageView.clipsToBounds = false
        authorImageView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(128.0)
            make.height.equalTo(146.0)
            make.right.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 25.0
        let attributedSingleQuote = NSAttributedString(string: "“", attributes: [NSParagraphStyleAttributeName : paragraphStyle])
        
        let singleQuoteLabel = UILabel()
        singleQuoteLabel.attributedText = attributedSingleQuote
        singleQuoteLabel.font = UIFont(name: "BentonSans-Book", size: 19.0)
        singleQuoteLabel.numberOfLines = 0
        singleQuoteLabel.textColor = UIColor.bhnTextDarkBlue()
        singleQuoteLabel.sizeToFit()
        contentView.addSubview(singleQuoteLabel)
        
        singleQuoteLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(dateLabel.snp_bottom).offset(8.0)
            make.left.equalTo(contentView).offset(6.0)
        }
        
        quoteLabel.font = UIFont(name: "BentonSans-Book", size: 19.0)
        quoteLabel.numberOfLines = 0
        quoteLabel.textColor = UIColor.bhnTextDarkBlue()
        contentView.addSubview(quoteLabel)
        
        quoteLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(dateLabel.snp_bottom).offset(8.0)
            make.left.equalTo(contentView).offset(15.0)
            make.right.equalTo(contentView).offset(-110.0)
        }
        
        shareButton.setImage(UIImage(named: "WordsSourceIcon"), forState: .Normal)
        contentView.addSubview(shareButton)
        shareButton.snp_makeConstraints { (make) -> Void in
            make.top.greaterThanOrEqualTo(quoteLabel.snp_bottom).offset(15.0)
            make.left.equalTo(contentView).offset(15.0)
            make.bottom.equalTo(contentView).offset(-15.0)
        }
        
        authorLabel.font = UIFont(name:"BentonSans-Medium", size: 12.0)
        authorLabel.textColor = UIColor.bhnTextDarkBlue()
        authorLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(authorLabel)
        
        authorLabel.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(shareButton)
            make.left.equalTo(shareButton.snp_right).offset(10.0)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureForWisdom(wisdom: Wisdom, row: Int) {
        dateLabel.text = wisdom.title.uppercaseString
        dateLabel.sizeToFit()
        
        authorLabel.text = wisdom.author.uppercaseString
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 25.0
        
        let attributedQuote = NSAttributedString(string: wisdom.quote + "”", attributes: [NSParagraphStyleAttributeName : paragraphStyle])
        quoteLabel.attributedText = attributedQuote
        
        if row % 3 == 0 { backgroundColor = UIColor.bhnWisdomBlue() }
        if row % 3 == 1 { backgroundColor = UIColor.bhnWisdomGreen() }
        if row % 3 == 2 { backgroundColor = UIColor.bhnWisdomOrange() }
        
        if let image = wisdom.image(row) {
            authorImageView.image = image
        } else {
        }
    }
}

