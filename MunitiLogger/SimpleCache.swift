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
    private var storageDate : [(String,UnixTime)]
    
    private var timer : Timer?
    
    private var autoRemove : Bool
    private var removeAfter : Int
    private var refreshRate : Int
    
    /// initialize a new cache object
    /// - parameter autoRemove: Boolean flag for auto removing data after x mins
    /// - parameter afterMins: Removes data after x number of minutes
    /// - parameter refreshRatePerMin: chech the data x times each minute, 1 is recommended
    init(autoRemove : Bool = false, afterMins : Int = 0, refreshRatePerMin : Int = 1) {
        self.storage = [String : Any]()
        self.storageDate = [(String,UnixTime)]()
        
        self.autoRemove = autoRemove
        self.removeAfter = afterMins
        self.refreshRate = refreshRatePerMin
        
        if autoRemove {
            let interval = 60.0 / self.refreshRate.doubleValue
            self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: self.timerCallBack(_:))
        }
        
    }
    
    /// store or get cached value for key
    subscript(_ key : String) -> Any? {
        get {
            return self.storage[key]
        }
        set (object) {
            guard let obj = object else { return }
            self.storage.updateValue(obj, forKey: key)
            self.storageDate.append((key, Date().timeIntervalSince1970))
            
            self.storageDate = self.storageDate.sorted(by: { value1, value2 -> Bool in
                value1.1 > value2.1
            })
        }
    }
    
    /// checks the elements in storage and removes old data
    /// TODO: This function is a bit buggy, will fix it tomorrow
    private func timerCallBack(_ timer : Timer) {
        
        background {
            let deadline = Date().timeIntervalSince1970 - (self.removeAfter.doubleValue * 60.0)
            for value in self.storageDate.enumerated() {
                guard value.element.1 < deadline else { return }
                guard self.storageDate.count > value.offset else { return }
                self.storageDate.remove(at: value.offset)
                self.storage.removeValue(forKey: value.element.0)
            }
            
        }.run()
        
    }
    
    /// number of elements stored in cache
    var count : Int {
        return storage.count
    }
    
    /// remove all stored objects
    func removeAll() {
        storage.removeAll()
        storageDate.removeAll()
    }
    
    /// remove specific value from cache
    func remove(_ key : String) {
        storage.removeValue(forKey: key)
        for (index,value) in self.storageDate.enumerated() {
            if value.0 == key {
                self.storageDate.remove(at: index)
                return
            }
        }
    }
    
}
