//
//  Muniti.swift
//  MunitiLogger
//
//  Created by Shayan on 5/13/17.
//  Copyright © 2017 Shayan. All rights reserved.
//

import Foundation

class Muniti {
    
    let statics : MunitiStats
    typealias JSON = [String : Any]
    
    init(){
        self.statics = MunitiStats()
    }
    
    /// this is the log funtion with types
    func log(_ text : String, type : conditions) {
        self.log(text, type: type.rawValue)
    }
    
    /// this is the general log funtion
    func log(_ text : String, type : String = "") {
        // here we will send the data with user id to the server
        
        // this is a sample json file
        let json : JSON = ["uid" : "self.uid", "log" : text, "type" : type, "date" : statics.unix]
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
