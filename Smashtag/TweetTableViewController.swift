//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Pete Bounford on 13/02/2017.
//  Copyright © 2017 PBO Apps. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    private struct Storyboard {
        static let TweetCellIdentifier = "Tweet"
        static let ViewTweetSegueIdentifier = "View Tweet"
        static let ViewTweetersSegueIdentifier = "Tweeters Mentioning Search Term"
    }
    
    // MARK: - Model
    
    var tweetContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    var tweets = [Array<Twitter.Tweet>]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var searchText: String? {
        didSet {
            tweets.removeAll()
            lastTwitterRequest = nil
            searchForTweets()
            navigationItem.title = searchText
            RecentSearchTerms.add(searchText!)
        }
    }
    
    private var twitterRequest: Twitter.Request? {
        if lastTwitterRequest == nil {
            if let query = searchText, !query.isEmpty {
                return Twitter.Request(search: query + " -filter:retweets", count: 100)
            }
        }
        return lastTwitterRequest?.newer
    }
    
    private var lastTwitterRequest: Twitter.Request?
    
    private func searchForTweets() {
        if let request = twitterRequest {
            lastTwitterRequest = request
            request.fetchTweets { [weak weakSelf = self] newTweets in
                DispatchQueue.main.async {
                    if request == weakSelf?.lastTwitterRequest {
                        if !newTweets.isEmpty {
                            weakSelf?.tweets.insert(newTweets, at: 0)
                            weakSelf?.updateDatabase(with: newTweets)
                        }
                    }
                    weakSelf?.refreshControl?.endRefreshing()
                }
            }
        } else {
            self.refreshControl?.endRefreshing()
        }
    }
    
    private func updateDatabase(with newTweets: [Twitter.Tweet]) {
        //var tweet = Model.Tweet(context: tweetContainer.viewContext)
        tweetContainer.viewContext.perform {
            for twitterInfo in newTweets {
                _ = Tweet.create(from: twitterInfo, for: self.tweetContainer.viewContext)
            }
            do {
                try self.tweetContainer.viewContext.save()
            } catch {
                print("Error saving tweets for searchText: \(self.searchText)")
                print("Exception: \( error)")
            }
        }
        printDatabaseStatistics()
        print("Done printing database statistics")
    }
    
    private func printDatabaseStatistics() {
        tweetContainer.viewContext.perform {
            // This is an inefficient way of counting, as it fetches husks of all the data rows and then counts on the code-side
            let request: NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
            if let results = try? self.tweetContainer.viewContext.fetch(request) {
                print("\(results.count) TwitterUsers")
            }
            // This is a more efficient way of counting, as the count happens on the DB side and only the integer number is returned
            let requestTweetCount: NSFetchRequest<Tweet> = Tweet.fetchRequest()
            if let tweetCount = try? self.tweetContainer.viewContext.count(for: requestTweetCount) {
                print("\(tweetCount) Tweets")
            }
        }
    }
    
    @IBAction func refresh() {
        searchForTweets()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TweetCellIdentifier, for: indexPath)

        let tweet = tweets[indexPath.section][indexPath.row]
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return tweets[indexPath.section][indexPath.row].hasDetails()
    }
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        return true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case Storyboard.ViewTweetSegueIdentifier:
            if let tdtvc = segue.destination as? TweetDetailTableViewController {
                if let cell = sender as? TweetTableViewCell {
                    if let indexPath = tableView.indexPath(for: cell) {
                        tdtvc.tweet = tweets[indexPath.section][indexPath.row]
                    }
                }
            }
        case Storyboard.ViewTweetersSegueIdentifier:
            if let tweetersTVC = segue.destination as? TweetersTableViewController {
                tweetersTVC.mention = searchText
                tweetersTVC.managedObjectContext = tweetContainer.viewContext
            }
        default:
            break
        }
        
    }

}

private extension Twitter.Tweet {
    func hasDetails() -> Bool {
        return !self.media.isEmpty || !self.hashtags.isEmpty || !self.userMentions.isEmpty || !self.urls.isEmpty
    }
}
