//
//  Muniti.swift
//  MunitiLogger
//
//  Created by Shayan on 5/13/17.
//  Copyright © 2017 Shayan. All rights reserved.
//

import Foundation

typealias JSON = [String : Any]

class Muniti {
    
    let statics : MunitiStats
    let http : MunitiHTTP
    
    init(url : String, token : String){
        self.http = MunitiHTTP(url: url, token : token)
        self.statics = MunitiStats()
    }
    
    func setup(){
        
        // start registering the user activity
        Logger.statics.registerSession()
        
        // if its first session, register the user on firebase
        if statics.isFirstSession {
            http.register()
        }
    }
    
    /// this is the log funtion with types
    func log(_ text : String, type : conditions = .log) {
        self.log(text, type: type.rawValue)
    }
    
    /// this is the general log funtion
    func log(_ text : String, type : String) {
        // here we will send the data with user id to the server
        
        // this is a sample json file
        
        
        self.http.log(text, type)
        
    }
    
    func warning(_ text : String) {
        log(text, type: .warning)
    }
    
    func error(_ text : String) {
        log(text, type: .error)
    }
    
    func newUser(_ text : String) {
        log(text, type: .newUser)
    }
    
    func message(_ text : String) {
        log(text, type: .message)
    }
    
    public enum conditions : String {
        case warning = "⚠️"
        case error = "😱"
        case message = "💬"
        case newUser = "🎉"
        case log = "🤖"
        case none = ""
    }
    
    
}
