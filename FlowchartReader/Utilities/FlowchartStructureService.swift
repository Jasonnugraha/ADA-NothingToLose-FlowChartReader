//
//  FlowchartStructure.swift
//  FlowchartReader
//
//  Created by Reza Harris on 16/06/21.
//

import UIKit
import AVFoundation

enum Direction: String {
    case Right = "Go To The Right, Decision Yes"
    case Left = "Go To The Left, Decision No"
    case Up = "Go Up"
    case Down = "Go Down"
}

class FlowchartStructureService {
    
    func increaseBtnOpacity(direction: Direction, btn: UIButton) {
        btn.alpha = 0.1
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = .clear
    }
    
    func decreaseBtnOpactity(direction: Direction, btn: UIButton) {
        btn.alpha = 0.8
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0, green: 0.4868601561, blue: 1, alpha: 0.434231761)
    }
    
    func setupBtnAlpha(btn: UIButton) {
        btn.alpha = 0.1
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = .clear
    }
    
    func accessibilityElInit(btn: UIButton, label: String) {
        btn.isAccessibilityElement = true
        btn.accessibilityLabel = label
    }
    
    func initStepSound(flowStep: Int, flowchartDetails: [FlowchartDetail]) {
        var utterance = AVSpeechUtterance(string: "\(flowchartDetails[flowStep].shape), \(flowchartDetails[flowStep].text)")
        utterance.rate = 0.55
        utterance.volume = 0.8

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    func checkAvailableStep(currentFlow: FlowchartDetail, direction: Direction, histories: [FlowchartDetail]) -> Int {
        var nextStep: Int!
        
        if direction == Direction.Right {
            nextStep = currentFlow.right
        } else if direction == Direction.Left {
            nextStep = currentFlow.left
        } else if direction == Direction.Down {
            nextStep = currentFlow.down
        } else {
            if histories.count == 0 {
                nextStep = -1
            } else {
                var lastIndex = histories.last
                nextStep = lastIndex?.id
            }
        }
        
        return nextStep
    }
    
    func currentStepSound(direction: Direction, flowchartDetails: [FlowchartDetail], flowStep: Int, stepId: Int) {
        var utterance: AVSpeechUtterance!
        
        if flowStep > -1 {
            
            let speech = flowchartDetails[stepId].shape != "Decision" ? "\(flowchartDetails[stepId].shape), \(flowchartDetails[stepId].text)" : "\(flowchartDetails[stepId].shape), \(flowchartDetails[stepId].text), \(Direction.Right.rawValue), \(Direction.Left.rawValue)"
            
            switch direction {
            case .Right:
                utterance = AVSpeechUtterance(string: "Right, \(speech)")
            case .Left:
                utterance = AVSpeechUtterance(string: "Left, \(speech)")
            case .Up:
                utterance = AVSpeechUtterance(string: "Up, \(speech)")
            case .Down:
                utterance = AVSpeechUtterance(string: "Down, \(speech)")
            default:
                break
            }
        } else {
            if flowStep == -1 {
                utterance = AVSpeechUtterance(string: "No Direction")
            } else if flowStep == -2 {
                utterance = AVSpeechUtterance(string: "End Process")
            }
        }
        
        utterance.rate = 0.55
        utterance.volume = 0.8

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
}
