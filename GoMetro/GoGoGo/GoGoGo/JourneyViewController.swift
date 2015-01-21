//
//  FirstViewController.swift
//  GoGoGo
//
//  Created by Byron Coetsee on 2015/01/19.
//  Copyright (c) 2015 GoMetro (Pty) Ltd. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class JourneyViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIPageViewControllerDataSource, UIGestureRecognizerDelegate {

	@IBOutlet weak var map: MKMapView!
	@IBOutlet weak var journeyContainerView: UIView!
	@IBOutlet weak var viewNavigateBar: UIView!
	@IBOutlet weak var viewHeading: UIView!
	@IBOutlet weak var viewAgencies: UIView!
	
	//Layout constraints
	@IBOutlet weak var navigateBarTopLayout: NSLayoutConstraint! // Original is 113
	
	// Veriables
	var manager = CLLocationManager()
	
	var pageViewController: UIPageViewController?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		manager.requestWhenInUseAuthorization()
		
		var theSpan: MKCoordinateSpan = MKCoordinateSpanMake(0.5, 0.5)
		var theRegion: MKCoordinateRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(-33.9206605, 18.424724), theSpan)
		map.setRegion(theRegion, animated: true)
		map.showsUserLocation = true
		map.mapType = MKMapType.Standard
		map.showsUserLocation = true
		map.showsPointsOfInterest = true
		map.showsBuildings = true
		
		manager.delegate = self
		manager.desiredAccuracy = kCLLocationAccuracyBest
		
		let navigateBarGestureUp = UISwipeGestureRecognizer(target: self, action: "openNavigateBar")
		let navigateBarGestureDown = UISwipeGestureRecognizer(target: self, action: "closeNavigateBar")
		let headingTapGesture = UITapGestureRecognizer(target: self, action: "openCloseAgencyViewController")
		navigateBarGestureUp.direction = UISwipeGestureRecognizerDirection.Up
		navigateBarGestureDown.direction = UISwipeGestureRecognizerDirection.Down
		viewHeading.addGestureRecognizer(headingTapGesture)
		
		viewNavigateBar.addGestureRecognizer(navigateBarGestureUp)
		viewNavigateBar.addGestureRecognizer(navigateBarGestureDown)
		
		let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("pageController") as UIPageViewController
		pageController.view.frame = CGRectMake(0.0, 0.0, journeyContainerView.frame.width, journeyContainerView.frame.height)
		pageController.view.clipsToBounds = true
		pageController.dataSource = self
		
		// Temp. Making an object of the first view controller to display
		let initalViewController = self.storyboard!.instantiateViewControllerWithIdentifier("journeySwipeDiscover") as JourneySwipeDiscoverViewController
		
		// Making an array of view controllers for the pageViewController
//		let viewControllers : NSArray = [initalViewController]
		pageController.setViewControllers([initalViewController], direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
		
		pageViewController = pageController
		addChildViewController(pageViewController!)
		journeyContainerView.addSubview(pageViewController!.view)
		pageViewController!.didMoveToParentViewController(self)
		
	}
	
	// Navigate bar gesture methods
	func openNavigateBar() {
		println("Opening")
		animateChange(viewNavigateBar, controlLayout: navigateBarTopLayout, number: 113)
	}
	
	func closeNavigateBar() {
		println("Closing")
		// Calculates where to place the navigate bar
		animateChange(viewNavigateBar, controlLayout: navigateBarTopLayout, number: (map.frame.origin.x + map.frame.height - 8 - viewNavigateBar.frame.height))
	}
	
	//Heading tap gesture method
	func openCloseAgencyViewController() {
		if viewAgencies.hidden == true {
			self.viewAgencies.alpha = 0.0
			self.viewAgencies.hidden = false
			UIView.animateWithDuration(0.3, animations: {
				self.viewAgencies.alpha = 1.0 })
		} else {
			UIView.animateWithDuration(0.3, animations: {
				self.viewAgencies.alpha = 0.0
				}, completion: {
					(finished:Bool) -> Void in
					self.viewAgencies.hidden = true
			})
		}
	}
	
	// Swipe page view controller delegate methods
	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
		if viewController.restorationIdentifier == "journeySwipeRecent" {
			return self.storyboard!.instantiateViewControllerWithIdentifier("journeySwipeDiscover") as JourneySwipeDiscoverViewController
		} else {
			return nil
		}
	}
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
		if viewController.restorationIdentifier == "journeySwipeDiscover" {
			return self.storyboard!.instantiateViewControllerWithIdentifier("journeySwipeRecent") as JourneySwipeRecentViewController
		} else {
			return nil
		}
	}
	
	func animateChange(control : AnyObject, controlLayout : NSLayoutConstraint, number : CGFloat, duration : NSTimeInterval = 0.3) {
		controlLayout.constant = number
		UIView.animateWithDuration(duration, animations: {
			control.layoutIfNeeded()
		})
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

