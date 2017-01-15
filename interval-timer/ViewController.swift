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

    @IBOutlet weak var timerLabel: UILabel!
    
    var timer = Timer()
    var startTime = TimeInterval()
    var player: AVAudioPlayer?
    
    @IBOutlet weak var intervalText: UILabel!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    
    var interval = 5
    var music = true;
    var i = 0
    
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("The music value is set to: \(music)")
        progressView.setProgress(0, animated: true)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.intervalSelect))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.intervalSelect))
        
        leftSwipe.direction = UISwipeGestureRecognizerDirection.left
        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func start(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target:self, selector: #selector(ViewController.updateCounter), userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate
    }
    

    @IBAction func stop(_ sender: Any) {
        timer.invalidate()
        timerLabel.text = "00:00.00"
        progressView.setProgress(0, animated: false)
    }
    
    
    func updateCounter() {
        var elapsedTime: TimeInterval = NSDate.timeIntervalSinceReferenceDate - startTime
        print(round(elapsedTime))
        
        if (round(elapsedTime).truncatingRemainder(dividingBy: Double(interval)) == 0 ) {//&& music && round(elapsedTime) != 0) {
            playSound()
            progressView.progress = 0.0
        }
        
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
    
    @IBAction func musicOnOff(_ sender: Any) {
        music = !music
        
    }
    
    func intervalSelect(_ gesture: UIGestureRecognizer) {
        
        let intervalOptions = [5, 10, 15, 20, 30, 60, 90, 120]
        
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

    
    
}

