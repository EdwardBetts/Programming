//
//  RacerProfileViewController.swift
//  drag
//
//  Created by Byron Coetsee on 2014/07/27.
//  Copyright (c) 2014 Byron Coetsee. All rights reserved.
//

import UIKit

class RacerProfileViewController: UIViewController {
    
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var lblWins: UILabel!
    @IBOutlet var lblLosses: UILabel!
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet var winLooseBar: UIProgressView!
    @IBOutlet var lblCar: UILabel!
    @IBOutlet var lblModded: UILabel!
    @IBOutlet var lblBhp: UILabel!
    @IBOutlet var lblColour: UILabel!
    @IBOutlet var viewLoading: UIView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var username: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewLoading.layer.cornerRadius = 10
        
        lblUsername.text = username
    }
    
    override func viewDidAppear(animated: Bool)  {
        
        var query = PFQuery(className: "Profiles")
        query.whereKey("username", equalTo: username)
        query.getFirstObjectInBackgroundWithBlock({
            (object: PFObject!, error: NSError!) -> Void in
            if !error {
                var wins = object["wins"] as Int
                var losses = object["losses"] as Int
                
                self.lblWins.text = "\(wins)"
                self.lblLosses.text = "\(losses)"
                self.lblCar.text = object["car"] as String
                self.lblBhp.text = object["horsepower"] as String
                self.lblColour.text = object["colour"] as String
                self.lblModded.text = object["modded"] as String
                
                self.lblTotal.text = "\(wins+losses)"
                self.winLooseBar.progress = Float(Float(losses)/Float(wins))
                dispatch_async(dispatch_get_main_queue(), {
                    self.stopLoading()
                    })
            }
            })

    }
    
    @IBAction func race(sender: AnyObject) {
        showAlert("Lets go!", message: "This will notify the racer they have been challenged to a race and will init the race procedure")
        
        var dispatch = dispatch_queue_create("dispatch", nil)
        dispatch_async(dispatch, {
            
            // Build the actual push notification target query
            var query : PFQuery = PFInstallation.query()
            query.whereKey("username", equalTo: self.username)
            
            // Send the notification.
            var push : PFPush = PFPush()
            push.setQuery(query)
            push.setMessage("\(current.user) is challenging you to a race")
            push.sendPushInBackground()
            
            var addChallengeQuery = PFObject(className: "Challenges")
            addChallengeQuery["challengeFrom"] = current.user
            addChallengeQuery["challengeTo"] = self.username
            addChallengeQuery["accepted"] = "no"
            addChallengeQuery.saveInBackground()
        })
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func message(sender: AnyObject) {
        showAlert("Message", message: "This will allow a user to send a message to the racer")
    }
    
    func startLoading() {
        viewLoading.hidden = false
        spinner.startAnimating()
    }
    
    func stopLoading() {
        viewLoading.hidden = true
        spinner.startAnimating()
    }
    
    func showAlert(title: String, message: String)
    {
        if UIDevice.currentDevice().systemVersion.compare("8.0") == true {
            var alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            var alert: UIAlertView = UIAlertView()
            alert.addButtonWithTitle("OK")
            alert.title = title
            alert.message = message
            alert.show()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
