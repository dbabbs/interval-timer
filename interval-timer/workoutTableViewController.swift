//
//  workoutTableViewController.swift
//  interval-timer
//
//  Created by Babbs, Dylan on 1/15/17.
//  Copyright © 2017 Babbs, Dylan. All rights reserved.
//

import UIKit

class workoutTableViewController: UITableViewController {

    var activity:Array< String > = Array < String >()
    var time:Array< String > = Array < String >()
    var text = String()

    override func viewDidLoad() {
        get_data_from_url("https://dbabbs.github.io/interval-timer/workout.json")
        print(text)
    }
    
    @IBAction func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return activity.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        cell.textLabel?.text = activity[indexPath.row]
        cell.detailTextLabel?.text = time[indexPath.row]

        return cell
    }
    
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
        }
        DispatchQueue.main.async(execute: {self.refresh()})
    }
    
    func refresh()  {
        self.tableView.reloadData()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
