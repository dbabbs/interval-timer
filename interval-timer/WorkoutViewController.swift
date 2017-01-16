//
//  WorkoutViewController.swift
//  interval-timer
//
//  Created by Babbs, Dylan on 1/15/17.
//  Copyright © 2017 Babbs, Dylan. All rights reserved.
//

import UIKit

class WorkoutViewController: UIViewController {
    
    var data : [[String:AnyObject]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func getData() {
        let urlString = "https://dbabbs.github.io/interval-timer/workout.json"
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    let workouts = parsedData["Workout"] as! [String:Any]
                    
                    //print("\(workouts) Workout")
                    for workout in workouts {
                        let name = workout.value as! [String:Any] 
                        print(name[1])
                    }
                    
                    
                    //let currentTemperatureF = currentConditions["temperature"] as! Double
                    //print(currentTemperatureF)
                } catch let error as NSError {
                    print(error)
                }
            }
            
        }.resume()
    }
    

    


}
