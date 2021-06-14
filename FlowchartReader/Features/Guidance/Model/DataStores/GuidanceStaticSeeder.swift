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
        
        guidanceList.append(Guidance(pGuidanceID: 0, pTitle: "What is flowchart?", pDescription: "A flowchart is simply a graphical representation of steps. It shows steps in sequential order and is widely used in presenting the flow of algorithms, workflow or processes. \nTypically, a flowchart shows the steps as boxes of various kinds, and their order by connecting them with arrows."))
        guidanceList.append(Guidance(pGuidanceID: 1, pTitle: "What are the symbol in a flochart?",pDescription: "Flowcharts use special shapes to represent different types of actions or steps in a process. Lines and arrows show the sequence of the steps, and the relationships among them. These are known as flowchart symbols." +
            "\nCommon Flowchart Symbols: " +
            "\nRectangle Shape - Represents a process. " +
            "\nOval Shape - Represents the start or end. " +
            "\nDiamond Shape - Represents a decision. " +
            "\nParallelogram - Represents input/output. "
        ))
        guidanceList.append(Guidance(pGuidanceID: 2, pTitle: "How to read a flowchart?", pDescription: "Guidance: Read Flowchart"))
        guidanceList.append(Guidance(pGuidanceID: 3, pTitle: "How to save my flowchart", pDescription: "Guidance: Save my flowchart"))
        guidanceList.append(Guidance(pGuidanceID: 4, pTitle: "How to delete my saved flowchart?", pDescription: "Guidance: Delete my saved flowchart"))
        
        return guidanceList
    }
}
