//
//  ChallengesViewController.swift
//  drag
//
//  Created by Byron Coetsee on 2014/07/28.
//  Copyright (c) 2014 Byron Coetsee. All rights reserved.
//

import UIKit

class ChallengesViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var tblChallenges: UITableView!
    @IBOutlet var viewLoading: UIView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    
    
    var challenges: [[String]] = [] // Array of arrays. type String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var query = PFQuery(className: "Challenges")
        query.whereKey("challengeFrom", equalTo: current.user)
        query.whereKey("challengeTo", equalTo: current.user)
        query.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if !error {
                for object : PFObject! in objects {
                    var challengeInfo : [String] = [object["challengeFrom"] as String, object["challengeTo"] as String, object["accepted"] as String]
                    if !challengeInfo.isEmpty {
                        self.challenges.append(challengeInfo)
                    }
                    println(self.challenges)
                    println(challengeInfo)
                }
            } else {
                println(error)
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.stopLoading()
                self.tblChallenges.reloadData()
                })
        }
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "refreshTable", userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
    }
    
    func refreshTable() {
        tblChallenges.reloadData()
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return challenges.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell : UITableViewCell = UITableViewCell()
        println(challenges.count)
        if challenges[indexPath.row].count > 0 {
            cell.textLabel.text = "From: \(challenges[indexPath.row][0]) - To: \(challenges[indexPath.row][1])"
        } else {
            cell.textLabel.text = "Nothing"
        }
        return cell
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
