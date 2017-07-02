//
//  Workout.swift
//  interval-timer
//
//  Created by Babbs, Dylan on 7/2/17.
//  Copyright © 2017 Babbs, Dylan. All rights reserved.
//

import UIKit

class Workout: NSObject {
    
    static let sharedInstance = Workout()
    
    var activity:Array< String > = Array < String >()
    var time:Array< String > = Array < String >()
    
    func get_data_from_url(_ link:String) {
        let url:URL = URL(string: link)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                
                return
            }
            self.extract_json(data!)
        })
        task.resume()
    }
    
    func extract_json(_ data: Data) {
        let json: Any?
        
        do {
            json = try JSONSerialization.jsonObject(with: data, options: [])
        } catch {
            return
        }
        
        guard let data_list = json as? NSArray else {
            return
        }
        
        
        if let workout_data = json as? NSArray {
            for i in 0 ..< data_list.count {
                if let entry = workout_data[i] as? NSDictionary {
                    if let timeEntry = entry["time"] as? String {
                        if let activityEntry = entry["activity"] as? String  {
                            time.append(timeEntry)
                            activity.append(activityEntry)
                        }
                    }
                }
            }
            print(activity)
            print(time)
        }
        
        DispatchQueue.main.async(execute: {self.refresh()})
    }
    
    func refresh()  {
        //self.tableView.reloadData()
    }

}
