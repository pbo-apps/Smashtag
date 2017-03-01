//
//  TweetersTableViewController.swift
//  Smashtag
//
//  Created by Pete Bounford on 01/03/2017.
//  Copyright © 2017 PBO Apps. All rights reserved.
//

import UIKit
import CoreData

class TweetersTableViewController: CoreDataTableViewController<TwitterUser> {

    // MARK: = Model
    var mention: String? { didSet { updateUI() } }
    var managedObjectContext: NSManagedObjectContext? { didSet { updateUI() } }
    
    private func updateUI() {
        if let context = managedObjectContext, mention != nil, mention!.characters.count > 0 {
            let request: NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
            request.predicate = NSPredicate(format: "any tweets.text contains[c] %@", mention!)
            request.sortDescriptors = [NSSortDescriptor(
                key: "screenName",
                ascending: true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )]
            fetchedResultsController = NSFetchedResultsController<TwitterUser>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
        } else {
            fetchedResultsController = nil
        }
    }
    
    // MARK: - Table view data source
    
    private struct Storyboard {
        static let TweeterCellIdentifier = "Twitter User Cell"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Twitter User Cell", for: indexPath)

        if let twitterUser = fetchedResultsController?.object(at: indexPath) {
            var screenName: String?
            twitterUser.managedObjectContext?.performAndWait {
                screenName = twitterUser.screenName
            }
            cell.textLabel?.text = screenName
        }

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
