//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Pete Bounford on 13/02/2017.
//  Copyright © 2017 PBO Apps. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Model
    
    var tweets = [Array<Tweet>]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var searchText: String? {
        didSet {
            tweets.removeAll()
            lastTwitterRequest = nil
            searchForTweets()
            title = searchText
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
                        }
                    }
                    weakSelf?.refreshControl?.endRefreshing()
                }
            }
        } else {
            self.refreshControl?.endRefreshing()
        }
    }
    
    @IBAction func refresh() {
        searchForTweets()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    private struct Storyboard {
        static let TweetCellIdentifier = "Tweet"
        static let ViewTweetSegueIdentifier = "View Tweet"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TweetCellIdentifier, for: indexPath)

        let tweet = tweets[indexPath.section][indexPath.row]
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }

        return cell
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Storyboard.ViewTweetSegueIdentifier {
            if let mvc = segue.destination as? MentionTableViewController {
                if let cell = sender as? TweetTableViewCell {
                    if let indexPath = tableView.indexPath(for: cell) {
                        mvc.tweet = tweets[indexPath.section][indexPath.row]
                    }
                }
            }
        }
        
    }

}
