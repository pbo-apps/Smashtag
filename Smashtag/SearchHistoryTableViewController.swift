//
//  SearchHistoryTableViewController.swift
//  Smashtag
//
//  Created by Pete Bounford on 27/02/2017.
//  Copyright © 2017 PBO Apps. All rights reserved.
//

import UIKit

class SearchHistoryTableViewController: UITableViewController {
    
    private struct Storyboard {
        static let searchTermCell = "Search Term Cell"
        static let searchHistoricTermSegueIdentifier = "Search Historic Term"
        static let mentionsPopularitySegueIdentifier = "View Search Term Mentions By Popularity"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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
            }
        default:
            break
        }
    }

}
