//
//  SignupViewController.swift
//  Underground
//
//  Created by Byron Coetsee on 2014/10/24.
//  Copyright (c) 2014 Byron Coetsee. All rights reserved.
//

import Foundation
import UIKit
import Parse

class SignupViewController: UIViewController, PFSignUpViewControllerDelegate {
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPasswordConfirm: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func signup(sender: AnyObject) {
        if !txtUsername.text.isEmpty && !txtPassword.text.isEmpty && !txtPasswordConfirm.text.isEmpty {
            if txtPassword.text == txtPasswordConfirm.text {
                var user : PFUser = PFUser()
                user.username = txtUsername.text
                user.password = txtPassword.text
                user.signUpInBackgroundWithBlock {(succeeded: Bool!, error: NSError!) -> Void in
                    if (error != nil) {
                        if error.code == 202 {
                            global.showAlert("Unsuccessful", message: "Username \(self.txtUsername.text) already taken")
                            self.txtUsername.becomeFirstResponder()
                        } else {
                            global.showAlert("Unsuccessful", message: error.description)
                        }
                        println(error)
                    } else {
                        global.showAlert("Success", message: "You have been signed up. Sweet")
                    }
                }
            } else {
                global.showAlert("Almost...", message: "Passwords do not match")
                // Password field becomeFirstResponder, but which one? D:
            }
        } else {
            global.showAlert("Oops", message: "Fill in all the fields")
            // Maybe find the empty field and make first responder?
        }
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}