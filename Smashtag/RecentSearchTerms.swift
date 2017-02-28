//
//  RecentSearchTerms.swift
//  Smashtag
//
//  Created by Pete Bounford on 27/02/2017.
//  Copyright © 2017 PBO Apps. All rights reserved.
//

import Foundation

class RecentSearchTerms {
    private static let defaultsKey = "RecentSearchTermsDefaultsKey"
    
    static func add(_ searchTerm: String) {
        var searchTerms = UserDefaults.standard.stringArray(forKey: RecentSearchTerms.defaultsKey) ?? [String]()
        
        if let index = searchTerms.index(where: { return searchTerm.caseInsensitiveCompare($0) == ComparisonResult.orderedSame }) {
            searchTerms.remove(at: index)
        } else if searchTerms.count == 100 {
            searchTerms.remove(at: 99)
        }
        
        searchTerms.insert(searchTerm.lowercased(), at: 0)
        
        UserDefaults.standard.set(searchTerms, forKey: RecentSearchTerms.defaultsKey)
    }
    
    static func get() -> [String] {
        return UserDefaults.standard.stringArray(forKey: RecentSearchTerms.defaultsKey) ?? [String]()
    }
}
