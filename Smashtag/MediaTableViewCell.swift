//
//  MediaTableViewCell.swift
//  Smashtag
//
//  Created by Pete Bounford on 28/02/2017.
//  Copyright © 2017 PBO Apps. All rights reserved.
//

import UIKit
import Twitter

class MediaTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetImageView: UIImageView!
    
    var media: Twitter.MediaItem? { didSet { updateUI() } }
    
    private func updateUI() {
        tweetImageView?.image = nil
        if let media = self.media {
            fetchImage(for: media)
        }
    }
    
    private func fetchImage(for media: Twitter.MediaItem) {
        let imageUrl = media.url
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            let contentsOfURL = NSData(contentsOf: media.url)
            DispatchQueue.main.async { [weak weakSelf = self] in
                if imageUrl == weakSelf?.media?.url {
                    if let imageData = contentsOfURL {
                        weakSelf?.tweetImageView?.image = UIImage(data: imageData as Data)
                    }
                } else {
                    print("ignored data returned from url \(imageUrl)")
                }
            }
        }
    }
    
}
