//
//  DateHelper.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/4/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import Foundation

class DateHelper {
    static let sharedInstance = DateHelper()
    
    let dateFormatter: NSDateFormatter
    let videoFormatter: NSDateFormatter
    let monthFormatter: NSDateFormatter
    let dayFormatter: NSDateFormatter
    
    init() {
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        
        videoFormatter = NSDateFormatter()
        videoFormatter.dateFormat  = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        monthFormatter = NSDateFormatter()
        monthFormatter.dateFormat = "MMM"

        dayFormatter = NSDateFormatter()
        dayFormatter.dateFormat = "dd"
    }
}
