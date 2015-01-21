//
//  ViewController.swift
//  Underground
//
//  Created by Byron Coetsee on 2014/10/24.
//  Copyright (c) 2014 Byron Coetsee. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func login(sender: AnyObject) {
        var user = PFUser()
        PFUser.logInWithUsernameInBackground(txtUsername.text, password: txtPassword.text, block: {(user: PFUser!, error: NSError!) -> Void in
            if (error != nil) {
                println(error)
                self.btnLogin.enabled = false
                self.btnSignup.enabled = false
                switch error.code {
                case 100:
                    global.showAlert("Unsuccessful", message: "The network connection was lost")
                    self.btnLogin.enabled = true
                    self.btnSignup.enabled = true
                    break
                case 101:
                    global.showAlert("Unsuccessful", message: "Invalid login credentials")
                    self.btnLogin.enabled = true
                    self.btnSignup.enabled = true
                    break
                default:
                    global.showAlert("Unsuccessful", message: "Dunno, bra")
                    self.btnLogin.enabled = true
                    self.btnSignup.enabled = true
                    break
                }
            } else {
                var storyboard = UIStoryboard(name: "Main", bundle: nil)
                var vc: MainViewController = storyboard.instantiateViewControllerWithIdentifier("mainViewController") as MainViewController
                vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                self.self.presentViewController(vc, animated: true, completion: {
                    global.showAlert("IN", message: "We in yo!")
                })
            }
        })
    }
    
    @IBAction func signup(sender: AnyObject) {
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var vc: SignupViewController = storyboard.instantiateViewControllerWithIdentifier("signupViewController") as SignupViewController
        vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    //    func showAlert(title: String, message: String)
    //    {
    //        var systemVersion : Int = UIDevice.currentDevice().systemVersion.componentsSeparatedByString(".")[0].toInt()!
    //        if systemVersion < 8 {
    //            var alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    //            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    //            self.presentViewController(alert, animated: true, completion: nil)
    //        } else {
    //            var alert: UIAlertView = UIAlertView()
    //            alert.addButtonWithTitle("OK")
    //            alert.title = title
    //            alert.message = message
    //            alert.show()
    //        }
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

