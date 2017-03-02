//
//  SearchHistoryTableViewController.swift
//  Smashtag
//
//  Created by Pete Bounford on 27/02/2017.
//  Copyright © 2017 PBO Apps. All rights reserved.
//

import UIKit

class SearchHistoryTableViewController: UITableViewController {
    
    var tweetContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    private struct Storyboard {
        static let searchTermCell = "Search Term Cell"
        static let searchHistoricTermSegueIdentifier = "Search Historic Term"
        static let mentionsPopularitySegueIdentifier = "View Search Term Mentions By Popularity"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return RecentSearchTerms.get().count > 0 ? 1 : 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecentSearchTerms.get().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.searchTermCell, for: indexPath)

        cell.textLabel?.text = RecentSearchTerms.get()[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Storyboard.searchHistoricTermSegueIdentifier, sender: RecentSearchTerms.get()[indexPath.row])
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case Storyboard.searchHistoricTermSegueIdentifier:
            if let ttvc = segue.destination as? TweetTableViewController {
                ttvc.searchText = sender as? String
            }
        case Storyboard.mentionsPopularitySegueIdentifier:
            if let mptvc = segue.destination as? MentionsPopularityTableViewController, let cell = sender as? UITableViewCell {
                mptvc.searchText = cell.textLabel?.text
                mptvc.managedObjectContext = tweetContainer.viewContext
            }
        default:
            break
        }
    }

}
