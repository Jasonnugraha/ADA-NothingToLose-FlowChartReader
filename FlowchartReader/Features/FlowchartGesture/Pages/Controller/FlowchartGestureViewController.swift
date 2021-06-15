//
//  FlowchartGestureViewController.swift
//  FlowchartReader
//
//  Created by Reza Harris on 14/06/21.
//

import UIKit
import AVFoundation

enum SwipeGesture: String {
    case Right = "Swipe Right, Decision Yes"
    case Left = "Swipe Left, Decision No"
    case Up = "Swipe Up"
    case Down = "Swipe Down"
}

class FlowchartGestureViewController: UIViewController {
    @IBOutlet weak var actionListLabel: UILabel!
    
    var flowchartDetails = [
        FlowchartDetail(id: 0, shape: "Teriminator", text: "Start", down: 1, right: -1, left: -1),
        FlowchartDetail(id: 1, shape: "Process", text: "Open a Book", down: 2, right: -1, left: -1),
        FlowchartDetail(id: 2, shape: "Decision", text: "Favourite Book", down: -1, right: 4, left: 3),
        FlowchartDetail(id: 3, shape: "Process", text: "Close The Book", down: 5, right: -1, left: -1),
        FlowchartDetail(id: 4, shape: "Process", text: "Read The Book", down: 3, right: -1, left: -1),
        FlowchartDetail(id: 5, shape: "Teriminator", text: "End", down: -2, right: -1, left: -1),
    ]
    
    var histories = [FlowchartDetail]()
    
    var stepId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setActionAccesibilityGesture()
//        swipeBox.isAccessibilityElement = true
//        swipeBox.accessibilityTraits = .allowsDirectInteraction
        stepId = 0
        addGesture()
    }
    
    func setActionAccesibilityGesture() {
        let upAction = UIAccessibilityCustomAction(name: "Go Up",
                                                   target: self,
                                                   selector: #selector(upAction))
        
        let downAction = UIAccessibilityCustomAction(name: "Go Down",
                                                     target: self,
                                                     selector: #selector(downAction))
        
        
        let leftAction = UIAccessibilityCustomAction(name: "Go To The Left",
                                                     target: self,
                                                     selector: #selector(leftAction))
        
        let rightAction = UIAccessibilityCustomAction(name: "Go To The Right",
                                                      target: self,
                                                      selector: #selector(rightAction))
        
        actionListLabel.accessibilityCustomActions = [upAction, downAction, leftAction, rightAction]
    }
    
    @objc func upAction() -> Bool {
        //Code to be implemented for the appropriate action.
        print("1")
        return true
    }
    
    @objc func downAction() -> Bool {
        print("2")
        //Code to be implemented for the appropriate action.
        return true
    }
    
    @objc func leftAction() -> Bool {
        print("3")
        //Code to be implemented for the appropriate action.
        return true
    }
    
    @objc func rightAction() -> Bool {
        print("4")
        //Code to be implemented for the appropriate action.
        return true
    }
    
    func addGesture() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    @objc
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right:
//                commandSound(swipeGesture: SwipeGesture.Right)
                flowchartStep(swipeGesture: .Right)
                print("Right")
            case .left:
//                commandSound(swipeGesture: SwipeGesture.Left)
                flowchartStep(swipeGesture: .Left)
                print("Left")
            case .down:
                flowchartStep(swipeGesture: .Down)
                print("Down")
            case .up:
//                commandSound(swipeGesture: SwipeGesture.Up)
                flowchartStep(swipeGesture: .Up)
                print("Up")
            default:
                break
            }
        }
    }
    
    func commandSound(swipeGesture: SwipeGesture) {
        let utterance: AVSpeechUtterance!
        
        switch swipeGesture {
        case .Right:
            utterance = AVSpeechUtterance(string: "\(SwipeGesture.Right.rawValue)")
        case .Left:
            utterance = AVSpeechUtterance(string: "\(SwipeGesture.Left.rawValue)")
        case .Up:
            utterance = AVSpeechUtterance(string: "\(SwipeGesture.Up.rawValue)")
        case .Down:
            utterance = AVSpeechUtterance(string: "\(SwipeGesture.Down.rawValue)")
        default:
            break
        }
        
        utterance.rate = 0.55
        utterance.volume = 0.8

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    func flowchartStep(swipeGesture: SwipeGesture) {
        
        let currentFlowchartDetail = flowchartDetails[stepId!]
        
        var a = checkAvailableStep(currentFlow: currentFlowchartDetail, swipeGesture: swipeGesture)
        
        if swipeGesture == SwipeGesture.Up {
            if a < 0 {
                print("No")
                currentStepSound(swipeGesture: swipeGesture, flowStep: -1)
            } else {
                print("Yes")
                histories.removeLast()
                stepId = a
                currentStepSound(swipeGesture: swipeGesture, flowStep: a)
            }
        } else {
            if a > -1 {
                histories.append(flowchartDetails[stepId!])
                stepId = a
                currentStepSound(swipeGesture: swipeGesture, flowStep: a)
            } else {
                currentStepSound(swipeGesture: swipeGesture, flowStep: a)
            }
        }
    }
    
    func checkAvailableStep(currentFlow: FlowchartDetail, swipeGesture: SwipeGesture) -> Int {
        var nextStep: Int!
        
        if swipeGesture == SwipeGesture.Right {
            nextStep = currentFlow.right
        } else if swipeGesture == SwipeGesture.Left {
            nextStep = currentFlow.left
        } else if swipeGesture == SwipeGesture.Down {
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
    
    func currentStepSound(swipeGesture: SwipeGesture, flowStep: Int) {
        var utterance: AVSpeechUtterance!
        
        if flowStep > -1 {
            switch swipeGesture {
            case .Right:
                utterance = AVSpeechUtterance(string: "Swipe Right, \(flowchartDetails[stepId!].shape), \(flowchartDetails[stepId!].text)")
            case .Left:
                utterance = AVSpeechUtterance(string: "Swipe Left, \(flowchartDetails[stepId!].shape), \(flowchartDetails[stepId!].text)")
            case .Up:
                utterance = AVSpeechUtterance(string: "Swipe Up, \(flowchartDetails[stepId!].shape), \(flowchartDetails[stepId!].text)")
            case .Down:
                utterance = AVSpeechUtterance(string: "Swipe Down, \(flowchartDetails[stepId!].shape), \(flowchartDetails[stepId!].text)")
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
