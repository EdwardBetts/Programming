//
//  ViewController.swift
//  TimeSheet
//
//  Created by Byron Coetsee on 2014/11/17.
//  Copyright (c) 2014 Byron Coetsee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var punchTimes = NSUserDefaults.standardUserDefaults()
    var timesWorked : [String : [String]]!
    @IBOutlet weak var txtNum1: UITextField!
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var txtNum2: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func click2(sender : AnyObject) {
        lblResult.text = 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

