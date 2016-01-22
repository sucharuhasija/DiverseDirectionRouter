//
//  ResultsViewController+PXIGoogleDirections.swift
//  DiverseDestination
//
//  Created by Sucharu hasija on 22/01/16.
//  Copyright © 2016 SucharuHasija. All rights reserved.
//

import GoogleMaps
import UIKit
import PXGoogleDirections
import MobileCoreServices
import CoreLocation
extension ResultsViewController: PXGoogleDirectionsDelegate {
    func googleDirectionsWillSendRequestToAPI(googleDirections: PXGoogleDirections, withURL requestURL: NSURL) -> Bool {
        NSLog("googleDirectionsWillSendRequestToAPI:withURL:")
        return true
    }
    
    func googleDirectionsDidSendRequestToAPI(googleDirections: PXGoogleDirections, withURL requestURL: NSURL) {
        NSLog("googleDirectionsDidSendRequestToAPI:withURL:")
        NSLog("\(requestURL.absoluteString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)")
    }
    
    func googleDirections(googleDirections: PXGoogleDirections, didReceiveRawDataFromAPI data: NSData) {
        NSLog("googleDirections:didReceiveRawDataFromAPI:")
        NSLog(NSString(data: data, encoding: NSUTF8StringEncoding) as! String)
    }
    
    func googleDirectionsRequestDidFail(googleDirections: PXGoogleDirections, withError error: NSError) {
        NSLog("googleDirectionsRequestDidFail:withError:")
        NSLog("\(error)")
    }
    
    func googleDirections(googleDirections: PXGoogleDirections, didReceiveResponseFromAPI apiResponse: [PXGoogleDirectionsRoute]) {
        NSLog("googleDirections:didReceiveResponseFromAPI:")
        NSLog("Got \(apiResponse.count) routes")
        for i in 0 ..< apiResponse.count {
            NSLog("Route \(i) has \(apiResponse[i].legs.count) legs")
        }
    }
}


extension ResultsViewController: GMSMapViewDelegate {
}
