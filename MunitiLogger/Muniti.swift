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
    
    /// if true, will send log to console
    var consoleVerbose : Bool = true
    
    /// if true, will send log to firebase
    var firebaseVerbose : Bool = true
    
    
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
    func log(_ text : String, type : conditions = .log, _ condition : LogCases = .both) {
        self.log(text, type: type.rawValue, condition)
    }
    
    /// this is the general log funtion
    func log(_ text : String, type : String, _ condition : LogCases = .both) {
        // here we will send the data with user id to the server
        
        switch condition {
            case .both:
                if firebaseVerbose { self.http.log(text, type) }
                if consoleVerbose { print("\(type) \(text)") }
            case .console:
                if consoleVerbose { print("\(type) \(text)") }
            case .firebase:
                if firebaseVerbose { self.http.log(text, type) }
        }
        
    }
    
    enum LogCases {
        case firebase
        case console
        case both
    }
    
    func warning(_ text : String, _ condition : LogCases = .both) {
        log(text, type: .warning, condition)
    }
    
    func error(_ text : String, _ condition : LogCases = .both) {
        log(text, type: .error, condition)
    }
    
    func newUser(_ text : String, _ condition : LogCases = .both) {
        log(text, type: .newUser, condition)
    }
    
    func message(_ text : String, _ condition : LogCases = .both) {
        log(text, type: .message, condition)
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
