//
//  NapTimer.swift
//  PowerNapTimer34
//
//  Created by Junior Suarez-Leyva on 11/21/20.
//

import Foundation

class NapTimer {
    
    var timeRemaining: TimeInterval?
    var timeCounter: Timer?
    var isActive: Bool {
        return timeRemaining != nil
    }
    
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
        } else {
            self.timeRemaining = nil
            timeCounter?.invalidate()
            
        }
    }
    
    func stopTimer() {
        self.timeRemaining = nil
        timeCounter?.invalidate()
        
    }
    
}
