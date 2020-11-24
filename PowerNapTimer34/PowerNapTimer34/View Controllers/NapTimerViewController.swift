//
//  NapTimerViewController.swift
//  PowerNapTimer34
//
//  Created by Junior Suarez-Leyva on 11/21/20.
//

import UIKit

class NapTimerViewController: UIViewController {

    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var timerButton: UIButton!
    
    let myTimer = NapTimer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTimer.delegate = self
    }
    
    
    @IBAction func timerButtonTapped(_ sender: Any) {
        if myTimer.isActive {
            myTimer.stopTimer()
        } else {
            myTimer.startTimer(time: 5)
        }
        updateLabel()
        updateButton()
    }
    
    
    func updateLabel() {
        if myTimer.isActive {
            guard let timeRemaining = myTimer.timeRemaining else { return }
            let minutes = Int(timeRemaining / 60)
            let seconds = Int(timeRemaining.truncatingRemainder(dividingBy: 60))
            let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
            timerLabel.text = "\(minutes):\(secondsString)"
        } else {
            timerLabel.text = "20:00"
        }
    }
    
    
    func updateButton() {
        timerButton.setTitle(myTimer.isActive ? "Cancel Nap" : "Start Nap", for: .normal)
    }
    
    
    func displaySnoozeAlertController() {
        
    }

}

extension NapTimerViewController: NapTimerDelegate {
    func timerSecondTicked() {
        updateLabel()
    }
    
    func timerStopped() {
        updateLabel()
        updateButton()
    }
    
    func timerCompleted() {
        updateLabel()
        updateButton()
        
    }
    
    
}
