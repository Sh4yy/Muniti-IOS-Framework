//
//  TelegramLogger.swift
//  Telegram-Logging
//
//  Created by Shayan on 11/27/16.
//  Copyright © 2016 Shayan. All rights reserved.
import Foundation

open class TLLogger {
    
    private typealias Parameters = [String : Any]
    
    private var api_url = "https://api.telegram.org/"
    private var api_key : String!
    private var chat_id : String!
    private var route : String {
        return self.api_url + "bot" + self.api_key
    }
 
    fileprivate let storage : LocalStorage
    
    public init(token : String, chat_id : String) {
        self.api_key = token
        self.chat_id = chat_id
        self.storage = LocalStorage()
    }
    
    private enum telegramPaths : String {
        case sendMessage = "/sendMessage"
    }
    
    public func log(_ text : String, type : String, to : String? = nil){
        
        let str_condition = type == "" ? "" : type + " "
        let target : String = (to != nil) ? to! : chat_id
        let params : Parameters = ["chat_id" : target, "text" : str_condition + text]

        let path = route.appending(telegramPaths.sendMessage.rawValue)
        
        MunitiHTTP.makeRequest(path, params, .POST)
        
    }
    
}








