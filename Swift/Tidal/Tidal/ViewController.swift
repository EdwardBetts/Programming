//
//  ViewController.swift
//  Tidal
//
//  Created by Byron Coetsee on 2014/11/04.
//  Copyright (c) 2014 Byron Coetsee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let shareDefaults = NSUserDefaults(suiteName: "group.tidalWidge")
        shareDefaults?.setObject("Have a great day", forKey: "stringKey")
        shareDefaults?.synchronize()
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

