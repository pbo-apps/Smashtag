//
//  MentionsPopularityTableViewController.swift
//  Smashtag
//
//  Created by Pete Bounford on 02/03/2017.
//  Copyright © 2017 PBO Apps. All rights reserved.
//

import UIKit

class MentionsPopularityTableViewController: UITableViewController {

    // MARK: - Model
    var searchText: String? { didSet { updateUI() } }
    
    private func updateUI() {
        // Will need to create the fetch request controller here
    }

    private struct Storyboard {
        static let mentionCell = "Mention Popularity Cell"
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.mentionCell, for: indexPath)

        cell.textLabel?.text = searchText

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
