//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Pete Bounford on 14/02/2017.
//  Copyright © 2017 PBO Apps. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    
    var tweet: Twitter.Tweet? { didSet { updateUI() } }
    
    private func updateUI() {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet {
            setText(for: tweet)
            setName(for: tweet)
            fetchProfileImage(for: tweet)
            setCreatedDateTime(for: tweet)
        }
        
    }
    
    private func fetchProfileImage(for tweet: Twitter.Tweet) {
        if let profileImageURL = tweet.user.profileImageURL {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                let contentsOfURL = NSData(contentsOf: profileImageURL)
                DispatchQueue.main.async { [weak weakSelf = self] in
                    if profileImageURL == weakSelf?.tweet?.user.profileImageURL {
                        if let imageData = contentsOfURL {
                            weakSelf?.tweetProfileImageView?.image = UIImage(data: imageData as Data)
                        }
                    } else {
                        print("ignored data returned from url \(profileImageURL)")
                    }
                }
            }
        }
    }
    
    private func setCreatedDateTime(for tweet: Twitter.Tweet) {
        tweetCreatedLabel?.text = tweet.created.formatForTweet()
    }
    
    private func setText(for tweet: Twitter.Tweet) {
        tweetTextLabel?.text = tweet.text
        if tweetTextLabel?.text != nil {
            for _ in tweet.media {
                tweetTextLabel.text! += " 📸"
            }
            let text = NSMutableAttributedString(string: tweetTextLabel.text!)
            text.highlight(UIColor.orange, for: tweet.hashtags)
            text.highlight(UIColor.blue, for: tweet.urls)
            text.highlight(UIColor.magenta, for: tweet.userMentions)
            tweetTextLabel!.attributedText = text
        }
    }
    
    private func setName(for tweet: Twitter.Tweet) {
        tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
    }
}

private extension NSMutableAttributedString {
    func highlight(_ color: UIColor, for mentions: [Twitter.Mention]) {
        for mention in mentions {
            self.addAttribute(NSForegroundColorAttributeName, value: color, range: mention.nsrange)
        }
    }
}
