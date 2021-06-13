//
//  ResultViewController.swift
//  FlowchartReader
//
//  Created by Jessi Febria on 11/06/21.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var resultImageView: UIImageView!
    var resultImage : UIImage?
    
    var flowchartComponents : [FlowchartComponent]?
    
    var lineComponents : [FlowchartComponent] = []
    var arrowComponents : [FlowchartComponent] = []
    var shapeComponents : [FlowchartComponent] = []
    
    var sortedFlowchartComponents : [FlowchartComponent]?
    //    var shapeDictionary: [FlowchartComponent : Int] = [FlowchartComponent : Int]()
    
    var flowchartDetails : [FlowchartDetail] = []
    var tempShape : FlowchartComponent?
    
    var doneIndex : [Int] = []
    
    let shape = ["terminator", "process", "inputoutput", "decision"]
    let arrow = ["arrow_up", "arrow_down", "arrowleft", "arrow_right"]
    let line = ["horizontal line", "vertical_line"]
    
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
        
        sortedFlowchartComponents = sortByXandY(arrayFlowchartComponent: shapeComponents)
        
        guard let sortedFlowchartComponents = sortedFlowchartComponents else {
            return
        }
        
        printFlowchartComponents(flowcharts: flowchartComponents)
        
        print("\n SHAPE IN THIS FLOWCHART : ")
        printFlowchartComponents(flowcharts: sortedFlowchartComponents)
        
        //traceFlowchartShape(component: sortedFlowchartComponents[0], id: 0)
        
        for i in 0..<sortedFlowchartComponents.count{
            print("\n\n")
            traceFlowchartShape(component: sortedFlowchartComponents[i], id: i)
        }
        
        
        print(flowchartDetails)
    }
    func traceFlowchartShape(component : FlowchartComponent, id : Int){
        
        
        tempShape = component
        let closestComponents = closestNextComponentFromShape(component: component)
        
        print("trace flowchart")
        
        let componentName = component.shape
        
        let closestShape = closestComponents.filter({shape.contains($0.shape)})
        let closestLineOrArrowFromComponent = closestComponents.filter({!(shape.contains($0.shape))})
        
        
        if componentName == "decision" {
            
            var closestLineOrArrowOne : FlowchartComponent?
            var closestLineOrArrowTwo : FlowchartComponent?
            
            /// jika dia decision maka harus ketemu 2 line
            if closestLineOrArrowFromComponent.count < 2 {
                print("Not enough line/ arrow detected for decision")
            } else {
                /// kalo belok belok, pokonya smpe ketemu ada panah
                closestLineOrArrowOne = closestLineOrArrowFromComponent[0]
                closestLineOrArrowTwo = closestLineOrArrowFromComponent[1]
                
                if closestLineOrArrowOne?.arrowTo == closestLineOrArrowTwo?.arrowTo {
                    print("Detection false, same line detected for 2 decision answer")
                } else {
                    for _ in 0...5{
                        if (arrow.contains(closestLineOrArrowOne!.shape)){
                            print("the closest line or arrow ONE is : ")
                            printFlowchart(flowchart: closestLineOrArrowOne!)
                            break
                        }
                        
                        print("this is from iteration arrow ONE \(closestLineOrArrowOne!.shape) ")
                        
                        if let temp = closestNextComponentFromLineOrArrow(component: closestLineOrArrowOne!).filter({!(shape.contains($0.shape))}).first {
                            closestLineOrArrowOne = temp
                            print("tempLineOrArrowOne : ")
                            printFlowchart(flowchart: closestLineOrArrowOne!)
                        } else {
                            break
                        }
                    }
                    
                    for _ in 0...5{
                        if (arrow.contains(closestLineOrArrowTwo!.shape)){
                            print("the closest line or arrow TWO is : ")
                            printFlowchart(flowchart: closestLineOrArrowTwo!)
                            break
                        }
                        
                        print("this is from iteration arrow TWO \(closestLineOrArrowTwo!.shape)")
                        
                        if let temp = closestNextComponentFromLineOrArrow(component: closestLineOrArrowTwo!).filter({!(shape.contains($0.shape))}).first {
                            closestLineOrArrowTwo = temp
                            print("tempLineOrArrowTwo : ")
                            printFlowchart(flowchart: closestLineOrArrowTwo!)
                        } else {
                            break
                        }
                    }
                }
            }
            
            ///ceritanya yang ONE itu yes, yang TWO itu no
            if let loa1 = closestLineOrArrowOne, let loa2 = closestLineOrArrowTwo, let fs1 = closestFlowchartShapeFromLineOrArrow(lineOrArrow: loa1), let fs2 = closestFlowchartShapeFromLineOrArrow(lineOrArrow: loa2){
                
                let right = sortedFlowchartComponents!.firstIndex(of: fs1)!
                let left = sortedFlowchartComponents!.firstIndex(of: fs2)!
                
                fs1.noArrow.append(noArrowConfiguration(arrowTo: loa1.arrowTo))
                fs2.noArrow.append(noArrowConfiguration(arrowTo: loa2.arrowTo))
                
                let flowchartDetail = FlowchartDetail(id: id, shape: componentName, text: "percobaan bunda", down: -1, right: right, left: left)
                flowchartDetails.append(flowchartDetail)
                
                doneIndex.append(id)
                
            } else {
                let flowchartDetail = FlowchartDetail(id: id, shape: componentName, text: "percobaan bunda", down: -1, right: -2, left: -2)
                flowchartDetails.append(flowchartDetail)
                print("Flowchart Shape after decision not detected")
            }
            
        } else {
            //            if componentName == "terminator" && text == "END" {}
            
            var closestLineOrArrow : FlowchartComponent?
            
            if closestLineOrArrowFromComponent.count == 0 {
                print("No line or arrow nearby")
            } else {
                /// kalo belok belok, pokonya smpe ketemu ada panah
                closestLineOrArrow = closestLineOrArrowFromComponent[0]
                
                for _ in 0...5{
                    if arrow.contains(closestLineOrArrow!.shape){
                        print("the closest line or arrow is : ")
                        printFlowchart(flowchart: closestLineOrArrow!)
                        break
                    }
                    
                    print("this is from iteration \(closestLineOrArrow!.shape)")
                    
                    if let temp = closestNextComponentFromLineOrArrow(component: closestLineOrArrow!).filter({!(shape.contains($0.shape))}).first {
                        closestLineOrArrow = temp
                        print("tempLineOrArrow : ")
                        printFlowchart(flowchart: closestLineOrArrow!)
                    } else {
                        break
                    }
                }
            }
            
            if let loa = closestLineOrArrow, let fs = closestFlowchartShapeFromLineOrArrow(lineOrArrow: loa){
                
                print("DOWN FLOWCHARTT ISSSS :")
                printFlowchart(flowchart: fs)
                let down = sortedFlowchartComponents!.firstIndex(of: fs)!
                
                fs.noArrow.append(noArrowConfiguration(arrowTo: loa.arrowTo))
                
                let flowchartDetail = FlowchartDetail(id: id, shape: componentName, text: "percobaan bunda", down: down, right: -1, left: -1)
                flowchartDetails.append(flowchartDetail)
                
            } else {
                if closestShape.count > 0 {
                    let down = sortedFlowchartComponents!.firstIndex(of: closestShape[0])!
                    
                    closestShape[0].noArrow.append(noArrowConfiguration(arrowTo: closestShape[0].arrowTo))
                    
                    let flowchartDetail = FlowchartDetail(id: id, shape: componentName, text: "percobaan bunda", down: down, right: -1, left: -1)
                    flowchartDetails.append(flowchartDetail)
                } else {
                    let flowchartDetail = FlowchartDetail(id: id, shape: componentName, text: "percobaan bunda", down: -2, right: -1, left: -1)
                    flowchartDetails.append(flowchartDetail)
                    
                    print("No next solution found, sorry!")
                }
            }
            
            
        }
        
        
        print(flowchartDetails)
    }
    
    func noArrowConfiguration(arrowTo : String) -> String{
        if arrowTo == "Up" {
            return "Bottom"
        } else if arrowTo == "Bottom"{
            return "Up"
        } else if arrowTo == "Left"{
            return "Right"
        } else {
            return "Left"
        }
    }
    
    func closestFlowchartShapeFromLineOrArrow(lineOrArrow : FlowchartComponent) -> FlowchartComponent?{
        print("\nfrom closestFlowchartShapeFromLineOrArrow")
        let closestComponents = closestNextComponentFromLineOrArrow(component: lineOrArrow)
        
        let closestFlowchartShape = closestComponents.filter({shape.contains($0.shape)})
        
        printFlowchartComponents(flowcharts: closestFlowchartShape)
        return closestFlowchartShape.first
    }
    
    
    func closestNextComponentFromShape(component : FlowchartComponent)-> [FlowchartComponent] {
        print("\nFROM closestNextComponentFromShape")
        printFlowchart(flowchart: component)
        
        let minX = component.minX
        let minY = component.minY
        let maxY = component.maxY
        let maxX = component.maxX
        
        let tempFlowchartComponents = flowchartComponents?.filter({$0 != tempShape})
        
        var tempComponent : [FlowchartComponent] = []
        var tempDistance : [Float] = []
        ///from up
        if !(component.noArrow.contains("Up")){
            let fromUp = tempFlowchartComponents!.filter({($0.minX > minX && $0.maxX < maxX && $0.maxY - 0.1 < minY && minY - $0.maxY <= 0.1) && ($0.shape == "arrow_up" || !(arrow.contains($0.shape)))}).sorted(by: {$0.maxY > $1.maxY})
            tempComponent.append(contentsOf: fromUp)
            for obj in fromUp{
                tempDistance.append(minY - obj.maxY)
                obj.arrowTo = "Up"
            }
            print("fromUP : ")
            printFlowchartComponents(flowcharts: fromUp)
        }
        
        ///from right
        if !(component.noArrow.contains("Right")){
            let fromRight = tempFlowchartComponents!.filter({($0.maxY < maxY && $0.minY > minY && $0.minX + 0.1 > maxX && $0.minX - maxX <= 0.1) && ($0.shape == "arrow_right" || !(arrow.contains($0.shape)))}).sorted(by: {$0.minX < $1.minX})
            tempComponent.append(contentsOf: fromRight)
            for obj in fromRight{
                tempDistance.append(obj.minX - maxX)
                obj.arrowTo = "Right"
            }
            print("fromRight :")
            printFlowchartComponents(flowcharts: fromRight)
        }
        ///from left
        if !(component.noArrow.contains("Left")){
            let fromLeft = tempFlowchartComponents!.filter({($0.maxY < maxY && $0.minY > minY && $0.maxX - 0.1 < minX && minX - $0.maxX <= 0.1) && ($0.shape == "arrowleft" || !(arrow.contains($0.shape)))}).sorted(by: {$0.maxX > $1.maxX})
            tempComponent.append(contentsOf: fromLeft)
            for obj in fromLeft{
                tempDistance.append(minX - obj.maxX)
                obj.arrowTo = "Left"
            }
            print("fromLeft :")
            printFlowchartComponents(flowcharts: fromLeft)
        }
        ///from bottom
        if !(component.noArrow.contains("Bottom")){
            let fromBottom = tempFlowchartComponents!.filter({(($0.minX > minX) && ($0.maxX < maxX) && ($0.minY + 0.1 > maxY) && ($0.minY - maxY <= 0.1)) && (($0.shape == "arrow_down") || (!(arrow.contains($0.shape))))}).sorted(by: {$0.minY < $1.minY})
            tempComponent.append(contentsOf: fromBottom)
            for obj in fromBottom{
                tempDistance.append(obj.minY - maxY)
                obj.arrowTo = "Bottom"
            }
            print("fromBottom : ")
            printFlowchartComponents(flowcharts: fromBottom)
        }
        return sortByDistance(arrayFC: tempComponent, distance: tempDistance)
    }
    
    func closestNextComponentFromLineOrArrow(component : FlowchartComponent)-> [FlowchartComponent] {
        print("\nFROM closestNextComponentFromLineOrArrow")
        printFlowchart(flowchart: component)
        
        let minX = component.minX
        let minY = component.minY
        let maxY = component.maxY
        let maxX = component.maxX
        
        var tempFlowchartComponents = flowchartComponents?.filter({$0 != tempShape})
        
        var tempComponent : [FlowchartComponent] = []
        var tempDistance : [Float] = []
        
        ///from up
        if !(component.noArrow.contains("Up")){
            let fromUp = tempFlowchartComponents!.filter({($0.minX - 0.1 < minX && $0.maxX + 0.1 > maxX && $0.maxY - 0.1 < minY && minY - $0.maxY <= 0.1) && ($0.shape == "arrow_up" || !(arrow.contains($0.shape)))}).sorted(by: {$0.maxY > $1.maxY})
            tempComponent.append(contentsOf: fromUp)
            print("fromUp :")
            printFlowchartComponents(flowcharts: fromUp)
            for obj in fromUp{
                tempDistance.append(minY - obj.maxY)
                obj.arrowTo = "Up"
            }
        }
        ///from right
        if !(component.noArrow.contains("Right")){
            let fromRight = tempFlowchartComponents!.filter({($0.maxY + 0.1 > maxY && $0.minY - 0.1 < minY && $0.minX + 0.1 > maxX && $0.minX - maxX <= 0.1) && ($0.shape == "arrow_right" || !(arrow.contains($0.shape)))}).sorted(by: {$0.minX < $1.minX})
            tempComponent.append(contentsOf: fromRight)
            print("fromRight :")
            printFlowchartComponents(flowcharts: fromRight)
            for obj in fromRight{
                tempDistance.append(obj.minX - maxX)
                obj.arrowTo = "Right"
            }
        }
        ///from left
        if !(component.noArrow.contains("Left")){
            let fromLeft = tempFlowchartComponents!.filter({($0.maxY + 0.1 > maxY && $0.minY - 0.1 < minY && $0.maxX - 0.1 < minX && minX - $0.maxX <= 0.1) && ($0.shape == "arrowleft" || !(arrow.contains($0.shape)))}).sorted(by: {$0.maxX > $1.maxX})
            tempComponent.append(contentsOf: fromLeft)
            print("fromLeft :")
            printFlowchartComponents(flowcharts: fromLeft)
            for obj in fromLeft{
                tempDistance.append(minX - obj.maxX)
                obj.arrowTo = "Left"
            }
        }
        ///from bottom
        if !(component.noArrow.contains("Bottom")){
            let fromBottom = tempFlowchartComponents!.filter({($0.minX - 0.1 < minX && $0.maxX + 0.1 > maxX && $0.minY + 0.1 > maxY && $0.minY - maxY <= 0.1) && ($0.shape == "arrow_down" || !(arrow.contains($0.shape)))}).sorted(by: {$0.minY < $1.minY})
            tempComponent.append(contentsOf: fromBottom)
            print("fromBottom :")
            printFlowchartComponents(flowcharts: fromBottom)
            for obj in fromBottom{
                tempDistance.append(obj.minY - maxY)
                obj.arrowTo = "Bottom"
            }
        }
        return sortByDistance(arrayFC: tempComponent, distance: tempDistance)
    }
    
    
    
    func sortByXandY(arrayFlowchartComponent : [FlowchartComponent]) -> [FlowchartComponent]{
        let sortedByX = arrayFlowchartComponent.sorted(by: {$0.minX < $1.minX})
        
        return sortedByX.sorted(by: {$0.minY < $1.minY})
    }
    
    func sortByDistance(arrayFC : [FlowchartComponent], distance : [Float]) -> [FlowchartComponent]{
        
        
        var tempFC : [FlowchartComponent] = []
        
        let sorted = distance.enumerated().sorted(by: {$0.element < $1.element})
        let justIndices = sorted.map{$0.offset}
        
        for i in justIndices{
            tempFC.append(arrayFC[i])
        }
        
        print("AFTER SORTED :")
        printFlowchartComponents(flowcharts: tempFC)
        return tempFC
    }
    
    func printFlowchart(flowchart: FlowchartComponent) {
        print("\(flowchart.shape) - min x \(flowchart.minX) - min y \(flowchart.minY) - max X \(flowchart.maxX) - max Y \(flowchart.maxY) -  no arrow \(flowchart.noArrow) - arrow to \(flowchart.arrowTo)")
    }
    
    func printFlowchartComponents(flowcharts: [FlowchartComponent]){
        for fc in flowcharts{
            printFlowchart(flowchart: fc)
        }
    }
}
