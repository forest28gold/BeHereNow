//
//  WisdomPushView.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/11/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit
import AlamofireImage

protocol PushViewDelegate {
    func pushViewShouldPresentActivityViewControllerWithItems(pushView: PushView, activityItems: [AnyObject])
    func pushViewShouldPresentPodcast(pushView: PushView, podcastIndex: Int)
    func pushViewShouldPresentArticle(pushView: PushView, article: Article)
}

class PushView: UIView {
    var delegate: PushViewDelegate?
    
    let viewModel: PushViewModel
    let quoteLabel = UILabel()
    
    init(frame: CGRect, contentType aContentType:Section, wisdom aWisdom: Wisdom?, podcastIndex aPodcastIndex: Int?, article anArticle: Article?) {
        viewModel = PushViewModel(contentType: aContentType, wisdom: aWisdom, podcastIndex: aPodcastIndex, article: anArticle)
        super.init(frame: frame)
        
        backgroundColor = UIColor.bhnPodcastBlue().colorWithAlphaComponent(0.8)
        
        let mainView = UIView()
        mainView.clipsToBounds = true
        mainView.layer.borderColor = UIColor.whiteColor().CGColor
        mainView.backgroundColor = UIColor.whiteColor()
        mainView.layer.borderWidth = 1.0
        addSubview(mainView)
        mainView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(65.0)
            make.left.equalTo(self).offset(40.0)
            make.bottom.equalTo(self).offset(-35.0)
            make.right.equalTo(self).offset(-40.0)
        }
        
        let pushCloseButton = UIButton()
        pushCloseButton.backgroundColor = UIColor.bhnPodcastBlue().colorWithAlphaComponent(0.8)
        pushCloseButton.setImage(UIImage(named: "PushCloseButton"), forState: .Normal)
        pushCloseButton.addTarget(self, action: #selector(PushView.close), forControlEvents: .TouchUpInside)
        addSubview(pushCloseButton)
        pushCloseButton.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(mainView.snp_top)
            make.size.equalTo(CGSizeMake(30.0, 28.0))
            make.centerX.equalTo(self)
        }
        
        let topView = UIView()
        topView.backgroundColor = UIColor.bhnWisdomBlue()
        mainView.addSubview(topView)
        topView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(mainView)
            make.height.equalTo(180.0)
            make.width.equalTo(mainView)
            make.centerX.equalTo(mainView)
        }
        
        if viewModel.contentType != .Wisdom {
            let topImageView = UIImageView()
            topImageView.contentMode = .ScaleAspectFill
            if let url = NSURL(string:viewModel.imageUrl()) {
                topImageView.af_setImageWithURL(url, imageTransition: .CrossDissolve(0.5))
            }
            topView.addSubview(topImageView)

            topImageView.snp_makeConstraints(closure: { (make) -> Void in
                make.size.equalTo(topView)
                make.center.equalTo(topView)
            })
            
        }
        
        let dateCircle = UIView()
        dateCircle.backgroundColor = UIColor.whiteColor()
        dateCircle.layer.cornerRadius = 24.0
        topView.addSubview(dateCircle)
        
        dateCircle.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(48, 48.0))
            make.top.equalTo(topView).offset(13.0)
            make.left.equalTo(topView).offset(13.0)
        }
        
        let monthLabel = UILabel()
        monthLabel.font = UIFont(name:"BentonSans-Book", size: 13.0)
        monthLabel.textColor = UIColor.bhnTextDarkBlue()
        monthLabel.textAlignment = .Center
        monthLabel.text = DateHelper.sharedInstance.monthFormatter.stringFromDate(viewModel.dateForContent()).uppercaseString
        dateCircle.addSubview(monthLabel)
        
        monthLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(dateCircle).offset(12.0)
            make.centerX.equalTo(dateCircle)
        }
        
        let dayLabel = UILabel()
        dayLabel.font = UIFont(name:"Didot-Bold", size: 19.0)
        dayLabel.textColor = UIColor.bhnTextDarkBlue()
        dayLabel.textAlignment = .Center
        dayLabel.text = DateHelper.sharedInstance.dayFormatter.stringFromDate(viewModel.dateForContent())
        dateCircle.addSubview(dayLabel)
        
        dayLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(monthLabel.snp_bottom).offset(-5.0)
            make.centerX.equalTo(dateCircle)
        }
        
        let bottomView = UIScrollView()
        bottomView.backgroundColor = UIColor.whiteColor()
        mainView.addSubview(bottomView)
        bottomView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(mainView).offset(180.0)
            make.width.equalTo(mainView)
            make.left.equalTo(mainView)
            make.bottom.equalTo(mainView).offset(-28.0)
        }
        
        if viewModel.contentType == .Wisdom {
            if let wisdom = viewModel.wisdom {
                let authorImageView = UIImageView()
                topView.addSubview(authorImageView)
                authorImageView.contentMode = .ScaleAspectFill
                
                let randomRow = Int(arc4random_uniform(6))
                
                if randomRow % 3 == 0 { topView.backgroundColor = UIColor.bhnWisdomBlue() }
                if randomRow % 3 == 1 { topView.backgroundColor = UIColor.bhnWisdomGreen() }
                if randomRow % 3 == 2 { topView.backgroundColor = UIColor.bhnWisdomOrange() }
                
                authorImageView.image = wisdom.image(randomRow)
                authorImageView.snp_makeConstraints { (make) -> Void in
                    make.width.equalTo(128.0)
                    make.height.equalTo(146.0)
                    make.right.equalTo(topView)
                    make.bottom.equalTo(topView)
                }
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.minimumLineHeight = 25.0
                let attributedSingleQuote = NSAttributedString(string: "“", attributes: [NSParagraphStyleAttributeName : paragraphStyle])
                
                let singleQuoteLabel = UILabel()
                singleQuoteLabel.attributedText = attributedSingleQuote
                singleQuoteLabel.font = UIFont(name: "BentonSans-Book", size: 20.0)
                singleQuoteLabel.numberOfLines = 0
                singleQuoteLabel.textColor = UIColor.bhnTextDarkBlue()
                singleQuoteLabel.sizeToFit()
                bottomView.addSubview(singleQuoteLabel)
                
                singleQuoteLabel.snp_makeConstraints { (make) -> Void in
                    make.top.equalTo(bottomView).offset(10.0)
                    make.left.equalTo(bottomView).offset(6.0)
                }
                
                quoteLabel.font = UIFont(name: "BentonSans-Book", size: 20.0)
                quoteLabel.textColor = UIColor.bhnTextDarkBlue()
                quoteLabel.numberOfLines = 0
                let attributedQuote = NSAttributedString(string: wisdom.quote + "”", attributes: [NSParagraphStyleAttributeName : paragraphStyle])
                quoteLabel.attributedText = attributedQuote
                quoteLabel.sizeToFit()
                bottomView.addSubview(quoteLabel)
                
                quoteLabel.snp_makeConstraints { (make) -> Void in
                    make.top.equalTo(bottomView).offset(10.0)
                    make.left.equalTo(bottomView).offset(15.0)
                    make.right.equalTo(bottomView).offset(-15.0)
                    make.bottom.equalTo(bottomView).offset(-60.0)
                    make.width.lessThanOrEqualTo(mainView).offset(-30.0)
                }
                
                let shareButton = UIButton()
                shareButton.setImage(UIImage(named: "WordsSourceIcon"), forState: .Normal)
                shareButton.addTarget(self, action: #selector(PushView.didTapShareButton), forControlEvents: .TouchUpInside)
                bottomView.addSubview(shareButton)
                
                shareButton.snp_makeConstraints { (make) -> Void in
                    make.top.equalTo(quoteLabel.snp_bottom).offset(15.0)
                    make.left.equalTo(bottomView).offset(15.0)
                    make.height.equalTo(25.0)
                }
                
                let authorLabel = UILabel()
                authorLabel.text = wisdom.author
                authorLabel.font = UIFont(name:"BentonSans-Medium", size: 12.0)
                authorLabel.textColor = UIColor.bhnTextDarkBlue()
                authorLabel.adjustsFontSizeToFitWidth = true
                bottomView.addSubview(authorLabel)
                
                authorLabel.snp_makeConstraints { (make) -> Void in
                    make.centerY.equalTo(shareButton)
                    make.left.equalTo(shareButton.snp_right).offset(10.0)
                }
            }
        } else {
            let shareButton = UIButton()
            shareButton.setImage(UIImage(named: "WordsSourceIcon"), forState: .Normal)
            shareButton.addTarget(self, action: #selector(PushView.didTapShareButton), forControlEvents: .TouchUpInside)
            bottomView.addSubview(shareButton)
            
            shareButton.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(bottomView).offset(20.0)
                make.left.equalTo(bottomView).offset(15.0)
                make.size.equalTo(CGSizeMake(25.0, 25.0))
            }
            
            let articleLabel = UILabel()
            articleLabel.userInteractionEnabled = true
            articleLabel.font = UIFont(name:"BentonSans-Medium", size: 14.0)
            articleLabel.textColor = UIColor.bhnTextDarkBlue()
            articleLabel.text = viewModel.contentTitle()
            if viewModel.contentType == .Podcasts { articleLabel.numberOfLines = 1 } else { articleLabel.numberOfLines = 4 }
            articleLabel.sizeToFit()
            bottomView.addSubview(articleLabel)
            
            articleLabel.snp_makeConstraints { (make) -> Void in
                make.left.equalTo(shareButton.snp_right).offset(12.0)
                make.width.equalTo(mainView).offset(-70.0)
                if viewModel.contentType == .Podcasts {
                    make.height.equalTo(14.0)
                    make.top.equalTo(shareButton)
                } else {
                    make.top.equalTo(shareButton).offset(-3.0)
                }
            }
            
            let titleButton = UIButton()
            titleButton.addTarget(self, action: #selector(PushView.didTapArticleButton), forControlEvents: .TouchUpInside)
            articleLabel.addSubview(titleButton)
            titleButton.snp_makeConstraints(closure: { (make) -> Void in
                make.center.equalTo(articleLabel)
                make.size.equalTo(articleLabel)
            })

            if viewModel.contentType == .Podcasts || viewModel.contentType == .Videos {
                let playButton = UIButton()
                playButton.addTarget(self, action: #selector(PushView.didTapPlayButton), forControlEvents: .TouchUpInside)
                playButton.setImage(UIImage(named: "VideoPlayArrow"), forState: .Normal)
                topView.addSubview(playButton)
                playButton.snp_makeConstraints { (make) -> Void in
                    make.size.equalTo(CGSizeMake(75.0, 75.0))
                    make.center.equalTo(topView)
                }
            } else {
                let articleButton = UIButton()
                articleButton.addTarget(self, action: #selector(PushView.didTapArticleButton), forControlEvents: .TouchUpInside)
                topView.addSubview(articleButton)
                articleButton.snp_makeConstraints(closure: { (make) -> Void in
                    make.center.equalTo(topView)
                    make.size.equalTo(topView)
                })
            }
            
            
            if viewModel.contentType == .Podcasts {
                if let podcast = viewModel.podcast {
                    let podcastLabel = UILabel()
                    podcastLabel.font = UIFont(name: "BentonSans-Book", size: 13.0)
                    podcastLabel.text = "Episode \(podcast.episodeNumberString) - \(podcast.duration)"
                    podcastLabel.textColor = UIColor.bhnTextDarkBlue()
                    bottomView.addSubview(podcastLabel)
                    
                    podcastLabel.snp_makeConstraints(closure: { (make) -> Void in
                        make.top.equalTo(articleLabel.snp_bottom).offset(2.0)
                        make.left.equalTo(articleLabel)
                        make.width.equalTo(mainView).offset(-70.0)
                    })
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.minimumLineHeight = 15.0
                    
                    let attributedString = NSAttributedString(string: podcast.description, attributes:[NSParagraphStyleAttributeName: paragraphStyle])
                    
                    quoteLabel.font = UIFont(name: "BentonSans-Book", size: 12.0)
                    quoteLabel.textColor = UIColor.bhnTextDarkBlue()
                    quoteLabel.numberOfLines = 0
                    quoteLabel.sizeToFit()
                    quoteLabel.attributedText = attributedString
                    bottomView.addSubview(quoteLabel)
                    
                    quoteLabel.snp_makeConstraints { (make) -> Void in
                        make.top.equalTo(podcastLabel).offset(30.0)
                        make.left.equalTo(bottomView).offset(15.0)
                        make.right.equalTo(bottomView).offset(-15.0)
                        make.bottom.equalTo(bottomView).offset(-60.0)
                        make.width.lessThanOrEqualTo(mainView).offset(-30.0)
                    }
                }
            }
        }
        
        let wisdomLine = UIView()
        wisdomLine.backgroundColor = UIColor.bhnTextDarkBlue()
        mainView.addSubview(wisdomLine)
        wisdomLine.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(mainView).offset(13.0)
            make.width.equalTo(mainView).offset(-26.0)
            make.height.equalTo(1.0)
            make.bottom.equalTo(mainView).offset(-28.0)
        }
        
        let wordsLabel = UILabel()
        wordsLabel.font = UIFont(name:"BentonSans-Regular", size: 10.0)
        wordsLabel.textColor = UIColor.bhnTextDarkBlue()
        wordsLabel.text = viewModel.contentTypeString()
        wordsLabel.sizeToFit()
        mainView.addSubview(wordsLabel)
        
        wordsLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(mainView).offset(13.0)
            make.bottom.equalTo(mainView).offset(-12.0)
        }
    }
    
    func close() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.alpha = 0.0
            }) { (Bool) in
                self.removeFromSuperview()
        }
    }
    
    func didTapPlayButton() {
        if viewModel.contentType == .Podcasts {
            if let podcastIndex = viewModel.podcastIndex, let delegate = delegate {
                delegate.pushViewShouldPresentPodcast(self, podcastIndex: podcastIndex)
            }
        }
        if viewModel.contentType == .Videos {
            if let video = viewModel.article, let delegate = delegate {
                delegate.pushViewShouldPresentArticle(self, article: video)
            }
        }
    }
    
    func didTapArticleButton() {
        if let article = viewModel.article, let delegate = delegate {
            delegate.pushViewShouldPresentArticle(self, article: article)
        }
    }
    
    func didTapShareButton() {
        if let wisdom = viewModel.wisdom {
            let shareString = wisdom.quote + " -" + wisdom.author
            if let delegate = delegate {
                if let url = NSURL(string:wisdom.link) {
                    delegate.pushViewShouldPresentActivityViewControllerWithItems(self, activityItems: [shareString, url])
                } else {
                    delegate.pushViewShouldPresentActivityViewControllerWithItems(self, activityItems: [shareString])
                }
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
