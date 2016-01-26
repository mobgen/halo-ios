//
//  StoreLocatorViewController.swift
//  HaloSwiftDemo
//
//  Created by Borja Santos-Díez on 10/09/15.
//  Copyright © 2015 MOBGEN Technology. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import Halo

class Store: NSObject, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(instance: Halo.GeneralContentInstance) {
        
        let dict = instance.values!
        
        self.title = dict["Name"] as? String
        
        let latitude = (dict["Latitude"] as! NSString).doubleValue
        let longitude = (dict["Longitude"] as! NSString).doubleValue
        
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        super.init()
    }
}

class StoreLocatorViewController : UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
 
    var mapView: MKMapView?
    var moduleId: String?
    var annotations: [MKAnnotation]?
    
    let regionRadius: CLLocationDistance = 1000
    let defaultPin = "pinIdentifier"
    let locationManager = CLLocationManager()
    
    init(module: Halo.Module) {
        super.init(nibName: nil, bundle: nil)
        moduleId = module.internalId
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MKMapView(frame: self.view.frame)
        mapView?.delegate = self
        
        self.view.addSubview(mapView!)
        
        let mgr = Halo.Manager.sharedInstance
        
        mgr.generalContent.getInstances(moduleId: self.moduleId!) { (result) -> Void in
            
            switch result {
            case .Success(let instances):
                
                let arr = instances as [Halo.GeneralContentInstance]
                self.annotations = [MKAnnotation]()
                
                for inst in arr {
                    self.annotations?.append(Store(instance: inst))
                }
        
                if CLLocationManager.locationServicesEnabled() {
                    self.locationManager.delegate = self
                    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    self.locationManager.requestAlwaysAuthorization()
                    self.locationManager.startUpdatingLocation()
                }
                
                self.loadData()
                
            case .Failure(let error):
                NSLog("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier(defaultPin) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: defaultPin)
        }
        pinView!.animatesDrop = true;
        
        return pinView;
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView?.setRegion(coordinateRegion, animated: true)
    }
    
    func loadData() {
        
        if let annot = self.mapView?.annotations {
            self.mapView?.removeAnnotations(annot)
        }
        
        if let annot = annotations {
            mapView?.addAnnotations(annot)
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Get the closest store
        
        let currentLoc = manager.location!
        
        self.annotations?.sortInPlace({ (store1, store2) -> Bool in
            let st1 = store1 as! Store
            let st2 = store2 as! Store
            
            let loc1 = CLLocation(latitude: st1.coordinate.latitude, longitude: st1.coordinate.longitude)
            let loc2 = CLLocation(latitude: st2.coordinate.latitude, longitude: st2.coordinate.longitude)
            
            let dist1 = loc1.distanceFromLocation(currentLoc)
            let dist2 = loc2.distanceFromLocation(currentLoc)
            
            return (dist1 < dist2)
        })
        
        if let annot = self.annotations {
            let closestStore = annot[0] as! Store
            let closestLocation = CLLocation(latitude: closestStore.coordinate.latitude, longitude: closestStore.coordinate.longitude)
            
            centerMapOnLocation(closestLocation)
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
}