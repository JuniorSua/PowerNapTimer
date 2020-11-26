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
    fileprivate let userNotificationIdentifier = "TimerCompletedNotification"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTimer.delegate = self
    }
    
    
    @IBAction func timerButtonTapped(_ sender: Any) {
        if myTimer.isActive {
            myTimer.stopTimer()
            cancelLocalNotification()
        } else {
            myTimer.startTimer(time: 5)
            scheduleNotification()
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
        let snoozeAlertController = UIAlertController(title: "Time to wake up", message: "Still tired?", preferredStyle: .alert)
        snoozeAlertController.addTextField { (textfield) in
            textfield.placeholder = "Snooze for how many minutes?"
            textfield.keyboardType = .numberPad
        }
        let snoozeAction = UIAlertAction(title: "Snooze", style: .default) { (_) in
            guard let timeText = snoozeAlertController.textFields?.first?.text, let time = TimeInterval(timeText) else { return }
            self.myTimer.startTimer(time: time * 60)
            self.scheduleNotification()
            self.updateLabel()
            self.updateButton()
        }
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        snoozeAlertController.addAction(snoozeAction)
        snoozeAlertController.addAction(dismissAction)
        
        present(snoozeAlertController, animated: true)
        
    }
    
    func scheduleNotification() {
        let notificationContent         = UNMutableNotificationContent()
        
        notificationContent.title       = "Wake up!"
        notificationContent.subtitle    = "Nap time is over."
        notificationContent.badge       = 1
        notificationContent.sound       = .default
        
        guard let timeRemaining         = myTimer.timeRemaining else { return }   
        let date                        = Date(timeInterval: timeRemaining, since: Date())
        let dateComponents              = Calendar.current.dateComponents([.minute,.second], from: date)
        let trigger                     = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request                     = UNNotificationRequest(identifier: userNotificationIdentifier, content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
        
    }
    
    func cancelLocalNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [userNotificationIdentifier])
    }

}

extension NapTimerViewController: NapTimerDelegate {
    func timerSecondTicked() {
        updateLabel()
    }
    
    func timerStopped() {
        updateLabel()
        updateButton()
        cancelLocalNotification()
    }
    
    func timerCompleted() {
        updateLabel()
        updateButton()
        displaySnoozeAlertController()
        
    }
    
    
}
