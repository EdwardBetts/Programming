//
//  JourneySwipeDiscoverViewController.swift
//  GoGoGo
//
//  Created by Byron Coetsee on 2015/01/20.
//  Copyright (c) 2015 GoMetro (Pty) Ltd. All rights reserved.
//

import UIKit

class JourneySwipeDiscoverViewController: UIViewController, UITableViewDelegate {
	
	
	@IBOutlet weak var tblData: UITableView!
	
	var tempDiscoverNames = ["Adriana Limas", "Byron Coetsee", "Justin Coetzee"]
	var tempDiscoverUpdateCount = ["500", "24", "3467"]
	var tempDiscoverRecentPost = ["The train is late today - keeps stopping in random places on the track. Should have taken the helicopter instead", "Glad I took my bike instead of the train!", "People cant wait for the iOS app to be launched!"]

    override func viewDidLoad() {
        super.viewDidLoad()
		println("View loaded")
    }
	
	override func viewDidAppear(animated: Bool) {
		tblData.reloadData()
		println("View appeared")
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		println(tempDiscoverNames.count)
		return tempDiscoverNames.count
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 125
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell : MessagesDiscoverTableViewCell = tblData.dequeueReusableCellWithIdentifier("discoverCell", forIndexPath: indexPath) as MessagesDiscoverTableViewCell
		cell.imageProfilePic = formatProfilePic(cell.imageProfilePic)
		cell.lblName.text = tempDiscoverNames[indexPath.row]
		cell.lblUpdateCount.text = "\(tempDiscoverUpdateCount[indexPath.row]) Updates Posted"
		cell.lblPost.text = tempDiscoverRecentPost[indexPath.row]
		cell.clipsToBounds = true
		println(cell)
		return cell
	}
	
	func formatProfilePic(profilePic: UIImageView) -> UIImageView {
		profilePic.layer.cornerRadius = 0.5 * profilePic.bounds.size.width
		profilePic.layer.borderWidth = 1
		profilePic.layer.borderColor = UIColor.whiteColor().CGColor
		profilePic.clipsToBounds = true
		
		return profilePic
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
