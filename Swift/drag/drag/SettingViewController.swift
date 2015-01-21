//
//  SettingViewController.swift
//  drag
//
//  Created by Byron Coetsee on 2014/07/26.
//  Copyright (c) 2014 Byron Coetsee. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet var lblDistance: UILabel!
    @IBOutlet var distanceSlider: UISlider!
    @IBOutlet var txtCar: UITextField!
    @IBOutlet var segModded: UISegmentedControl!
    @IBOutlet var txtHorsepower: UITextField!
    @IBOutlet var txtColour: UITextField!
    @IBOutlet var viewLoading: UIView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var saveChanges = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewLoading.layer.cornerRadius = 10
        
        lblDistance.text = NSString(format: "%.0f", round(abs(current.radius)))
        distanceSlider.value = Float(current.radius)
    }
    
    override func viewDidAppear(animated: Bool) {
        startLoading()
        var query = PFQuery(className:"Profiles")
        query.whereKey("username", equalTo:current.user)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if !error {
                for object : PFObject! in objects {
                    self.txtCar.text = object["car"] as String
                    println(object["modded"] as String)
                    if object["modded"] as String == "Yes" {
                        self.segModded.selectedSegmentIndex = 0
                    } else {
                        self.segModded.selectedSegmentIndex = 1
                    }
                    self.txtHorsepower.text = object["horsepower"] as String
                    self.txtColour.text = object["colour"] as String
                }
            } else {
                println(error)
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.stopLoading()
                })
        }
    }
    
    @IBAction func distanceBar(sender: AnyObject) {
        current.radius = Double(abs(distanceSlider.value))
        lblDistance.text = NSString(format: "%.0f", round(abs(current.radius)))
    }
    
    @IBAction func done(sender: AnyObject) {
        if saveChanges == true {
            startLoading()
            var query = PFQuery(className:"Profiles")
            query.whereKey("username", equalTo:current.user)
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if !error {
                    for object : PFObject! in objects {
                        object["car"] = self.txtCar.text
                        if self.segModded.selectedSegmentIndex == 0 {
                            object["modded"] = "Yes"
                        } else {
                            object["modded"] = "No"
                        }
                        object["horsepower"] = self.txtHorsepower.text
                        object["colour"] = self.txtColour.text
                        object.saveInBackground()
                    }
                    current.car = self.txtCar.text
                    current.colour = self.txtColour.text
                    current.hp = self.txtHorsepower.text
                    current.modded = self.segModded.selectedSegmentIndex
                    
                } else {
                    println(error)
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.stopLoading()
                    })
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func startLoading() {
        viewLoading.hidden = false
        spinner.startAnimating()
    }
    
    func stopLoading() {
        viewLoading.hidden = true
        spinner.startAnimating()
    }
    
    @IBAction func back (sedner: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func changeSaveChanges(sender: AnyObject) {
        saveChanges = true
    }
    
    @IBAction func hideKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
