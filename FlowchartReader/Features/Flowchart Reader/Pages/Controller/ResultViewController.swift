//
//  ResultViewController.swift
//  FlowchartReader
//
//  Created by Jessi Febria on 11/06/21.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var resultImageView: UIImageView!
    
    var flowchartComponents : [FlowchartComponent]?
    var lineComponents : [FlowchartComponent] = []
    var arrowComponents : [FlowchartComponent] = []
    var shapeComponents : [FlowchartComponent] = []
//    var shapeDictionary: [FlowchartComponent : Int] = [FlowchartComponent : Int]()
    
    var flowchartDetails : [FlowchartDetail] = []
    var tempShape : FlowchartComponent?
        
    var doneIndex : [Int] = []
    
    var resultImage : UIImage?
    let shape = ["terminator", "process", "inputoutput", "decision"]
    let arrow = ["arrow_up", "arrow_down", "arrowleft", "arrow_right"]
    let line = ["horizontal line", "vertical_line"]
    
    var generatedId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let resultImage = resultImage {
            print(resultImage)
            resultImageView.image = resultImage
        }
        
        guard let flowchartComponents = flowchartComponents else {
            return
        }
        
        lineComponents = flowchartComponents.filter({line.contains($0.shape)})
        shapeComponents = flowchartComponents.filter({shape.contains($0.shape)})
        arrowComponents = flowchartComponents.filter({arrow.contains($0.shape)})
        
        print("TOTAL SHAPE \(shapeComponents.count)")
       
        
        let sortedFlowchartComponents = sortByXandY(arrayFlowchartComponent: shapeComponents)
        
        for flowchart in flowchartComponents {
            print(flowchart)
        }
        
        for flowchart in sortedFlowchartComponents{
//            print(flowchart)
            print("\(flowchart.shape) - min x \(flowchart.minX) - min y \(flowchart.minY) - max X \(flowchart.maxX) - max Y \(flowchart.maxY) \n")
        }
        
        for i in 0..<sortedFlowchartComponents.count{
            traceFlowchartShape(component: sortedFlowchartComponents[i], id: i)
        }
        
        
        print(flowchartDetails)
    }
    
    func traceFlowchartShape(component : FlowchartComponent, id : Int){
        
        
        tempShape = component
        let closestComponents = closestNextComponentFromShape(component: component)
        
        print("trace flowchart")
        
        let componentName = component.shape
        
        let closestLine = closestComponents.filter({line.contains($0.shape)})
        let closestArrow = closestComponents.filter({arrow.contains($0.shape)})
        let closestShape = closestComponents.filter({shape.contains($0.shape)})

        
            if componentName == "decision" {
                
                var closestLineOrArrowOne : FlowchartComponent?
                var closestLineOrArrowTwo : FlowchartComponent?
                
                /// jika dia decision maka harus ketemu 2 line
                if closestLine.count < 2 {
                    if closestArrow.count < 2 {
                        print("Not enough line/ arrow detected for decision")
                    } else {
                        closestLineOrArrowOne = closestArrow[0]
                        closestLineOrArrowTwo = closestArrow[1]
                    }
                } else {
                    //DISINI HARUSNYA NANTI DIITUNG GIMANA KALO LINENYA BELOK BELOK
                    closestLineOrArrowOne = closestLine[0]
                    closestLineOrArrowTwo = closestLine[1]
                }
                
                ///ceritanya yang ONE itu yes, yang TWO itu no
                if let loa1 = closestLineOrArrowOne, let loa2 = closestLineOrArrowTwo, let fs1 = closestFlowchartShapeFromLineOrArrow(lineOrArrow: loa1), let fs2 = closestFlowchartShapeFromLineOrArrow(lineOrArrow: loa2){
                    
                    let right = shapeComponents.firstIndex(of: fs1)!
                    let left = shapeComponents.firstIndex(of: fs2)!
                    
                    
                    let flowchartDetail = FlowchartDetail(id: id, shape: componentName, text: "percobaan bunda", down: -1, right: right, left: left)
                    flowchartDetails.append(flowchartDetail)
                    
                    doneIndex.append(id)
                    
                } else {
                    print("Flowchart Shape after decision not detected")
                }
                
            } else {
                //            if componentName == "terminator" && text == "END" {}
                
                var closestLineOrArrow : FlowchartComponent?
                
                if closestLine.count == 0 {
                    if closestArrow.count > 0 {
                        closestLineOrArrow = closestArrow[0]
                        print("AAAAAAAAA")
                    } else {
                        print("No line or arrow nearby")
                    }
                } else {
                    /// kalo belok belok, pokonya smpe ketemu ada panah
                    var tempLineOrArrow = closestLine[0]
                    closestLineOrArrow = tempLineOrArrow
                    
                    for _ in 0...5{
                        if arrow.contains(tempLineOrArrow.shape){
                            closestLineOrArrow = tempLineOrArrow
                            print("the closest line or arrow is \(closestLineOrArrow)")
                            break
                        }
                        print("this is from iteration \(tempLineOrArrow.shape)")
                        if let temp = closestNextComponentFromLineOrArrow(component: tempLineOrArrow).first {
                            tempLineOrArrow = temp
                            print("tempLineOrArrow \(tempLineOrArrow)")
                        } else {
                            break
                        }
                    }
                }
                
                if let loa = closestLineOrArrow, let fs = closestFlowchartShapeFromLineOrArrow(lineOrArrow: loa){
                    
                    print("DOWN FLOWCHARTT ISSSS \(fs)")
                    let down = shapeComponents.firstIndex(of: fs)!
                    
                    let flowchartDetail = FlowchartDetail(id: id, shape: componentName, text: "percobaan bunda", down: down, right: -1, left: -1)
                    flowchartDetails.append(flowchartDetail)
                    
                } else {
                    if closestShape.count > 0 {
                        let down = shapeComponents.firstIndex(of: closestShape[0])!
                        
                        let flowchartDetail = FlowchartDetail(id: id, shape: componentName, text: "percobaan bunda", down: down, right: -1, left: -1)
                        flowchartDetails.append(flowchartDetail)
                    } else {
                        print("No solution found, sorry!")
                    }
                }
                
                
            }
        
        
        print(flowchartDetails)
    }
    
    func closestFlowchartShapeFromLineOrArrow(lineOrArrow : FlowchartComponent) -> FlowchartComponent?{
        print("from closestFlowchartShapeFromLineOrArrow")
        let closestComponents = closestNextComponentFromLineOrArrow(component: lineOrArrow)
        
        let closestFlowchartShape = closestComponents.filter({shape.contains($0.shape)})
        
        print(closestFlowchartShape)
        return closestFlowchartShape.first
    }
    
    
    func closestNextComponentFromShape(component : FlowchartComponent)-> [FlowchartComponent] {
        print("FROM closestNextComponentFromShape")
        print(component)
        
        let minX = component.minX
        let minY = component.minY
        let maxY = component.maxY
        let maxX = component.maxX
        
        let tempFlowchartComponents = flowchartComponents?.filter({$0 != tempShape})
        
        var tempComponent : [FlowchartComponent] = []
        ///from up
        let fromUp = tempFlowchartComponents!.filter({($0.minX > minX && $0.maxX < maxX && $0.maxY - 0.1 < minY && minY - $0.maxY <= 0.1) && ($0.shape == "arrow_up" || !(arrow.contains($0.shape)))}).sorted(by: {$0.maxY > $1.maxY})
        tempComponent.append(contentsOf: fromUp)
        print("fromUP \(fromUp)")
        
        ///from right
        let fromRight = tempFlowchartComponents!.filter({($0.maxY < maxY && $0.minY > minY && $0.minX + 0.1 > maxX && $0.minX - maxX <= 0.1) && ($0.shape == "arrow_right" || !(arrow.contains($0.shape)))}).sorted(by: {$0.minX < $1.minX})
        tempComponent.append(contentsOf: fromRight)
        print("fromRight \(fromRight)")
        
        ///from left
        let fromLeft = tempFlowchartComponents!.filter({($0.maxY < maxY && $0.minY > minY && $0.maxX - 0.1 < minX && minX - $0.maxX <= 0.1) && ($0.shape == "arrowleft" || !(arrow.contains($0.shape)))}).sorted(by: {$0.maxX > $1.maxX})
        tempComponent.append(contentsOf: fromLeft)
        print("fromLeft \(fromLeft)")
        
        ///from bottom
        let fromBottom = tempFlowchartComponents!.filter({(($0.minX > minX) && ($0.maxX < maxX) && ($0.minY + 0.1 > maxY) && ($0.minY - maxY <= 0.1)) && (($0.shape == "arrow_down") || (!(arrow.contains($0.shape))))}).sorted(by: {$0.minY < $1.minY})
        tempComponent.append(contentsOf: fromBottom)
        
        print("fromBottom \(fromBottom)")
        
        return sortByXandY(arrayFlowchartComponent: tempComponent)
    }
    
    func closestNextComponentFromLineOrArrow(component : FlowchartComponent)-> [FlowchartComponent] {
        print("FROM closestNextComponentFromLineOrArrow")
        print(component)
        
        let minX = component.minX
        let minY = component.minY
        let maxY = component.maxY
        let maxX = component.maxX
        
        let tempFlowchartComponents = flowchartComponents?.filter({$0 != tempShape})
        
        var tempComponent : [FlowchartComponent] = []
        ///from up
        let fromUp = tempFlowchartComponents!.filter({($0.minX - 0.1 < minX && $0.maxX + 0.1 > maxX && $0.maxY < minY && minY - $0.maxY <= 0.1) && ($0.shape == "arrow_up" || !(arrow.contains($0.shape)))}).sorted(by: {$0.maxY > $1.maxY})
        tempComponent.append(contentsOf: fromUp)
        print("fromUP \(fromUp)")
        
        ///from right
        let fromRight = tempFlowchartComponents!.filter({($0.maxY + 0.1 > maxY && $0.minY - 0.1 < minY && $0.minX > maxX && $0.minX - maxX <= 0.1) && ($0.shape == "arrow_right" || !(arrow.contains($0.shape)))}).sorted(by: {$0.minX < $1.minX})
        tempComponent.append(contentsOf: fromRight)
        print("fromRight \(fromRight)")
        
        ///from left
        let fromLeft = tempFlowchartComponents!.filter({($0.maxY + 0.1 > maxY && $0.minY - 0.1 < minY && $0.maxX < minX && minX - $0.maxX <= 0.1) && ($0.shape == "arrowleft" || !(arrow.contains($0.shape)))}).sorted(by: {$0.maxX > $1.maxX})
        tempComponent.append(contentsOf: fromLeft)
        print("fromUP \(fromLeft)")
        
        ///from bottom
        let fromBottom = tempFlowchartComponents!.filter({($0.minX - 0.1 < minX && $0.maxX + 0.1 > maxX && $0.minY > maxY && $0.minY - maxY <= 0.1) && ($0.shape == "arrow_down" || !(arrow.contains($0.shape)))}).sorted(by: {$0.minY < $1.minY})
        tempComponent.append(contentsOf: fromBottom)
        print("fromBottom \(fromUp)")
        
        
        return sortByXandY(arrayFlowchartComponent: tempComponent)
    }
    
    
    
    func sortByXandY(arrayFlowchartComponent : [FlowchartComponent]) -> [FlowchartComponent]{
        let sortedByX = arrayFlowchartComponent.sorted(by: {$0.minX < $1.minX})
        
        return sortedByX.sorted(by: {$0.minY < $1.minY})
    }
    
    
    
}

