//
//  FlowchartGestureViewController.swift
//  FlowchartReader
//
//  Created by Reza Harris on 14/06/21.
//

import UIKit
import AVFoundation

class FlowchartGestureViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var upBtn: UIButton!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var downBtn: UIButton!
    
    var flowchartDetails = [
        FlowchartDetail(id: 0, shape: "Teriminator", text: "Start", down: 1, right: -1, left: -1),
        FlowchartDetail(id: 1, shape: "Process", text: "Open a Book", down: 2, right: -1, left: -1),
        FlowchartDetail(id: 2, shape: "Decision", text: "Favourite Book", down: -1, right: 4, left: 3),
        FlowchartDetail(id: 3, shape: "Process", text: "Close The Book", down: 5, right: -1, left: -1),
        FlowchartDetail(id: 4, shape: "Process", text: "Read The Book", down: 3, right: -1, left: -1),
        FlowchartDetail(id: 5, shape: "Teriminator", text: "End", down: -2, right: -1, left: -1),
    ]
    
    var histories = [FlowchartDetail]()
    
    let service = FlowchartStructureService()
    
    var stepId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation With Button
        imageView.image = UIImage(named: "favbook")
        stepId = 0
        service.initStepSound(flowStep: stepId!, flowchartDetails: flowchartDetails)
        accessibilityElInit()
        setupBtnAlpha()
        
        // Navigation With VC & Swipe Gesture
//        addGesture()
    }
    
    func accessibilityElInit() {
        service.accessibilityElInit(btn: upBtn, label: "Up")
        service.accessibilityElInit(btn: downBtn, label: "Down")
        service.accessibilityElInit(btn: leftBtn, label: "Left")
        service.accessibilityElInit(btn: rightBtn, label: "Right")
    }
    
    func setupBtnAlpha() {
        service.setupBtnAlpha(btn: upBtn)
        service.setupBtnAlpha(btn: downBtn)
        service.setupBtnAlpha(btn: leftBtn)
        service.setupBtnAlpha(btn: rightBtn)
    }
    
    // Button Handler
    func respondToButtonTap(direction: Direction) {
        switch direction {
        case .Right:
            flowchartStep(direction: .Right)
        case .Left:
            flowchartStep(direction: .Left)
        case .Up:
            flowchartStep(direction: .Up)
        case .Down:
            flowchartStep(direction: .Down)
        default:
            break
        }
    }
    
    func flowchartStep(direction: Direction) {
        
        let currentFlowchartDetail = flowchartDetails[stepId!]
        
        var a = service.checkAvailableStep(currentFlow: currentFlowchartDetail, direction: direction, histories: histories)
        
        if direction == Direction.Up {
            if a < 0 {
                service.currentStepSound(direction: direction, flowchartDetails: flowchartDetails, flowStep: -1, stepId: stepId ?? 0)
            } else {
                histories.removeLast()
                stepId = a
                service.currentStepSound(direction: direction, flowchartDetails: flowchartDetails, flowStep: a, stepId: stepId ?? 0)
            }
        } else {
            if a > -1 {
                histories.append(flowchartDetails[stepId!])
                stepId = a
                service.currentStepSound(direction: direction, flowchartDetails: flowchartDetails, flowStep: a, stepId: stepId ?? 0)
            } else {
                service.currentStepSound(direction: direction, flowchartDetails: flowchartDetails, flowStep: a, stepId: stepId ?? 0)
            }
        }
    }
    
    @IBAction func upBtn(_ sender: Any) {
        service.increaseBtnOpacity(direction: .Up, btn: upBtn)
        respondToButtonTap(direction: .Up)
    }
    @IBAction func rightBtn(_ sender: Any) {
        service.increaseBtnOpacity(direction: .Right, btn: rightBtn)
        respondToButtonTap(direction: .Right)
    }
    @IBAction func leftBtn(_ sender: Any) {
        service.increaseBtnOpacity(direction: .Left, btn: leftBtn)
        respondToButtonTap(direction: .Left)
    }
    @IBAction func downBtn(_ sender: Any) {
        service.increaseBtnOpacity(direction: .Down, btn: downBtn)
        respondToButtonTap(direction: .Down)
    }
    
    
    @IBAction func upBtnTouchDown(_ sender: Any) {
        service.decreaseBtnOpactity(direction: .Up, btn: upBtn)
    }
    @IBAction func rightBtnTouchDown(_ sender: Any) {
        service.decreaseBtnOpactity(direction: .Right, btn: rightBtn)
    }
    @IBAction func leftBtnTouchDown(_ sender: Any) {
        service.decreaseBtnOpactity(direction: .Left, btn: leftBtn)
    }
    @IBAction func downBtnTouchDown(_ sender: Any) {
        service.decreaseBtnOpactity(direction: .Down, btn: downBtn)
    }
    
    
    func increaseBtnOpacity(direction: Direction) {
        switch direction {
        case .Up:
            upBtn.alpha = 0.1
            upBtn.setTitleColor(UIColor.white, for: .normal)
            upBtn.backgroundColor = .clear
        case .Down:
            downBtn.alpha = 0.1
            downBtn.setTitleColor(UIColor.white, for: .normal)
            downBtn.backgroundColor = .clear
        case .Right:
            rightBtn.alpha = 0.1
            rightBtn.setTitleColor(UIColor.white, for: .normal)
            rightBtn.backgroundColor = .clear
        case .Left:
            leftBtn.alpha = 0.1
            leftBtn.setTitleColor(UIColor.white, for: .normal)
            leftBtn.backgroundColor = .clear
        default:
            break
        }
    }
    @IBAction func saveOnTap(_ sender: Any) {
        let alert = UIAlertController(title: "Save Flowchart", message: "Enter your flowchart name", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Some Text Here"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0].text
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

//
//func addGesture() {
//    let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
//    swipeRight.direction = .right
//    self.view.addGestureRecognizer(swipeRight)
//
//    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
//    swipeLeft.direction = .left
//    self.view.addGestureRecognizer(swipeLeft)
//
//    let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
//    swipeUp.direction = .up
//    self.view.addGestureRecognizer(swipeUp)
//
//    let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
//    swipeDown.direction = .down
//    self.view.addGestureRecognizer(swipeDown)
//}
//
//@objc
//func respondToSwipeGesture(gesture: UIGestureRecognizer) {
//    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
//        switch swipeGesture.direction {
//        case .right:
//            flowchartStep(direction: .Right)
//        case .left:
//            flowchartStep(direction: .Left)
//        case .down:
//            flowchartStep(direction: .Down)
//        case .up:
//            flowchartStep(direction: .Up)
//        default:
//            break
//        }
//    }
//}
