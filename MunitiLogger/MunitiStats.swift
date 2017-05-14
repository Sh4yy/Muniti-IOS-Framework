//
//  MunitiStats.swift
//  MunitiLogger
//
//  Created by Shayan on 5/13/17.
//  Copyright © 2017 Shayan. All rights reserved.
//

import Foundation

fileprivate let storage = LocalStorage()

typealias UnixTime = Double

extension Array where Element : Double {
    
}

class MunitiStats {
    
    let sessionStarted : Double
    
    var unix : UnixTime {
        return Date().timeIntervalSince1970
    }
    
    init() {
        self.sessionStarted = Date().timeIntervalSince1970
    }
    
    var averageSessionDuration : Double? {
        return durationArray.computedAverage
    }
    
    var currentSessionDuration : Double {
        return unix - sessionStarted
    }
    
    var isFirstSession : Bool {
        return self.firstSessionFlag
    }
    
    var lastSession : UnixTime? {
        return storage[MSSN(.lastSessionDate)].doubleValue
    }
    
    var firstSession : UnixTime? {
        return storage[MSSN(.fistSessionDate)].doubleValue
    }
    
    var numberOfSessions : Int {
        return storage[MSSN(.numberOfSessions)].intValue ?? 0
    }
    
    var currentVersion : String? {
        return appVersion()
    }
    
    var recentlyUpdated : Bool {
        return self.recentlyUpdatedFlag
    }
    
    /// resgiter session flag
    /// if true: resgisterSession has been executed
    private var registerSessionFlag = false
    
    /// this is the only public function for this class
    /// it will trigger all the session calculations
    /// sets a flag to true to avoid further executions
    func registerSession() {
        
        guard !registerSessionFlag else { return } // add warning log here
        registerSessionFlag = !registerSessionFlag
        
        // do the calculations
        newSession()
        
        // check for updates
        checkUpdate()
        
    }
    
    // if true: this is user's first session
    private var firstSessionFlag = false
    
    private func newSession() {
    
        // check number of sessions
        if numberOfSessions == 0 { self.firstSessionFlag = true }
        
        // increase number of sessions
        increaseNumberOfSessions()
        
    }
    
    // if true: this is the first session after update
    private var recentlyUpdatedFlag = false
    
    private func checkUpdate() {

        /// get the previous version from storage
        let previousVersion = storage[MSSN(.lastSessionVersion)].stringValue
        /// save new version to storage
        storage[MSSN(.lastSessionVersion)] = Node(self.currentVersion)
        
        /// compare new and previous version to see if changed
        guard let pv = previousVersion,
              let nv = self.currentVersion else { return }
        
        if pv != nv {
            self.recentlyUpdatedFlag = true
        }
        
        
    }
    
    func didEnterBackground() {
        addNewDurationToStorage()
    }
    
    /// return an array with durations from previous sessions
    private var durationArray : [Double] {
        let timeDuration = [Double]()
        guard let tda = storage[MSSN(.durationStorageArray)].anyObject as? [Double] else {
            return timeDuration
        }
        return tda
        
    }
    
    
    /// adds a new duration to the storage
    func addNewDurationToStorage() {
        
        var tda = self.durationArray
        tda.append(self.currentSessionDuration)
        storage[MSSN(.durationStorageArray)] = Node(tda)
        
    }
    
    func willTerminate() { print("app about to terminate") }
    
    // increases the number of sessions and stores it to the storage
    private func increaseNumberOfSessions(by value : Int = 1) {
        storage[MSSN(.numberOfSessions)] = Node(numberOfSessions + value)
    }
    
}


// TODO: Enter names with spacing for easier readability.
enum MunitiStatsStorage:String {
    
    ///Stores user's first session date as unix value
    case fistSessionDate = "first session date"
    
    ///Stores user's last session date as unix value
    case lastSessionDate = "last session date"
    
    ///Stores the number of sessions as an integer
    case numberOfSessions = "number of sessions"
    
    ///Stores the last session app version
    case lastSessionVersion = "last session app version"
    
    ///Stores a list of durations to storage
    case durationStorageArray = "duration storage array"
    
    ///Stores the users unique identifier
    case userId = "user id"
    
}

/// Returns the app's current version
func appVersion() -> String? {
    return (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String?) ?? ""
}


func MSSN(_ value : MunitiStatsStorage) -> String {
    let SIGNATURE : String = "Muniti_"
    return SIGNATURE + value.rawValue.replacingOccurrences(of: " ", with: "")
}
