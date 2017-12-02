//
//  Wisdom.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/2/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit

protocol Content {
    
}

struct Wisdom: Content {
    var date: NSDate
    var title: String = ""
    var quote: String = ""
    var author: String = ""
    var link: String = ""
    
    init(quoteString: String, title aTitle: String, dateString: String, link aLink: String) {
        title = aTitle
        if let wisdomDate = DateHelper.sharedInstance.videoFormatter.dateFromString(dateString) {
            date = wisdomDate
        } else {
            date = NSDate()
        }
        let parts = quoteString.componentsSeparatedByString("-")
        if parts.count > 1 {
            if let lastPart = parts.last {
                let nonAlphanumericSet = NSCharacterSet.alphanumericCharacterSet().invertedSet
                author = lastPart.stringByTrimmingCharactersInSet(nonAlphanumericSet)
                quote = quoteString.stringByReplacingOccurrencesOfString(lastPart, withString: "").stringByTrimmingCharactersInSet(nonAlphanumericSet)
            }
        }
        if quote == "" {
            quote = quoteString.stringByReplacingOccurrencesOfString("\"", withString: "")
        }
        link = aLink
    }
    
    func image(row: Int) -> UIImage? {
        var imageName = ""
        switch (author) {
            case "Ram Dass": imageName = "RamDassImage"
            case "Rumi": imageName = "RumiImage"
            case "Sharon Salzberg": imageName = "SharonSalzbergImage"
            case "Jack Kornfield": imageName = "JackKornfieldImage"
            case "Krishna Das": imageName = "KrishnaDasImage"
            case "Thich Nhat Hanh": imageName = "ThichNatHanImage"
            case "The Dalai Lama": imageName = "DalaiLamaImage"
            case "HH The Dalai Lama": imageName = "DalaiLamaImage"
            case "His Holiness the Dalai Lama": imageName = "DalaiLamaImage"
            case "His Holiness The Dalai Lama": imageName = "DalaiLamaImage"
            case "Ramana Maharshi": imageName = "RamanaMaharshiImage"
            case "Neem Karoli Baba (Maharajji)": imageName = "MaharajiImage"
            case "Neem Karoli Baba (Maharajji": imageName = "MaharajiImage"
            case "Neem Karoli Baba": imageName = "MaharajiImage"
            case "Chogyam Trungpa": imageName = "TrungpaImage"
            case "Chogyam Trungpa Rinpoche": imageName = "TrungpaImage"
            case "Chögyam Trungpa": imageName = "TrungpaImage"
            case "Chögyam Trungpa Rinpoche": imageName = "TrungpaImage"
        default:
            if row % 6 == 0 { imageName = "WowPlaceholderBlue" }
            if row % 6 == 1 { imageName = "WowPlaceholderGreen" }
            if row % 6 == 2 { imageName = "WowPlaceholderOrange" }
            if row % 6 == 3 { imageName = "WowPlaceholderBlue2" }
            if row % 6 == 4 { imageName = "WowPlaceholderGreen2" }
            if row % 6 == 5 { imageName = "WowPlaceholderOrange" }
        }
        
        return UIImage(named: imageName)
    }
}
