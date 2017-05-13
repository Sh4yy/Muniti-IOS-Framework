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
    
    private var user_id : String {
        if let uid = storage[MSSN(.userId)].stringValue {
            return uid
        } else {
            let uid = UUID().uuidString
            storage[MSSN(.userId)] = Node(uid)
            return uid
        }
    }
    
    /// this function will register the user to firebase
    func register() {
        let json : JSON = [
            "date" : Date().timeIntervalSince1970
        ]
    }
    
    
    /// this will be the endpoint of every request
    func makeRequest(_ route : String, json : JSON, _ method : httpMethods = .POST) {
        guard let url = URL(string: route) else { return }
        let request = URLRequest(url: url)
        let session = URLSession.shared.dataTask(with: request)
        session.resume()
    }
    
    enum httpMethods {
        case GET
        case POST
        case PATCH
    }
    
    
}
