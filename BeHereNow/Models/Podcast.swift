//
//  Podcast.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/7/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import Foundation

struct Podcast: Content {
    let episodeNumberString: String
    let title: String
    let url: String
    let imageUrl: String
    let date: NSDate
    let duration: String
    let description: String
    
    init(title aTitle: String, url aUrl: String, imageUrl anImageUrl: String, dateString: String, duration aDuration: String, description aDescription: String) {
        let titleParts = aTitle.componentsSeparatedByString("–")
        if (titleParts.count == 2) {
            episodeNumberString = titleParts[0].stringByReplacingOccurrencesOfString("Ep.", withString: "").stringByReplacingOccurrencesOfString("Episode", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                title = titleParts[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        } else {
            let titleParts = aTitle.componentsSeparatedByString(":")
            if (titleParts.count == 2) {
                episodeNumberString = titleParts[0].stringByReplacingOccurrencesOfString("Ep.", withString: "").stringByReplacingOccurrencesOfString("Episode", withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                title = titleParts[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            } else {
                title = aTitle
                episodeNumberString = "0"
            }
        }
        url = aUrl
        imageUrl = anImageUrl
        if let formattedDate = DateHelper.sharedInstance.dateFormatter.dateFromString(dateString) {
            date = formattedDate
        } else {
            date = NSDate()
        }
        duration = aDuration
        description = FormattingHelper.stripHTML(aDescription)
    }
}
