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

    var timer = Timer()
    var startTime = TimeInterval()
    var player: AVAudioPlayer?

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var intervalText: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var musicStatus: UILabel!

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!


    var interval = 30
    var music = true;
    var i = 4
    let intervalOptions = [5, 10, 15, 20, 30, 60, 90, 120]

    override func viewDidLoad() {
        super.viewDidLoad()
        print("The music value is set to: \(music)")

        progressView.setProgress(0, animated: false)
        intervalText.text = "\(interval)"

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

        if (round(elapsedTime).truncatingRemainder(dividingBy: Double(interval)) == 0 && music && round(elapsedTime) != 0) {
            playSound()
            progressView.progress = 0.0
            flashScreen()
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
                music = true
                musicStatus.text = "🎹"
            case UISwipeGestureRecognizerDirection.down:
                music = false
                musicStatus.text = "❌"
            default:
                break
            }
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

}
