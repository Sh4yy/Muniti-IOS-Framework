//
//  ViewController.swift
//  MunitiLogger
//
//  Created by Shayan on 5/13/17.
//  Copyright © 2017 Shayan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var cache : SimpleCache!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //test()
        
//        Logger.warning("hey this is a warning message")
//        
//        sleep(1)
//        
//        Logger.error("this app just crashed")
//        
//        sleep(1)
//        
//        Logger.log("new button touched")
//        
//        cache = SimpleCache(autoRemove: true, afterMins: 1, refreshRatePerMin: 1)
//        
//        cacheTest()
        
          eventTest()
        
    }
    
    func eventTest() {
        
        Logger.firebaseVerbose = true
        
        let eventName = "testEvent"
        
        print("event value \(Logger.statics.eventValue(eventName))")
        
        for _ in 1 ... 10 {
        Logger.statics.registerEvent(eventName)
        }
        
        print("event value \(Logger.statics.eventValue(eventName))")
        
        Logger.log("now deleting the event \(eventName)", type: .log)
        
        Logger.statics.removeEvent(eventName)
        
        print("event value \(Logger.statics.eventValue(eventName))")
        
        Logger.firebaseVerbose = true
            
    }
    
    func cacheTest() {
        
        cache["password"] = "myPass"
        cache["image"] = #imageLiteral(resourceName: "shitty")
        cache["button"] = UIButton()
        cache["array"] = [1,34,5,65,3,4,3]
        
        print("cache count = \(cache.count)")
        
        background {
            sleep(30)
            mainQueue {
                self.cache["new"] = 234.0
            }
            sleep(40)
        }.then {
            mainQueue {
                print("cache count = \(self.cache.count)")
            }
        }.run()
        
    }
    
    func test() {
        
        print("first open")
        print(Logger.statics.isFirstSession)
        
        print("app version")
        print(appVersion() ?? "not available")
        
        print("session number")
        print(Logger.statics.numberOfSessions)
        
        print("current session duration")
        //        sleep(1)
        print(Logger.statics.currentSessionDuration)
        //        sleep(2)
        //        print(Logger.statics.currentSessionDuration)
        //        sleep(3)
        //        print(Logger.statics.currentSessionDuration)
        
        print("recent updated")
        print(Logger.statics.recentlyUpdated)
        
        print("session average")
        print(Logger.statics.averageSessionDuration)
        
    }

    /// these work perfectly :D
    @IBAction func FIRandConsole(_ sender: Any) {
        Logger.warning("this is a test warning for both console and firebase", .both)
    }
    
    @IBAction func FIRlog(_ sender: Any) {
        Logger.message("this is a test message for firebase only", .firebase)
    }
    
    @IBAction func CONlog(_ sender: Any) {
        Logger.error("this is an error message for console only", .console)
    }
    
}

