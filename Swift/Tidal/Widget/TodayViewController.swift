//
//  TodayViewController.swift
//  Widget
//
//  Created by Byron Coetsee on 2014/11/04.
//  Copyright (c) 2014 Byron Coetsee. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, NSURLConnectionDelegate {
    
    @IBOutlet weak var tideView: UIView!
    @IBOutlet var mainView: UIView!
    var data = NSMutableData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
//        self.preferredContentSize = CGSizeMake(mainView.frame.size.width, 50)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        
        // **********************************************************
        
//        let urlPath: String = "YOUR URL STRING"
//        var url: NSURL = NSURL(string: urlPath)!
//        var request: NSURLRequest = NSURLRequest(URL: url)
//        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: true)!
//        connection.start()
        
        // **********************************************************
        var mainFrame = self.mainView.frame
        var newFrame : CGRect = self.tideView.frame
        newFrame.size.height = 20
        newFrame.size.width = mainFrame.size.width
        newFrame.origin = CGPointMake(mainFrame.width - newFrame.width, mainFrame.height - newFrame.height)
        self.tideView.frame = newFrame
        
//        let shareDefaults = NSUserDefaults(suiteName: "group.tidalWidget")
        
//        txtOutput.text = shareDefaults?.objectForKey("stringKey") as String
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        self.data.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!)
    {
        var err: NSError
        // throwing an error on the line below (can't figure out where the error message is)
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        println(jsonResult)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        var margins = defaultMarginInsets
        margins.bottom = 1.0
        margins.left = 1.0
        margins.right = 1.0
        return margins
    }
    
}
