//
//  AgenciesViewController.swift
//  GoGoGo
//
//  Created by Byron Coetsee on 2015/01/21.
//  Copyright (c) 2015 GoMetro (Pty) Ltd. All rights reserved.
//

import UIKit

class AgenciesViewController: UIViewController, UITableViewDelegate {
	
	
	@IBOutlet weak var tblAgencies: UITableView!
	@IBOutlet weak var viewHeading: UIView!
	@IBOutlet weak var lblAgency: UILabel!
	@IBOutlet weak var lblCity: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return 2
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell : AgencyTableViewCell = tblAgencies.dequeueReusableCellWithIdentifier("agencyCell", forIndexPath: indexPath) as AgencyTableViewCell

		return cell
	}
}
