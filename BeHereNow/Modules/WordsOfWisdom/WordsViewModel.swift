//
//  WordsViewModel.swift
//  BeHereNow
//
//  Created by AppsCreationTech on 2/1/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

import ReactiveCocoa

class WordsViewModel {
    func loadWisdom() -> Signal<String, NSError> {
        if let signal = ContentCache.sharedInstance.wisdomSignal {
            return signal
        } else {
            return ContentCache.sharedInstance.loadWisdom()
        }
    }

    func didDeleteDonations() -> Bool { return ContentCache.sharedInstance.didDeleteDonations }
    
    func isLoading() -> Bool { return ContentCache.sharedInstance.isLoadingWisdom }
    
    func didLoadAll() -> Bool { return ContentCache.sharedInstance.didLoadAllWisdom }
    
    func didCompleteInitialLoad() -> Bool { return ContentCache.sharedInstance.wisdom.count > 0 }
    
    func numberOfRows() -> Int { return ContentCache.sharedInstance.wisdom.count + (didDeleteDonations() ? 0 : 1) }
    
    func wisdomForRow(row: Int) -> Wisdom { return ContentCache.sharedInstance.wisdom[row - (didDeleteDonations() ? 0 : 1)] }
}
