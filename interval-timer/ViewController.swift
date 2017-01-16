//
//  ViewController.swift
//  interval-timer
//
//  Created by Babbs, Dylan on 1/14/17.
//  Copyright © 2017 Babbs, Dylan. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    let workoutSegueIdentifier = "showWorkoutSegue"
    
    var timer2 = Timer()
    var startTime2 = TimeInterval()
    
    var timer = Timer()
    var startTime = TimeInterval()
    var player: AVAudioPlayer?
    
    var activity:Array< String > = Array < String >()
    var time:Array< String > = Array < String >()

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var intervalText: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var musicStatus: UILabel!

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var voiceOptions = ["🔇", "🔊", "👄", "🇬🇧"]
    var voiceStatus = "👄"
    var z = 2


    var interval = 30
    var music = true;
    var i = 4
    let intervalOptions = [5, 10, 15, 20, 30, 60, 90, 120]
    var instance = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        get_data_from_url("https://dbabbs.github.io/interval-timer/workout.json")
        print("The music value is set to: \(music)")


        progressView.setProgress(0, animated: false)
        intervalText.text = "\(interval)"
        musicStatus.text = voiceStatus

        startButton.backgroundColor = UIColor(red: 0/255, green: 118/255, blue: 255/255, alpha: 1)
        startButton.layer.cornerRadius = 0.5 * startButton.bounds.size.width
        //stopButton.backgroundColor = UIColor(red: 61/255, green: 61/255, blue: 61/255, alpha: 1)
        stopButton.layer.cornerRadius = 0.5 * stopButton.bounds.size.width

        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.intervalSelect))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.intervalSelect))
        leftSwipe.direction = UISwipeGestureRecognizerDirection.left
        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)

        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.musicControl))
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.musicControl))
        downSwipe.direction = UISwipeGestureRecognizerDirection.down
        upSwipe.direction = UISwipeGestureRecognizerDirection.up
        view.addGestureRecognizer(downSwipe)
        view.addGestureRecognizer(upSwipe)

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func start(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target:self, selector: #selector(ViewController.updateCounterText), userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate
        
        timer2 = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(ViewController.updateCounter), userInfo: nil, repeats: true)
        startTime2 = NSDate.timeIntervalSinceReferenceDate
        
    }
    
    func speak(word : String) {
        let utterance = AVSpeechUtterance(string: word)
        var language = ""
        if voiceStatus == "🇬🇧" {
            language = "en-gb"
        } else if voiceStatus == "👄" {
            language = "en-us"
        }
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        
    }

    @IBAction func stop(_ sender: Any) {
        timer.invalidate()
        timer2.invalidate()
        timerLabel.text = "00:00.00"
        progressView.setProgress(0, animated: false)
    }

    func updateCounter() {
        var elapsedTime: TimeInterval = NSDate.timeIntervalSinceReferenceDate - startTime
        
        var elapsedTime2: TimeInterval = NSDate.timeIntervalSinceReferenceDate - startTime2
        //print(elapsedTime2)
        var length = activity.count - 1
        //print(length)
        
        var tempRound = round(elapsedTime)
        //print(tempRound)
        if (tempRound.truncatingRemainder(dividingBy: Double(interval)) == 0 && round(elapsedTime) != 0) {
            if voiceStatus == "🔊" {
                playSound()
            } else if voiceStatus == "👄" || voiceStatus == "🇬🇧"{
                speak(word: activity[instance])
                //speak(word: "\(instance)")
                //print("THIS IS IIIIIIIII: \(instance)")
            }
            progressView.progress = 0.0
            flashScreen()
            instance += 1
            if instance == length {
                instance = 0
            }
        }
        
        
    }
    
    func updateCounterText() {
        
        var elapsedTime: TimeInterval = NSDate.timeIntervalSinceReferenceDate - startTime
        
        var elapsedTime2: TimeInterval = NSDate.timeIntervalSinceReferenceDate - startTime2
        
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        let seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        let milli = UInt8(elapsedTime * 100)
        
        
        //main label:
        timerLabel.text = "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds)).\(String(format: "%02d", milli))"
        
        //progress view:
        progressView.progress = Float(seconds).truncatingRemainder(dividingBy: Float(interval)) / Float(interval)
    }

    func playSound() {
        let url = Bundle.main.url(forResource: "horn", withExtension: "mp3")!

        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }

            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func intervalSelect(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right: //-1
                if (i - 1 > -1) {
                    i -= 1
                }
            case UISwipeGestureRecognizerDirection.left: //+1
                if (i + 1 != intervalOptions.count) {
                    i += 1
                }
            default:
                break
            }
            print("after: \(i)")
            interval = intervalOptions[i]
            intervalText.text = "\(interval)"
        }
    }

    func musicControl(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.up:
                if (z - 1 > -1) {
                    z -= 1
                }
            case UISwipeGestureRecognizerDirection.down:
                if (z + 1 != voiceOptions.count) {
                    z += 1
                }
            default:
                break
            }
            voiceStatus = voiceOptions[z]
            musicStatus.text = voiceStatus
        }
    }
    
    func flashScreen() {
        let screenSize = UIScreen.main.bounds
        let frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        let shutterView = UIView(frame: frame)
        shutterView.backgroundColor = UIColor.white
        view.addSubview(shutterView)
        UIView.animate(withDuration: 0.3, animations: {
            shutterView.alpha = 0.25
        }, completion: { (_) in
            shutterView.removeFromSuperview()
        })
        print("flashed")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == workoutSegueIdentifier {
            let destination = segue.destination as? workoutTableViewController
            destination?.activity = activity
            destination?.time = time
            destination?.text = "yo"
        }
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
        //self.tableView.reloadData()
    }

}
