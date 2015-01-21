//
//  ViewController.swift
//  drag
//
//  Created by Byron Coetsee on 2014/07/25.
//  Copyright (c) 2014 Byron Coetsee. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
                            
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblLat: UILabel!
    @IBOutlet var lblLong: UILabel!
    
    var manager = CLLocationManager()
    var user = "Byron"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UIDevice.currentDevice().systemVersion == "8.0") { manager.requestWhenInUseAuthorization() }
        
//        var timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "sendLocation", userInfo: nil, repeats: true)
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
    }
    
    @IBAction func retrieve(sender: AnyObject) {
        
        var query = PFQuery(className:"Locations")
        query.whereKey("user", equalTo:"testPlayer")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if !error {
                // The find succeeded.
                println("Successfully retrieved \(objects.count) scores.")
//                // Do something with the found objects
                for object : PFObject! in objects {
                    var geopoint = PFGeoPoint(latitude: self.manager.location.coordinate.latitude, longitude: self.manager.location.coordinate.longitude)
                    object["location"] = geopoint
                    object.saveInBackground()
                    println("yay")
                }
            } else {
                var location = PFObject(className: "Locations")
                location["user"] = "anotherPlayer"
                var geopoint = PFGeoPoint(latitude: self.manager.location.coordinate.latitude, longitude: self.manager.location.coordinate.longitude)
                location["location"] = geopoint
                location.saveInBackground()
                println("nay")
            }
        }
        
        println(manager.location.coordinate.latitude)
        println(manager.location.coordinate.longitude)
    }
    
    func sendLocation()
    {
        var location = PFObject(className: "Locations")
        location["user"] = "Byron"
//        location["location"] = [manager.location.coordinate.latitude, manager.location.coordinate.longitude]
        location.saveInBackground()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

