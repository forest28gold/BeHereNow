//
//  SearchTableViewCell.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/29/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    var searchImageView = UIImageView()
    let gradientLayer = CAGradientLayer()
    let typeLabel = UILabel()
    let mainLabel = UILabel()
    let subtitleLabel = UILabel()
    let bottomLine = UIView()
    let playImageView = UIImageView()
    let episodeCircle = UIView()
    let episodeNumberLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .None
        
        gradientLayer.colors = [UIColor.bhnPodcastBlue().CGColor, UIColor.bhnGradientBlue().CGColor]
        gradientLayer.frame = contentView.bounds
        contentView.layer.insertSublayer(gradientLayer, atIndex: 0)
        
        contentView.addSubview(searchImageView)
        
        searchImageView.contentMode = .ScaleAspectFill
        searchImageView.clipsToBounds = true
        searchImageView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(65.0, 65.0))
            make.left.equalTo(contentView)
            make.top.equalTo(contentView)
        }
        
        playImageView.image = UIImage(named: "VideoPlayArrow")
        playImageView.contentMode = .ScaleAspectFit
        searchImageView.addSubview(playImageView)
        
        playImageView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(48.0, 48.0))
            make.center.equalTo(searchImageView)
        }
        
        episodeCircle.backgroundColor = UIColor.bhnLightBlue().colorWithAlphaComponent(0.7)
        episodeCircle.layer.cornerRadius = 24.0
        contentView.addSubview(episodeCircle)
        
        episodeCircle.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(48.0, 48.0))
            make.center.equalTo(searchImageView)
        }
        
        let episodeTitleLabel = UILabel()
        episodeTitleLabel.text = "EP"
        episodeTitleLabel.font = UIFont(name: "BentonSans-Book", size: 14.0)
        episodeTitleLabel.textAlignment = .Center
        episodeTitleLabel.sizeToFit()
        episodeTitleLabel.textColor = UIColor.bhnTextDarkBlue()
        episodeCircle.addSubview(episodeTitleLabel)
        
        episodeTitleLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(episodeCircle).offset(10.0)
            make.centerX.equalTo(episodeCircle)
        }
        
        episodeNumberLabel.font = UIFont(name:"Didot-Bold", size: 19.0)
        episodeNumberLabel.textAlignment = .Center
        episodeNumberLabel.textColor = UIColor.bhnTextDarkBlue()
        episodeCircle.addSubview(episodeNumberLabel)
        
        episodeNumberLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(episodeTitleLabel.snp_bottom).offset(-5.0)
            make.centerX.equalTo(episodeTitleLabel)
        }
        
        typeLabel.font = UIFont(name: "BentonSans-Medium", size: 10.0)
        typeLabel.textColor = UIColor.bhnTextDarkBlue()
        contentView.addSubview(typeLabel)
        typeLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(searchImageView.snp_right).offset(10.0)
            make.top.equalTo(contentView).offset(9.0)
        }

        mainLabel.font = UIFont(name: "BentonSans-Regular", size: 16.0)
        mainLabel.textColor = UIColor.bhnTextDarkBlue()
        contentView.addSubview(mainLabel)
        mainLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(searchImageView.snp_right).offset(10.0)
            make.right.equalTo(contentView).offset(-10.0)
            make.centerY.equalTo(contentView)
        }
        
        subtitleLabel.font = UIFont(name: "BentonSans-Book", size: 13.0)
        subtitleLabel.textColor = UIColor.bhnTextDarkBlue()
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(searchImageView.snp_right).offset(10.0)
            make.right.equalTo(contentView).offset(-10.0)
            make.top.equalTo(mainLabel.snp_bottom).offset(3.0)
        }
        
        let topLine = UIView()
        topLine.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(topLine)
        topLine.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView)
            make.width.equalTo(contentView)
            make.centerX.equalTo(contentView)
            make.height.equalTo(0.5)
        }
        
        bottomLine.hidden = true
        bottomLine.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(bottomLine)
        bottomLine.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(contentView)
            make.width.equalTo(contentView)
            make.centerX.equalTo(contentView)
            make.height.equalTo(0.5)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = contentView.bounds
    }
    
    func configureForContent(content: Content, isLast: Bool) {
        bottomLine.hidden = !isLast
        
        if let article = content as? Article {
            typeLabel.text = article.isVideo ? "VIDEO" : "ARTICLE"
            playImageView.hidden = !article.isVideo
            episodeCircle.hidden = true
            mainLabel.text = article.title
            if let url = NSURL(string: article.imageUrl) {
                searchImageView.image = nil
                searchImageView.af_setImageWithURL(url, placeholderImage: nil, imageTransition: .CrossDissolve(0.5), runImageTransitionIfCached: false)
            }
            subtitleLabel.text = article.date.timeAgoSinceNow()
        }
        if let podcast = content as? Podcast {
            typeLabel.text = "PODCAST"
            playImageView.hidden = true
            episodeCircle.hidden = false
            episodeNumberLabel.text = podcast.episodeNumberString
            mainLabel.text = podcast.title
            if let url = NSURL(string: podcast.imageUrl) {
                searchImageView.image = nil
                searchImageView.af_setImageWithURL(url, placeholderImage: nil, imageTransition: .CrossDissolve(0.5), runImageTransitionIfCached: false)
            }
            subtitleLabel.text = podcast.date.timeAgoSinceNow() + " - " + podcast.duration
        }
    }
}
