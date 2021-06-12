//
//  FlowchartComponent.swift
//  FlowchartReader
//
//  Created by Jessi Febria on 11/06/21.
//

import Foundation

struct FlowchartComponent : Hashable{
    let shape : String
    let minX : Float
    let minY : Float
    let maxX : Float
    let maxY : Float
}

struct FlowchartDetail {
    let id : Int
    let shape : String
    let text : String
    let down : Int
    let right : Int
    let left : Int
}
