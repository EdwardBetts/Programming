//
//  AddNewGroupViewController.swift
//  Panic
//
//  Created by Byron Coetsee on 2014/12/05.
//  Copyright (c) 2014 Byron Coetsee. All rights reserved.
//

import UIKit
import Parse

class AddNewGroupViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var joinTopLayout: NSLayoutConstraint!
	@IBOutlet weak var joinHeightLayout: NSLayoutConstraint!
	@IBOutlet weak var joinWidthLayout: NSLayoutConstraint!
	
    
    @IBOutlet weak var textBoxContainerView: UIView!
    @IBOutlet weak var tblGroups: UITableView!
    @IBOutlet weak var viewLoading: UIVisualEffectView!
    @IBOutlet weak var btnJoin: UIButton!
    @IBOutlet weak var viewPrivate: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var switchPrivate: UISwitch!
	@IBOutlet weak var lblPublicInstruction: UILabel!
	@IBOutlet weak var lblInstruction: UILabel!
	@IBOutlet weak var lblPrivatePublic: UILabel!
    
    var selectedTextField : UITextField!
    var searching : Bool = false
    var groups : NSArray = []
    var privateGroups : [String] = []
    var groupsDuringSearch : NSArray = []
    var query : PFQuery!
	var searchSpinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		searchBar.setShowsCancelButton(false, animated: true)
		tblGroups.hidden = true
		query = PFQuery(className: "Groups")
        viewLoading.hidden = true
        searchBar.tintColor = UIColor.whiteColor()
        viewPrivate.backgroundColor = UIColor.clearColor()
        viewPrivate.hidden = true
        btnJoin.hidden = true
        tblGroups.backgroundColor = UIColor.clearColor()
		
		searchSpinner.startAnimating()
		searchSpinner.frame.origin = CGPointMake(searchBar.frame.width - 120, 12)
		
		btnJoin.layer.cornerRadius = 0.5 * btnJoin.bounds.size.width
		btnJoin.layer.borderWidth = 2
		btnJoin.layer.borderColor = UIColor.whiteColor().CGColor
    }
	
    func fetchGroups(initFetch : Bool = false) {
        if query != nil { query.cancel() }
		searchBar.addSubview(searchSpinner)
        query.whereKey("flatValue", hasPrefix: searchBar.text.formatGroupForFlatValue())
        query.orderByDescending("name")
        query.findObjectsInBackgroundWithBlock({
            (objects: [AnyObject]!, error: NSError!) -> Void in
            println("Running fetch")
            if error == nil {
                println("Fetch returned something")
                var tempGroupArray : [String] = []
                self.groups = []
                for groupRaw in objects {
                    var groupObject = groupRaw as PFObject
                    var groupString : String = groupObject["name"] as String
                    if groupObject["public"] as Bool == false {
                        self.privateGroups.append(groupString)
                    } else {
                        tempGroupArray.append(groupString)
                    }
                }
                self.groups = tempGroupArray as AnyObject as [String]
                dispatch_async(dispatch_get_main_queue(), {
					self.searching = false
                    self.tblGroups.reloadData()
                    self.viewLoading.hidden = true
					self.searchSpinner.removeFromSuperview()
                })
            } else {
                global.showAlert("Error fetching groups", message: "There was an error retrieving the list of groups. Possibly check you internet connection.")
                self.viewLoading.hidden = true
				self.searchSpinner.removeFromSuperview()
            }
        })
    }
	
	func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		switch (selectedScope) {
		case 0:
			println("Public")
			tblGroups.hidden = false
			tblGroups.reloadData()
			btnJoin.hidden = true
			viewPrivate.hidden = true
			break;
			
		case 1:
			println("Private")
			tblGroups.hidden = true
			btnJoin.hidden = false
			viewPrivate.hidden = true
			btnJoin.setTitle("Join", forState: UIControlState.Normal)
			animateChange(btnJoin, controlLayout: joinTopLayout, number: 170)
			animateChange(btnJoin, controlLayout: joinHeightLayout, number: 55)
			animateChange(btnJoin, controlLayout: joinWidthLayout, number: 55)
			btnJoin.layer.cornerRadius = 0.5 * btnJoin.bounds.size.width
			lblPublicInstruction.hidden = true
			break;
			
		case 2:
			println("New")
			tblGroups.hidden = true
			btnJoin.setTitle("Create", forState: UIControlState.Normal)
			btnJoin.hidden = false
			viewPrivate.hidden = false
			animateChange(btnJoin, controlLayout: joinTopLayout, number: 290)
			animateChange(btnJoin, controlLayout: joinHeightLayout, number: 65)
			animateChange(btnJoin, controlLayout: joinWidthLayout, number: 65)
			btnJoin.layer.cornerRadius = 0.5 * btnJoin.bounds.size.width
			lblPublicInstruction.hidden = true
			break;
			
		default:
			break;
		}
	}
	
	func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
		searchBar.setShowsCancelButton(true, animated: true)
		return true
	}
	
	func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
		searchBar.setShowsCancelButton(false, animated: true)
		return true
	}
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.selectedScopeButtonIndex == 0) {
            if countElements(searchBar.text) == 3 {
                fetchGroups(initFetch: false)
				if tblGroups.hidden == true { tblGroups.hidden = false }
				lblPublicInstruction.hidden = true
            } else if countElements(searchBar.text) > 3 { searching = true }
			var pred: NSPredicate = NSPredicate(format: "SELF contains[c] %@", searchText)!
			groupsDuringSearch = groups.filteredArrayUsingPredicate(pred)
			tblGroups.reloadData()
        }
        if searchText.isEmpty {
            searching = false
			tblGroups.hidden = true
			lblInstruction.text = "Type at least 3 characters to search"
            tblGroups.reloadData()
        }
    }
	
	@IBAction func changePrivatePublicLabel(sender: AnyObject) {
		if switchPrivate.on == true {
			lblPrivatePublic.text = "Private"
		} else {
			lblPrivatePublic.text = "Public"
		}
	}
	
    
	@IBAction func join(sender: AnyObject) {
		if countElements(searchBar.text) > 2 {
			var groupAlreadyJoined = false
			for channel in global.installation.channels as [String] {
				if channel.formatGroupForFlatValue() == searchBar.text.formatGroupForFlatValue() {
					groupAlreadyJoined = true
					break
				}
			}
			if groupAlreadyJoined == false {
				if searchBar.selectedScopeButtonIndex == 1 {
					joinPrivateGroup()
				} else if searchBar.selectedScopeButtonIndex == 2 {
					createGroup()
				}
			} else {
				global.showAlert("", message: "You are already subscribed to this group")
			}
		} else {
			global.showAlert("", message: "Groups require 3 or more characters in their name")
		}
	}
	
	// Joins a private group
	func joinPrivateGroup() {
		btnJoin.enabled = false
		var queryAddNewGroupCheckFlat = PFQuery(className: "Groups")
		query.whereKey("flatValue", equalTo: searchBar.text.formatGroupForFlatValue())
		query.findObjectsInBackgroundWithBlock({
			(object : [AnyObject]!, error : NSError!) -> Void in
			if object.count > 0 {
				let pfObject = object[0] as PFObject
				dispatch_async(dispatch_get_main_queue(), {
					let name = pfObject["name"] as String
					global.addGroup(name)
					global.showAlert("Successful", message: "You have joined the group \(name)")
					self.btnJoin.enabled = true
					self.dismissViewControllerAnimated(true, completion: nil)
				})
			} else {
				self.btnJoin.enabled = true
				global.showAlert("", message: "The group '\(self.searchBar.text)' does not exist. Check the spelling or use the New tab to create it")
			}
		})
		self.btnJoin.enabled = true
	}
	
	// Creates a new group
	func createGroup() {
		var error : NSErrorPointer?
		let tempGroupsArray : [String] = groups as [String] // Used because you cannot run contains() on an NSArray. Converted to [String]
		if query != nil { query.cancel() }
		btnJoin.enabled = false
		switchPrivate.enabled = false
//		searchBar.showsScopeBar = false
		searchBar.sizeToFit()
		
		var queryAddNewGroupCheckFlat = PFQuery(className: "Groups")
		query.whereKey("flatValue", equalTo: searchBar.text.formatGroupForFlatValue())
		query.findObjectsInBackgroundWithBlock({
			(object : [AnyObject]!, error : NSError!) -> Void in
			if object != nil {
				if object.count == 0 {
					var newGroupObject : PFObject = PFObject(className: "Groups")
					newGroupObject["name"] = self.searchBar.text.lowercaseString.capitalizedString
					newGroupObject["flatValue"] = self.searchBar.text.formatGroupForFlatValue()
					newGroupObject["country"] = PFUser.currentUser()["country"] as String
					newGroupObject["admin"] = PFUser.currentUser()
					if self.switchPrivate.on {
						newGroupObject["public"] = false
					} else {
						newGroupObject["public"] = true
					}
					newGroupObject.saveInBackgroundWithBlock({
						(result: Bool, error: NSError!) -> Void in
						if result == true {
							dispatch_async(dispatch_get_main_queue(), {
								global.showAlert("Successful", message: "Group \(self.searchBar.text.lowercaseString.capitalizedString) created successfully. Please note - Private groups will not show up when someone searches for it. They will need to enter the groups name in the 'Private' tab and tap join.")
								self.btnJoin.enabled = true
								self.searchBar.showsScopeBar = true
								self.searchBar.sizeToFit()
								global.addGroup(self.searchBar.text.lowercaseString.capitalizedString)
								self.dismissViewControllerAnimated(true, completion: nil)
							})
						} else {
							global.showAlert("Oops", message: error.localizedFailureReason!)
							self.btnJoin.enabled = true
//							self.searchBar.showsScopeBar = true
							self.searchBar.sizeToFit()
							self.switchPrivate.enabled = true
						}
					})
				} else {
					let name = object[0]["name"] as String
					let country = object[0]["country"] as String
					let privateGroup = object[0]["public"] as Bool
					global.showAlert("Unseccessful", message: "Group '\(self.searchBar.text)' already exists\n\nName: \(name)\nCountry:\(country)\nPublic: \(privateGroup)")
					self.btnJoin.enabled = true
//					self.searchBar.showsScopeBar = true
					self.searchBar.sizeToFit()
					self.switchPrivate.enabled = true
				}
			}
		})

	}
	
    func animateChange(control : AnyObject, controlLayout : NSLayoutConstraint, number : CGFloat) {
        controlLayout.constant = number
        UIView.animateWithDuration(0.3, animations: {
            control.layoutIfNeeded()
        })
    }
	
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if searching == false {
            global.addGroup(groups.objectAtIndex(indexPath.row) as String)
            global.showAlert("Successful", message: "You have joined the group \(groups.objectAtIndex(indexPath.row))")
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            global.addGroup(groupsDuringSearch.objectAtIndex(indexPath.row) as String)
            global.showAlert("Successful", message: "You have joined the group \(groupsDuringSearch.objectAtIndex(indexPath.row))")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching == true {
			if searchBar.text.isEmpty {
				tblGroups.hidden = true
				lblInstruction.text = "Type at least 3 characters to search"
				lblInstruction.hidden = false
			} else if groupsDuringSearch.count == 0 {
				tblGroups.hidden = true
				lblInstruction.text = "No results"
				lblInstruction.hidden = false
			} else {
				tblGroups.hidden = false
				lblInstruction.hidden = true
			}
			
            return groupsDuringSearch.count
        } else {
			if searchBar.text.isEmpty {
				tblGroups.hidden = true
				lblInstruction.text = "Type at least 3 characters to search"
				lblInstruction.hidden = false
			} else if groups.count == 0 {
				tblGroups.hidden = true
				lblInstruction.text = "No results"
				lblInstruction.hidden = false
			} else {
				tblGroups.hidden = false
			}
			
            return groups.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.backgroundColor = UIColor.clearColor()
        
        if searching == true {
            if groupsDuringSearch.objectAtIndex(indexPath.row) as String == "" {
                cell.textLabel?.text = "Nil"
            } else {
                cell.textLabel?.text = (groupsDuringSearch.objectAtIndex(indexPath.row) as String)
            }
            return cell
        } else {
            if groups.objectAtIndex(indexPath.row) as NSString == "" {
                cell.textLabel?.text = "Nil"
            } else {
                cell.textLabel?.text = (groups.objectAtIndex(indexPath.row) as String)
            }
            return cell
        }
    }
	
	func searchBarCancelButtonClicked(searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
    
    @IBAction func hideKeyboard(sender: AnyObject) {
        searchBar.resignFirstResponder()
    }
    
    @IBAction func back(sender: AnyObject) {
		if query != nil { query.cancel() }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
