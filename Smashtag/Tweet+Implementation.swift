//
//  Tweet+Implementation.swift
//  Smashtag
//
//  Created by Pete Bounford on 28/02/2017.
//  Copyright © 2017 PBO Apps. All rights reserved.
//

import Foundation
import CoreData
import Twitter

extension Tweet {
    class func create(from twitterInfo: Twitter.Tweet, for context: NSManagedObjectContext) -> Tweet? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tweet")
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.identifier)
        
        // predicate is unique, so there should only be one or zero results in the returned array
        if let tweet = (try? context.fetch(request))?.first as? Tweet {
            return tweet
        } else {
            let tweet = Tweet(context: context)
            tweet.unique = twitterInfo.identifier
            tweet.text = twitterInfo.text
            tweet.posted = twitterInfo.created as NSDate?
            // TODO: Need to add TwitterUser creation as per 40:22 of lecture 11
            tweet.tweeter
        }
        
        return nil
    }
}
