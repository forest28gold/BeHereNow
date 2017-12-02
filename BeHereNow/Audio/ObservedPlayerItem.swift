//
//  ObservedPlayerItem.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/9/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ObservedPlayerItem: AVPlayerItem {
    weak var observer: NSObject?
    
    convenience init (asset: AVAsset, observer anObserver: NSObject, context: UnsafeMutablePointer<Void>) {
        self.init(asset: asset)
        observer = anObserver
        self.addObserver(anObserver, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: context)
    }
    
    deinit {
        if let unwrappedObserver = observer {
            self.removeObserver(unwrappedObserver, forKeyPath: "status")
        }
    }
}
