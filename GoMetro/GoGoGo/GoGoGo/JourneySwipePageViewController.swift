//
//  JourneySwipePageViewController.swift
//  GoGoGo
//
//  Created by Byron Coetsee on 2015/01/20.
//  Copyright (c) 2015 GoMetro (Pty) Ltd. All rights reserved.
//

import UIKit

class JourneySwipePageViewController: UIPageViewController, UIPageViewControllerDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

		let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("pageController") as UIPageViewController
		pageController.dataSource = self
		
		// Temp. Making an object of the first view controller to display
		let mainViewController = self.storyboard!.instantiateViewControllerWithIdentifier("journeySwipeDiscover") as JourneySwipeDiscoverViewController
		
		// Making an array of view controllers for the pageViewController
		let viewControllers : NSArray = [mainViewController]
		pageController.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
		
//		self = pageController
    }
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
		
		return nil
	}
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
		
		return nil
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
