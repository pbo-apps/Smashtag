//
//  TweetDetailTableViewController.swift
//  Smashtag
//
//  Created by Pete Bounford on 14/02/2017.
//  Copyright © 2017 PBO Apps. All rights reserved.
//

import UIKit
import Twitter

class TweetDetailTableViewController: UITableViewController {

    // MARK: - Model
    private var details = [TweetDetail]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var tweet: Tweet? {
        didSet {
            details.append(.Mention("Hashtags", tweet!.hashtags))
            details.append(.Mention("User Mentions", tweet!.userMentions))
            details.append(.Mention("Links", tweet!.urls))
            details.append(.Media("Images", tweet!.media))
        }
    }
    
    private enum TweetDetail {
        case Mention(String, [Mention])
        case Media(String, [MediaItem])
        
        var count: Int {
            switch self {
            case .Mention(let (_, items)):
                return items.count
            case .Media(let (_, items)):
                return items.count
            }
        }
        
        var name: String {
            switch self {
            case .Mention(let (name, _)), .Media(let (name, _)):
                return name
            }
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
        return details.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details[section].count
    }

    private struct Storyboard {
        static let MentionCellIdentifier = "Mention"
        static let MediaCellIdentifier = "Media"
        static let SearchMentionSegueIdentifier = "Search Mention"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch details[indexPath.section] {
        case .Mention(let (_, items)):
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.MentionCellIdentifier, for: indexPath)
            cell.textLabel?.text = items[indexPath.row].keyword
            return cell
        case .Media(let (_, items)):
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.MediaCellIdentifier, for: indexPath) as! MediaTableViewCell
            cell.media = items[indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return details[section].count > 0 ? details[section].name : nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch details[indexPath.section] {
        case .Mention(let (name, items)):
            switch name {
            case "Links":
                if let url = URL(string: items[indexPath.row].keyword) {
                    UIApplication.shared.open(url)
                }
            default:
                performSegue(withIdentifier: Storyboard.SearchMentionSegueIdentifier, sender: items[indexPath.row])
            }
        case .Media(let (_, items)):
            UIApplication.shared.open(items[indexPath.row].url)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch details[indexPath.section] {
        case .Mention:
            return UITableViewAutomaticDimension
        case .Media(let (_,items)):
            return tableView.bounds.width / CGFloat(items[indexPath.row].aspectRatio)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.SearchMentionSegueIdentifier {
            if let ttvc = segue.destination as? TweetTableViewController {
                if let mention = sender as? Mention {
                    ttvc.searchText = mention.keyword
                }
            }
        }
    }

}
