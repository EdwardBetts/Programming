//
//  SecondViewController.swift
//  GoGoGo
//
//  Created by Byron Coetsee on 2015/01/19.
//  Copyright (c) 2015 GoMetro (Pty) Ltd. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {
	
	@IBOutlet weak var segTableType: UISegmentedControl!
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var tblData: UITableView!
	
	var count = 0
	
	var tempDiscoverNames = ["Adriana Limas"]
	var tempDiscoverUpdateCount = ["500"]
	var tempDiscoverRecentPost = ["The train is late today - keeps stopping"]
	
	
	var tempChatName = ["Tyler Mash"]
	var tempChatMessage = ["Looks like the train is going to be late. Maybe we should take the helicopter"]
	
	var tempChatInviteName = ["Byron Coetsee"]
	

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func viewDidAppear(animated: Bool) {
		segTableType.selectedSegmentIndex = 0
	}
	
	@IBAction func changeTable(sender: AnyObject) {
		tblData.reloadData()
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if segTableType.selectedSegmentIndex == 0 {
			return tempDiscoverNames.count
		} else {
			println(tempChatName.count + tempChatInviteName.count)
			return tempChatName.count + tempChatInviteName.count
		}
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if segTableType.selectedSegmentIndex == 0 {
			return 125
		} else {
			return 80
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if segTableType.selectedSegmentIndex == 0 {
			var cell : MessagesDiscoverTableViewCell = tblData.dequeueReusableCellWithIdentifier("discoverCell", forIndexPath: indexPath) as MessagesDiscoverTableViewCell
			cell.imageProfilePic = formatProfilePic(cell.imageProfilePic)
			cell.lblName.text = tempDiscoverNames[indexPath.row]
			cell.lblUpdateCount.text = "\(tempDiscoverUpdateCount[indexPath.row]) Updates Posted"
			cell.lblPost.text = tempDiscoverRecentPost[indexPath.row]
			cell.clipsToBounds = true
			return cell
		} else {
			if indexPath.row < tempChatInviteName.count {
				var cell : MessagesChatInviteTableViewCell = tblData.dequeueReusableCellWithIdentifier("chatInviteCell", forIndexPath: indexPath) as MessagesChatInviteTableViewCell
				println(indexPath.row)
				cell.lblRequestMessage.text = "\(tempChatInviteName[indexPath.row]) sent you a chat request"
				cell.imageProfilePic = formatProfilePic(cell.imageProfilePic)
				cell.btnAccept = formatChatInviteButtons(cell.btnAccept)
				cell.btnDeny = formatChatInviteButtons(cell.btnDeny)
				cell.clipsToBounds = true
				return cell
			} else {
				var cell : MessagesChatTableViewCell = tblData.dequeueReusableCellWithIdentifier("chatCell", forIndexPath: indexPath) as MessagesChatTableViewCell
				cell.lblName.text = tempChatInviteName[indexPath.row - tempChatInviteName.count]
				cell.lblMessage.text = tempChatMessage[indexPath.row - tempChatInviteName.count]
				cell.imageProfilePic = formatProfilePic(cell.imageProfilePic)
				cell.lblMessage.frame = CGRectMake(cell.lblMessage.frame.origin.x, cell.lblMessage.frame.origin.y, cell.lblMessage.frame.size.width, 40)
				cell.lblMessage.sizeToFit()
				cell.clipsToBounds = true
				return cell
			}
		}
	}
	
	func formatProfilePic(profilePic: UIImageView) -> UIImageView {
		profilePic.layer.cornerRadius = 0.5 * profilePic.bounds.size.width
		profilePic.layer.borderWidth = 1
		profilePic.layer.borderColor = UIColor.whiteColor().CGColor
		profilePic.clipsToBounds = true
		
		return profilePic
	}
	
	func formatChatInviteButtons(button: UIButton) -> UIButton {
		button.layer.cornerRadius = 5
		button.layer.borderWidth = 1
		button.layer.borderColor = UIColor.blueColor().CGColor
		
		return button
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

