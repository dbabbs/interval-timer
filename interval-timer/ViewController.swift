//
//  ViewController.swift
//  interval-timer
//
//  Created by Babbs, Dylan on 1/14/17.
//  Copyright © 2017 Babbs, Dylan. All rights reserved.
//

import UIKit
import AVFoundation
import KDCircularProgress
import Spring

class ViewController: UIViewController {
    
    //UI
    var total = 360
    var totalSeconds = 360
    
    var interval = 30
    var seconds = 30 //make this the same as interval!
    
    var timer: Timer!
    var greenTimer: Timer!
    var occured = Int()
    
    //Timer time
    var intervalTimer = Timer()
    var totalTimer = Timer()
    

    //UI
    @IBOutlet weak var barNavigation: UIImageView!
    
    
    var gradient = CAGradientLayer()
    
    @IBOutlet weak var triggerButton: UIButton!
    @IBOutlet weak var outerCircleOne: SpringButton!
    @IBOutlet weak var outerCircleTwo: UIButton!
    @IBOutlet weak var currentItem: UILabel!
    @IBOutlet weak var currentSubTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!

    
    //progress label
    var innerProgress: KDCircularProgress!
    var outerProgress: KDCircularProgress!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barNavigation.isHidden = true
        
        if track {
            black()
        } else {
            white()
        }
        
        //UI
        
        triggerButton.layer.cornerRadius = triggerButton.frame.width / 2
        triggerButton.layer.masksToBounds = true
        
        
        //outlines
        outerCircleOne.layer.cornerRadius = outerCircleOne.frame.width / 2
        outerCircleTwo.layer.cornerRadius = outerCircleTwo.frame.width / 2
        outerCircleOne.layer.borderWidth = 10
        outerCircleTwo.layer.borderWidth = 10
        outerCircleOne.layer.borderColor = colors.lightGrey.cgColor
        outerCircleTwo.layer.borderColor = colors.lightGrey.cgColor
        
        //timertext
        currentSubTimeLabel.text = "\(seconds)"
        updateTimeLabel(seconds: total)
        
        //load workout
        
    
        //Swiping
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.timeSelect))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.timeSelect))
        leftSwipe.direction = UISwipeGestureRecognizerDirection.left
        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    
    }
    
    func timeSelect(_ gesture: UIGestureRecognizer) {
        
        if !track {
            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.right: //-30
                    if total > 30 {
                       total -= 30 
                    }
                case UISwipeGestureRecognizerDirection.left: //+30
                    total += 30
                default:
                    break
                }
                
                updateTimeLabel(seconds: total)
                
                
                totalSeconds = total
            }
        } else {
            //TO DO:
            //shake animation
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func trigger(_ sender: UIButton) {
        if !track {
            black()
            runTimer()
            innerProgress.isHidden = false
            outerProgress.isHidden = false
        } else {
            if timer != nil {
                timer.invalidate()
                timer = nil
            }
            if greenTimer != nil {
                greenTimer.invalidate()
                greenTimer = nil
            }
            white()
            stopTimer()
            innerProgress.isHidden = true
            outerProgress.isHidden = true
            
            afterFirst = false
        }
        track = !track
    }
    
    func black() {
        //Unhide labels & change color
        currentItem.isHidden = false
        totalTimeLabel.isHidden = false
        currentItem.textColor = colors.white
        totalTimeLabel.textColor = colors.white
        currentSubTimeLabel.isHidden = false
        currentSubTimeLabel.textColor = colors.white
        
        //Main button
        triggerButton.backgroundColor = UIColor(white: 1, alpha: 0.0)
        triggerButton.setTitleColor(UIColor(white: 1, alpha: 0.0), for: UIControlState.normal)
        
        //outer circles
        outerCircleOne.isHidden = true
        outerCircleTwo.isHidden = true
        
        //background color
        let colorTop =  colors.blackStart.cgColor
        let colorBottom = colors.black.cgColor
        gradient.colors = [colorTop, colorBottom]
        gradient.locations = [ 0.0, 1.0]
        gradient.frame = self.view.bounds
        self.view.layer.insertSublayer(gradient, at: 0)
        
        //inner circle
        innerProgress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        innerProgress.startAngle = -90
        innerProgress.progressThickness = 0.3
        innerProgress.trackThickness = 0
        innerProgress.clockwise = true
        innerProgress.roundedCorners = true
        innerProgress.glowMode = .noGlow
        innerProgress.set(colors: colors.blue)
        innerProgress.center = CGPoint(x: view.center.x+3, y: view.center.y+1)
        view.addSubview(innerProgress)
        
        
        occured = 1
        
        callInner()
        
        
        
        //outer circle
        
        outerProgress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 260, height: 260))
        outerProgress.startAngle = -90
        outerProgress.progressThickness = 0.23
        outerProgress.trackThickness = 0
        outerProgress.clockwise = true
        outerProgress.roundedCorners = true
        outerProgress.glowMode = .noGlow
        outerProgress.set(colors: colors.red)
        outerProgress.center = CGPoint(x: view.center.x+3, y: view.center.y+1)
        view.addSubview(outerProgress)
        
        
        //transition
        transition(item: self.view)
        
        
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(interval), target: self, selector: #selector(callInner), userInfo: nil, repeats: true)
        
        outerProgress.animate(fromAngle: 0, toAngle: 360, duration: TimeInterval(total)) { completed in }
        
        
        
    }
    
    var afterFirst = false
    
    func callInner() {
        
        if !afterFirst {
            afterFirst = true
        } else {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }

        
        currentItem.text = workouts[Int(arc4random_uniform(UInt32(workouts.count)))]
        seconds = interval
        occured += 1
        if (occured > total / interval) {
            if timer != nil {
                timer.invalidate()
                timer = nil
            }
            
            greenTimer = Timer.scheduledTimer(timeInterval: TimeInterval(interval), target: self, selector: #selector(green), userInfo: nil, repeats: false)
        }
        innerProgress.animate(fromAngle: 0, toAngle: 360, duration: TimeInterval(interval)) { completed in }
        
    }
    
    func green() {
        greenTimer.invalidate()
        greenTimer = nil
        outerProgress.set(colors: colors.green)
        innerProgress.set(colors: colors.green)

        if intervalTimer != nil {
            intervalTimer.invalidate()
        }
        if totalTimer != nil {
            totalTimer.invalidate()
        }
        
        /*
        innerProgress.duration = 2.0
        innerProgress.animation = "pop"
        outerProgress.animation = "pop"
        
        innerProgress.animate()
        outerProgress.animate()
        */
    }
    
    func white() {
        //Hide labels & change color
        currentItem.isHidden = true
        //totalTimeLabel.isHidden = true
        totalTimeLabel.textColor = colors.black
        currentSubTimeLabel.isHidden = true
        
        
        //Main button
        triggerButton.backgroundColor = colors.blue
        triggerButton.setTitleColor(colors.white, for: UIControlState.normal)
        
        //outer circles
        outerCircleOne.layer.borderColor = colors.lightGrey.cgColor
        outerCircleTwo.layer.borderColor = colors.lightGrey.cgColor
        outerCircleOne.isHidden = false
        outerCircleTwo.isHidden = false
        
        //Set background
        gradient.removeFromSuperlayer()
        self.view.backgroundColor = colors.white
        transition(item: self.view)
        
        
    }
    
    func transition(item: UIView) {
        UIView.transition(with: item,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {  
        return true  
    }  
    
    
    //**** Actual Timer ******
    
    func runTimer() {
        
        //subtime
        intervalTimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateSubTimer)), userInfo: nil, repeats: true)
        
        //main time
        totalTimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    
    func updateSubTimer() {
        
        //sub time
        seconds -= 1
        if seconds == -1 {
            currentSubTimeLabel.text = "0"
        } else {
            currentSubTimeLabel.text = "\(seconds)"
        }
        
    }
    
    func updateTimer() {
        //main time
        
        //this is a temporary fix right here:
        if totalSeconds == total - interval {
            totalSeconds -= 1
        }
        totalSeconds -= 1
        updateTimeLabel(seconds: totalSeconds)
        
    }
    
    
    func updateTimeLabel(seconds: Int) {
        let minutesLeft = Int(seconds) / 60 % 60
        var minutesText = "\(minutesLeft)"
        if minutesLeft < 10 {
            minutesText = "0" + "\(minutesLeft)"
        }
        
        let secondsLeft = Int(seconds) % 60
        var secondsText = "\(secondsLeft)"
        if secondsLeft < 10 {
            secondsText = "0" + "\(secondsLeft)"
        }
        if secondsLeft < 1 && minutesLeft < 1 {
            totalTimeLabel.text = "00:00"
        } else {
            totalTimeLabel.text = "\(minutesText):\(secondsText)"
        }
        print(totalTimeLabel.text)
    }
    
    func stopTimer() {
        //subtime
        intervalTimer.invalidate()
        seconds = interval
        
        //main time
        totalTimer.invalidate()
        totalSeconds = total
        
        updateTimeLabel(seconds: total)
        
    }
    
}
