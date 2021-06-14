//
//  Readme.swift
//  FlowchartReader
//
//  Created by Reza Harris on 12/06/21.
//

import Foundation

class GuidanceStaticSeeder {

    static func getGuidance() -> [Guidance] {
        var guidanceList = [Guidance]()
        
        guidanceList.append(Guidance(pGuidanceID: 0, pTitle: "What is flowchart?", pDescription: "A flowchart is simply a graphical representation of steps. It shows steps in sequential order and is widely used in presenting the flow of algorithms, workflow or processes. Typically, a flowchart shows the steps as boxes of various kinds, and their order by connecting them with arrows."))
        guidanceList.append(Guidance(pGuidanceID: 1, pTitle: "What are the symbol in a flochart?", pDescription: "?"))
        guidanceList.append(Guidance(pGuidanceID: 2, pTitle: "How to read a flowchart?", pDescription: "??"))
        guidanceList.append(Guidance(pGuidanceID: 3, pTitle: "How to save my flowchart", pDescription: "???"))
        guidanceList.append(Guidance(pGuidanceID: 4, pTitle: "How to delete my saved flowchart?", pDescription: "?????"))
        
        return guidanceList
    }
}
