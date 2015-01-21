//
//  MainViewController.swift
//  Panic
//
//  Created by Byron Coetsee on 2014/11/30.
//  Copyright (c) 2014 Byron Coetsee. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

protocol testDelegate {
    func test()
}

class MainViewController: UIViewController, UIGestureRecognizerDelegate, CLLocationManagerDelegate {
    
    var delegate: testDelegate?
    
    var testString = ""
    
    var tabbarViewController : TabBarViewController!
    var manager : CLLocationManager!
    var pushQuery : PFQuery = PFInstallation.query()
    var pendingPushNotifications = false // Tracks the button status. Dont send push if Panic isnt active.
    var allowAddToPushQue = true // Tracks if a push has been sent. Should not allow another push to be qued if false.
	
    
    @IBOutlet weak var btnPanic: UIButton!
    @IBOutlet weak var background: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "pauseLocationUpdates:", name:"applicationDidEnterBackground", object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "resumeLocationUpdates:", name:"applicationWillEnterForeground", object: nil)
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        
        btnPanic.layer.cornerRadius = 0.5 * btnPanic.bounds.size.width
        btnPanic.layer.borderWidth = 2
        btnPanic.layer.borderColor = UIColor.greenColor().CGColor
        
        btnPanic.layer.shadowOpacity = 1.0
        btnPanic.layer.shadowColor = UIColor.greenColor().CGColor
        btnPanic.layer.shadowRadius = 4.0
        btnPanic.layer.shadowOffset = CGSizeZero
    }
    
    @IBAction func panicPressed(sender: AnyObject) {
		tabbarViewController.closeSidebar()
		if tutorial.swipeToOpenMenu == true {
			if (btnPanic.titleLabel?.text == "Activate") {
				UIView.animateWithDuration(0.3, animations: {
					self.tabbarViewController.hideTabbar() })
				
				if global.panicConfirmation == true {
					
					var saveAlert = UIAlertController(title: "Activate?", message: "Activate Panic and send notifications?", preferredStyle: UIAlertControllerStyle.Alert)
					saveAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
						self.activatePanic()
					}))
					saveAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action: UIAlertAction!) in }))
					presentViewController(saveAlert, animated: true, completion: nil)
					
				} else {
					activatePanic()
				}
			} else {
				deativatePanic()
			}
		}
    }
	
    func activatePanic() {
		panicHandler.panicIsActive = true
        tabbarViewController.panicIsActive = true
        manager.startUpdatingLocation()
        btnPanic.setTitle("Deactivate", forState: UIControlState.Normal)
        btnPanic.layer.borderColor = UIColor.redColor().CGColor
        btnPanic.layer.shadowColor = UIColor.redColor().CGColor
        
        if pendingPushNotifications == false {
            pendingPushNotifications = true
            if allowAddToPushQue == true {
                allowAddToPushQue = false
                if global.panicConfirmation == true {
                    sendNotification()
                } else {
                    let timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "sendNotification", userInfo: nil, repeats: false)
                }
            }
        }
    }
    
    func deativatePanic() {
		panicHandler.panicIsActive = false
        pendingPushNotifications = false
        tabbarViewController.panicIsActive = false
        global.getLocalHistory()
        UIView.animateWithDuration(0.3, animations: {
            self.tabbarViewController.showTabbar() })
        panicHandler.endPanic()
        manager.stopUpdatingLocation()
        btnPanic.setTitle("Activate", forState: UIControlState.Normal)
        btnPanic.layer.borderColor = UIColor.greenColor().CGColor
        btnPanic.layer.shadowColor = UIColor.greenColor().CGColor
    }
    
    func sendNotification() {
        println("In sendNotificaion method")
        var dict = NSDictionary(dictionary: ["badge":"Increment"])
        if pendingPushNotifications == true {
//            var channels : [String] = []
            for group in global.joinedGroups {
//                channels.append(group.formatGroupForFlatValue())
                var push = PFPush()
                let userName = PFUser.currentUser()["name"] as String
                let userNumber = PFUser.currentUser()["cellNumber"] as String
				var tempQuery = PFInstallation.query()
//				tempQuery.whereKey("channels", containsString: group.formatGroupForChannel())
				tempQuery.whereKey("channels", equalTo: group.formatGroupForChannel())
				tempQuery.whereKey("installationId", notEqualTo: PFInstallation.currentInstallation().installationId)
				push.setQuery(tempQuery)
//				push.setChannel(group.formatGroupForChannel())
                push.expireAfterTimeInterval(18000) // 5 Hours
                push.setData(["alert" : "\(userName) needs help! Contact them on \(userNumber) or view their location in the app.", "badge" : "Increment", "sound" : "default"])
//                push.sendPushInBackgroundWithBlock(nil)
				push.sendPushInBackgroundWithBlock({
					(result : Bool!, error : NSError!) -> Void in
					if result == true {
						println("Push sent to group \(group.formatGroupForChannel())")
					} else if error != nil {
						println(error)
					}
				})
//                println("Push sent to group \(group.formatGroupForChannel())")
            }
            pendingPushNotifications = false
            
        } else {
            println("Canceled Notifications")
        }
        allowAddToPushQue = true
    }
    
    // LOCATION FUNCTIONS *******************
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//		if global.appIsInBackground == true {
//			manager.startMonitoringSignificantLocationChanges()
        panicHandler.updatePanic(manager.location)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
    }
	
	func pauseLocationUpdates(notification: NSNotification) {
		println("PAUSED from NC")
		manager.stopUpdatingLocation()
	}
	
	func resumeLocationUpdates(notification: NSNotification) {
		println("RESUMED from NC")
		manager.startUpdatingLocation()
	}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
