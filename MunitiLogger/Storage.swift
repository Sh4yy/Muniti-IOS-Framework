//: Playground - noun: a place where people can play

//
//  LocalStorage.swift
//  Tutorial
//
//  Created by Shayan on 3/11/17.
//  Copyright © 2017 Shayan. All rights reserved.
//

import Foundation

extension StorageKeys {
    static let accessKey = StorageKey<String>("accessKey")
}

class LocalStorage {
    
    
    private let defaults = UserDefaults.standard
    
    subscript(_ index : String) -> Node {
        get {
            return self.get(index: index)
        }
        set {
            self.set(index: index, newValue)
        }
    }
    
    @discardableResult
    func remove(_ key : String) -> Bool {
        guard hasKey(key) else { return false }
        defaults.removeObject(forKey: key)
        return true
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
