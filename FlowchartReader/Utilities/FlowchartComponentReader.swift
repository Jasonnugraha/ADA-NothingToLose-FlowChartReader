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

    func detect(image: CIImage) -> [FlowchartComponent]? {
        guard let model = try? VNCoreMLModel(for: FlowchartComponentDetectorRev_1().model ) else {
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
                let boundingBox = result.boundingBox
                
                let flowchartComponent = FlowchartComponent(shape: objectName, minX: Float(boundingBox.minX), minY: Float(1 - boundingBox.minY), maxX:  Float(boundingBox.maxX), maxY: Float(1 - boundingBox.minY + boundingBox.maxY - boundingBox.minY), noArrow: [], arrowTo: "", fromIndex: [])
                
                flowchartComponents.append(flowchartComponent)
                
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
