//: Playground - noun: a place where people can play

//
//  LocalStorage.swift
//  Tutorial
//
//  Created by Shayan on 3/11/17.
//  Copyright © 2017 Shayan. All rights reserved.
//

import Foundation


class Node {
    
    private let value : Any?
    
    init<T>(_ newValue : T) {
        self.value = newValue
    }
    
    var stringValue : String? {
        get { return get() }
    }
    
    var intValue : Int? {
        get { return get() }
    }
    
    var doubleValue : Double? {
        get { return get() }
    }
    
    var boolValue : Bool? {
        get { return get() }
    }
    
    var characterValue : Character? {
        get { return get() }
    }
    
    var floatValue : Float? {
        get { return get() }
    }
    
    var anyObject : AnyObject? {
        get { return self.value as AnyObject? }
    }
    
    private func get<T>() -> T? {
        return self.value as? T ?? nil
    }
    
}

class StorageKeys {}

class StorageKey<ValueType> : StorageKeys {
    var key : String!
    init(_ key : String) {
        self.key = key
        super.init()
    }
}

extension StorageKeys {
    static let accessKey = StorageKey<String>("accessKey")
}

class LocalStorage {
    
    
    let defaults = UserDefaults.standard
    
    subscript(_ index : String) -> Node {
        get {
            return self.get(index: index)
        }
        set {
            self.set(index: index, newValue)
        }
    }
    
    func hasKey(_ key : String) -> Bool {
        return defaults.value(forKey: key) == nil ? false : true
    }
    
    func rawValue<T>(_ key : StorageKey<T>) -> T? {
        return get(index: key.key) as? T
    }
    
    private func get(index : String) -> Node {
        let node = Node(defaults.value(forKey: index))
        return node
    }
    
    private func set(index : String, _ value : Node) {
        defaults.set(value.anyObject, forKey: index)
        defaults.synchronize()
    }
    
    
}
