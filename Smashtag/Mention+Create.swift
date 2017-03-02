//
//  Mention+Create.swift
//  Smashtag
//
//  Created by Pete Bounford on 02/03/2017.
//  Copyright © 2017 PBO Apps. All rights reserved.
//

import Foundation
import CoreData
import Twitter

extension Mention {
    class func create(from twitterInfo: Twitter.Mention, for context: NSManagedObjectContext) -> Mention {
        let mentionName = twitterInfo.keyword.lowercased()
        let request: NSFetchRequest<Mention> = Mention.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", mentionName)
        
        // predicate is unique, so there should only be one or zero results in the returned array
        do {
            if let mention = (try context.fetch(request)).first {
                mention.count += 1
                return mention
            }
        } catch {
            print("\(error)")
        }
        let mention = Mention(context: context)
        mention.name = mentionName
        mention.count = 1
        return mention
    }
}
