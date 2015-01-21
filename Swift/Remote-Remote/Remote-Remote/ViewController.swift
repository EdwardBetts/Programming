//
//  ViewController.swift
//  Remote-Remote
//
//  Created by Byron Coetsee on 2014/10/11.
//  Copyright (c) 2014 Byron Coetsee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSURLConnectionDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var txtIP: UITextField!
    @IBOutlet weak var txtToggleBottomLeft: UITextField!
    @IBOutlet weak var txtToggleBottomRight: UITextField!
    var selectedTextField : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtIP.delegate = self
        txtToggleBottomLeft.delegate = self
        txtToggleBottomRight.delegate = self
        txtIP.text = "coetsee.duckdns.org"
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func Gate(sender: AnyObject) {
        sendRequest("gate")
    }
    @IBAction func Garage(sender: AnyObject) {
        sendRequest("garage")
    }
    @IBAction func ToggleBottomLeft(sender: AnyObject) {
        sendRequest(txtToggleBottomLeft.text)
    }
    @IBAction func ToggleBottomRight(sender: AnyObject) {
        sendRequest(txtToggleBottomRight.text)
    }
    
    func sendRequest(instruction : String)
    {
        var url =  NSURL(string: "http://\(txtIP.text)/?\(instruction)")
        var request = NSURLRequest(URL: url!)
        var conn = NSURLConnection(request: request, delegate: self, startImmediately: true)
//        conn.start()
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        if !error.localizedDescription.isEmpty {
            showAlert("Error", message: error.localizedDescription)
        } else {
            showAlert("Error", message: error.description)
        }
    }
    
    @IBAction func hideKeyboard(sender: AnyObject) {
        if selectedTextField != nil {
            selectedTextField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        selectedTextField = textField
    }
    
    func showAlert(title: String, message: String)
    {
        var systemVersion : Int = UIDevice.currentDevice().systemVersion.componentsSeparatedByString(".")[0].toInt()!
        if systemVersion > 7 {
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

