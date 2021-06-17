//
//  FlowchartComponentReader.swift
//  FlowchartReader
//
//  Created by Jessi Febria on 11/06/21.
//

import UIKit
import Vision
import CoreML

class FlowchartComponentReader {
    
    var flowchartComponents : [FlowchartComponent] = []

    func detect(image: CIImage, bufferSize : CGSize) -> [FlowchartComponent]? {
        guard let model = try? VNCoreMLModel(for: FlowchartComponentDetectorRev_1_Iteration_5300().model ) else {
            fatalError("loading coreML model failed")
        }

        let request = VNCoreMLRequest(model: model) { [self] requesthere, error in

            guard let results = requesthere.results as? [VNRecognizedObjectObservation] else {
                fatalError("model failed to process image")
            }

            for result in results {
                let firstResult = result.labels.first
                let objectName = firstResult!.identifier
                let objectConfidence = firstResult!.confidence
//                let boundingBox = result.boundingBox
                
                let boundingBox = VNImageRectForNormalizedRect(result.boundingBox, Int(bufferSize.width), Int(bufferSize.height))
                let minY = Float(bufferSize.height) - Float(boundingBox.minY)
                let maxY = minY + Float(boundingBox.height)
                
                let flowchartComponent = FlowchartComponent(shape: objectName, minX: Float(boundingBox.minX), minY: minY, maxX:  Float(boundingBox.maxX), maxY: maxY , noArrow: [], arrowTo: "", fromIndex: [])
                flowchartComponents.append(flowchartComponent)
                
//                let flowchartComponent = FlowchartComponent(shape: objectName, minX: Float(boundingBox.minX), minY: Float(1 - boundingBox.minY), maxX:  Float(boundingBox.maxX), maxY: Float(1 - boundingBox.minY + boundingBox.maxY - boundingBox.minY), noArrow: [], arrowTo: "", fromIndex: [])
                
                
                print("\(objectName) - \(objectConfidence)")
            }
        }

        let handler = VNImageRequestHandler(ciImage: image)

        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        
        return flowchartComponents
    }


}
