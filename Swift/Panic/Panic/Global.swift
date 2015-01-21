//
//  Global.swift
//  Panic
//
//  Created by Byron Coetsee on 2014/11/30.
//  Copyright (c) 2014 Byron Coetsee. All rights reserved.
//

import UIKit
import Parse
import SystemConfiguration

var global : Global = Global()

extension String {
    func stripCharactersInSet(chars: [Character]) -> String {
        return String(filter(self) {find(chars, $0) == nil})
    }
    
    func formatGroupForChannel() -> String {
        return self.lowercaseString.capitalizedString.stripCharactersInSet([" "])
    }
    
    func formatGroupForFlatValue() -> String {
        return self.lowercaseString.stripCharactersInSet([" ", "_", "-", ",", "\"", ".", "/", "!", "?", "#", "(", ")", "&"])
    }
	
	func trim() -> String {
		return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
	}
}

class Global: UIViewController {
    
    var joinedGroups : [String] = [] // Array of groups the user belongs to
    var victimInformation : [String : [String]] = [:]
    var persistantSettings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var installation : PFInstallation = PFInstallation.currentInstallation()
    var panicHistoryLocal : [PFObject] = []
    var panicHistoryPublic : [PFObject] = []
    let queryUsers = PFUser.query()
    var queryUsersBusy = false
    var countries : [String] = []
    var appIsInBackground = false
    var panicConfirmation = false
	var backgroundPanic = false
    
    func getUserInformation() -> Bool {
        
        if PFUser.currentUser() != nil {
            PFUser.currentUser().fetchInBackgroundWithBlock({
                (object : PFObject!, error : NSError!) -> Void in
                if error != nil {
                    println("getUserInformation - \(error)")
                } else {
//                    println(object)
                }
            })
            
            if checkInternetConnectivity() == false {
                showAlert("No internet", message: "Although you have been logged in, an internet connection cannot be established. Please note this will have negative effects on the panic system. If you activate Panic, it will continue to try connect, but success cannot be guaranteed")
            }
			tutorial.load()
            return true
        }
		tutorial.reset()
        return false
    }
    
    func getVictimInformation(victims : [PFUser : PFGeoPoint]) {
        for (name, location) in victims {
            if self.victimInformation[name.objectId] == nil && queryUsersBusy == false {
                queryUsersBusy = true
                queryUsers.getObjectInBackgroundWithId(name.objectId, block: {
                    (userObject : PFObject!, error : NSError!) -> Void in
                    if userObject != nil {
                        let victimUsername = userObject["username"] as String
                        let victimName = userObject["name"] as String
                        let victimCell = userObject["cellNumber"] as String
                        self.victimInformation[name.objectId] = [victimUsername, victimName, victimCell]
//                        println("Fetching info for user \(victimUsername)")
                    }
                    self.queryUsersBusy = false
//                    println("Set queryUsersBusy to false")
                })
            } else if queryUsersBusy == true {
				
            }
        }
    }
    
    func getGroups() {
        if persistantSettings.objectForKey("groups") != nil {
            joinedGroups = persistantSettings.objectForKey("groups") as [String]
        } else {
            var user = PFUser.currentUser()
            if user["groups"] != nil {
                joinedGroups = user["groups"] as [String]
            } else {
                joinedGroups = []
            }
        }
        
        var groupFormatted : [String] = []
        for group in joinedGroups {
            groupFormatted.append(group.lowercaseString.capitalizedString.stripCharactersInSet([" "]))
        }
        installation.setObject([], forKey: "channels")
        installation.addUniqueObjectsFromArray(groupFormatted, forKey: "channels")
        installation.saveInBackgroundWithBlock(nil)
    }
    
    func getLocalHistory() {
        panicHistoryLocal = []
        var queryHistory = PFQuery(className: "Panics")
        queryHistory.whereKey("user", equalTo: PFUser.currentUser())
        queryHistory.orderByDescending("createdAt")
		queryHistory.includeKey("user")
		queryHistory.limit = 50
        queryHistory.findObjectsInBackgroundWithBlock({
            (objects : [AnyObject]!, error : NSError!) -> Void in
            if error == nil {
                for objectRaw in objects {
                    let object = objectRaw as PFObject
                    self.panicHistoryLocal.append(object)
                }
            } else {
                println(error)
            }
            println("DONE getting local history")
        })
    }
    
    func addGroup(groupName : String) {
        joinedGroups.append(groupName)
        persistantSettings.setObject(joinedGroups, forKey: "groups")
        persistantSettings.synchronize()
		updateSubs(groupName, amount: 1)
        updateGroups()
        installation.addUniqueObject(groupName.lowercaseString.capitalizedString.stripCharactersInSet([" "]), forKey: "channels")
        installation.saveInBackgroundWithBlock(nil)
    }
    
    func removeGroup(groupName : String) {
        joinedGroups.removeAtIndex(find(joinedGroups, groupName)!)
        persistantSettings.setObject(joinedGroups, forKey: "groups")
        persistantSettings.synchronize()
		updateSubs(groupName, amount: -1)
        updateGroups()
        installation.removeObject(groupName.lowercaseString.capitalizedString.stripCharactersInSet([" "]), forKey: "channels")
        installation.saveInBackgroundWithBlock(nil)
    }
	
	func updateSubs(groupName: String, amount: Int) {
		var incrementSubCountQuery = PFQuery(className: "Groups")
		incrementSubCountQuery.whereKey("flatValue", equalTo: groupName.formatGroupForFlatValue())
		incrementSubCountQuery.getFirstObjectInBackgroundWithBlock({
			(object: PFObject!, error: NSError!) -> Void in
			if object != nil {
				object.incrementKey("subscribers", byAmount: amount)
				object.saveInBackgroundWithBlock(nil)
			}
		})
	}
    
    func updateGroups() {
        var user = PFUser.currentUser()
        user["groups"] = joinedGroups
        user.saveInBackgroundWithBlock(nil)
    }
    
    func setPanicNotification(enabled : Bool) {
        if enabled == true {
            panicConfirmation = true
        } else {
            panicConfirmation = false
        }
        persistantSettings.setObject(panicConfirmation, forKey: "panicConfirmation")
        persistantSettings.synchronize()
    }
	
	func setBackgroundUpdate(enabled : Bool) {
		if enabled == true {
			backgroundPanic = true
		} else {
			backgroundPanic = false
		}
		persistantSettings.setObject(panicConfirmation, forKey: "backgroundPanic")
		persistantSettings.synchronize()
	}
	
    func getCountries() {
        var bundle : String = NSBundle.mainBundle().pathForResource("Countries", ofType: "txt")!
        var content = String(contentsOfFile: bundle, encoding: NSUTF8StringEncoding, error: nil)!
        var countriesRaw: [String] = content.componentsSeparatedByString("\n")
        for country in countriesRaw {
            if !country.isEmpty {
                countries.append(country)
            }
        }
        countries = countries.sorted{ $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }
        println("Done getting countries")
    }

    func checkInternetConnectivity() -> Bool{
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
        }
        
        var flags: SCNetworkReachabilityFlags = 0
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
            return false
        }
        
        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection) ? true : false
    }
    
    func showAlert(title: String, message: String)
    {
        var alert: UIAlertView = UIAlertView()
        alert.addButtonWithTitle("OK")
        alert.title = title
        alert.message = message
        alert.show()
    }
    
    func getSystemVersion() -> Int
    {
        return UIDevice.currentDevice().systemVersion.componentsSeparatedByString(".")[0].toInt()!
    }
	
	// TUTORIAL STUFF
	
	func showTutorialView() -> UIVisualEffectView {
		let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
		var blurView = UIVisualEffectView(effect: darkBlur)
		blurView.frame = self.view.bounds
		return blurView
	}
}
