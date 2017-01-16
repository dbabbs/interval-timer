//
//  workoutViewController.swift
//  interval-timer
//
//  Created by Babbs, Dylan on 1/15/17.
//  Copyright © 2017 Babbs, Dylan. All rights reserved.
//

import UIKit

class workoutViewController: UIViewController {

    @IBOutlet weak var workoutText: UITextView!
    
    var tempWord = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        self.workoutText.text = tempWord
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        let urlString = "https://dbabbs.github.io/interval-timer/workout.json"
        var word : String = ""
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    let workouts = parsedData["Workout"] as! [String:Any]
                    for (key, value) in workouts {
                        let sequences = value as! [Any]
                        for i in sequences {
                            let instance = i as! [String:Any]
                            var activityWord = "\(instance["activity"])"
                            var timeWord = "\(instance["time"])"
                            word += "time: \(timeWord)   activity: \(activityWord)\n"

                        }
                        //print(self.activities)
                    }
                    print(word)
                    
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        
            
            }.resume()
        tempWord = word
        
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
