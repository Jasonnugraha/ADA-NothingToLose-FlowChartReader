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
    
    lazy var utterance = AVSpeechUtterance(string: "")
    lazy var synthesizer = AVSpeechSynthesizer()
    
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
        utterance = AVSpeechUtterance(string: "\(flowchartDetails[flowStep].shape), \(flowchartDetails[flowStep].text)")
        utterance.rate = 0.55
        utterance.volume = 0.8
        
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
        
        if flowStep > -1 {
            
            let speech = flowchartDetails[stepId].shape != "Decision" ? "\(flowchartDetails[stepId].shape), \(flowchartDetails[stepId].text)" : "\(flowchartDetails[stepId].shape), \(flowchartDetails[stepId].text), \(Direction.Right.rawValue), \(Direction.Left.rawValue)"
            
            switch direction {
            case .Right:
                utterance = AVSpeechUtterance(string: " \(speech)")
            case .Left:
                utterance = AVSpeechUtterance(string: " \(speech)")
            case .Up:
                utterance = AVSpeechUtterance(string: " \(speech)")
            case .Down:
                utterance = AVSpeechUtterance(string: " \(speech)")
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
        
        utterance.rate = 0.5
        utterance.volume = 1

        if checkVoiceOverIsOn() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.7, execute: {
                self.synthesizer.speak(self.utterance)
            })
        } else {
            synthesizer.speak(utterance)
        }
    }
    
    
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func save(image: UIImage, fileName: String) -> String? {
        let fileName = "\(fileName)"
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = image.jpegData(compressionQuality: 1.0) {
           try? imageData.write(to: fileURL, options: .atomic)
           return fileName // ----> Save fileName
        }
        print("Error saving image")
        return nil
    }
    
    func load(fileName: String) -> UIImage? {
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    
    func checkVoiceOverIsOn() -> Bool {
        return UIAccessibility.isVoiceOverRunning
    }
    
    func convertFlowchartDetails(flowchartDetails: [CDFlowchartDetail]) -> [FlowchartDetail] {
        var allDetails = [FlowchartDetail]()
        for i in 0...flowchartDetails.count - 1 {
            let detail = FlowchartDetail(id: Int(flowchartDetails[i].id), shape: flowchartDetails[i].shape!, text: flowchartDetails[i].text!, down: Int(flowchartDetails[i].down), right: Int(flowchartDetails[i].right), left: Int(flowchartDetails[i].left))
            allDetails.append(detail)
        }
        
        return allDetails
    }
    
}
