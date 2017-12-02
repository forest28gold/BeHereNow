//
//  DrawingHelper.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/8/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit

class DrawingHelper {
    class func strokeLine(context: CGContextRef, fromX: CGFloat, fromY: CGFloat, toX: CGFloat, toY: CGFloat) {
        CGContextMoveToPoint(context, fromX, fromY)
        CGContextAddLineToPoint(context, toX, toY)
        
        CGContextSetLineWidth(context, 1.0)
        CGContextStrokePath(context)
        
    }    
}
