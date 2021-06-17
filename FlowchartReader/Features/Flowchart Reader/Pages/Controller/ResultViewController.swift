//
//  ResultViewController.swift
//  FlowchartReader
//
//  Created by Jessi Febria on 11/06/21.
//

// BUAT DELETION KALO ADA YANG DUPLIKAT DUPLIKAT


import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var resultImageView: UIImageView!
    var resultImage : UIImage?
    
    var detectionOverlay : CALayer! = nil
    
    var flowchartComponents : [FlowchartComponent]?
    var textComponents: [TextComponent]?
    
    var lineComponents : [FlowchartComponent] = []
    var arrowComponents : [FlowchartComponent] = []
    var shapeComponents : [FlowchartComponent] = []
    
    var sortedFlowchartComponents : [FlowchartComponent]?
    
    var flowchartDetails : [FlowchartDetail] = []
    
    var tempShape : FlowchartComponent?
    var prevShape: FlowchartComponent?
    
    var constantLOAX : Float = 0.0
    var constantLOAY : Float = 0.0
    var constantTextX : Float = 0.0
    var constantTextY : Float = 0.0
    
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
        
        let minX = flowchartComponents.min(by: {$0.minX < $1.minX})?.minX
        let minY = flowchartComponents.min(by: {$0.minY < $1.minY})?.minY
        let maxX = flowchartComponents.max(by: {$0.maxX < $1.maxX})?.maxX
        let maxY = flowchartComponents.max(by: {$0.maxY < $1.maxY})?.maxY
        
        let intervalX = (Float(maxX!) - Float(minX!)) / 15.0
        let intervalY = (Float(maxY!) - Float(minY!)) / 10.0
        
        constantLOAX = intervalX
        constantLOAY = intervalY
        constantTextX = constantLOAX / 5.0
        constantTextY = constantLOAY / 5.0
        
        print("\nCONSTANT LOAx \(constantLOAX) CONSTANT LOA y \(constantLOAY) constant text x \(constantTextX) constant text y \(constantTextY)")
        print("\nSMALLES OBJECT -> min x - \(minX) min y - \(minY) max X - \(maxX) max Y - \(maxY) ")
        
        printFlowchartComponents(flowcharts: flowchartComponents)
        
        print("\n SHAPE IN THIS FLOWCHART : ")
        printFlowchartComponents(flowcharts: sortedFlowchartComponents)
        
        print(textComponents)
        
        sortedFlowchartComponents[0].noArrow.append("Up")
        
        for i in 0..<sortedFlowchartComponents.count{
            print("\n\n")
            let flowchart = sortedFlowchartComponents[i]
//            let layer = createRoundedRectLayerWithBounds(CGRect(x: CGFloat(flowchart.minX), y: CGFloat(flowchart.minY), width: CGFloat(flowchart.maxX - flowchart.minX), height: CGFloat(flowchart.maxY - flowchart.minY)))
//
//            self.view.layer.addSublayer(layer)
            traceFlowchartShape(component: flowchart, id: i)
        }
        
    }
    
//    func setupLayers() {
//        detectionOverlay = CALayer()
//        detectionOverlay.name = "DetectionOverlay"
//        detectionOverlay.bounds = CGRect(x: 0,
//                                         y: 0,
//                                         width: 1920,
//                                         height: 1080)
//        self.view.layer
//    }
//
    
    func createRoundedRectLayerWithBounds(_ bounds: CGRect) -> CALayer {
        print("ADD LAYERRRR")
        
        let shapeLayer = CALayer()
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)

        shapeLayer.borderWidth = 50
        shapeLayer.borderColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.2, 1.0, 0.5, 0.8])
        shapeLayer.cornerRadius = 7
        return shapeLayer
    }
    
    func traceFlowchartShape(component : FlowchartComponent, id : Int){
        
        tempShape = component
        
        let closestComponents = closestNextComponentFromShape(component: component)
        
        print("trace flowchart")
        
        let componentName = component.shape
        
        let closestShape = closestComponents.filter({shape.contains($0.shape)})
        var closestLineOrArrowFromComponent = closestComponents.filter({!(shape.contains($0.shape))})
        
        if componentName == "decision" {
            
            var closestLineOrArrowOne : FlowchartComponent?
            var closestLineOrArrowTwo : FlowchartComponent?
            
            prevShape = nil
            
            /// dari 1 arah hanya boleh ada 1 aja, yang paling deket yauw
            var indexMustOut : [Int] = []
            var flag : [String : Int] = ["Up" : 0, "Bottom" : 0, "Right" : 0, "Left" :0]
            
            for i in 0..<closestLineOrArrowFromComponent.count{
                if flag[closestLineOrArrowFromComponent[i].arrowTo] == 0 {
                    flag[closestLineOrArrowFromComponent[i].arrowTo] = 1
                } else {
                    indexMustOut.append(i)
                }
            }
            
            indexMustOut = indexMustOut.sorted(by: {$0 > $1})
            
            for index in indexMustOut {
                closestLineOrArrowFromComponent.remove(at: index)
            }
            
            /// jika dia decision maka harus ketemu 2 line
            if closestLineOrArrowFromComponent.count < 2 {
                print("Not enough line/ arrow detected for decision")
            } else {
                
                /// tentuin mana yang line yes, mana yang line no
                (closestLineOrArrowOne, closestLineOrArrowTwo) = checkYesOrNoFromTwoComponent(component1:closestLineOrArrowFromComponent[0] , component2: closestLineOrArrowFromComponent[1])
                
                /// kalo belok belok, pokonya smpe ketemu ada panah, dibatesin brp kalinya
                print("FIRST LINE - THE YES ONE")
                closestLineOrArrowOne = loopUntilArrowFound(component: closestLineOrArrowOne!)
                
                print("SECOND LINE - THE NO ONE")
                closestLineOrArrowTwo = loopUntilArrowFound(component: closestLineOrArrowTwo!)
               
            }
            
            /// ONE itu yes, yang TWO itu no
            if let loa1 = closestLineOrArrowOne, let loa2 = closestLineOrArrowTwo, let fs1 = closestFlowchartShapeFromLineOrArrow(lineOrArrow: loa1), let fs2 = closestFlowchartShapeFromLineOrArrow(lineOrArrow: loa2){
                
                let right = sortedFlowchartComponents!.firstIndex(of: fs1)!
                let left = sortedFlowchartComponents!.firstIndex(of: fs2)!
                
                fs1.noArrow.append(noArrowConfiguration(arrowTo: loa1.arrowTo))
                fs2.noArrow.append(noArrowConfiguration(arrowTo: loa2.arrowTo))
                
                fs1.fromIndex.append(id)
                fs2.fromIndex.append(id)
                
                let flowchartDetail = FlowchartDetail(id: id, shape: componentName, text: detectTextInShape(component: component), down: -1, right: right, left: left)
                flowchartDetails.append(flowchartDetail)
                
            } else {
                ///kalo gagal, cek apakah ada shape terdekatkah?
                
                if ((closestShape.count >= 2) && (closestShape[0].arrowTo != closestShape[1].arrowTo)) {
                    
                    var fs1 = closestShape[0]
                    var fs2 = closestShape[1]
                    
                    (fs1, fs2 ) = checkYesOrNoFromTwoComponent(component1: fs1, component2: fs2)
                    
                    let right = sortedFlowchartComponents!.firstIndex(of: fs1)!
                    let left = sortedFlowchartComponents!.firstIndex(of: fs2)!
                    
                    fs1.noArrow.append(noArrowConfiguration(arrowTo: component.arrowTo))
                    fs2.noArrow.append(noArrowConfiguration(arrowTo: component.arrowTo))
                    
                    fs1.fromIndex.append(id)
                    fs2.fromIndex.append(id)
                    
                    let flowchartDetail = FlowchartDetail(id: id, shape: componentName, text: detectTextInShape(component: component), down: -1, right: right, left: left)
                    flowchartDetails.append(flowchartDetail)
                    
                } else {
                    
                    let flowchartDetail = FlowchartDetail(id: id, shape: componentName, text: detectTextInShape(component: component), down: -1, right: -2, left: -2)
                    flowchartDetails.append(flowchartDetail)
                    print("Flowchart Shape after decision not detected")
                    
                }
            }
            
        } else {
            
            var closestLineOrArrow : FlowchartComponent?
            
            if component.fromIndex.count > 0 {
                prevShape = sortedFlowchartComponents![component.fromIndex[component.fromIndex.count - 1]]
            }
            
            if closestLineOrArrowFromComponent.count == 0 {
                print("No line or arrow nearby")
            } else {
                /// kalo belok belok, pokonya smpe ketemu ada panah
                closestLineOrArrow = closestLineOrArrowFromComponent[0]
                
                closestLineOrArrow = loopUntilArrowFound(component: closestLineOrArrow!)
            }
            
            if let loa = closestLineOrArrow, let fs = closestFlowchartShapeFromLineOrArrow(lineOrArrow: loa){
                
                print("DOWN FLOWCHARTT ISSSS :")
                printFlowchart(flowchart: fs)
                let down = sortedFlowchartComponents!.firstIndex(of: fs)!
                
                fs.noArrow.append(noArrowConfiguration(arrowTo: loa.arrowTo))
                fs.fromIndex.append(id)
                
                let flowchartDetail = FlowchartDetail(id: id, shape: componentName, text: detectTextInShape(component: component), down: down, right: -1, left: -1)
                flowchartDetails.append(flowchartDetail)
                
            } else {
                if closestShape.count > 0 {
                    let down = sortedFlowchartComponents!.firstIndex(of: closestShape[0])!
                    
                    closestShape[0].noArrow.append(noArrowConfiguration(arrowTo: closestShape[0].arrowTo))
                    closestShape[0].fromIndex.append(id)
                    
                    let flowchartDetail = FlowchartDetail(id: id, shape: componentName, text: detectTextInShape(component: component), down: down, right: -1, left: -1)
                    flowchartDetails.append(flowchartDetail)
                } else {
                    let flowchartDetail = FlowchartDetail(id: id, shape: componentName, text: detectTextInShape(component: component), down: -2, right: -1, left: -1)
                    flowchartDetails.append(flowchartDetail)
                    
                    print("No next solution found, sorry!")
                }
            }
        }
        
        print(flowchartDetails)
    }
    
    func checkYesOrNoFromTwoComponent(component1 : FlowchartComponent, component2 : FlowchartComponent) -> (FlowchartComponent, FlowchartComponent) {
        let resultFromLineOne = closestYesOrNoTextFromComponent(component: component1)
        
        printFlowchart(flowchart: component1)
        print("THE TEXT NEAR IT IS \(resultFromLineOne)")
        
        if resultFromLineOne == "yes" {
            return (component1, component2)
        }
        
        return (component2, component1)
    }
    
    func loopUntilArrowFound(component : FlowchartComponent) -> FlowchartComponent {
        var result : FlowchartComponent = component
        var visited : [FlowchartComponent] = []
        
        for _ in 0...5{
            if (arrow.contains(result.shape)){
                printFlowchart(flowchart: result)
                break
            }
            
            if let temp = closestNextComponentFromLineOrArrow(component: result).filter({!(shape.contains($0.shape))}).first {
                if visited.contains(temp){
                    break
                } else {
                    visited.append(temp)
                    result = temp
                }
                print("tempLineOrArrow : ")
                printFlowchart(flowchart: result)
            } else {
                break
            }
        }
        
        return result
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
    
    func closestYesOrNoTextFromComponent(component : FlowchartComponent) -> String {
        
        let textComponentsContainYesOrNo = textComponents!.filter({($0.text.lowercased() == "yes") || ($0.text.lowercased() == "no") })
        
        let minX = component.minX
        let minY = component.minY
        //        let maxY = component.maxY
        //        let maxX = component.maxX
        
        var shortestDistance : [Float] = []
        
        for textComponent in textComponentsContainYesOrNo {
            
            //            var tempDistance : [Float] = []
            
            //            let upDiff = minY - textComponent.maxY
            //            let bottomDiff = textComponent.minY - maxY
            //            let rightDiff = textComponent.minX - maxX
            //            let leftDiff = minX - textComponent.maxX
            //
            //            tempDistance.append(upDiff)
            //            tempDistance.append(bottomDiff)
            //            tempDistance.append(rightDiff)
            //            tempDistance.append(leftDiff)
            //
            //            tempDistance = tempDistance.filter({$0 > 0})
            //
            //            if tempDistance.count > 0 {
            //                shortestDistance.append(tempDistance.max()!)
            //            }
            let diffX = minX - textComponent.minX
            let diffY = minY - textComponent.minY
            
            let distance = ((diffX * diffX) + (diffY * diffY)).squareRoot()
            shortestDistance.append(distance)
            
        }
        
        if shortestDistance.count > 0 {
            let sorted = shortestDistance.enumerated().sorted(by: {$0.element < $1.element})
            let justIndices = sorted.map{$0.offset}
            let textFound = textComponentsContainYesOrNo[justIndices[0]].text.lowercased()
            return textFound
        } else {
            return "yes or no text not found"
        }
        
    }
    
    
    func closestFlowchartShapeFromLineOrArrow(lineOrArrow : FlowchartComponent) -> FlowchartComponent?{
        print("\nfrom closestFlowchartShapeFromLineOrArrow")
        let closestComponents = closestNextComponentFromLineOrArrow(component: lineOrArrow)
        
        let closestFlowchartShape = closestComponents.filter({shape.contains($0.shape)})
        
        printFlowchartComponents(flowcharts: closestFlowchartShape)
        return closestFlowchartShape.first
    }
    
    func detectTextInShape(component : FlowchartComponent) -> String {
        
        var tempTextResult : [TextComponent] = []
        var indexRemoved : [Int] = []
        
        if textComponents!.count > 0 {
            for i in 0..<textComponents!.count{
                //                print(i, textComponents!.count)
                let text = textComponents![i]
                if ((text.minX + constantTextX > component.minX) && (text.maxX - constantTextX < component.maxX) && (text.minY + constantTextY > component.minY) && (text.maxY - constantTextY < component.maxY)) {
                    tempTextResult.append(text)
                    indexRemoved.append(i)
                }
            }
        }
        
        for index in indexRemoved.sorted(by: {$0 > $1}) {
            print("removing index")
            print(index, textComponents?.count)
            textComponents?.remove(at: index)
            print(textComponents)
        }
        
        tempTextResult = tempTextResult.sorted(by: {$0.minY < $1.minY})
        
        var result = ""
        
        for text in tempTextResult {
            result += " \(text.text)"
        }
        
        return result
        
    }
    
    
    func closestNextComponentFromShape(component : FlowchartComponent)-> [FlowchartComponent] {
        print("\nFROM closestNextComponentFromShape")
        printFlowchart(flowchart: component)
        
        let minX = component.minX
        let minY = component.minY
        let maxY = component.maxY
        let maxX = component.maxX
        
        var tempFlowchartComponents = flowchartComponents
        
        let indicesSorted = component.fromIndex.sorted(by: { $0 > $1 })
        
        for index in indicesSorted {
            if let indexAt = tempFlowchartComponents?.firstIndex(of: sortedFlowchartComponents![index]) {
                tempFlowchartComponents?.remove(at: indexAt)
            }
        }
        
        tempFlowchartComponents = tempFlowchartComponents!.filter({$0 != tempShape})
        
        var tempComponent : [FlowchartComponent] = []
        var tempDistance : [Float] = []
        ///from up
        if !(component.noArrow.contains("Up")){
            let fromUp = tempFlowchartComponents!.filter({($0.minX + constantLOAX > minX && $0.maxX - constantLOAX < maxX && $0.maxY - constantLOAY < minY && minY - $0.maxY <= constantLOAY) && ($0.shape == "arrow_up" || !(arrow.contains($0.shape)))}).sorted(by: {$0.maxY > $1.maxY})
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
            let fromRight = tempFlowchartComponents!.filter({($0.maxY - constantLOAY < maxY && $0.minY + constantLOAY > minY && $0.minX + constantLOAX > maxX && $0.minX - maxX <= constantLOAX) && ($0.shape == "arrow_right" || !(arrow.contains($0.shape)))}).sorted(by: {$0.minX < $1.minX})
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
            let fromLeft = tempFlowchartComponents!.filter({($0.maxY - constantLOAY < maxY && $0.minY + constantLOAY > minY && $0.maxX - constantLOAX < minX && minX - $0.maxX <= constantLOAX) && ($0.shape == "arrowleft" || !(arrow.contains($0.shape)))}).sorted(by: {$0.maxX > $1.maxX})
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
            let fromBottom = tempFlowchartComponents!.filter({(($0.minX + constantLOAX > minX) && ($0.maxX - constantLOAX < maxX) && ($0.minY + constantLOAY > maxY) && ($0.minY - maxY <= constantLOAY)) && (($0.shape == "arrow_down") || (!(arrow.contains($0.shape))))}).sorted(by: {$0.minY < $1.minY})
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
        
        var tempFlowchartComponents = flowchartComponents
        
        if let prevShape = prevShape {
            print("PREV SHAPE")
            printFlowchart(flowchart: prevShape)
        }
        tempFlowchartComponents = tempFlowchartComponents!.filter({($0 != tempShape) && ($0 != prevShape) && ($0 != component)})
        
        var tempComponent : [FlowchartComponent] = []
        var tempDistance : [Float] = []
        
        ///from up
        if (component.arrowTo != "Bottom"){
            let fromUp = tempFlowchartComponents!.filter({($0.minX - constantLOAX < minX && $0.maxX + constantLOAX > maxX && $0.maxY - constantLOAY < minY && minY - $0.maxY <= constantLOAY) && ($0.shape == "arrow_up" || !(arrow.contains($0.shape)))}).sorted(by: {$0.maxY > $1.maxY})
            tempComponent.append(contentsOf: fromUp)
            print("fromUp :")
            printFlowchartComponents(flowcharts: fromUp)
            for obj in fromUp{
                tempDistance.append(minY - obj.maxY)
                obj.arrowTo = "Up"
            }
        }
        ///from right
        if (component.arrowTo != "Left"){
            let fromRight = tempFlowchartComponents!.filter({($0.maxY + constantLOAY > maxY && $0.minY - constantLOAY < minY && $0.minX + constantLOAX > maxX && $0.minX - maxX <= constantLOAX) && ($0.shape == "arrow_right" || !(arrow.contains($0.shape)))}).sorted(by: {$0.minX < $1.minX})
            tempComponent.append(contentsOf: fromRight)
            print("fromRight :")
            printFlowchartComponents(flowcharts: fromRight)
            for obj in fromRight{
                tempDistance.append(obj.minX - maxX)
                obj.arrowTo = "Right"
            }
        }
        ///from left
        if (component.arrowTo != "Right"){
            let fromLeft = tempFlowchartComponents!.filter({($0.maxY + constantLOAY > maxY && $0.minY - constantLOAY < minY && $0.maxX - constantLOAX < minX && minX - $0.maxX <= constantLOAX) && ($0.shape == "arrowleft" || !(arrow.contains($0.shape)))}).sorted(by: {$0.maxX > $1.maxX})
            tempComponent.append(contentsOf: fromLeft)
            print("fromLeft :")
            printFlowchartComponents(flowcharts: fromLeft)
            for obj in fromLeft{
                tempDistance.append(minX - obj.maxX)
                obj.arrowTo = "Left"
            }
        }
        ///from bottom
        if (component.arrowTo != "Up"){
            let fromBottom = tempFlowchartComponents!.filter({($0.minX - constantLOAX < minX && $0.maxX + constantLOAX > maxX && $0.minY + constantLOAY > maxY && $0.minY - maxY <= constantLOAY) && ($0.shape == "arrow_down" || !(arrow.contains($0.shape)))}).sorted(by: {$0.minY < $1.minY})
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
        let sortedByX = arrayFlowchartComponent.sorted(by: {$0.minY < $1.minY})
        
        return sortedByX.sorted(by: {$0.minX < $1.minX && $0.minY < $1.minY})
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
        print("\(flowchart.shape) - min x \(flowchart.minX) - min y \(flowchart.minY) - max X \(flowchart.maxX) - max Y \(flowchart.maxY) -  no arrow \(flowchart.noArrow) - arrow to \(flowchart.arrowTo) - from index (\(flowchart.fromIndex)")
    }
    
    func printFlowchartComponents(flowcharts: [FlowchartComponent]){
        for fc in flowcharts{
            printFlowchart(flowchart: fc)
        }
    }
}

