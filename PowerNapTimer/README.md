#  ReadMe - Master-PowerNap (Week 2 - Day 2)

This is the Instructor Guide for PowerNap (Week 2 - Day 2)

Please be sure to update this readme file after completing your lesson. Make sure to include any major "sticking points" that came up while teaching the lesson.

If any changes have been made to the master file, other than updates to the readme file, please be sure to log them in the commit message.

Please be sure to read through the ReadMe file entirely, and make sure to research any points that you get stuck on as well as the common questions below.


## App Objective:
This is Day 2 of Protocols & Delegates. With this app, PowerNap, you are going to continue diving into Protocols & Delegates, demonstrating this effective (1-to-1) communication pattern. This will be paired with an introduction to alert controllers (which are quite commonly paired with protocols) and local notification.


## Common Questions:
Q: Can this be accomplished in one file without using a protocol and delegate?
A: Yes, but that doesn't follow Apple's conventions, and starts to put too much code into one file. Sure, this app has a small amount of code, but imagine if an app has 160,000 lines of code, and we just kept adding code to the same file...

Q:
A:


## Instructor Log:
Examples:
04.09.2020 - File created by Cameron Stuart
05.01.2021 - File taught by Person X - changed depricated code in MyTimer.swift


## Step-By-Step Guide:
1) Explain app objective. Share or remind students of Boss-Intern analogy.

2) Present app (from master file) to discuss with class and determine what needs to be built.
    - App has a timer, a button to start the time, an alert when the timer goes off (if user is in the app), a notification when the timer goes off (if user is outside the app), a button to say "I'm Up", and text field to add minutes and keep snoozing.
    
3) Create Single View App called PowerNap.

4) Oranganize folders (only need a Resources folder for this app) & relocate plist.

5) Build out UI
    - App has a Label that shows the time counting down.
    - App has a Button the says "Start Nap".
    - Make sure to constrain these objects properly.
    - Rename viewController file and class name to "PowerNapViewController" & then set it on the storyboard.
    
6) DISCUSS - What exactly is happening in this app? We have a user who initiates a timer, and then the timer tells our view controller to update the UI (THINK BOSS-INTERN RELATIONSHIP), and give us an alert and a notification once the timer hits 0:00. So, we need to build out 2 files, our timer class, and our view controller.

7) Build out MyTimer swift file - we do this to abstract complexity from our view controller.
    - STEP 1 - Create our MyTimer class.
    
        ```swift
        class MyTimer {
            
        }

    - STEP 2 - Determine necessary variables (timer, timeLeft, isOn).
    
        ```swift
        // timer is optional because when the timer is not running, it should be nil.
        var timer: Timer?
        // timeLeft is optional because when our timer not running, it should be nil.
        var timeLeft: TimerInterval?
        // isOn is a computed property because when our timer is stopped, our timeLeft will be set to nil, and therefore we want our isOn status to immediately switch to false.
        var isOn: Bool {
            if timeLeft == nil {
                return false
            } else {
                return true
            }
        }
        ```
    
    - STEP 3 - Determine necessary functions (startTimer, secondsTicked, stopTimer, timeLeftAsString).
    
        ```swift
        func startTimer() {
        }
        
        func stopTimer() {
        }
        
        func timeLeftAsString() {
        }
        ```
        
    - STEP 3A - Start to build startTimer function. This function should have 1 parameter, a TimeInterval that the user gives us, let's call it "duration".

        ```swift
        func startTimer(duration: TimeInterval) {
        }
        ```
        Now, this is a good place to make sure things are working by simply adding a print statement to the function.

        ```swift
        func startTimer(time: TimeInterval) {
            print("Start timer function called.")
        }
        ```
        Let's test this by going back to our PowerNapViewController and adding an instance of myTimer() above the viewDidLoad.

        ```swift
        var myTimer = MyTimer()
        ```
            
        Then let's call myTimer.startTimer(time: 10) inside the viewDidLoad to test our timer and make sure our print statement is printed. 

        ```swift
        myTimer.startTimer(time: 4)
        ``` 

        Continue building startTimer function by checking to see if the timer is already on (we don't want it starting again if it is already on). If it is not on, set timeLeft variable to the TimeInterval being passed into the startTimer function, create a timer that trigger a block of code every 1 second, and then create a helper function (our block of code) to be run - we will call that function secondTicked().
        
        ```swift
        func startTimer(time: TimeInterval) {
            /// What happens if our timer is already on? We don't want to be starting the timer again.
            if isOn {
                // Do nothing!
                print("This must be a mistake, there is already a timer running")
            } else {
                timeLeft = time
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
                    self.secondTicked()
                })
            }
        }
        ```
                        
        Now, let's build out our secondTicked helper function. We will make it a private function, because we don't need our PowerNapViewController to have access to it. Our goal is to reduce the time left by 1 second, every second. However, if our timeLeft is 0, we don't want to reduce it any further. Because timeLeft is optional, we will need to put in a guard statement to make sure it is not nil.

        ```swift      
        private func secondTicked() {
            // Check to see how much time is left
            guard let timeLeft = timeLeft else {
                print("The timer is not currently running")
                return
            }
            
            // If our timeLeft is greater than 0, we need to reduce it by 1
            if timeLeft > 0 {
                self.timeLeft = timeLeft - 1
                // Tell our view controller (intern) to update the time.
                
                // Print out our remaining time as a string for testing purposes
                print(self.timeLeft!)
            // If our timeLeft is equal to 0, we need to stop the time and alert the user
            } else {
                self.timeLeft = nil
                timer?.invalidate()
                print("Timer has been stopped")
                // Tell our view controller (intern) that the timer has completed.

            }
        }
        ```
                    
    - STEP 3B - Let's build our stopTimer function:

        ```swift
        func stopTimer() {
            self.timeLeft = nil
            timer?.invalidate()
            print("User has stopped the timer")
            // Tell our view controller (intern) that the timer has been stopped.
        }            
    - STEP 3C - Let's build our timeLeftAsString function:
    For our timeRemaining variable, we are going to set it to an Int value of timeLeft in order for us to not have to deal with decimal values when converting to a string. Additionally, we are going to use Nil-colescing in order to have a default value if timeLeft is nil. In this case, we will use 20 minutes as the default value.
    We will use String Formatting instead of string interpolation in order to make sure we always have two digits in front of the colon, and two digits after the colon. (ex. 20:00 instead of 20:0).

        ```swift
        func timeLeftAsString() -> String {
            let timeRemaining = Int(self.timeLeft ?? 20 * 60)
            let minutesLeft = timeRemaining / 60
            let secondsLeft = timeRemaining - (minutesLeft * 60)
            return String(format: "%02d : %02d", arguments: [minutesLeft, secondsLeft])
        }
        ```
        
        Update the print statement in our secondTicked helper function to print(timeLeftAsString) instead of print(timeLeft!).
        
    - STEP 4 - Create our protocols. Keep in mind, our protocols are to be built outside of the class.  Looking at the app, we can tell that our MyTimer class (the boss) needs to inform our tell our inter 3 things: 1) A second has ticked by, update the UI. 2) The timer has stopped, update the UI. 3) The timer has completed, send the user an alert. *We will make this protocol only work with classes (we can go into this later down the road).

        ```swift
        protocol MyTimerDelegate: class {
            func timerSecondTicked()
            func timerHasStopped()
            func timerHasCompleted()
        }
                    
    - STEP 5 - We will need to create a delegate variable inside our MyTimer class in order to have access to those protocols. This variable needs to be weak and optional (we will go into why later down the road).

        ```swift
        weak var delegate: MyTimerDelegate?
    
    - STEP 6 (Not notated in MyTimer.swift) - Implement our delegate functions. To do so, we will simply call delegate?.timerSecondTicked (or a different function) We will need to call these functions in a few places. In our stopTimer function we will call delegate?.timerHasStopped(). In our secondTicked function, if our timeLeft is greater than 0, we will need to call delegate?.timerSecondTicked(), and if our timeLeft is 0, we will need to call delegate?.timerHasCompleted().
    
8) Build out the view controller.
    - STEP 1 - Connect your outlets (time label and start/stop button - this is being connected as an outlet because we will be changing the button title).

        ```swift
        @IBOutlet weak var timeLabel: UILabel!
        @IBOutlet weak var startStopButton: UIButton!
                
    - STEP 2 - Connect your actions (start/stop button).

        ```swift
        @IBAction func startStopButtonTapped(_ sender: Any) {

        }

    - STEP 3 - Create an extension for PowerNapViewController and conform to our MyTimerDelegate.

        ```swift
        extension PowerNapViewController: MyTimerDelegate {

        }
        ```

        After typing in this extension, an error will occur. Great thing is, it will give us a fix button. Click fix and watch it's magic happen! After you click fix, you should see the following:
        
        ```swift
        extension PowerNapViewController: MyTimerDelegate {
            func timerSecondTicked() {
            }
            
            func timerHasStopped() {
            }
            
            func timerHasCompleted() {
            }
        }
        ```
                        
        For now, let's add some print statements to each of these functions for testing purposes:
        
        ```swift
        extension PowerNapViewController: MyTimerDelegate {
            func timerSecondTicked() {
                print("timerSecondTicked")
            }
            
            func timerHasStopped() {
                print("timerHasStopped")
            }
            
            func timerHasCompleted() {
                print("timerHasCompleted")
            }
        }
        ```
    
    - STEP 4 - Set the myTimer.delegate = self in the PowerNapViewController.

        ```swift 
        myTimer.delegate = self
    
    - STEP 5 - Create a function to update our time label and button title, depending on the status of the timer (on or off). Make sure to call the function in the timerSecondTicked, the timerHasStopped, and the timerHasCompleted protocol stubs. You can remove the print statements we has in those functions.

        ```swift
        func updateLabelAndButton() {
            timeLabel.text = myTimer.timeLeftAsString()
            var title = "Start Nap"
            if myTimer.isOn {
                title = "Stop"
            }
            startStopButton.setTitle(title, for: .normal)
        }
        
        ....
        
        extension PowerNapViewController: MyTimerDelegate {
            func timerSecondTicked() {
                updateLabelAndButton()
            }
            
            func timerHasStopped() {
                updateLabelAndButton()
            }
            
            func timerHasCompleted() {
                updateLabelAndButton()
            }
        }
    
    - STEP 6 - Build out the startStopButtonTapped Action. We will first need to determine if our timer is already running or not. If our timer is already running, we will need to call myTimer.stopTimer(), if it is not, we will call myTimer.startTimer(time: 10). At this point go ahead and remove the "myTimer.startTimer(10)" from the viewDidLoadand.

        ```swift
        @IBAction func startStopButtonTapped(_ sender: Any) {
            if myTimer.isOn {
                myTimer.stopTimer()
            } else {
                myTimer.startTimer(time: 10)
            }
        }
    
    - STEP 7 - Create a function to create an alert that informs the user that the timer has completed, and gives them the option to reset it, or say they are up. Instructor - please be aware of how to build an alert controller and all the necessary compnents. After building the alert controller, make sure to call this function in the timerHasCompleted protocol stub.

        ```swift
        func createAlertController() {
            let alert = UIAlertController(title: "Time to wake up!", message: "Or maybe not?", preferredStyle: .alert)
            
            let dismissAction = UIAlertAction(title: "I'm Up!", style: .default, handler: nil)
            alert.addAction(dismissAction)
            
            let snoozeAction = UIAlertAction(title: "Snooze", style: .destructive) { (_) in
                let textField = alert.textFields?.first
                guard let timeAsString = textField?.text,
                let timeAsDouble = Double(timeAsString) else { return }
                
                self.myTimer.startTimer(time: timeAsDouble * 60)
                self.scheduleLocalNotification(timeInterval: timeAsDouble * 60)
            }
            alert.addAction(snoozeAction)
            
            alert.addTextField { (textField) in
                textField.placeholder = "How many minutes do you want to snooze?"
                textField.keyboardType = .numberPad
            }
            
            present(alert, animated: true, completion: nil)
        }
        
        ....
        
        extension PowerNapViewController: MyTimerDelegate {
            func timerSecondTicked() {
                updateLabelAndButton()
            }
            
            func timerHasStopped() {
                updateLabelAndButton()
            }
            
            func timerHasCompleted() {
                updateLabelAndButton()
                createAlertController()
            }
        }

    
    - STEP 8 - Create a function to schedule a local notification. Should should be set to go off at the same time that alert would trigger. Make sure to call the function where needed (anywhere that the startTimer function is being called). Additionally, in order to have accss to UNUserNotificationCenter, you will need to import UserNotifications. Additionally, we will create a constant called identifier that will be used in the UNNotificationRequest. This will prevent typo mistakes.

        ```swift
        import UserNotifications
        
        ....
        
        let identifier = "wakeUpNotification"
        
        ....

        func scheduleLocalNotification(timeInterval: TimeInterval) {
            let content = UNMutableNotificationContent()
            content.title = "WAKE UP!"
            content.subtitle = "It is time to get going!"
            content.badge = 1
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (_) in
                print("User asked to get a local notification.")
            }
        }

    - STEP 9 - If you tested the app now, you would notice that the notifications are not working properly. That is because we havent asked the user for permission to send them notifications. Let's ask them. In the viewDidLoad add the following code:

        ```swift
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (authorizationGranted, error) in
            if authorizationGranted {
                print("User has given us permission to send notifications.")
            }
        }

The app should now be fully functional! Although, maybe not altogether perfect. Challenge students to add functionality to cancel the notification if the timer is cancelled. You will also notice, if you put the app into the background and come back to it later, the timer label will no longer be reflecting the correct time. Challenge the students to think through how this would best be updated.
