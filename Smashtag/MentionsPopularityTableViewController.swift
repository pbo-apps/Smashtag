//
//  MentionsPopularityTableViewController.swift
//  Smashtag
//
//  Created by Pete Bounford on 02/03/2017.
//  Copyright © 2017 PBO Apps. All rights reserved.
//

import UIKit
import CoreData

class MentionsPopularityTableViewController: CoreDataTableViewController<Mention> {
    
    private struct Storyboard {
        static let mentionCell = "Mention Popularity Cell"
    }
    
    // MARK: - Model
    var searchText: String? { didSet { updateUI() } }
    var managedObjectContext: NSManagedObjectContext? { didSet { updateUI() } }
    
    private func updateUI() {
        if let context = managedObjectContext, searchText != nil, searchText!.characters.count > 0 {
            self.navigationItem.title = "Mentions related to " + searchText!
            let request: NSFetchRequest<Mention> = Mention.fetchRequest()
            request.predicate = NSPredicate(format: "any tweets.text contains[c] %@ and count > %@", searchText!, NSNumber(value: 1))
            request.sortDescriptors = [NSSortDescriptor(
                key: "count",
                ascending: false
                ),
                NSSortDescriptor(
                    key: "name",
                    ascending: true,
                    selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )]
            fetchedResultsController = NSFetchedResultsController<Mention>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
        } else {
            self.navigationItem.title = "No mentions to display"
            fetchedResultsController = nil
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.mentionCell, for: indexPath)

        if let mention = fetchedResultsController?.object(at: indexPath) {
            var mentionName: String?
            var mentionedInCount: Int?
            mention.managedObjectContext?.performAndWait {
                mentionName = mention.name
                mentionedInCount = mention.tweets?.count
            }
            cell.textLabel?.text = mentionName
            cell.detailTextLabel?.text = String(mentionedInCount ?? 0)
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
