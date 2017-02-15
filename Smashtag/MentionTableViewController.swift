//
//  MentionTableViewController.swift
//  Smashtag
//
//  Created by Pete Bounford on 14/02/2017.
//  Copyright © 2017 PBO Apps. All rights reserved.
//

import UIKit
import Twitter

class MentionTableViewController: UITableViewController {

    // MARK: - Model
    var mentions = [Array<Mention>]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var tweet: Tweet? {
        didSet {
            mentions = [tweet!.hashtags]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return mentions.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentions[section].count
    }

    private struct Storyboard {
        static let MentionCellIdentifier = "Mention"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.MentionCellIdentifier, for: indexPath)

        let mention = mentions[indexPath.section][indexPath.row]
        cell.textLabel?.text = mention.keyword

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
