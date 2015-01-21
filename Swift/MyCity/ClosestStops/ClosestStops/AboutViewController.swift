//
//  AboutViewController.swift
//  MyCiti
//  :)
//
//  Created by Byron Coetsee on 2014/09/19.
//  Copyright (c) 2014 Byron Coetsee. All rights reserved.
//

import UIKit
import MessageUI
import Parse

class AboutViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var txtNotices: UITextView!
    
    var mail: MFMailComposeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        txtNotices.editable = true
        txtNotices.editable = false
        PFAnalytics.trackEventInBackground("About", dimensions: nil, block: nil)
        
        var fetchNotices: dispatch_queue_t = dispatch_queue_create("fetchNotices", nil)
        
        dispatch_async(fetchNotices, {
            var text : String = self.updateInformationText()
            dispatch_async(dispatch_get_main_queue(), {
                self.txtNotices.text = text
            })
        })
    }
    
    @IBAction func contact(sender: AnyObject) {
        
        mail = MFMailComposeViewController()
        if(MFMailComposeViewController.canSendMail()) {
            
            mail.mailComposeDelegate = self
            mail.setSubject("MyCiti App")
            mail.setToRecipients(["byroncoetsee@gmail.com"])
            mail.setMessageBody("Dig your app mate!", isHTML: true)
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
    
    func updateInformationText() -> String
    {
        var url: NSURL = NSURL(string: "http://www.switchedoncomputing.co.za/appUpdates.cgi".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        var error: NSError?
        var webData = String(contentsOfURL: url, encoding: NSUTF8StringEncoding, error: &error)
        
        if error == nil {
            return (webData! as String)
        } else {
            return "No notices at this time."
        }
    }
    
    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
