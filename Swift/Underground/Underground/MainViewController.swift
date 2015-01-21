//
//  MainViewController.swift
//  Underground
//
//  Created by Byron Coetsee on 2014/10/24.
//  Copyright (c) 2014 Byron Coetsee. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Parse

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var statusIndicator: UISwitch!
    @IBOutlet weak var lblRegistered: UILabel!
    @IBOutlet weak var lblOnline: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var btnMap: UIButton!
    @IBOutlet weak var switchStatus: UISwitch!
    
    var manager = CLLocationManager()
    var status = "off"
    var changingStatus = false
    var errorMessageCounter: dispatch_once_t = 0
    var timerSetStatusOff: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func map(sender: AnyObject) {
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var vc: MapViewController = storyboard.instantiateViewControllerWithIdentifier("mapViewController") as MapViewController
        vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func changeStatus(sender: AnyObject) {
        
        if self.statusIndicator.on {
            setStatusOn()
        } else {
            setStatusOff()
        }
    }
    
    @IBAction func settings(sender: AnyObject) {
        // Settings
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == CLAuthorizationStatus.Authorized || status == CLAuthorizationStatus.AuthorizedWhenInUse {
            // show button
        } else if status == CLAuthorizationStatus.Denied {
            global.showAlert("Location Denied", message: "Please allow location services for this app in Privacy Settings")
        }
    }
    
    func setStatusOn() {
        manager.startUpdatingLocation()
        if manager.location.horizontalAccuracy < 31 {
            status = "on"
            spinner.startAnimating()
            statusIndicator.userInteractionEnabled = false
            var dispatch = dispatch_queue_create("dispatch", nil)
            dispatch_async(dispatch, {
                var query = PFQuery(className:"Locations")
                query.whereKey("user", equalTo:PFUser.currentUser())
                query.findObjectsInBackgroundWithBlock({
                    (objects: [AnyObject]!, error: NSError!) -> Void in
                    if error == nil {
                        switch objects.count {
                        case 0:
                            // None (Should be this) - make one
                            var data = PFObject(className:"Locations")
                            data["user"] = PFUser.currentUser()
                            data["location"] = PFGeoPoint(location: self.manager.location!)
                            println("ON")
                            break
                        case 1:
                            // Only one - update location of it
                            var tempObject : PFObject = objects[0] as PFObject
                            tempObject["location"] = PFGeoPoint(location: self.manager.location)
                            tempObject.saveInBackgroundWithBlock(nil)
                            println("ON")
                            break
                        default:
                            // Any more than 1 - delete all and remake only one
                            for object in objects {
                                var tempObject : PFObject = object as PFObject
                                tempObject.deleteInBackgroundWithBlock(nil)
                            }
                            var data = PFObject(className:"Locations")
                            data["user"] = PFUser.currentUser()
                            data["location"] = PFGeoPoint(location: self.manager.location!)
                            println("ON")
                            break
                        }
                    } else {
                        self.switchStatus.setOn(false, animated: true)
                        global.showAlert("Oops", message: "Something went wrong. Please try again and check your internet connection")
                    }
                })
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.stopAnimating()
                    self.statusIndicator.userInteractionEnabled = true
                })
            })
        } else {
            switchStatus.setOn(false, animated: true)
            global.showAlert("GPS Accuracy", message: "Could not get a strong enough GPS signal. Try putting your phone on the dashboard and try again")
        }
    }
    
    func setStatusOff() {
        manager.stopUpdatingLocation()
        status = "off"
        spinner.startAnimating()
        statusIndicator.userInteractionEnabled = false
        var dispatch = dispatch_queue_create("dispatch", nil)
        dispatch_async(dispatch, {
            var query = PFQuery(className:"Locations")
            query.whereKey("user", equalTo:PFUser.currentUser())
            query.findObjectsInBackgroundWithBlock({
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    for object in objects {
                        var tempObject : PFObject = object as PFObject
                        tempObject.deleteInBackgroundWithBlock(nil)
                    }
                }
                //                else {
                //                    self.timerSetStatusOff = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "reload", userInfo: nil, repeats: true)
                //                    self.timerSetStatusOff.tolerance = NSTimeInterval(0.2)
                //                }
            })
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.stopAnimating()
                self.statusIndicator.userInteractionEnabled = true
            })
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}