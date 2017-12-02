//
//  FormattingHelper.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/9/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import Foundation

class FormattingHelper {
    class func stripHTML(string: String) -> String {
        return string.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
    }
}
