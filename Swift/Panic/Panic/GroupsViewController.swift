//
//  GroupsViewController.swift
//  Panic
//
//  Created by Byron Coetsee on 2014/12/02.
//  Copyright (c) 2014 Byron Coetsee. All rights reserved.
//

import UIKit

class GroupsViewController: UIViewController, UITableViewDelegate {
	
	// Controls
	
    @IBOutlet weak var tblGroups: UITableView!
	@IBOutlet weak var btnAdd: UIButton!
	@IBOutlet weak var lblDescription: UILabel!
	
	// Tutorial
	
	@IBOutlet weak var viewTutorial: UIVisualEffectView!
	@IBOutlet weak var imageTap: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewDidAppear(animated: Bool) {
		if global.joinedGroups.count == 0 { tutorial.addNewGroup = false }
		if tutorial.addNewGroup == false {
			viewTutorial.hidden = false
			animateTutorial()
		}
	}
    
    @IBAction func addContact(sender: AnyObject) {
        tutorial.addNewGroup = true
		tutorial.save()
		println("Set addNewGroups to TRUE")
		if viewTutorial.hidden == false {
			UIView.animateWithDuration(0.5, animations: {
				self.viewTutorial.alpha = 0.0 }, completion: {
					(finished: Bool) -> Void in
					self.viewTutorial.hidden = true
			})
		}
    }
    
    func refresh() {
        tblGroups.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return global.joinedGroups.count
        //return names.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "standard")
        cell.backgroundColor = UIColor.clearColor()
		cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont(name: "Heiti SC light", size: 16)
        cell.textLabel?.text = global.joinedGroups[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        //Unused. Here incase...
        var editRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Edit", handler:{action, indexpath in
            println("EDIT•ACTION");
        });
        
        editRowAction.backgroundColor = UIColor.orangeColor()
        
        var deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler:{action, indexpath in
            self.refresh()
            global.removeGroup(global.joinedGroups[indexPath.row])
            
            self.tblGroups.reloadData()
        });
        return [deleteRowAction];
    }
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let currentLabelValue = lblDescription.text
		
		// Fade out
		UIView.animateWithDuration(0.3, animations: {
			self.lblDescription.alpha = 0.0
			}, completion: {
				
				// Change text and fade in
				(finished: Bool) -> Void in
				self.lblDescription.text = "Swipe for more options"
				UIView.animateWithDuration(0.3, animations: {
				self.lblDescription.alpha = 1.0
					}, completion: {
						(finished: Bool) -> Void in
						
						// Fade out after 2 second delay
						UIView.animateWithDuration(0.3, delay: 2, options: nil, animations: {
							self.lblDescription.alpha = 0.0
							}, completion: {
								(finished: Bool) -> Void in
								self.lblDescription.text = currentLabelValue
								
								// Fade back in with original text
								UIView.animateWithDuration(0.3, animations: {
									self.lblDescription.alpha = 1.0
									})
						})
					})
		})
	}
	
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) { }
	
	func animateTextChange(newString : String) {
		UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
			self.lblDescription.alpha = 0.0
			}, completion: {
				(finished: Bool) -> Void in
				
				//Once the label is completely invisible, set the text and fade it back in
				self.lblDescription.text = newString
				
				// Fade in
				UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
					self.lblDescription.alpha = 1.0
					}, completion: nil)
		})
	}
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
	
	// Tutorial
	
	func animateTutorial() {
		self.imageTap.layer.shadowColor = UIColor.whiteColor().CGColor
		self.imageTap.layer.shadowRadius = 5.0
		self.imageTap.layer.shadowOffset = CGSizeZero
		
		self.btnAdd.layer.shadowColor = UIColor.whiteColor().CGColor
		self.btnAdd.layer.shadowRadius = 5.0
		self.btnAdd.layer.shadowOffset = CGSizeZero
		
		var animate = CABasicAnimation(keyPath: "shadowOpacity")
		animate.fromValue = 0.0
		animate.toValue = 1.0
		animate.autoreverses = true
		animate.duration = 1
		
		self.imageTap.layer.addAnimation(animate, forKey: "shadowOpacity")
		self.btnAdd.layer.addAnimation(animate, forKey: "shadowOpacity")
		
		if tutorial.addNewGroup == false {
			let timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "animateTutorial", userInfo: nil, repeats: false)
		}

	}
}
