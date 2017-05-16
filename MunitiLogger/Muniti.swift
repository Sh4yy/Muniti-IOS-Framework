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
    var tlogger : TLLogger? = nil
    
    /// if true, will send log to console
    var consoleVerbose : Bool = true
    
    /// if true, will send log to firebase
    var firebaseVerbose : Bool = true
    
    /// if true, will send log to telegram
    var telegramVerbose : Bool = true
    
    /// you can change default to either firebase console or both
    var defaultVerboseCase : [LogCases] = [.console, .firebase]
    
    init(url : String, token : String, telegramToken : String? = nil, telegramChatId : String? = nil){
        self.http = MunitiHTTP(url: url, token : token)
        self.statics = MunitiStats()
        if let telegramToken = telegramToken,
           let telegramChatId = telegramChatId {
           self.tlogger = TLLogger(token: telegramToken, chat_id: telegramChatId)
        }
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
    func log(_ text : String, type : conditions = .log, _ condition : [LogCases]? = nil) {
        self.log(text, type: type.rawValue, condition)
    }
    
    /// this is the general log funtion
    func log(_ text : String, type : String, _ condition : [LogCases]? = nil) {
        // here we will send the data with user id to the server
        
        let verboseCondition = condition ?? defaultVerboseCase
        
        if (verboseCondition.contains(.console)) {
            if consoleVerbose { print("\(type) \(text)") }
        }
        
        if verboseCondition.contains(.firebase) {
            if firebaseVerbose { self.http.log(text, type) }
        }
        
        if verboseCondition.contains(.telegram) {
            if telegramVerbose { self.tlogger?.log(text, type: type) }
        }
        
    }
    
    enum LogCases {
        case firebase
        case console
        case telegram
    }
    
    func telegram(_ text : String, type : conditions = .log, chat_id : String? = nil, forced : Bool = false) {
        if telegramVerbose || forced { self.tlogger?.log(text, type: type.rawValue, to: chat_id) }
    }
    
    func warning(_ text : String, _ condition : [LogCases]? = nil) {
        log(text, type: .warning, condition)
    }
    
    func error(_ text : String, _ condition : [LogCases]? = nil) {
        log(text, type: .error, condition)
    }
    
    func newUser(_ text : String, _ condition : [LogCases]? = nil) {
        log(text, type: .newUser, condition)
    }
    
    func message(_ text : String, _ condition : [LogCases]? = nil) {
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
