//
//  MunitiRegister.swift
//  MunitiLogger
//
//  Created by Shayan on 5/13/17.
//  Copyright © 2017 Shayan. All rights reserved.
//
import Foundation

protocol MunitiHTTPDelagate {
    
    /// json will contain uid, log, type, date
    func uploadVerbose(_ json : JSON)
    
    /// json will contain uid and date
    func userRegister(json : JSON)
    
}

class MunitiHTTP {
    
    let storage = LocalStorage()
    
    let firebase_url : String
    let firebase_token : String
    
    /// users can use this delagate to upload their data
    /// to somewhere other than firebase
    var verboseDelagate : MunitiHTTPDelagate? = nil
    
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
        if verboseDelagate != nil {
            verboseDelagate?.uploadVerbose(json)
        }
        MunitiHTTP.makeRequest(makeRoute(.logs), json, .POST)
    }
    
    /// this function will register the user to firebase
    func register() {
        let json : JSON = [
            "\(self.user_id)" : [
            "joined" : Date().timeIntervalSince1970 ]]
        
        if verboseDelagate != nil {
            verboseDelagate?.userRegister(json: json)
        }
        MunitiHTTP.makeRequest( makeRoute(.register), json, .PATCH)
    }
    
    // these are our current firebase routes
    enum routes : String {
        
        // users will be registred here
        case register = "users"
        
        // logs will be uploaded here
        case logs = "logs"
    }
    
    private func makeRoute(_ route : routes) -> String {
        return self.firebase_url + "/" + route.rawValue + ".json"
    }
    
    /// this will be the endpoint of every request
    static func makeRequest(_ route : String, _ json : JSON, _ method : httpMethods = .POST, completion : ((Data?, URLResponse?, Error?) -> Void)? = nil) {
        guard let url = URL(string: route) else { return }
        var request = URLRequest(url: url)
        
        guard let json = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
            return
        }
        
        request.httpBody = json
        request.httpMethod = method.rawValue
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            if completion != nil {
                completion!(data, urlResponse, error)
            }
        }
        
        
        session.resume()
    }
    
    enum httpMethods : String {
        case GET = "GET"
        case POST = "POST"
        case PATCH = "PATCH"
    }
    
    
}
