//
//  PodcastTableViewCell.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/7/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit
import SnapKit
import DateTools

class PodcastTableViewCell: UITableViewCell {
    let podcastLabel = UILabel()
    let dateDurationLabel = UILabel()
    let episodeNumberLabel = UILabel()
    let gradientLayer = CAGradientLayer()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.bhnPodcastBlue()        
        selectionStyle = .None
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
        
        gradientLayer.colors = [UIColor.bhnPodcastBlue().CGColor, UIColor.bhnGradientBlue().CGColor]
        gradientLayer.frame = contentView.bounds
        contentView.layer.insertSublayer(gradientLayer, atIndex: 0)

        let episodeCircle = UIView()
        episodeCircle.backgroundColor = UIColor.bhnLightBlue()
        episodeCircle.layer.cornerRadius = 24.0
        contentView.addSubview(episodeCircle)
        
        episodeCircle.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(48.0, 48.0))
            make.left.equalTo(self).offset(15.0)
            make.top.equalTo(self).offset(9.0)
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
        
        episodeNumberLabel.font = UIFont(name:"Didot-Bold", size: 21.0)
        episodeNumberLabel.textAlignment = .Center
        episodeNumberLabel.textColor = UIColor.bhnTextDarkBlue()
        episodeCircle.addSubview(episodeNumberLabel)
        
        episodeNumberLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(episodeTitleLabel.snp_bottom).offset(-5.0)
            make.centerX.equalTo(episodeTitleLabel)
        }
        
        podcastLabel.font = UIFont(name: "BentonSans-Regular", size: 16.0)
        podcastLabel.textColor = UIColor.bhnTextDarkBlue()
        contentView.addSubview(podcastLabel)
        
        podcastLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(19.0)
            make.left.equalTo(episodeCircle.snp_right).offset(12.0)
            make.right.equalTo(contentView).offset(-10.0)
        }
        
        dateDurationLabel.font = UIFont(name: "BentonSans-Book", size: 12.0)
        dateDurationLabel.textColor = UIColor.bhnTextDarkBlue()
        contentView.addSubview(dateDurationLabel)

        dateDurationLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(podcastLabel.snp_bottom).offset(2.0)
            make.left.equalTo(podcastLabel)
            make.right.equalTo(contentView).offset(-10.0)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = contentView.frame
    }
    
    func configureForPodcast(podcast: Podcast) {
        episodeNumberLabel.text = podcast.episodeNumberString
        episodeNumberLabel.sizeToFit()
        
        podcastLabel.text = podcast.title
        podcastLabel.sizeToFit()
        
        dateDurationLabel.text = podcast.date.timeAgoSinceNow() + " - " + podcast.duration
        dateDurationLabel.sizeToFit()
    }
}
