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

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func timerButtonTapped(_ sender: Any) {
        if myTimer.isActive {
            myTimer.stopTimer()
        } else {
            myTimer.startTimer(time: 5)
        }
    }
    
    
    func updateLabel() {
        if myTimer.isActive {
            guard let timeRemaining = myTimer.timeRemaining else { return }
            let minutes = Int(timeRemaining / 60)
            let seconds = Int(timeRemaining.truncatingRemainder(dividingBy: 60))
        } else {
            
        }
    }
    
    
    func updateButton() {
        
    }

}
