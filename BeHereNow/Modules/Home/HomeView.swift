//
//  HomeView.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 1/25/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit
import SnapKit

protocol HomeViewDelegate {
    func homeViewDidSelectSection(homeView: HomeView, section: Section)
    func homeViewMenuButtonWasTapped(homeView: HomeView)
    func homeViewThreeDotMenuButtonWasTapped(homeView: HomeView)
}

enum CircleState {
    case BeHereNow
    case Maharaji
    case RamDass
}

class HomeView: UIView {
    static let texts = ["WORDS\n OF WISDOM", "ARTICLES", "VIDEOS", "PODCASTS"]
    
    var showFullLines = false
    var delegate: HomeViewDelegate?
    var viewsToHide = [UIView]()
    let menuButton = UIButton()

    var circleState = CircleState.BeHereNow
    let maharajiImageView = UIImageView()
    let ramDassImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        
        var size: CGFloat = 230.0
        if DeviceType.IS_IPHONE_6P { size = 255.0 }
        if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 { size = 200.0 }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = 45.0
        
        let attributedString = NSAttributedString(string: "BE\nHERE\nNOW", attributes:[NSParagraphStyleAttributeName: paragraphStyle])
        
        let centerLabel = UILabel()
        centerLabel.userInteractionEnabled = true
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
        
        maharajiImageView.frame = centerLabel.bounds
        maharajiImageView.alpha = 0.0
        maharajiImageView.image = UIImage(named: "MaharajiCircle")
        maharajiImageView.contentMode = .ScaleAspectFill
        centerLabel.addSubview(maharajiImageView)
        
        maharajiImageView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(centerLabel)
            make.center.equalTo(centerLabel)
        }
        
        ramDassImageView.frame = centerLabel.bounds
        ramDassImageView.alpha = 0.0
        ramDassImageView.image = UIImage(named: "RamDassCircle")
        ramDassImageView.contentMode = .ScaleAspectFill
        centerLabel.addSubview(ramDassImageView)
        
        ramDassImageView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(centerLabel)
            make.center.equalTo(centerLabel)
        }
        
        let centerButton = UIButton()
        centerLabel.addSubview(centerButton)
        centerButton.addTarget(self, action: #selector(HomeView.centerButtonWasTapped), forControlEvents: .TouchUpInside)
        centerButton.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(centerLabel)
            make.center.equalTo(centerLabel)
        }
        
        menuButton.setImage(UIImage(named: "MenuButton"), forState: .Normal)
        menuButton.addTarget(self, action: #selector(HomeView.menuButtonWasTapped), forControlEvents: .TouchUpInside)
        menuButton.backgroundColor = UIColor.bhnLightBlue()
        
        addSubview(menuButton)
        menuButton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(32.0)
            make.size.equalTo(CGSizeMake(62.0, 40.0))
        }
        
        let threeDotButton = UIButton()
        threeDotButton.backgroundColor = UIColor.bhnLightBlue()
        threeDotButton.setImage(UIImage(named: "ThreeDotIcon"), forState: .Normal)
        threeDotButton.addTarget(self, action: #selector(HomeView.threeDotButtonWasTapped), forControlEvents: .TouchUpInside)
        addSubview(threeDotButton)
        
        threeDotButton.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self).offset(-20.0)
            make.centerX.equalTo(self)
        }
        
        for i in 0...3 { addButton(i) }
        
        setNeedsDisplay()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addButton(number: Int) {
        let x = number % 2
        let y = number / 2
        let numberLabel = UILabel()
        numberLabel.text = "\(number + 1)"
        numberLabel.textAlignment = .Center
        numberLabel.font = UIFont(name: "Didot-Bold", size: 44.0)
        numberLabel.textColor = UIColor.bhnDarkBlue()

        addSubview(numberLabel)

        numberLabel.snp_makeConstraints { (make) -> Void in
            if x == 0 { make.left.equalTo(self).offset(17.0) } else { make.right.equalTo(self).offset(-17.0) }
            if y == 0 { make.top.equalTo(self).offset(38.0) } else { make.bottom.equalTo(self).offset(-38.0) }
            make.size.equalTo(CGSizeMake(47.0, 52.0))
        }

        let textLabel = UILabel()
        textLabel.text = HomeView.texts[number]
        textLabel.textAlignment = .Center
        textLabel.numberOfLines = (number == 0) ? 2 : 1
        textLabel.font = UIFont(name: "BentonSans-Book", size: 11.0)
        textLabel.textColor = UIColor.bhnDarkBlue()
        addSubview(textLabel)
        
        textLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(numberLabel)
            make.top.equalTo(numberLabel.snp_bottom).offset(0.0)
        }

        let sectionButton = UIButton()
        sectionButton.addTarget(self, action: #selector(HomeView.sectionButtonWasTapped(_:)), forControlEvents: .TouchUpInside)
        sectionButton.tag = number
        addSubview(sectionButton)
        
        sectionButton.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(80.0, 100.0))
            if x == 0 { make.left.equalTo(self) } else { make.right.equalTo(self) }
            if y == 0 { make.top.equalTo(self) } else { make.bottom.equalTo(self) }
        }
        
        viewsToHide.append(numberLabel)
        viewsToHide.append(textLabel)
    }
    
    func updateViews(hidden: Bool) {
        for view in viewsToHide {
            view.alpha = hidden ? 0.0 : 1.0
        }
        showFullLines = hidden
        menuButton.backgroundColor = hidden ? UIColor.clearColor() : UIColor.bhnLightBlue()
        setNeedsDisplay()
    }
    
    func sectionButtonWasTapped(button: UIButton) {
        if let delegate = delegate, let section = Section(rawValue: button.tag) { delegate.homeViewDidSelectSection(self, section: section) }
    }
    
    func menuButtonWasTapped() {
        if let delegate = delegate { delegate.homeViewMenuButtonWasTapped(self) }
    }
    
    func threeDotButtonWasTapped() {
        if let delegate = delegate { delegate.homeViewThreeDotMenuButtonWasTapped(self) }
    }
    
    func centerButtonWasTapped() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            switch self.circleState {
            case .BeHereNow:
                self.maharajiImageView.alpha = 1.0
                self.circleState = .Maharaji
            case .Maharaji:
                self.ramDassImageView.alpha = 1.0
                self.circleState = .RamDass
            case .RamDass:
                self.ramDassImageView.alpha = 0.0
                self.maharajiImageView.alpha = 0.0
                self.circleState = .BeHereNow
            }
            }) { (Bool) -> Void in
                switch self.circleState {
                case .BeHereNow: break
                case .Maharaji: break
                case .RamDass: self.maharajiImageView.alpha = 0.0
                }
        }
        UIView.animateWithDuration(0.5) { () -> Void in
        }
    }
    
    override func drawRect(rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            CGContextSetStrokeColorWithColor(context, UIColor(white: 1.0, alpha: 0.7).CGColor)
            if showFullLines {
                DrawingHelper.strokeLine(context, fromX: 6.0, fromY: 0.0, toX: rect.size.width - 7.0, toY: rect.size.height)
                DrawingHelper.strokeLine(context, fromX: 7.0, fromY: rect.size.height, toX: rect.size.width - 6.0, toY: 0.0)
                DrawingHelper.strokeLine(context, fromX: rect.size.width/2, fromY: 0.0, toX: rect.size.width/2, toY: rect.size.height)
                
                DrawingHelper.strokeLine(context, fromX: 41.5, fromY: 0.0, toX: 41.5, toY: rect.size.height)
                DrawingHelper.strokeLine(context, fromX: 0.0, fromY: 66.0, toX: rect.size.width, toY: 66.0)
                DrawingHelper.strokeLine(context, fromX: rect.size.width - 41.5, fromY: 0.0, toX: rect.size.width - 41.5, toY: rect.size.height)
                DrawingHelper.strokeLine(context, fromX: 0.0, fromY: rect.size.height - 65.0, toX: rect.size.width, toY: rect.size.height - 65.0)
                
                DrawingHelper.strokeLine(context, fromX: 74.0, fromY: 0.0, toX: 0.0, toY: 150.0)
                DrawingHelper.strokeLine(context, fromX: rect.size.width - 74.0, fromY: 0.0, toX: rect.size.width, toY: 150.0)

                DrawingHelper.strokeLine(context, fromX: 73.0, fromY: rect.size.height, toX: 0.0, toY: rect.size.height - 150.0)
                DrawingHelper.strokeLine(context, fromX: rect.size.width - 73.0, fromY: rect.size.height, toX: rect.size.width, toY: rect.size.height - 150.0)
            } else {
                DrawingHelper.strokeLine(context, fromX: 70.0, fromY: 115.0, toX: rect.size.width - 70.0, toY: rect.size.height - 95.0)
                DrawingHelper.strokeLine(context, fromX: 70.0, fromY: rect.size.height - 95.0, toX: rect.size.width - 70.0, toY: 115.0)
                DrawingHelper.strokeLine(context, fromX: rect.size.width/2, fromY: 105.0, toX: rect.size.width/2, toY: rect.size.height - 85.0)
                
                DrawingHelper.strokeLine(context, fromX: 42.0, fromY: 120.0, toX: 42.0, toY: rect.size.height - 100.0)
                DrawingHelper.strokeLine(context, fromX: 70.0, fromY: 65.0, toX: rect.size.width - 70.0, toY: 65.0)
                DrawingHelper.strokeLine(context, fromX: rect.size.width - 42.0, fromY: 120.0, toX: rect.size.width - 42.0, toY: rect.size.height - 100.0)
                
                DrawingHelper.strokeLine(context, fromX: 42.0, fromY: 0.0, toX: 42.0, toY: 30.0)
                DrawingHelper.strokeLine(context, fromX: rect.size.width - 42.0, fromY: 0.0, toX: rect.size.width - 42.0, toY: 30.0)
                DrawingHelper.strokeLine(context, fromX: 42.0, fromY: rect.size.height - 20.0, toX: 42.0, toY: rect.size.height)
                DrawingHelper.strokeLine(context, fromX: rect.size.width - 42.0, fromY: rect.size.height - 20.0, toX: rect.size.width - 42.0, toY: rect.size.height)
                
                DrawingHelper.strokeLine(context, fromX: 9.0, fromY: 0.0, toX: 24.0, toY: 30.0)
                DrawingHelper.strokeLine(context, fromX: rect.size.width - 9.0, fromY: 0.0, toX: rect.size.width - 24.0, toY: 30.0)
                DrawingHelper.strokeLine(context, fromX: 11.0, fromY: rect.size.height, toX: 22.0, toY: rect.size.height - 20.0)
                DrawingHelper.strokeLine(context, fromX: rect.size.width - 11.0, fromY: rect.size.height, toX: rect.size.width - 22.0, toY: rect.size.height - 20.0)
                
                DrawingHelper.strokeLine(context, fromX: 71.0, fromY: 0.0, toX: 56.0, toY: 30.0)
                DrawingHelper.strokeLine(context, fromX: rect.size.width - 71.0, fromY: 0.0, toX: rect.size.width - 56.0, toY: 30.0)
                DrawingHelper.strokeLine(context, fromX: 69.0, fromY: rect.size.height, toX: 58.0, toY: rect.size.height - 20.0)
                DrawingHelper.strokeLine(context, fromX: rect.size.width - 69.0, fromY: rect.size.height, toX: rect.size.width - 58.0, toY: rect.size.height - 20.0)
                
                DrawingHelper.strokeLine(context, fromX: 0.0, fromY: 144.0 , toX: 15.0, toY: 116.0)
                DrawingHelper.strokeLine(context, fromX: rect.size.width, fromY: 144.0 , toX: rect.size.width - 15.0, toY: 116.0)
                DrawingHelper.strokeLine(context, fromX: rect.size.width, fromY: rect.size.height - 124.0 , toX: rect.size.width - 15.0, toY: rect.size.height - 96.0)
                DrawingHelper.strokeLine(context, fromX: 0.0, fromY: rect.size.height - 124.0 , toX: 15.0, toY: rect.size.height - 96.0)

                DrawingHelper.strokeLine(context, fromX: 70.0, fromY: rect.size.height - 65.0, toX: rect.size.width - 70.0, toY: rect.size.height - 65.0)
                
                
                DrawingHelper.strokeLine(context, fromX: rect.size.width/2, fromY: 0.0, toX: rect.size.width/2, toY: rect.size.height)
                
                
                DrawingHelper.strokeLine(context, fromX: 0.0, fromY: 65.0, toX: 15.0, toY: 65.0)
                DrawingHelper.strokeLine(context, fromX: 0.0, fromY: rect.size.height - 65.0, toX: 15.0, toY: rect.size.height - 65.0)
                DrawingHelper.strokeLine(context, fromX: rect.size.width - 15.0, fromY: 65.0, toX: rect.size.width, toY: 65.0)
                DrawingHelper.strokeLine(context, fromX: rect.size.width - 15.0, fromY: rect.size.height - 65.0, toX: rect.size.width, toY: rect.size.height - 65.0)
            }
            
            DrawingHelper.strokeLine(context, fromX: 0.0, fromY: rect.size.height/2, toX: rect.size.width, toY: rect.size.height/2)
            DrawingHelper.strokeLine(context, fromX: 50.0, fromY: rect.size.height/2, toX: rect.size.width - 50.0, toY: rect.size.height/2)
        }
    }
}
