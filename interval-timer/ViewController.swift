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
    

    //UI
    var gradient = CAGradientLayer()
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var triggerButton: UIButton!
    @IBOutlet weak var outerCircleOne: UIButton!
    @IBOutlet weak var outerCircleTwo: UIButton!
    @IBOutlet weak var currentItem: UILabel!
    @IBOutlet weak var currentSubTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.layer.masksToBounds = true
        
        triggerButton.layer.cornerRadius = triggerButton.frame.width / 2
        triggerButton.layer.masksToBounds = true
        
        
        //outlines
        outerCircleOne.layer.cornerRadius = outerCircleOne.frame.width / 2
        outerCircleTwo.layer.cornerRadius = outerCircleTwo.frame.width / 2
        outerCircleOne.layer.borderWidth = 10
        outerCircleTwo.layer.borderWidth = 10
        outerCircleOne.layer.borderColor = colors.lightGrey.cgColor
        outerCircleTwo.layer.borderColor = colors.lightGrey.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if track {
            black()
        } else {
            white()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func trigger(_ sender: UIButton) {
        if !track {
            black()
        } else {
            white()
        }
        track = !track
    }
    
    func black() {
        //Unhide labels & change color
        currentItem.isHidden = false
        totalTimeLabel.isHidden = false
        currentItem.textColor = colors.white
        totalTimeLabel.textColor = colors.white
        intervalLabel.textColor = colors.white
        currentSubTimeLabel.isHidden = false
        currentSubTimeLabel.textColor = colors.white
        
        //Main button
        triggerButton.backgroundColor = UIColor(white: 1, alpha: 0.0)
        triggerButton.setTitleColor(UIColor(white: 1, alpha: 0.0), for: UIControlState.normal)
        
        //outer circles
        outerCircleOne.layer.borderColor = colors.blue.cgColor
        outerCircleTwo.layer.borderColor = colors.red.cgColor
        
        let colorTop =  colors.blackStart.cgColor
        let colorBottom = colors.black.cgColor
        gradient.colors = [colorTop, colorBottom]
        gradient.locations = [ 0.0, 1.0]
        gradient.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradient, at: 0)
        transition(item: self.view)
        
    }
    
    func white() {
        //Hide labels & change color
        currentItem.isHidden = true
        totalTimeLabel.isHidden = true
        intervalLabel.textColor = colors.black
        currentSubTimeLabel.isHidden = true
        
        //Main button
        triggerButton.backgroundColor = colors.blue
        triggerButton.setTitleColor(colors.white, for: UIControlState.normal)
        
        //outer circles
        outerCircleOne.layer.borderColor = colors.lightGrey.cgColor
        outerCircleTwo.layer.borderColor = colors.lightGrey.cgColor
        
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
    
}
