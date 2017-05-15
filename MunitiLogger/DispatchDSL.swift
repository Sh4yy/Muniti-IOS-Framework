//
//  DispatchDSL.swift
//  DispatchDSL
//
//  Created by Shayan on 2/18/17.
//  Copyright © 2017 Shayan. All rights reserved.
//

import Foundation

@discardableResult
public func background(qos : DispatchQoS.QoSClass = .background,function : @escaping () -> Void) -> BackgroundQueue {
    let dispatch = BackgroundQueue(qos: qos, function : function)
    return dispatch
}

public func mainQueue(function : @escaping () -> Void) {
    DispatchQueue.main.async {
        function()
    }
}
 ////
open class BackgroundQueue {
    
    private let qos : DispatchQoS.QoSClass
    private var list : [() -> Void]
    
    init(qos : DispatchQoS.QoSClass, function : @escaping () -> Void){
        self.qos = qos
        self.list = []
        self.append {
            function()
        }
    }
    
    public func run() {
        DispatchQueue.global(qos: qos).async {
            for function in self.list {
                function()
            }
            
            self.list.removeAll()
            
        }
    }
    
    @discardableResult
    public func pause(for seconds : Int) -> BackgroundQueue {
        self.append {
            sleep(UInt32(seconds))
        }
        return self
    }
    
    @discardableResult
    public func then(_ function : @escaping () -> Void) -> BackgroundQueue {
        self.list.append(function)
        return self
    }
    
    private func append(function : @escaping (Void) -> Void) {
        self.list.append(function)
    }
    
}
