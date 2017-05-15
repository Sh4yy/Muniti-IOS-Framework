//
//  CacheEngine.swift
//  MunitiLogger
//
//  Created by Shayan on 5/14/17.
//  Copyright © 2017 Shayan. All rights reserved.
//

import Foundation

class SimpleCache {
    
    private var storage : [String : Any]
    private var storageDate : [String : UnixTime]
    
    private var timer : Timer?
    
    private var autoRemove : Bool
    private var removeAfter : Int
    private var refreshRate : Int
    
    init(autoRemove ar : Bool = false, afterMins am: Int = 0, refreshRatePerMin : Int = 1) {
        self.storage = [String : Any]()
        self.storageDate = [String : UnixTime]()
        
        self.autoRemove = ar
        self.removeAfter = am
        self.refreshRate = refreshRatePerMin
        
        if autoRemove {
            let interval = 60.0 / self.refreshRate.doubleValue
            self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: self.timerCallBack(_:))
        }
        
    }
    
    private func timerCallBack(_ timer : Timer) {
        
        let deadline = Date().timeIntervalSince1970 - (removeAfter.doubleValue * 60.0)
        
        
        
    }
    
    subscript(_ key : String) -> Any? {
        
        get {
            return self.storage[key]
        }
        
        set (object) {
            guard let obj = object else { return }
            self.storage.updateValue(obj, forKey: key)
        }
        
    }
    
    
    
}
