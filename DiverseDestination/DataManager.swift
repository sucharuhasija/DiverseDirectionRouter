//
//  DataManager.swift
//  DiverseDestination
//
//  Created by Sucharu hasija on 21/01/16.
//  Copyright © 2016 SucharuHasija. All rights reserved.
//

import UIKit
import AFNetworking



protocol ResponseDataManager:class
{


    func ResponseForThe(type:String , withLocationInfo info:NSDictionary)

}
class DataManager: NSObject {

   
    weak var delegate:ResponseDataManager?
    
    
    // reguest call from Google API
    func getDataFromWebOfKind(type:String, withRequiredInfo info:NSDictionary )
    {
    
        
        
         let urlString = kGoogleBaseUrl.stringByAppendingFormat( "location=%@,%@&radius=5000&types=%@&sensor=true&key=AIzaSyC11DIGXGPuitHLkjFT-fDypwQT99FUWoE",(info.valueForKey("latitude")?.stringValue)!,(info.valueForKey("longitude")?.stringValue)!,type)
       
        
        
        let manager = AFHTTPSessionManager()
        manager.GET(urlString, parameters: nil, progress: nil, success: { (NSURLSessionDataTask, response) -> Void in
            
            // print(response)
            self.getLocationOfNearest(type, fromUserLocation: response as! NSDictionary)
      
            
            }) { (task, error) -> Void in
                
        }
        
    
    
    
    
    
    
    }
    
    
    // Result Handler
    func getLocationOfNearest(type:String, fromUserLocation location:NSDictionary)
    {
    
    
        let results:NSArray  = location.valueForKey("results") as! NSArray
        
        if(results.count != 0)
        {
        
        delegate?.ResponseForThe(type, withLocationInfo: results.objectAtIndex(0) as! NSDictionary)
        }
     
        print(results.objectAtIndex(0) as! NSDictionary)
        

    
    }
  
}
