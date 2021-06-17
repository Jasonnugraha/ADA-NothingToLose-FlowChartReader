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
        guidanceList.append(Guidance(pGuidanceID: 1, pTitle: "What are the symbol in a flowchart?",pDescription: "Flowcharts use special shapes to represent different types of actions or steps in a process. Lines and arrows show the sequence of the steps, and the relationships among them. These are known as flowchart symbols." +
                                        "\nCommon Flowchart Symbols: " +
                                        "\nTerminator Symbol - Represents the start or end. " +
                                        "\nProcess Symbol - Represents a process. " +
                                        "\nDecision Symbol - Represents a decision. " +
                                        "\nInput/Output Symbol - Represents an input/output. "
        ))
        guidanceList.append(Guidance(pGuidanceID: 2,
                                     pTitle: "How to capture a flowchart?",
                                     pDescription:
                                        "Guidance: Capture a Flowchart \n" +
                                        "\n 1. Press the scan flowchart button" +
                                        "\n 2. Hover the camera to the detected flowchart" +
                                        "\n 3. Follow the direction guide to make sure the image is detected" +
                                        "\n 4. Wait until the hold sound 3 times" +
                                        "\n 5. Your image will be processed"
        ))
        guidanceList.append(Guidance(pGuidanceID: 3,
                                     pTitle: "How to read flowchart",
                                     pDescription:
                                        "Guidance: Read my flowchart \n" +
                                        "\n 1. Your flowchart image will start from the beginning of the flowchart" +
                                        "\n 2. Press up to move to previous state" +
                                        "\n 3. Press down to move to next state" +
                                        "\n 4. Press left to give input no for decision" +
                                        "\n 5. Press right to give input yes for decision"
        ))
        guidanceList.append(Guidance(pGuidanceID: 4,
                                     pTitle: "How to save my flowchart",
                                     pDescription:
                                        "Guidance: Save my flowchart" +
                                        "\nAfter capturing the flowchart, press save button on top right corner of the apps, then input the file name"
        ))
        guidanceList.append(Guidance(pGuidanceID: 5,
                                     pTitle: "How to delete my saved flowchart?",
                                     pDescription:
                                        "Guidance: Delete my saved flowchart" +
                                        "\n Open The saved flowchart, swipe left of the selected flowchart and press delete"
        ))
        
        return guidanceList
    }
}
