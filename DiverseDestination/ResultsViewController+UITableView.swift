//
//  ResultsViewController+UITableView.swift
//  DiverseDestination

//
//  Created by Sucharu hasija on 22/01/16.
//  Copyright © 2016 SucharuHasija. All rights reserved.//

import GoogleMaps
import UIKit
import PXGoogleDirections
import MobileCoreServices
import CoreLocation



// Result View Controller UITableView Data Source and delegate Methods
extension ResultsViewController: UITableViewDataSource {
  
    
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //  ?? 0
        if isMapSet
        {
            
            return (results[routeIndex].legs).count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (results[routeIndex].legs[section].steps).count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let leg = results[routeIndex].legs[section]
        if let dist = leg.distance?.description, dur = leg.duration?.description {
            return "Step \(section + 1) (\(dist), \(dur))"
        } else {
            return "Step \(section + 1)"
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("RouteStep")
        if (cell == nil) {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "RouteStep")
        }
        let step = results[routeIndex].legs[indexPath.section].steps[indexPath.row]
        if let instr = step.rawInstructions {
            cell!.textLabel!.text = instr
        }
        if let dist = step.distance?.description, dur = step.duration?.description {
            cell!.detailTextLabel?.text = "\(dist), \(dur)"
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let step = results[routeIndex].legs[indexPath.section].steps[indexPath.row]
        mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(step.bounds, withPadding: 40.0))
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let step = results[routeIndex].legs[indexPath.section].steps[indexPath.row]
        var msg: String
        if let m = step.maneuver {
            msg = "\(step.rawInstructions!)\nGPS instruction: \(m)\nFrom: (\(step.startLocation!.latitude); \(step.startLocation!.longitude))\nTo: (\(step.endLocation!.latitude); \(step.endLocation!.longitude))"
        } else {
            msg = "\(step.rawInstructions!)\nFrom: (\(step.startLocation!.latitude); \(step.startLocation!.longitude))\nTo: (\(step.endLocation!.latitude); \(step.endLocation!.longitude))"
        }
        let alert = UIAlertController(title: "sucharuhasija", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
extension ResultsViewController: UITableViewDelegate {
}

