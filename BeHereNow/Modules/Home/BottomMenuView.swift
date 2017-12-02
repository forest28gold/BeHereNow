//
//  BottomMenuView.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/3/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit
import SnapKit

protocol BottomMenuDelegate {
    func bottomMenuDidSelectSection(bottomMenu: BottomMenuView, section: Section)
    func bottomMenuThreeDotsIconWasTapped(bottomMenu: BottomMenuView)
}

class BottomMenuView: UIView {
    static let texts = ["WOW", "ARTICLES", "VIDEOS", "PODCASTS"]
    static let positions = [0.25, 0.65, 1.35, 1.75]
    
    var delegate: BottomMenuDelegate?
    
    var selectorView = UIView()
    var selectedTab = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        backgroundColor = UIColor.bhnLightBlue()

        addSelectorView()
        for i in 0...3 { addNumberLabel(i) }
        
        let threeDotButton = UIButton()
        threeDotButton.setImage(UIImage(named: "ThreeDotIcon"), forState: .Normal)
        threeDotButton.addTarget(self, action: #selector(didTapThreeDotIcon), forControlEvents: .TouchUpInside)
        addSubview(threeDotButton)
        
        threeDotButton.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self).offset(-20.0)
            make.centerX.equalTo(self)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSelectorView() {
        selectorView.backgroundColor = UIColor.bhnSelectorBlue()
        selectorView.layer.cornerRadius = 28.0
        selectorView.layer.borderWidth = 0.5
        selectorView.layer.borderColor = UIColor.whiteColor().CGColor
        addSubview(selectorView)
        
        updateSelectorViewConstraints()
    }
    
    func updateSelectorViewConstraints () {
        selectorView.snp_remakeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(56.0, 56.0))
            make.centerX.equalTo(self).multipliedBy(BottomMenuView.positions[selectedTab])
            make.bottom.equalTo(self).offset(6.0)
        }
    }
    
    func addNumberLabel(index: Int) {
        let numberLabel = UILabel()
        numberLabel.text = "\(index + 1)"
        numberLabel.textAlignment = .Center
        numberLabel.font = UIFont(name: "Didot-Bold", size: 25.0)
        numberLabel.textColor = UIColor.bhnDarkBlue()
        numberLabel.sizeToFit()
        
        addSubview(numberLabel)
        numberLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self).multipliedBy(BottomMenuView.positions[index])
            make.bottom.equalTo(self)
        }
        
        let textLabel = UILabel()
        textLabel.text = BottomMenuView.texts[index]
        textLabel.textAlignment = .Center
        textLabel.font = UIFont(name: "BentonSans-Book", size: 8.5)
        textLabel.textColor = UIColor.bhnDarkBlue()
        addSubview(textLabel)
        
        textLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(numberLabel)
            make.bottom.equalTo(numberLabel.snp_top).offset(2.0)
        }
        
        let button = UIButton()
        button.tag = index
        button.addTarget(self, action: #selector(BottomMenuView.didTapTab(_:)), forControlEvents: .TouchUpInside)
        addSubview(button)
        button.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self).multipliedBy(BottomMenuView.positions[index])
            make.width.equalTo(60.0)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
    
    func updateSelectedTab(index: Int) {
        selectedTab = index
        updateSelectorViewConstraints()
    }
    
    func didTapTab(button: UIButton) {
        if selectedTab == button.tag { return }
        
        selectedTab = button.tag
        if let section = Section(rawValue: button.tag) {
            delegate?.bottomMenuDidSelectSection(self, section: section)
        }
        
        updateSelectorViewConstraints()
        UIView.animateWithDuration(0.5) { () -> Void in
            self.layoutIfNeeded()
        }
    }
    
    func didTapThreeDotIcon() {
        if let delegate = delegate {
            delegate.bottomMenuThreeDotsIconWasTapped(self)
        }
    }
    
    override func drawRect(rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            CGContextSetStrokeColorWithColor(context, UIColor(white: 1.0, alpha: 1.0).CGColor)
            
            DrawingHelper.strokeLine(context, fromX: 0.0, fromY: 0.0, toX: rect.size.width, toY: 0.0)
            DrawingHelper.strokeLine(context, fromX: rect.size.width/2, fromY: 0.0, toX: rect.size.width*0.5, toY: rect.size.height*0.3)
            DrawingHelper.strokeLine(context, fromX: rect.size.width/2, fromY: rect.size.height, toX: rect.size.width/2, toY: rect.size.height*0.75)
            
            DrawingHelper.strokeLine(context, fromX: 0.05*rect.size.width, fromY: rect.size.height, toX: 0.05*rect.size.width + 10.0, toY: rect.size.height - 16.0)
            DrawingHelper.strokeLine(context, fromX: 0.2*rect.size.width, fromY: rect.size.height, toX: 0.2*rect.size.width - 10.0, toY: rect.size.height - 16.0)
            DrawingHelper.strokeLine(context, fromX: 0.25*rect.size.width, fromY: rect.size.height, toX: 0.25*rect.size.width + 10.0, toY: rect.size.height - 16.0)
            DrawingHelper.strokeLine(context, fromX: 0.4*rect.size.width, fromY: rect.size.height, toX: 0.4*rect.size.width - 10.0, toY: rect.size.height - 16.0)
            DrawingHelper.strokeLine(context, fromX: 0.6*rect.size.width, fromY: rect.size.height, toX: 0.6*rect.size.width + 10.0, toY: rect.size.height - 16.0)
            DrawingHelper.strokeLine(context, fromX: 0.75*rect.size.width, fromY: rect.size.height, toX: 0.75*rect.size.width - 10.0, toY: rect.size.height - 16.0)
            DrawingHelper.strokeLine(context, fromX: 0.8*rect.size.width, fromY: rect.size.height, toX: 0.8*rect.size.width + 10.0, toY: rect.size.height - 16.0)
            DrawingHelper.strokeLine(context, fromX: 0.95*rect.size.width, fromY: rect.size.height, toX: 0.95*rect.size.width - 10.0, toY: rect.size.height - 16.0)
        }
    }
}
