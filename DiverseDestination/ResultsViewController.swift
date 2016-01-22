
//  Created by Sucharu hasija on 22/01/16.
//  Copyright © 2016 SucharuHasija. All rights reserved.//

import GoogleMaps
import UIKit
import PXGoogleDirections
import MobileCoreServices
import CoreLocation



class ResultsViewController: UIViewController ,CLLocationManagerDelegate ,ResponseDataManager{
  
    
    
    //  MARK: -  Declarations
    var waypoints: [PXLocation] = [PXLocation]()
    var StroedLocationsWithType = NSMutableDictionary()
    let locationManager = CLLocationManager()
    var locationDictionary:NSMutableDictionary = NSMutableDictionary()
    let datamanager = DataManager()
    var firstLocation:CLLocationCoordinate2D?
    var lastLocation:CLLocationCoordinate2D?
    weak var CentreCooredinates:CLLocation? = CLLocation()
    private let directionsAPI = PXGoogleDirections(apiKey: kGoogleMapAPIKey)
    var isMapSet:Bool = false
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var routesLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var directions: UITableView!
    var request: PXGoogleDirections!
    var results: [PXGoogleDirectionsRoute]!
    
    var routeIndex: Int = 0
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        callForTheLocationManagerToGetUserLocation()
    }
    // MARK: - UI Button Actions
    @IBAction func previousButtonTouched(sender: UIButton) {
        routeIndex -= 1
        updateRoute()
    }
    
    @IBAction func nextButtonTouched(sender: UIButton) {
        routeIndex += 1
        updateRoute()
    }
    
    @IBAction func closeButtonTouched(sender: UIButton) {
        //dismissViewControllerAnimated(true, completion: nil)
    }
    

    //  MARK: - Route Updater
    func updateRoute() {
        prevButton.enabled = (routeIndex > 0)
        nextButton.enabled = (routeIndex < (results).count - 1)
        routesLabel.text = "\(routeIndex + 1) of \((results).count)"
       // mapView.clear()
        for i in 0 ..< (results).count {
            if i != routeIndex {
                results[i].drawOnMap(mapView, strokeColor: UIColor.lightGrayColor(), strokeWidth: 3.0)
            }
        }
        mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(results[routeIndex].bounds, withPadding: 40.0))
        results[routeIndex].drawOnMap(mapView, strokeColor: UIColor.redColor(), strokeWidth: 4.0)
        results[routeIndex].drawOriginMarkerOnMap(mapView, title: "Origin", color: UIColor.greenColor(), opacity: 1.0, flat: true)
        results[routeIndex].drawDestinationMarkerOnMap(self.mapView, title: "Destination", color: UIColor.redColor(), opacity: 1.0, flat: true)
        directions.reloadData()
    }

    
    
     //  MARK: -  Initial method to declare location manager to call the location
    func callForTheLocationManagerToGetUserLocation()
    {
    
        locationManager.delegate = self

        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    }
    //  MARK: - CLLocationManagerDelegate Methods
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    
        let alert = UIAlertController(title: "sucharuhasija", message: error.description, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
    
    
    }
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    
        
        if(status != CLAuthorizationStatus.AuthorizedAlways)
        {
        
            let alert = UIAlertController(title: "sucharuhasija", message: "Please allow the app to use your location \n go  to settings > locations services > Diverse estination > allow app ", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        
        }
        
        
        
    }

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        locationManager.stopUpdatingLocation()
    
        if let location1: CLLocation! = manager.location {
            let Location: CLLocationCoordinate2D = location1!.coordinate
            let lat : NSNumber = NSNumber(double: Location.latitude)
            let lng : NSNumber = NSNumber(double: Location.longitude)
        firstLocation  = location1!.coordinate
            let marker = GMSMarker(position: location1!.coordinate)
            marker.title = "Origin"
            marker.map = self.mapView
            //Store it into Dictionary
            locationDictionary = ["latitude": lat, "longitude": lng]
            StroedLocationsWithType.setValue(locationDictionary, forKey: "location")
            datamanager.delegate = self
            datamanager.getDataFromWebOfKind("Hotel", withRequiredInfo:locationDictionary)
            print(locationDictionary)
        
        
        }
        else {
        print("no location...")
        }
    
    
    
        //        CentreCooredinates = [CLLocation].dropFirst()
        manager.stopUpdatingLocation()
    
    
    }
    
    
    //  MARK: -  ResponseDataDelegate Method
    func ResponseForThe(type: String, withLocationInfo info: NSDictionary) {
    
        var type1:String = ""
        switch type{
        case "Hotel":
            type1 = "airport"
           
            
            StroedLocationsWithType.setValue(info, forKey: type)
            datamanager.getDataFromWebOfKind(type1, withRequiredInfo:locationDictionary)
            break
        case "airport":
            type1 = "convenience_store"
            StroedLocationsWithType.setValue(info, forKey: type)
            datamanager.getDataFromWebOfKind(type1, withRequiredInfo:locationDictionary)
            let lat:NSNumber  = info.valueForKey("geometry")?.valueForKey("location")?.valueForKey("lat") as! NSNumber
            let lng = info.valueForKey("geometry")?.valueForKey("location")?.valueForKey("lng") as! NSNumber
            lastLocation = CLLocationCoordinate2DMake(lat.doubleValue, lng.doubleValue)
            StroedLocationsWithType.setValue(info, forKey: type)
            datamanager.getDataFromWebOfKind(type1, withRequiredInfo:locationDictionary)
           
            break
        case "convenience_store":
            StroedLocationsWithType.setValue(info, forKey: type)
           // datamanager.getDataFromWebOfKind(type1, withRequiredInfo:locationDictionary)
            self.PlaceTheWayPortOnTheMap()
            break
        default:
            break
       
            }
    
        let lat:NSNumber  = info.valueForKey("geometry")?.valueForKey("location")?.valueForKey("lat") as! NSNumber
        let lng = info.valueForKey("geometry")?.valueForKey("location")?.valueForKey("lng") as! NSNumber
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat.doubleValue, lng.doubleValue)
        waypoints.append(PXLocation.CoordinateLocation(coordinate))
        directionsAPI.waypoints.append(PXLocation.CoordinateLocation(coordinate))
        let marker = GMSMarker(position: coordinate)
        marker.title = info.valueForKey("name") as? String
        marker.map = self.mapView
    
    }
    
    
    //  MARK: - Call the DirectionsAPI to set Route
    func PlaceTheWayPortOnTheMap()
    {
        directionsAPI.delegate = self
        
        
        
        directionsAPI.from = PXLocation.CoordinateLocation(firstLocation!)
        directionsAPI.to = PXLocation.CoordinateLocation(lastLocation!)
       
            directionsAPI.mode = PXGoogleDirectionsMode.Driving
            directionsAPI.waypoints = waypoints
            directionsAPI.optimizeWaypoints = true
            
        
            directionsAPI.calculateDirections { (response) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    switch response {
                case let .Error(_, error):
                    let alert = UIAlertController(title: "PXGoogleDirectionsSample", message: "Error:\(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            case let .Success(request, routes):
                
                self.request = request
                self.results = routes
                self.isMapSet = true
                self.updateRoute()
            }
        })
    }
    
}


}

