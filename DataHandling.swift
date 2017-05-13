//
//  DataHandling.swift
//  MunitiLogger
//
//  Created by Derr McDuff on 17-05-13.
//  Copyright © 2017 Shayan. All rights reserved.
//

import Foundation
import UIKit

// For x,y data Sets
class DataSetXY {
    
    typealias Point = (x:Double,y:Double)
    
    var data: [Point]
    
    var size: Double {
        get {return Double(data.count)}
    }
    
    var average: Point {
        get {
            
            // Average of x
            let x = data.flatMap({$0.x})
            let xA = x.reduce(0,+)/Double(self.size)
            
            // Average of y
            let y = data.flatMap({$0.y})
            let yA = y.reduce(0,+)/Double(self.size)
            
            return (xA,yA)
            
        }
    }
    
    // Make inits using a type of data passing of our choice ([(x:Double,y:Double)]) or something like x:[Double] & y:[Double]
    init(_ d: [Point]) {
        self.data = d
    }
}

class DataProgression {
    
    var currentValue:Double
    var maxValue:Double
    var percentage:Double {get {return currentValue/maxValue}}
    
    init(currentValue: Double, maxValue: Double) {
        self.currentValue = currentValue
        self.maxValue = maxValue
    }
}

class Graph {
    
    typealias Scale = (delta:Double,jump:Double)
    
    var scales:(x:Scale,y:Scale)?
    
    var dataSet:DataSetXY
    
    init(dS: DataSetXY) {
        dataSet = dS
        self.setScales()
    }
    
    fileprivate func setScales() {
        self.scales = ((delta:2.0, jump:5.0),(delta:2.0, jump:5.0))
    }
    
}
