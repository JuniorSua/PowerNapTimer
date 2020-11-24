//
//  NapTimer.swift
//  PowerNapTimer34
//
//  Created by Junior Suarez-Leyva on 11/21/20.
//

import Foundation

protocol NapTimerDelegate: AnyObject {
    func timerSecondTicked()
    func timerStopped()
    func timerCompleted()
    
}

class NapTimer {
    
    var timeRemaining: TimeInterval?
    var timeCounter: Timer?
    var isActive: Bool {
        return timeRemaining != nil
    }
    
    weak var delegate: NapTimerDelegate?
    
    func startTimer(time: TimeInterval) {
        if !isActive {
            self.timeRemaining = time
            self.timeCounter = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
                self.secondTicked()
            })
        }
    }
    
    private func secondTicked() {
        guard let timeLeft = timeRemaining else { return }
        if timeLeft > 0 {
            self.timeRemaining = timeLeft - 1
            delegate?.timerSecondTicked()
        } else {
            self.timeRemaining = nil
            timeCounter?.invalidate()
            delegate?.timerCompleted()
            
        }
    }
    
    func stopTimer() {
        self.timeRemaining = nil
        timeCounter?.invalidate()
        delegate?.timerCompleted()
        
    }
    
}
