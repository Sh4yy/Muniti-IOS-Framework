//
//  Node.swift
//  MunitiLogger
//
//  Created by Shayan on 5/25/17.
//  Copyright © 2017 Shayan. All rights reserved.


import Foundation

class StorageKeys {
    fileprivate init() {}
}

class StorageKey<ValueType> : StorageKeys {
    
    var key : String!
    
    init(_ key : String) {
        self.key = key
    }
    
}

extension StorageKeys {
    static let accessToken = StorageKey<Int>("hi")
}

protocol NodeConvertible {
}

extension NodeConvertible {
    var node : Node {
        return Node(self)
    }
}

extension Int : NodeConvertible {}
extension Int32 : NodeConvertible {}
extension Int64 : NodeConvertible {}
extension String : NodeConvertible {}
extension Bool : NodeConvertible {}
extension Double : NodeConvertible {}
extension Float : NodeConvertible {}

class Node {
    
    private let value : AnyObject?
    
    init<T>(_ newValue : T?) {
        
        if newValue is Node {
            self.value = (newValue as! Node).anyObject
        } else {
            self.value = newValue as AnyObject
        }
        
    }
    
    // Automatically figures our the expected value
    // and if the value is nil, it will return the input
    func instead<T>(_ value : T) -> T {
        if value is String {
            return self.string as? T ?? value
        } else if value is Int {
            return self.int as? T ?? value
        } else if value is Int32 {
            return self.int32 as? T ?? value
        } else if value is Int64 {
            return self.int64 as? T ?? value
        } else if value is Double {
            return self.double as? T ?? value
        } else {
            return get() ?? value
        }
    }
    
    var node : Node {
        return Node(self.value)
    }
    
    var string : String? {
        get {
            if let v = self.intValue {
                return String(v)
            } else if let v = self.int32Value {
                return String(v)
            } else if let v = self.int64Value {
                return String(v)
            } else if let v = self.doubleValue {
                return String(v)
            } else if let v = self.bool {
                return v ? "true" : "false"
            } else if let v = self.stringValue {
                return v
            }
            
            return nil
            
        }
    }
    
    var int64 : Int64? {
        get {
            if let v = self.int32Value {
                return Int64(v)
            } else if let v = int64Value {
                return Int64(v)
            } else if let v = self.doubleValue {
                return Int64(v)
            } else if let v = self.stringValue {
                return Int64(v)
            } else if let v = self.intValue {
                return Int64(v)
            }
            
            return nil
            
        }
    }
    
    var int : Int? {
        get {
            guard let v = self.int64 else {
                return get()
            }
            
            return Int(v)
        }
    }
    
    var int32 : Int32? {
        get {
            if let v = self.int32Value {
                return Int32(v)
            } else if let v = self.int64Value {
                return Int32(v)
            } else if let v = self.doubleValue {
                return Int32(v)
            } else if let v = self.stringValue {
                return Int32(v)
            } else if let v = self.intValue {
                return Int32(v)
            }
            
            return nil
        }
        
    }
    
    var double : Double? {
        get {
            if let v = self.int32Value {
                return Double(v)
            } else if let v = self.int64Value {
                return Double(v)
            } else if let v = self.doubleValue {
                return Double(v)
            } else if let v = self.stringValue {
                return Double(v)
            } else if let v = self.intValue {
                return Double(v)
            }
            
            return nil
        }
    }
    
    var bool : Bool? {
        get {
            
            if let s = self.stringValue {
                
                if s.lowercased() == "false" { return false }
                if s.lowercased() == "true" { return true }
                
            }
            
            return get()
            
        }
    }
    
    var character : Character? {
        get { return get() }
    }
    
    var float : Float? {
        get {
            if let v = self.double {
                return Float(v)
            }
            
            return get()
        }
    }
    
    var anyObject : AnyObject? {
        get { return self.value }
    }
    
    var intValue : Int? {
        return get()
    }
    
    var int32Value : Int32? {
        return get()
    }
    
    var int64Value : Int64? {
        return get()
    }
    
    var doubleValue : Double? {
        return get()
    }
    
    var stringValue : String? {
        return get()
    }
    
    private func get<T>() -> T? {
        return self.value as? T ?? nil
    }
    
}

extension Dictionary where Value : Node {
    
    func node(_ index : Key) -> Node {
        return Node(self[index])
    }
    
    func node<T>(_ index : Key, _ instead : T) -> T {
        return node(index).instead(instead)
    }
    
}









