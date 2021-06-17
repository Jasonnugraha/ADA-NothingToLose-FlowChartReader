//
//  DetailFlowchartViewController.swift
//  FlowchartReader
//
//  Created by Reza Harris on 12/06/21.
//

import UIKit

class DetailFlowchartViewController: UIViewController {
    
    @IBOutlet var detailFlowchartView: DetailFlowchartView!
    
    @IBOutlet weak var upBtn: UIButton!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var downBtn: UIButton!
    
    var idFlowchart: UUID?
    
    let modelService = CDFlowchart()
    let service = FlowchartStructureService()
    
    var flowchart: CDFlowchartFile!
    var flowchartDetails = [FlowchartDetail]()
    
    var stepId: Int?
    var histories = [FlowchartDetail]()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let dataId = idFlowchart as? UUID {
            flowchart = modelService.getFlowchartFile(pFlowchartID: dataId)
            var rawValue = modelService.getAllFlowchartDetail(pFlowchartID: dataId)
            flowchartDetails = service.convertFlowchartDetails(flowchartDetails: rawValue)
            
            if let filePath = flowchart.filePath {
                detailFlowchartView.setImage(service.load(fileName: filePath)!)
            }
            
            stepId = 0
            service.initStepSound(flowStep: stepId!, flowchartDetails: flowchartDetails)
            accessibilityElInit()
            setupBtnAlpha()
        }
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

}
