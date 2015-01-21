//
//  SignUpViewController.swift
//  drag
//
//  Created by Byron Coetsee on 2014/07/26.
//  Copyright (c) 2014 Byron Coetsee. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet var txtUsername: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtPasswordCheck: UITextField!
    @IBOutlet var viewLoading: UIView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewLoading.layer.cornerRadius = 10
        
    }
    
    @IBAction func next(sender: AnyObject) {
        
        if !txtUsername.text.isEmpty & !txtUsername.text.isEmpty & !txtPassword.text.isEmpty & !txtPasswordCheck.text.isEmpty {
            if txtPassword.text == txtPasswordCheck.text {
                startLoading()
                // Sign them up!
                var user = PFUser()
                user.username = txtUsername.text
                user.password = txtPassword.text
                user.email = txtEmail.text
                user["installationId"] = PFInstallation.currentInstallation()
                
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool!, error: NSError!) -> Void in
                    if !error {
                        
                        var query = PFObject(className: "Profiles")
                        query["username"] = self.txtUsername.text
                        query["losses"] = 0
                        query["wins"] = 0
                        query.saveInBackground()
                        
                        query = PFObject(className: "Locations")
                        query["user"] = self.txtUsername.text
                        query["status"] = "off"
                        query["location"] = PFGeoPoint(latitude: 0.0, longitude: 0.0)
                        query.saveInBackground()
                        
                        self.showAlert("Game On", message: "Please login to begin.\n\nNote: This app is only to be used on closed off or private roads with permission from the local traffic police. By tapping 'OK' you acknowladge this and retain all responsibility for your actions.\nIf you die, lolz.\n\nWelcome to the Thunderdome")
                        self.stopLoading()
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        self.showAlert("Oops", message: error.localizedDescription)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.stopLoading()
                            })
                    }
                }
            } else {
                showAlert("Password Mismatch", message: "The passwords you typed do not match")
            }
        } else {
            showAlert("Missing fields", message: "Please fill in all the fields")
        }
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
    
    func startLoading() {
        viewLoading.hidden = false
        spinner.startAnimating()
    }
    
    func stopLoading() {
        viewLoading.hidden = true
        spinner.startAnimating()
    }
    
    @IBAction func back (sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func hideKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
