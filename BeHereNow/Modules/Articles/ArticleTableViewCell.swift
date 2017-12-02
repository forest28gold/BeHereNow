//
//  ArticleTableViewCell.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/4/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit
import SnapKit
import AlamofireImage

class ArticleTableViewCell: UITableViewCell {
    var articleImageView = UIImageView()
    var articleLabel = UILabel()
    var monthLabel = UILabel()
    var dayLabel = UILabel()
    var playImageView = UIImageView()
    let shareButton = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        articleImageView.contentMode = .ScaleAspectFill
        articleImageView.clipsToBounds = true
        contentView.addSubview(articleImageView)

        articleImageView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(contentView)
        }
        
        playImageView.image = UIImage(named: "VideoPlayArrow")
        articleImageView.addSubview(playImageView)
        playImageView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(70.0, 70.0))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(31.0)
        }
        
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.bhnLightBlue()
        bottomView.alpha = 0.8
        contentView.addSubview(bottomView)

        bottomView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(contentView)
            make.height.equalTo(55.0)
            make.bottom.equalTo(contentView)
        }
        
        shareButton.setImage(UIImage(named: "WordsSourceIcon"), forState: .Normal)
        bottomView.addSubview(shareButton)
        
        shareButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bottomView).offset(16.0)
            make.left.equalTo(bottomView).offset(15.0)
            make.size.equalTo(CGSizeMake(25.0, 25.0))
        }
        
        articleLabel.font = UIFont(name:"BentonSans-Regular", size: 15.0)
        articleLabel.textColor = UIColor.bhnTextDarkBlue()
        bottomView.addSubview(articleLabel)
        
        articleLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(shareButton.snp_right).offset(12.0)
            make.top.equalTo(shareButton).offset(-1.0)
            make.right.equalTo(bottomView).offset(-20.0)
        }
        
        let dateCircle = UIView()
        dateCircle.backgroundColor = UIColor.whiteColor()
        dateCircle.layer.cornerRadius = 24.0
        contentView.addSubview(dateCircle)
        
        dateCircle.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(48, 48.0))
            make.top.equalTo(contentView).offset(13.0)
            make.right.equalTo(contentView).offset(-13.0)
        }
        
        monthLabel.font = UIFont(name:"BentonSans-Book", size: 13.0)
        monthLabel.textColor = UIColor.bhnTextDarkBlue()
        monthLabel.textAlignment = .Center
        dateCircle.addSubview(monthLabel)
        
        monthLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(dateCircle).offset(12.0)
            make.centerX.equalTo(dateCircle)
        }
        
        dayLabel.font = UIFont(name:"Didot-Bold", size: 19.0)
        dayLabel.textColor = UIColor.bhnTextDarkBlue()
        dayLabel.textAlignment = .Center
        dateCircle.addSubview(dayLabel)
        
        dayLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(monthLabel.snp_bottom).offset(-5.0)
            make.centerX.equalTo(dateCircle)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureForArticle(article: Article, hidePlayIcon: Bool, placeholderImage: UIImage?) {
        playImageView.hidden = hidePlayIcon
        
        articleLabel.text = article.title
        articleLabel.numberOfLines = 2
        
        monthLabel.text = DateHelper.sharedInstance.monthFormatter.stringFromDate(article.date).uppercaseString
        monthLabel.sizeToFit()
        
        dayLabel.text = DateHelper.sharedInstance.dayFormatter.stringFromDate(article.date)
        dayLabel.sizeToFit()
        
        articleImageView.image = nil
        if let url = NSURL(string: article.imageUrl), let placeholderImage = placeholderImage {
            articleImageView.af_setImageWithURL(url, placeholderImage: placeholderImage, imageTransition: .CrossDissolve(0.5), runImageTransitionIfCached: false)
        }
    }
}
