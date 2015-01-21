//
//  Global.swift
//  Underground
//
//  Created by Byron Coetsee on 2014/10/26.
//  Copyright (c) 2014 Byron Coetsee. All rights reserved.
//

import Foundation
import UIKit

var global : Global = Global()

class Global: UIViewController {
    
    func showAlert(title: String, message: String)
    {
//        if getSystemVersion() < 8 {
//            var alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
//        } else {
            var alert: UIAlertView = UIAlertView()
            alert.addButtonWithTitle("OK")
            alert.title = title
            alert.message = message
            alert.show()
//        }
    }
    
    func getSystemVersion() -> Int
    {
        return UIDevice.currentDevice().systemVersion.componentsSeparatedByString(".")[0].toInt()!
    }
    
}
