//
//  PodcastsTopView.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/7/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit
import SnapKit

protocol PodcastsTopViewDelegate {
    func podcastsTopViewDidSelectIndex(podcastsTopView: PodcastsTopView, index: Int)
    func podcastsTopViewDidScrollToEnd(podcastsTopView: PodcastsTopView)
}

class PodcastsTopView: UIView {
    var delegate: PodcastsTopViewDelegate?
    
    var viewModel: PodcastViewModel
    
    var collectionView: UICollectionView!
    
    init(frame: CGRect, viewModel aViewModel: PodcastViewModel) {
        viewModel = aViewModel

        super.init(frame: frame)
                
        backgroundColor = UIColor.bhnPodcastBlue()
        
        let topEpisodeLabel = UILabel()
        topEpisodeLabel.text = "TOP EPISODES"
        topEpisodeLabel.font = UIFont(name: "Didot-Bold", size: 25.0)
        topEpisodeLabel.textColor = UIColor.bhnTextDarkBlue()
        addSubview(topEpisodeLabel)

        topEpisodeLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(7.0)
            make.centerX.equalTo(self)
        }

        let podcastLabel = UILabel()
        podcastLabel.text = "Ram Dass Here and Now"
        podcastLabel.font = UIFont(name: "BentonSans-Regular", size: 13.0)
        podcastLabel.textColor = UIColor.bhnTextDarkBlue()
        addSubview(podcastLabel)

        podcastLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(topEpisodeLabel.snp_bottom).offset(-4.0)
            make.centerX.equalTo(self)
        }
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .Horizontal
        
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: collectionViewLayout)
        collectionView.registerClass(PodcastsTopViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clearColor()
        addSubview(collectionView)
        
        collectionView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.left.equalTo(self).offset(0.0)
            make.bottom.equalTo(self)
            make.top.equalTo(self).offset(55.0)
        }
        
        let bottomWhiteLine = UIView()
        bottomWhiteLine.backgroundColor = UIColor.whiteColor()
        self.addSubview(bottomWhiteLine)
        bottomWhiteLine.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self)
            make.left.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(0.5)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PodcastsTopView: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfFeaturesPodcasts()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! PodcastsTopViewCell
        cell.configureForPodcast(viewModel.featuredPocastForRow(indexPath.row), placeholderImage: viewModel.placeholderImageForRow(indexPath.row))
        return cell
    }
}

extension PodcastsTopView: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let delegate = delegate {
            delegate.podcastsTopViewDidSelectIndex(self, index: indexPath.row)
        }
    }
}

extension PodcastsTopView: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return  CGSizeMake((bounds.size.width - 40.0)/3, bounds.size.width/2)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    }
}

extension PodcastsTopView: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if viewModel.isLoadingFeatured() || viewModel.didLoadAllFeatured() { return }
        
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let contentSize = scrollView.contentSize
        let inset = scrollView.contentInset;
        let x = offset.x + bounds.size.width - inset.right
        let w = contentSize.width
        
        let reload_distance: CGFloat = 20.0
        if( x > w + reload_distance) {
            if let delegate = delegate {
                delegate.podcastsTopViewDidScrollToEnd(self)
            }
        }
    }
}
