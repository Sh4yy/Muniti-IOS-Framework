//
//  MunitiRegister.swift
//  MunitiLogger
//
//  Created by Shayan on 5/13/17.
//  Copyright © 2017 Shayan. All rights reserved.
//

import Foundation

class MunitiHTTP {
    
    let storage = LocalStorage()
    
    let firebase_url : String
    let firebase_token : String
    
    init(url : String, token : String) {
        self.firebase_url = url
        self.firebase_token = token
    }
    
    var user_id : String {
        if let uid = storage[MSSN(.userId)].stringValue {
            return uid
        } else {
            let uid = UUID().uuidString
            storage[MSSN(.userId)] = Node(uid)
            return uid
        }
    }
    
    func log(_ text : String, _ type : String) {
        
        let json : JSON = ["uid" : self.user_id, "log" : text, "type" : type, "date" : Date().timeIntervalSince1970]
        makeRequest(makeRoute(.logs), json, .POST)
        
    }
    
    /// this function will register the user to firebase
    func register() {
        let json : JSON = [
            "\(self.user_id)" : [
            "joined" : Date().timeIntervalSince1970
                ]
        ]
        
        makeRequest( makeRoute(.register), json, .PATCH)
        
    }
    
    enum routes : String {
        case register = "users"
        case logs = "logs"
    }
    
    private func makeRoute(_ route : routes) -> String {
        return self.firebase_url + "/" + route.rawValue + ".json"
    }
    
    /// this will be the endpoint of every request
    func makeRequest(_ route : String, _ json : JSON, _ method : httpMethods = .POST) {
        guard let url = URL(string: route) else { return }
        var request = URLRequest(url: url)
        
        guard let json = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
            return
        }
        
        request.httpBody = json
        request.httpMethod = method.rawValue
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared.dataTask(with: request)
        session.resume()
    }
    
    enum httpMethods : String {
        case GET = "GET"
        case POST = "POST"
        case PATCH = "PATCH"
    }
    
    
}
