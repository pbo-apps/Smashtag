//
//  MentionsPopularityTableViewController.swift
//  Smashtag
//
//  Created by Pete Bounford on 02/03/2017.
//  Copyright © 2017 PBO Apps. All rights reserved.
//

import UIKit
import CoreData

class MentionsPopularityTableViewController: CoreDataTableViewController<Tweet> {
    
    private struct Storyboard {
        static let mentionCell = "Mention Popularity Cell"
    }
    
    // MARK: - Model
    var searchText: String? { didSet { updateUI() } }
    var managedObjectContext: NSManagedObjectContext? { didSet { updateUI() } }
    
    private func updateUI() {
        if let context = managedObjectContext, searchText != nil, searchText!.characters.count > 0 {
            let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
            //request.predicate = NSPredicate(format: "", <#T##args: CVarArg...##CVarArg#>)
            request.sortDescriptors = [NSSortDescriptor(
                key: "posted",
                ascending: false
                )]
            fetchedResultsController = NSFetchedResultsController<Tweet>(
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.mentionCell, for: indexPath)

        if let tweet = fetchedResultsController?.object(at: indexPath) {
            var tweeterName: String?
            var postedDate: Date?
            tweet.managedObjectContext?.performAndWait {
                tweeterName = tweet.tweeter?.screenName
                postedDate = tweet.posted as? Date
            }
            cell.textLabel?.text = tweeterName
            cell.detailTextLabel?.text = postedDate?.formatForTweet()
            
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
