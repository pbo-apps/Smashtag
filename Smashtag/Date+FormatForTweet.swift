//
//  Date+FormatForTweet.swift
//  Smashtag
//
//  Created by Pete Bounford on 02/03/2017.
//  Copyright © 2017 PBO Apps. All rights reserved.
//

import Foundation

extension Date {
    func formatForTweet() -> String {
        let formatter = DateFormatter()
        if NSDate().timeIntervalSince(self) > 24*60*60 {
            formatter.dateStyle = DateFormatter.Style.short
        } else {
            formatter.timeStyle = DateFormatter.Style.short
        }
        return formatter.string(from: self)
    }
}
