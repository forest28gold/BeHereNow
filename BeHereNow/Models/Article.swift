//
//  Article.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/4/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import Foundation

struct NextPageToken: Content {
    let token: String

    init (token aToken: String) {
        token = aToken
    }
}

struct Article: Content {
    let isVideo: Bool
    let title: String
    let author: String
    let url: String
    let imageUrl: String
    let date: NSDate
    
    init(title aTitle: String, url aUrl: String, imageUrl anImageUrl: String, dateString: String, author anAuthor:String, isVideo isAVideo: Bool) {
        isVideo = isAVideo
        title = aTitle
        author = anAuthor
        url = aUrl
        imageUrl = anImageUrl
        if let formattedDate = DateHelper.sharedInstance.dateFormatter.dateFromString(dateString) {
            date = formattedDate
        } else if let videoFormattedDate = DateHelper.sharedInstance.videoFormatter.dateFromString(dateString) {
            date = videoFormattedDate
        } else {
            date = NSDate()
        }
    }
}
