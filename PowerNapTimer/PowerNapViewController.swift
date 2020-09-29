//
//  PowerNapViewController.swift
//  Master-PowerNap
//
//  Created by Cameron Stuart on 4/8/20.
//  Copyright © 2020 Cameron Stuart. All rights reserved.
//

import UIKit

class PowerNapViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    //MARK: - Outlets
    // 1) Connect our outlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    
    //MARK: - Properties
    var myTimer = MyTimer()
    
    // 8) Create a string constant for our notification identifier
    let userNotificationIdentifier = "wakeUpNotification"

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // 4) Set the delegate for myTimer.
        myTimer.delegate = self
    }
    
    //MARK: - Actions
    // 2) Connect our Actions:
    @IBAction func startStopButtonTapped(_ sender: Any) {
        // 6) IF our timer is already running - this button will stop the timer, ELSE it will start the timer.
        if myTimer.isOn {
            myTimer.stopTimer()
            cancelLocalNotification()
        } else {
            myTimer.startTimer(duration: 5)
            scheduleLocalNotification(timeInterval: 5)
        }
    }
    
    //MARK: - Methods
    // 5) Function to update our time label and button title
    func updateLabelAndButton() {
        timeLabel.text = myTimer.timeLeftAsString()
        var title = "Start Nap"
        if myTimer.isOn {
            title = "Stop"
        }
        startStopButton.setTitle(title, for: .normal)
    }
    
    // 7) Function to present an alert that will inform the user the timer has completed
    func presentTimerFinishedAlertController() {
        let alert = UIAlertController(title: "Time to wake up!", message: "Or maybe not?", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "I'm Up!", style: .default, handler: nil)
        alert.addAction(dismissAction)
        
        let snoozeAction = UIAlertAction(title: "Snooze", style: .destructive) { (_) in
            let textField = alert.textFields?.first
            guard let timeAsString = textField?.text,
                let timeAsDouble = Double(timeAsString) else { return }
            
            self.myTimer.startTimer(duration: timeAsDouble * 60)
            self.scheduleLocalNotification(timeInterval: timeAsDouble * 60)
        }
        alert.addAction(snoozeAction)
        
        alert.addTextField { (textField) in
            textField.placeholder = "How many minutes do you want to snooze?"
            textField.keyboardType = .numberPad
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    // 8) Create function to schedule notifications based on the timer.
    /// WORK BACKWARDS
    func scheduleLocalNotification(timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "WAKE UP!"
        content.subtitle = "It is time to get going!"
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: userNotificationIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (_) in
            print("User asked to get a local notification.")
        }
    }
    
    func cancelLocalNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [userNotificationIdentifier])
    }
}

//MARK: - Extensions
// 3) Create an extension so that PowerNapViewController (intern) conforms to MyTimerDelegate (boss).
extension PowerNapViewController: MyTimerDelegate {
    func timerSecondTicked() {
        updateLabelAndButton()
    }
    
    func timerHasStopped() {
        updateLabelAndButton()
        cancelLocalNotification()
    }
    
    func timerHasCompleted() {
        updateLabelAndButton()
        presentTimerFinishedAlertController()
    }
}

