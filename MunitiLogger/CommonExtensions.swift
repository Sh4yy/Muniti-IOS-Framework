//
//  MunitiArrayExtention.swift
//  MunitiLogger
//
//  Created by Shayan on 5/14/17.
//  Copyright © 2017 Shayan. All rights reserved.
//

import UIKit
import Foundation

/// Floating Points
protocol FloatingPointType {
    
    /// casts the current value to double
    var doubleValue : Double { get }
    
    /// rounds to the closest integer towards up
    var ceil : Int { get }
    
    /// rounds to the closest integer towards down
    var floor : Int { get }
}

/// Integer FloatingPointType Extension
extension Int : FloatingPointType {
    var doubleValue : Double { return Double(self) }
    var ceil : Int { let x = doubleValue; return Int(x.rounded(.up)) }
    var floor : Int { let x = doubleValue; return Int(x.rounded(.down)) }
}

/// Double FloatingPointType Extension
extension Double : FloatingPointType {
    var doubleValue : Double { return self }
    var ceil : Int { let x = doubleValue; return Int(x.rounded(.up)) }
    var floor : Int { let x = doubleValue; return Int(x.rounded(.down)) }
}

/// Float FloatingPointType Extension
extension Float : FloatingPointType {
    var doubleValue : Double { return Double(self) }
    var ceil : Int { let x = doubleValue; return Int(x.rounded(.up)) }
    var floor : Int { let x = doubleValue; return Int(x.rounded(.down)) }
}

/// CGFloat FloatingPointType Extension
extension CGFloat : FloatingPointType {
    var doubleValue : Double { return Double(self) }
    var ceil : Int { let x = doubleValue; return Int(x.rounded(.up)) }
    var floor : Int { let x = doubleValue; return Int(x.rounded(.down)) }
}

/// Floating Point Infix Operator
func +(lhs : FloatingPointType, rhs: FloatingPointType) -> Double {
    return lhs + rhs
}

/// Floating Point Computed Average
extension Array where Element: FloatingPointType {
    
    /// returns an optional average value
    var computedAverage : Double? {
        guard !self.isEmpty else { return nil }
        return self.reduce(0, +) / count.doubleValue
    }
}

/// Invert Boolean Value
extension Bool {
    
    /// inverts the boolean value
    mutating func invert() {
        self = !self
    }
}

/// Custom Date Formatter Extensions
extension Formatter {
    
    /// converts date to year only -> 2017
    static let yearMedium : DateFormatter = {
        return Formatter.with(format : "yyyy")
    }()
    
    /// converts date to 3 digit month -> Mar
    static let monthMedium : DateFormatter = {
        return Formatter.with(format : "LLL")
    }()
    
    /// converts date to date of the day -> 15
    static let dayMedium : DateFormatter = {
        return Formatter.with(format: "d")
    }()
    
    /// converts date to 12x hour -> 11
    static let hour12 : DateFormatter = {
        return Formatter.with(format : "h")
    }()
    
    /// converts date to minutes only -> 5
    static let minute0x : DateFormatter = {
        return Formatter.with(format : "mm")
    }()
    
    /// converts date to am or pm
    static let amPm : DateFormatter = {
        return Formatter.with(format : "a")
    }()
    
    /// generates date formatter with date type -> "yyyy"
    static func with(format : String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter
    }
    
}

extension Date {
    
    /// returns the number of the year from date -> 2017
    var yearMedium : String { return Formatter.yearMedium.string(from: self) }
    
    /// returns the three digit name of the month -> Mar
    var monthMedium : String { return Formatter.monthMedium.string(from: self) }
    
    /// returns the day compontnet of the day -> 12
    var dayMedium : String { return Formatter.dayMedium.string(from: self) }
    
    /// returns the 12 hour component of the time -> 11
    var hour12 : String { return Formatter.hour12.string(from: self) }
    
    /// returns the minutes component of the date -> 54
    var minute0x : String { return Formatter.minute0x.string(from: self) }
    
    /// returns the am or pm component of the date -> am
    var amPm : String { return Formatter.amPm.string(from: self) }
    
    /// returns the time ago in string format
    /// * less than a minute -> 4s
    /// * less than a hour -> 34m
    /// * less than a day -> 22h
    /// * less than a week -> 6d
    /// * less than a year -> Mar 23
    /// * more than a year -> 23 Mar 2017
    var timeAgoInWords : String {
        let components = Calendar.current.dateComponents([.second,.minute,.hour,
                                                          .day,.month,.year],from: self, to: Date())
        
        if let year = components.year, year > 0 {
            return "\(dayMedium) \(monthMedium) \(yearMedium)"
        }
        
        if let month = components.month, month > 0 {
            return "\(monthMedium) \(dayMedium)"
        }
        
        if let day = components.day, day > 0 {
            if day > 7 {
                return "\(monthMedium) \(dayMedium)"
            } else {
                return "\(day)d"
            }
        }
        
        if let hour = components.hour, hour > 0 {
            return "\(hour)h"
        }
        
        if let minute = components.minute, minute > 0 {
            return "\(minute)m"
        }
        
        return "\(components.second ?? 0)s"
        
    }
}



