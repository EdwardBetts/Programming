//
//  TabBarViewController.swift
//  Panic
//
//  Created by Byron Coetsee on 2014/12/01.
//  Copyright (c) 2014 Byron Coetsee. All rights reserved.
//

import UIKit
import Parse

class TabBarViewController: UIViewController, UIGestureRecognizerDelegate {
	
	// Controls
	
	@IBOutlet var tabbarView : UIView!
	@IBOutlet var placeholderView: UIView!
	@IBOutlet var tabBarButtons: Array<UIButton>!
	@IBOutlet weak var tabbarBottomLayout: NSLayoutConstraint!
	@IBOutlet weak var sidebarLeftLayout: NSLayoutConstraint!
	@IBOutlet var btnLogout : UIButton!
	@IBOutlet weak var btnMenu: UIButton!
	@IBOutlet weak var viewSidebar: UIView!
	@IBOutlet weak var profilePic: UIImageView!
	@IBOutlet weak var lblName: UILabel!
	@IBOutlet weak var btnGroups: UIButton!
	
	// Tutorial
	
	@IBOutlet weak var viewSwipeRight: UIVisualEffectView!
	@IBOutlet weak var imageSwipeRight: UIImageView!
	@IBOutlet weak var layoutLeftSwipeRight: NSLayoutConstraint!
	
	// Tutorial Panic Button
	
	@IBOutlet weak var viewTutorialPanic: UIVisualEffectView!
	@IBOutlet weak var btnPanic: UIButton!
	@IBOutlet weak var lblDescription: UILabel!
	var descriptionCount = 0
	
	// Variables
	
	var panicIsActive : Bool = false
	var sideBarIsOpen : Bool = false
	var currentViewController: UIViewController?
	var recognizer : UIScreenEdgePanGestureRecognizer!
	var amAtHome: Bool = true
	var tapRecognizer : UITapGestureRecognizer!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		profilePic.layer.cornerRadius = 0.5 * profilePic.bounds.size.width
		profilePic.layer.borderWidth = 2
		profilePic.layer.borderColor = UIColor.whiteColor().CGColor
		profilePic.clipsToBounds = true
		
		tapRecognizer = UITapGestureRecognizer(target: self, action: "closeSidebar")
		recognizer = UIScreenEdgePanGestureRecognizer(target: self, action:Selector("openSidebar"))
		let closeRecognizer = UISwipeGestureRecognizer(target: self, action: "closeSidebar")
		closeRecognizer.direction = UISwipeGestureRecognizerDirection.Left
		recognizer.edges = UIRectEdge.Left
		recognizer.delegate = self
		
		viewSwipeRight.userInteractionEnabled = false
		placeholderView.addGestureRecognizer(recognizer)
		placeholderView.addGestureRecognizer(tapRecognizer)
		placeholderView.addGestureRecognizer(closeRecognizer)
	}
	
	override func viewDidAppear(animated: Bool) {
		
		if tutorial.swipeToOpenMenu == false {
			viewSwipeRight.hidden = false
			animateSwipeRight()
		}
		
		if tutorial.panic == false {
			setupTutorial()
		}
		
		if PFUser.currentUser()["name"] != nil {
			lblName.text = (PFUser.currentUser()["name"] as String)
		}
		if(tabBarButtons.count > 0) {
			performSegueWithIdentifier("customSegueMain", sender: tabBarButtons[1])
		}
		closeSidebar()
	}
	
	@IBAction func home(sender: AnyObject) {
		amAtHome = true
		closeSidebar()
		
		// Showing swipeRight tutorial
		if tutorial.swipeToOpenMenu == false {
			viewSwipeRight.hidden = false
			animateSwipeRight()
		}
		
		// Show panic tutorial
		if tutorial.panic == false {
			setupTutorial()
		}
		performSegueWithIdentifier("customSegueMain", sender: tabBarButtons[1])
	}
	
	// Actually groups
	@IBAction func contacts(sender: AnyObject) {
		tutorial.groupsButton = true
		tutorial.save()
		amAtHome = false
		closeSidebar()
		performSegueWithIdentifier("customSegueGroups", sender: sender)
	}
	
	@IBAction func history(sender: AnyObject) {
		amAtHome = false
		closeSidebar()
		hideTabbar()
		performSegueWithIdentifier("customSegueHistory", sender: sender)
	}
	
	@IBAction func settings(sender: AnyObject) {
		amAtHome = false
		closeSidebar()
		hideTabbar()
		performSegueWithIdentifier("customSegueSettings", sender: sender)
	}
	
	@IBAction func publicHistory(sender: AnyObject) {
		amAtHome = false
		closeSidebar()
		hideTabbar()
		performSegueWithIdentifier("customSeguePublicHistory", sender: sender)
	}
	
	@IBAction func emergancyNumbers(sender: AnyObject) {
		global.showAlert("", message: "Will show common emergancy numbers. eg. Paramedic, Polic, Fire etc")
	}
	
	func openSidebar() {
		if (recognizer.state == UIGestureRecognizerState.Began) {
			sideBarIsOpen = true
			if panicIsActive == false {
				self.sidebarLeftLayout.constant = 0
				tapRecognizer.enabled = true
				UIView.animateWithDuration(0.3, animations: {
					self.viewSidebar.layoutIfNeeded()
					self.hideTabbar()
					if self.amAtHome == true {
						tutorial.swipeToOpenMenu = true
						tutorial.save()
					}
				})
				if viewSwipeRight.hidden == false {
					UIView.animateWithDuration(0.5, animations: {
						self.viewSwipeRight.alpha = 0.0 }, completion: {
							(finished: Bool) -> Void in
							self.viewSwipeRight.hidden = true
							self.viewSwipeRight.alpha = 1.0
					})
				}
				if tutorial.groupsButton == false {
					if btnGroups.layer.animationForKey("shadowOpacity") == nil {
						animateGroupsButton()
					}
				}
			} else {
				global.showAlert("Not available", message: "Menus are unavailable while Panic is active")
			}
		}
	}
	
	func closeSidebar() {
		sideBarIsOpen = false
		self.sidebarLeftLayout.constant = -self.viewSidebar.frame.width - 1
		tapRecognizer.enabled = false
		UIView.animateWithDuration(0.3, animations: {
			self.viewSidebar.layoutIfNeeded()
			if (self.amAtHome == true) {
				self.showTabbar()
			}
		})
	}
	
	func showTabbar() {
		if panicIsActive == false {
			
			self.tabbarBottomLayout.constant = 0
			UIView.animateWithDuration(0.3, animations: {
				self.tabbarView.layoutIfNeeded()  })
		}
	}
	func hideTabbar() {
		
		self.tabbarBottomLayout.constant = -48
		UIView.animateWithDuration(0.3, animations: {
			self.tabbarView.layoutIfNeeded() })
	}
	
	@IBAction func back(sender: AnyObject) {
		global.showAlert("Note", message: "Logging out disables any panic notifications. You therefor will not be notified when someone activates the panic button.\n\nClosing the app with the home button or even the app switcher logs you out in a way that you still recieve notifications.")
		if global.persistantSettings.objectForKey("groups") != nil {
			global.persistantSettings.removeObjectForKey("groups")
		}
		PFUser.logOut()
		var installation = PFInstallation.currentInstallation()
		installation.setObject([], forKey: "channels")
		installation.saveInBackgroundWithBlock(nil)
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	override func shouldAutorotate() -> Bool {
		return true
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		let availableIdentifiers = ["customSegueMain", "customSegueMap", "customSegueGroups", "customSegueHistory", "customSegueSettings", "customSeguePublicHistory"]
		
		if(contains(availableIdentifiers, segue.identifier!)) {
			
			for btn in tabBarButtons {
				btn.titleLabel?.textColor = UIColor.grayColor()
			}
			
			let senderBtn = sender as UIButton
			senderBtn.titleLabel?.textColor = UIColor.whiteColor()
			
			if (segue.identifier != "customSegueMain" && segue.identifier != "customSegueMap") {
				hideTabbar()
			}
		}
	}
	
	// Tutorial
	
	func animateSwipeRight() {
		layoutLeftSwipeRight.constant = 8
		imageSwipeRight.layoutIfNeeded()
		animateChange(imageSwipeRight, controlLayout: layoutLeftSwipeRight, number: self.view.bounds.width - imageSwipeRight.bounds.width - 8, duration: 2)
		if tutorial.swipeToOpenMenu == false {
		let timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "animateSwipeRight", userInfo: nil, repeats: false)
		}
	}
	
	func animateGroupsButton() {
		
		self.btnGroups.layer.shadowColor = UIColor.whiteColor().CGColor
		self.btnGroups.layer.shadowRadius = 5.0
		self.btnGroups.layer.shadowOffset = CGSizeZero
		self.btnGroups.layer.shadowOpacity = 0.0
		self.btnGroups.layer.opacity = 0.4
		
		var animateShadow = CABasicAnimation(keyPath: "shadowOpacity")
		animateShadow.fromValue = 0.0
		animateShadow.toValue = 1.0
		animateShadow.autoreverses = true
		animateShadow.duration = 1
		
		var animateButton = CABasicAnimation(keyPath: "opacity")
		animateButton.fromValue = 0.4
		animateButton.toValue = 1.0
		animateButton.autoreverses = true
		animateButton.duration = 1
		
		self.btnGroups.layer.addAnimation(animateShadow, forKey: "shadowOpacity")
		self.btnGroups.layer.addAnimation(animateButton, forKey: "opacity")
		if tutorial.groupsButton == false {
			let timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "animateGroupsButton", userInfo: nil, repeats: false)
		} else {
			self.btnGroups.layer.opacity = 1.0
		}
	}
	
	func animateChange(control : AnyObject, controlLayout : NSLayoutConstraint, number : CGFloat, duration : NSTimeInterval = 0.3) {
		controlLayout.constant = number
		UIView.animateWithDuration(duration, animations: {
			control.layoutIfNeeded()
		})
	}
	
	// Tutorial Panic
	
	func setupTutorial() {
		btnPanic.setTitle("Activate", forState: UIControlState.Normal)
		descriptionCount = 0
		lblDescription.text = "Tap the Panic button. For the duration of this tutorial, it will have no effect but once it's finished, the button is live."
		viewTutorialPanic.hidden = false
		btnPanic.layer.cornerRadius = 0.5 * btnPanic.bounds.size.width
		btnPanic.layer.borderWidth = 2
		btnPanic.layer.borderColor = UIColor.greenColor().CGColor
		
		btnPanic.layer.shadowOpacity = 1.0
		btnPanic.layer.shadowColor = UIColor.greenColor().CGColor
		btnPanic.layer.shadowRadius = 4.0
		btnPanic.layer.shadowOffset = CGSizeZero
	}
	
	@IBAction func panicPressed(sender: AnyObject) {
		if (btnPanic.titleLabel?.text == "Activate") {
			btnPanic.setTitle("Deactivate", forState: UIControlState.Normal)
			btnPanic.layer.borderColor = UIColor.redColor().CGColor
			btnPanic.layer.shadowColor = UIColor.redColor().CGColor
		} else {
			btnPanic.setTitle("Activate", forState: UIControlState.Normal)
			btnPanic.layer.borderColor = UIColor.greenColor().CGColor
			btnPanic.layer.shadowColor = UIColor.greenColor().CGColor
		}
		descriptionCount = descriptionCount + 1
		
		switch (descriptionCount) {
		case 1:
			animateTextChange("In this state, your position is made available for others to track live on a map (which you can also do by tapping 'Map' in the bottom right corner of your screen after this tutorial). Notifications are also sent to people subscribed to the same groups you are, alerting them of your distress.")
			break;
			
		case 2:
			animateTextChange("When activating the Panic button, there is a 5 second time delay before notifications are sent out - this is to cater for accidental activations - it is very IMPORTANT to keep the app open for these 5 seconds. This can be disabled in Settings by choosing to have a confirmation each time it is activated.")
			break;
			
		case 3:
			animateTextChange("Tap one more time to finish")
			break;
			
		case 4:
			UIView.animateWithDuration(1.5, animations: {
				self.viewTutorialPanic.alpha = 0.0 }, completion: {
					(finished: Bool) -> Void in
					self.viewTutorialPanic.hidden = true
					self.viewTutorialPanic.alpha = 1.0
			})
			tutorial.panic = true
			tutorial.save()
			break;
			
		default:
			break;
		}
	}
	
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
}