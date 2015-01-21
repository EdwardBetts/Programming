//
//  SettingsViewController.swift
//  MyCiti
//
//  Created by Byron Coetsee on 2014/09/19.
//  Copyright (c) 2014 Byron Coetsee. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var sliderTime: UISlider!
    
    var mail: MFMailComposeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var notificationTime : Int = pref.persistantSettings.objectForKey("notificationTime") as Int
        lblTime.text = "\(notificationTime) mins"
        sliderTime.value = Float(notificationTime)
    }
    
    @IBAction func updateTime(sender: AnyObject) {
        lblTime.text = "\(Int(sliderTime.value)) mins"
        pref.persistantSettings.setObject(Int(sliderTime.value), forKey: "notificationTime")
        pref.persistantSettings.synchronize()
    }
    
    @IBAction func update(sender: AnyObject) {
        pref.showAlert("Coming soon...", message: "Will be used to update the apps information from an online python script.")
    }
    
    @IBAction func report(sender: AnyObject) {
        mail = MFMailComposeViewController()
        if(MFMailComposeViewController.canSendMail()) {
            
            mail.mailComposeDelegate = self
            mail.setSubject("MyCiti App")
            mail.setToRecipients(["byroncoetsee@gmail.com"])
            mail.setMessageBody("I am having the following issues with the MyCiti app: ", isHTML: true)
            self.presentViewController(mail, animated: true, completion: nil)
        }
        else {
            pref.showAlert("Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        switch(result.value){
        case MFMailComposeResultSent.value:
            println("Email sent")
            
        default:
            println("Whoops")
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
