//
//  JourneySwipeRecentViewController.swift
//  GoGoGo
//
//  Created by Byron Coetsee on 2015/01/20.
//  Copyright (c) 2015 GoMetro (Pty) Ltd. All rights reserved.
//

import UIKit

class JourneySwipeRecentViewController: UIViewController, UITableViewDelegate {
	
	@IBOutlet weak var tblData: UITableView!
	
	var tempNames = ["Home", "Thembi's Place", "Byron's House"]
	var tempAddrs = ["66 Albert Road, Woodstock", "23 Brink Lane, Hout Bay", "9 Stonehill Drive, Constantia"]
	var tempDays = [2, 4, 9]
	

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 95
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tempNames.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell : RecentTripTableViewCell = tblData.dequeueReusableCellWithIdentifier("recentTripCell", forIndexPath: indexPath) as RecentTripTableViewCell
		
		cell.lblName.text = tempNames[indexPath.row]
		cell.lblAddress.text = tempAddrs[indexPath.row]
		cell.lblDays.text = "\(tempDays[indexPath.row]) days ago"
		println("here")
		return cell
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
