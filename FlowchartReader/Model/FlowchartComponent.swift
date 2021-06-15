//
//  FlowchartComponent.swift
//  FlowchartReader
//
//  Created by Jessi Febria on 11/06/21.
//

import Foundation

class FlowchartComponent : Equatable {
    static func == (lhs: FlowchartComponent, rhs: FlowchartComponent) -> Bool {
        return lhs.shape == rhs.shape && lhs.minX == rhs.minX && lhs.minY == rhs.minY && lhs.maxX == rhs.maxX && lhs.maxY == rhs.maxY && lhs.noArrow == rhs.noArrow && lhs.arrowTo == rhs.arrowTo && lhs.fromIndex == rhs.fromIndex
    }
    
    let shape : String
    let minX : Float
    let minY : Float
    let maxX : Float
    let maxY : Float
    var noArrow : [String]
    var arrowTo : String
    var fromIndex : [Int]
    
    init(shape : String, minX : Float, minY : Float, maxX : Float, maxY : Float,noArrow : [String], arrowTo : String, fromIndex : [Int]) {
        self.shape = shape
        self.minX = minX
        self.minY = minY
        self.maxX = maxX
        self.maxY = maxY
        self.noArrow = noArrow
        self.arrowTo = arrowTo
        self.fromIndex = fromIndex
    }
}

struct FlowchartDetail {
    let id : Int
    let shape : String
    let text : String
    let down : Int
    let right : Int
    let left : Int
}




