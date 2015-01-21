//
//  AppDelegate.swift
//  drag
//
//  Created by Byron Coetsee on 2014/07/25.
//  Copyright (c) 2014 Byron Coetsee. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        
        Parse.setApplicationId("DGeEnbm6txDU6JQmFZXdMIJAdZTqstLVo6B8nKnw", clientKey: "RZIUCesZBfIV9JZLwe8RduGdhAOJfqJvBA0QvNwe")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        if (UIDevice.currentDevice().systemVersion == "8.0")
        {
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert |
                UIUserNotificationType.Badge, categories: nil
                ))
        } else {
            application.registerForRemoteNotificationTypes(UIRemoteNotificationType.Badge | UIRemoteNotificationType.Sound | UIRemoteNotificationType.Alert)
        }
        
        return true
    }
    
    func application(application: UIApplication!, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData!) {
        var installation: PFInstallation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication!, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]!) {
        PFPush.handlePush(userInfo)
    }
    
    func application(application: UIApplication!, didFailToRegisterForRemoteNotificationsWithError error: NSError!) {
        println(error)
    }
    
    func applicationWillResignActive(application: UIApplication!) {
        signout()
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication!) {
        signout()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication!) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication!) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication!) {
        signout()
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // Sign out the user - change their status to 'off'
    func signout() {
        var query = PFQuery(className:"Locations")
        query.whereKey("user", equalTo:current.user)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if !error {
                for object : PFObject! in objects {
                    object["status"] = "off"
                    object.saveInBackground()
                    println("Set status to OFF")
                }
            }
        }
    }
}

