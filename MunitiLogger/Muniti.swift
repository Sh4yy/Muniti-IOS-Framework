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
    
    init(){
        self.statics = MunitiStats()
    }
    
    func registerSession() {
        self.statics.registerSession()
    }
    
}
