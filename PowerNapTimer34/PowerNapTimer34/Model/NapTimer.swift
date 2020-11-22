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
    
}
