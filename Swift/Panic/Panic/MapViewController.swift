//
//  MapViewController.swift
//  Panic
//
//  Created by Byron Coetsee on 2014/12/02.
//  Copyright (c) 2014 Byron Coetsee. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Parse

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    var manager: CLLocationManager! = CLLocationManager()
    var locationPermission: Bool = false
    var centerMapLocation: dispatch_once_t = 0 // Predicate for dispatch once
    var locationPermissionDispatch: dispatch_once_t = 0
    var victims : [PFUser : PFGeoPoint] = [:]
    var timer : NSTimer!
    var queryPanicsIsActive = false
    var selectedVictim : [String] = []
//	var selectedAnnotation : MKAnnotation?
    var viewIsActive = false
    
    let queryPanics : PFQuery = PFQuery(className: "Panics")
    //    let queryUsers : PFQuery = PFQuery(className: "User")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.requestAlwaysAuthorization()
        
		if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Authorized) || (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse) {
			locationPermission = true
		}
		
		var theSpan: MKCoordinateSpan = MKCoordinateSpanMake(0.5, 0.5)
		var theRegion: MKCoordinateRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(-33.9206605, 18.424724), theSpan)
		//        var theRegion: MKCoordinateRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(45.93422, 7.63014), theSpan)
		map.setRegion(theRegion, animated: true)
		map.showsUserLocation = true
        map.mapType = MKMapType.Standard
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        viewIsActive = true
        getVictims()
    }
    
    @IBAction func findMe(sender: AnyObject) {
        if manager.location != nil {
            var theSpan: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
            var theRegion: MKCoordinateRegion = MKCoordinateRegionMake(manager.location.coordinate, theSpan)
            map.setRegion(theRegion, animated: true)
        }
    }
    
    func getVictims() {
        println("Getting victims from mapViewController")
        queryPanics.whereKey("active", equalTo: true)
        if queryPanicsIsActive == false {
            queryPanics.findObjectsInBackgroundWithBlock({
                (objects : [AnyObject]!, error: NSError!) -> Void in
                self.queryPanicsIsActive = true
                if error == nil {
                    self.victims = [:]
                    for object in objects {
                        let tempObject = object as PFObject
                        self.victims[tempObject["user"] as PFUser] = (tempObject["location"] as PFGeoPoint)
                    }
                    if global.queryUsersBusy == false {
                        global.getVictimInformation(self.victims)
                    } else {
                        println("Skipping getVictimInfo")
                    }
                    self.updateAnnotations()
                } else {
                    if error.localizedFailureReason != nil {
                        global.showAlert("", message: error.localizedFailureReason!)
                    } else {
                        global.showAlert("", message: "Could not get the list of Panics. Please check your internet connection and try again")
                    }
                }
                self.queryPanicsIsActive = false
            })
        }
        
        // CHANGE TO 30 SECONDS BEFORE RELEASE.........
        
        if viewIsActive == true {
            timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "getVictims", userInfo: nil, repeats: false)
        } else if viewIsActive == false {
            manager.stopUpdatingLocation()
            manager.delegate = nil
            map.delegate = nil
            println("Disabled timer")
            timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "freeMem", userInfo: nil, repeats: false)
        }
        
        if global.queryUsersBusy == true {
            
        }
    }
    
    // Updating annotations
    func updateAnnotations() {
		
//		var arrayOfAnno : [MKPointAnnotation] = []
//		
//		for (name, location) in victims {
//			let anno = MKPointAnnotation()
//			anno.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
//			let victimInfo = global.victimInformation[name.objectId]
//			if victimInfo != nil {
//				anno.title = victimInfo![1] // Name
//				anno.subtitle = victimInfo![2] // Cell
//			} else {
//				anno.title = name.objectId
//				anno.subtitle = "Loading name..."
//			}
//			arrayOfAnno.append(anno)
//		}
//		
//		for annotation in map.annotations {
//			if !contains(arrayOfAnno, annotation as MKAnnotation) {
//				map.removeAnnotation(annotation as MKAnnotation)
//			}
//		}
//		
//		for annotation in arrayOfAnno {
//			if !contains(map.annotations as [MKPointAnnotation], annotation) {
//				map.addAnnotation(annotation)
//			}
//		}
		
        map.removeAnnotations(map.annotations)
        for (name, location) in victims {
            let anno = MKPointAnnotation()
            anno.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
            let victimInfo = global.victimInformation[name.objectId]
            if victimInfo != nil {
                anno.title = victimInfo![1] // Name
                anno.subtitle = victimInfo![2] // Cell
            } else {
                anno.title = name.objectId
                anno.subtitle = "Loading name..."
            }
            map.addAnnotation(anno)
//			if selectedVictim.count > 0 {
//				if selectedVictim[0] == anno.title {
//					map.selectAnnotation(anno, animated: false)
//				}
//			}
        }
//		if selectedAnnotation != nil {
//			map.selectAnnotation(selectedAnnotation, animated: false)
//		}
    }
	
//	func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {
//		selectedVictim = []
//	}
	
    // When the user taps on an annotation
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!)
    {
        if view.annotation.subtitle? != nil {
//			selectedAnnotation = view.annotation
            selectedVictim = [view.annotation.title!, view.annotation.subtitle!]
        }
    }
    
    // How to add annotations
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView!
    {
        if !annotation.isEqual(mapView.userLocation) {
            var view: MKAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Standard")
            //            var currPlaceMark = annotation;
            
            var btnViewRight: UIButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
            btnViewRight.addTarget(self, action: "callVictim", forControlEvents: UIControlEvents.TouchUpInside)
            btnViewRight.setImage(UIImage(named: "call"), forState: UIControlState.Normal)
            
            //            var btnViewLeft: UIButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
            //            btnViewLeft.setImage(UIImage(named: "directionsToVictimIMAGE"), forState: UIControlState.Normal)
            
            //            btnViewLeft.addTarget(self, action: "getRouteToSelectedStop", forControlEvents: UIControlEvents.TouchUpInside)
            //
            if view.annotation.subtitle? != nil {
                if view.annotation.subtitle? != "Loading name..." {
                    view.rightCalloutAccessoryView = btnViewRight
                }
            }
            //            view.leftCalloutAccessoryView = btnViewLeft
            
            view.image = UIImage(named: "panic")
            
            view.enabled = true
            view.canShowCallout = true
            view.centerOffset = CGPointMake(0, 0)
            return view
        } else {
            return nil
        }
    }
    
    func callVictim() {
        if selectedVictim[0] != "Loading name..." {
            var url:NSURL = NSURL(string: "tel://\(selectedVictim[1])")!
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        if manager.location.horizontalAccuracy < 60 {
            dispatch_once(&centerMapLocation, {
                //                self.findMe(self.btnMe)
            })
        }
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if (status == CLAuthorizationStatus.Authorized) || (status == CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationAllowed()
        } else if status == CLAuthorizationStatus.Denied {
            locationNotAllowed(true)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!)
    {
        println(error)
        dispatch_once(&locationPermissionDispatch, {
            if error.localizedFailureReason != nil{
                global.showAlert(error.localizedDescription, message: error.localizedFailureReason!)
            } else {
                println("didFailWithError")
                global.showAlert("Location Error", message: "Location Services are unavailable at the moment.\n\nPossible reasons:\nInternet Connection\nIndoors\nLocation Permission")
            }
        })
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer!
    {
        var polylineRender: MKPolylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRender.lineWidth = 5.0
        polylineRender.strokeColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.95)
        return polylineRender;
    }
    
    
    func locationAllowed() {
        println("Location Allowed!!")
        
        locationPermission = true
        //        btnMe.hidden = false
        //        findMe(btnMe)
        locationPermissionDispatch = 0
        manager.startUpdatingLocation()
    }
    
    func locationNotAllowed(showMessage: Bool) {
        println("Location NOT Allowed!!")
        
        locationPermission = false
        //        btnMe.hidden = true
        manager.stopUpdatingLocation()
        if showMessage {
            dispatch_once(&locationPermissionDispatch, {
//                println("didChangeAuthorizationStatus")
                global.showAlert("Location Authorization", message: "To use this feature properly, please enable Location Services for this app in Settings > Privacy > Location")
            })
        }
    }
    
    func freeMem() {
//        println("Memory freed")
        map.mapType = MKMapType.Hybrid
        map.removeFromSuperview()
        map = nil
        manager = nil
    }
    
    override func viewWillDisappear(animated: Bool) {
        viewIsActive = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        map.mapType = MKMapType.Hybrid
        map.mapType = MKMapType.Standard
    }
}
