//
//  MyTimer.swift
//  Master-PowerNap
//
//  Created by Cameron Stuart on 4/8/20.
//  Copyright © 2020 Cameron Stuart. All rights reserved.
//

import Foundation

// 4) Create our protocol
//MARK: - Protocols
protocol MyTimerDelegate: class {
    func timerSecondTicked()
    func timerHasStopped()
    func timerHasCompleted()
}

// 1) Create our class:
class MyTimer {
    
    //MARK: - Properties
    // 5) Create our delegate variable
    weak var delegate: MyTimerDelegate?
    
    // 2) Create our variables:
    var timer: Timer?
    
    var timeLeft: TimeInterval?
    
    // Our timer status
    var isOn: Bool {
        if timeLeft == nil {
            return false
        } else {
            return true
        }
    }
    
    // 3) Create our functions:
    //MARK: - Methods
    // 3A) Funtion to start the timer
    func startTimer(duration: TimeInterval) {
        // IF our timer is already on, do nothing, ELSE start the timer.
        if isOn {
            // Do nothing!
            print("This must be a mistake, there is already a timer running")
        } else {
            timeLeft = duration
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
                self.secondTicked()
            })
        }
    }
    
    // 3B) Function to stop our timer:
    func stopTimer() {
        self.timeLeft = nil
        timer?.invalidate()
        timer = nil
        print("User has stopped the timer")
        // Tell our view controller (intern) that the timer has been stopped:
        delegate?.timerHasStopped()
    }
    
    // 3C) Convert timeLeft to a string:
    func timeLeftAsString() -> String {
        let timeRemaining = Int(self.timeLeft ?? 20 * 60)
        let minutesLeft = timeRemaining / 60
        let secondsLeft = timeRemaining - (minutesLeft * 60)
        //  String formatter to make sure we always have two digits in front of the colon, and two digits after the colon. (ex. 20:00 instead of 20:0)
        return String(format: "%02d : %02d", arguments: [minutesLeft, secondsLeft])
    }
    
    // Timer helper function:
    private func secondTicked() {
        // Check to make sure timeLeft isn't set to nil:
        guard let timeLeft = timeLeft else {
            print("The timer is not currently running")
            return
        }
        
        // IF our timeLeft is greater than 0, we need to reduce it by 1, ELSE we need to stop the time and alert the user
        if timeLeft > 0 {
            self.timeLeft = timeLeft - 1
            // Print out our remaining time as a string for testing purposes:
            print(self.timeLeftAsString())
            // Tell our view controller (intern) to update the time:
            delegate?.timerSecondTicked()
        } else {
            self.timeLeft = nil
            timer?.invalidate()
            timer = nil
            print("Timer has been stopped")
            // Tell our view controller (intern) that the timer has completed:
            delegate?.timerHasCompleted()
        }
    }
}
