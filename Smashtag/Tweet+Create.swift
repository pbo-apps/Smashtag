//
//  Tweet+Create.swift
//  Smashtag
//
//  Created by Pete Bounford on 28/02/2017.
//  Copyright © 2017 PBO Apps. All rights reserved.
//

import Foundation
import CoreData
import Twitter

extension Tweet {
    class func create(from twitterInfo: Twitter.Tweet, for context: NSManagedObjectContext) -> Tweet {
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.identifier)
        
        // predicate is unique, so there should only be one or zero results in the returned array
        do {
            if let tweet = (try context.fetch(request)).first {
                return tweet
            }
        } catch {
            print("\(error)")
        }
        let tweet = Tweet(context: context)
        tweet.unique = twitterInfo.identifier
        tweet.text = twitterInfo.text
        tweet.posted = twitterInfo.created as NSDate?
        tweet.tweeter = TwitterUser.create(from: twitterInfo.user, for: context)
        for twitterMention in twitterInfo.userMentions + twitterInfo.hashtags {
            tweet.addToMentions(Mention.create(from: twitterMention, for: context))
        }
        return tweet
    }
}
