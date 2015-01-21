//
//  PanicHandler.swift
//  Panic
//
//  Created by Byron Coetsee on 2014/12/09.
//  Copyright (c) 2014 Byron Coetsee. All rights reserved.
//

import Foundation
import Parse

var panicHandler = PanicHandler()

class PanicHandler: UIViewController {
    
    let query : PFQuery = PFQuery(className: "Panics")
    var queryObject : PFObject!
    var updating = false
    var objectInUse = false // Set to true when beginPanic() is called and object is created successfully on server. Only updates locations if set to true.
	var panicIsActive = false
    
    func beginPanic (location : CLLocation) {
        if updating == false && queryObject == nil {
            println("BEGIN")
            updating = true
            
            queryObject = PFObject(className: "Panics")
            queryObject["user"] = PFUser.currentUser()
            queryObject["location"] = PFGeoPoint(location: location)
            queryObject["active"] = true
            
            queryObject.saveInBackgroundWithBlock({
                (result: Bool, error: NSError!) -> Void in
//                println("beginPanic - saveObject")
                if result == true {
                    self.updating = false
                    self.objectInUse = true
                } else if error != nil {
                    global.showAlert("Error beginning location", message: "\(error.localizedDescription)\nWill try again in a few seconds")
                    self.updating = false
                }
            })
        }
    }
    
    func updatePanic (location : CLLocation) {
        
        if objectInUse == true {
            if queryObject != nil && updating == false {
                println("UPDATING")
                updating = true
                queryObject["location"] = PFGeoPoint(location: location)
                queryObject["active"] = true
                queryObject.saveInBackgroundWithBlock({
                    (result: Bool, error: NSError!) -> Void in
                    println("updatePanic - saveInBackground")
                    if result == true {
                        self.updating = false
                    } else if error != nil {
                        global.showAlert("Error updating location", message: "\(error.localizedDescription)\nWill try again in a few seconds")
                        self.updating = false
                    }
                })
            }
        } else {
            beginPanic(location)
        }
    }
    
    func pausePanic () {
        if objectInUse == true {
            println("PAUSING")
            global.persistantSettings.setObject(queryObject.objectId!, forKey: "queryObjectId")
            endPanic()
        }
    }
    
    func resumePanic () {
        
        if global.persistantSettings.objectForKey("queryObjectId") != nil {
            println("RESUMING")
            println(global.persistantSettings.objectForKey("queryObjectId")!)
            queryObject = query.getObjectWithId(global.persistantSettings.objectForKey("queryObjectId")! as String)
            objectInUse = true
        }
    }
    
    func endPanic () {
        println("END")
        query.cancel()
        if queryObject != nil {
            queryObject["active"] = false
            queryObject.saveInBackgroundWithBlock({
                (result: Bool!, error: NSError!) -> Void in
                if result == true {
                    println("END RUN CORRECTLY")
                } else {
                    println("END DIDNT FINISH - \(error.localizedDescription)")
                }
            })
        }
        objectInUse = false
        queryObject = nil
    }
}
