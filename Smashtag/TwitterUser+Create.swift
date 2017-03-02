//
//  TwitterUser+Create.swift
//  Smashtag
//
//  Created by Pete Bounford on 01/03/2017.
//  Copyright © 2017 PBO Apps. All rights reserved.
//

import Foundation
import CoreData
import Twitter

extension TwitterUser {
    
    class func create(from twitterInfo: Twitter.User, for context: NSManagedObjectContext)  -> TwitterUser {
        let request: NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
        request.predicate = NSPredicate(format: "screenName = %@", twitterInfo.screenName)
        do {
            if let twitterUser = (try context.fetch(request)).first {
                return twitterUser
            }
        } catch {
            print("\(error)")
        }
        let twitterUser = TwitterUser(context: context)
        twitterUser.screenName = twitterInfo.screenName
        twitterUser.name = twitterInfo.name
        return twitterUser
    }
    
}
