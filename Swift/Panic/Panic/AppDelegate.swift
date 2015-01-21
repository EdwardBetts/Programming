//
//  AppDelegate.swift
//  Panic
//
//  Created by Byron Coetsee on 2014/11/30.
//  Copyright (c) 2014 Byron Coetsee. All rights reserved.
//

import UIKit
import Parse
import ParseCrashReporting

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//		ParseCrashReporting.enable()
        Parse.setApplicationId("cBZmGCzXfaQAyxqnTh6eF2kIqCUnSm1ET8wYL5O7", clientKey:"rno7DabpDMU293yi2TF4S3jKOlrZX2P27EW70C3G")
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
        
        var populateCountries: dispatch_queue_t = dispatch_queue_create("populateCountries", nil)
        
        dispatch_async(populateCountries, {
            global.getCountries()
        })
		
		if global.persistantSettings.objectForKey("queryObjectId") != nil {
			println("Cleared persistance from didFinishLaunchingWithOptions")
			global.persistantSettings.removeObjectForKey("queryObjectId")
		}
        
        if global.persistantSettings.objectForKey("panicConfirmation") == nil {
            global.setPanicNotification(false)
        } else {
            global.panicConfirmation = global.persistantSettings.boolForKey("panicConfirmation")
        }
        
        if (PFInstallation.currentInstallation().badge != 0) {
            PFInstallation.currentInstallation().badge = 0
            PFInstallation.currentInstallation().saveEventually()
        }
        
        var notiType = UIUserNotificationType.Badge | UIUserNotificationType.Sound | UIUserNotificationType.Alert
        
        var notiSettings:UIUserNotificationSettings
        notiSettings = UIUserNotificationSettings(forTypes:notiType, categories: nil)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(notiSettings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
//        println("Got remote notifs")
        var currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.saveInBackgroundWithBlock(nil)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
		if panicHandler.panicIsActive == false {
			PFPush.handlePush(userInfo)
		}
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
    }

    func applicationWillResignActive(application: UIApplication) {
//        println("applicationWillResignActive")
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
		if global.backgroundPanic == false {
			println("PAUSE")
			panicHandler.pausePanic()
			NSNotificationCenter.defaultCenter().postNotificationName("applicationDidEnterBackground", object: nil)
			
		}
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
		if global.backgroundPanic == false {
			println("RESUME")
			panicHandler.resumePanic()
			NSNotificationCenter.defaultCenter().postNotificationName("applicationWillEnterForeground", object: nil)
			
		}
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
//        println("applicationDidBecomeActive")
        
    }

	func applicationWillTerminate(application: UIApplication) {
		
		global.victimInformation = [:]
		panicHandler.endPanic()
		if global.persistantSettings.objectForKey("queryObjectId") != nil {
			global.persistantSettings.removeObjectForKey("queryObjectId")
		}
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
}

