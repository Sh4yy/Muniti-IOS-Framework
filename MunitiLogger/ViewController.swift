//
//  ViewController.swift
//  MunitiLogger
//
//  Created by Shayan on 5/13/17.
//  Copyright © 2017 Shayan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //test()
        
        Logger.warning("hey this is a warning message")
        
        sleep(2)
        
        Logger.error("this app just crashed")
        
        sleep(2)
        
        Logger.log("new button touched")
      
        
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


}

