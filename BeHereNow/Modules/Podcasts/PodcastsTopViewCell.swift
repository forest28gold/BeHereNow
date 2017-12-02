//
//  PodcastsTopViewCell.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/7/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit
import AlamofireImage
import SnapKit

class PodcastsTopViewCell: UICollectionViewCell {
    var podcastImageView = UIImageView()
    var podcastTitleLabel = UILabel()
    let episodeNumberLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.bhnPodcastBlue().CGColor, UIColor.bhnGradientBlue().CGColor]
        gradientLayer.frame = contentView.bounds
        contentView.layer.insertSublayer(gradientLayer, atIndex: 0)
        
        contentView.addSubview(podcastImageView)
        podcastImageView.contentMode = .ScaleAspectFill
        podcastImageView.clipsToBounds = true
        podcastImageView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(contentView).offset(-10.0)
            make.height.equalTo(contentView.snp_width).offset(-10.0)
            make.top.equalTo(self)
            make.left.equalTo(self).offset(5.0)
        }
        
        let episodeCircle = UIView()
        episodeCircle.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        episodeCircle.layer.cornerRadius = 33.0
        podcastImageView.addSubview(episodeCircle)
        
        episodeCircle.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(66.0, 66.0))
            make.center.equalTo(podcastImageView)
        }
        
        let episodeTitleLabel = UILabel()
        episodeTitleLabel.text = "EP"
        episodeTitleLabel.font = UIFont(name: "BentonSans-Book", size: 14.0)
        episodeTitleLabel.textAlignment = .Center
        episodeTitleLabel.sizeToFit()
        episodeTitleLabel.textColor = UIColor.bhnTextDarkBlue()
        episodeCircle.addSubview(episodeTitleLabel)
        
        episodeTitleLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(episodeCircle).offset(22.0)
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
        
        contentView.addSubview(podcastTitleLabel)
        podcastTitleLabel.font = UIFont(name: "BentonSans-Book", size: 12.0)
        podcastTitleLabel.textColor = UIColor.bhnTextDarkBlue()
        podcastTitleLabel.textAlignment = .Center
        podcastTitleLabel.numberOfLines = 2

        podcastTitleLabel.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(podcastImageView)
            make.top.equalTo(podcastImageView.snp_bottom).offset(5.0)
            make.centerX.equalTo(contentView)
        }
        
        let arrowImageView = UIImageView(image: UIImage(named: "BluePlayArrow"))
        contentView.addSubview(arrowImageView)
        arrowImageView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(40.0, 40.0))
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-8.0)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureForPodcast(podcast: Podcast, placeholderImage: UIImage?) {
        podcastImageView.image = nil
        if let url = NSURL(string: podcast.imageUrl), let placeholderImage = placeholderImage {
            podcastImageView.af_setImageWithURL(url, placeholderImage: placeholderImage, imageTransition: .CrossDissolve(0.5), runImageTransitionIfCached: false)
        }
        
        podcastTitleLabel.text = podcast.title
        
        episodeNumberLabel.text = podcast.episodeNumberString
        episodeNumberLabel.sizeToFit()
    }
}
