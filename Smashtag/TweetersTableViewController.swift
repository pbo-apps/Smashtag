//
//  TweetersTableViewController.swift
//  Smashtag
//
//  Created by Pete Bounford on 28/02/2017.
//  Copyright © 2017 PBO Apps. All rights reserved.
//

import UIKit

class TweetersTableViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }

}
