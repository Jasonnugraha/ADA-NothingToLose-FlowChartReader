//
//  Guidance.swift
//  FlowchartReader
//
//  Created by Kristian Lukito on 13/06/21.
//

import Foundation

class Guidance{
    var guidanceID: Int
    var title: String
    var description: String

    init(pGuidanceID: Int, pTitle: String, pDescription: String) {
        self.guidanceID = pGuidanceID
        self.title = pTitle
        self.description = pDescription
    }
}
