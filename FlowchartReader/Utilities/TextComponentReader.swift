//
//  TextComponentReader.swift
//  FlowchartReader
//
//  Created by Jason Nugraha on 14/06/21.
//

import UIKit
import Vision

class TextComponentReader {
    var textComponents : [TextComponent] = []
    var bufferSize : CGSize = .zero
    
    func createVisionRequest(image: UIImage, bufferSizeLocal : CGSize) -> [TextComponent]
    {
        guard let cgImage = image.cgImage else {
            fatalError("Failed to read image")
        }
        bufferSize = bufferSizeLocal
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let vnRequests = [vnTextDetectionRequest]
        
        do{
            try requestHandler.perform(vnRequests)
        }catch let error as NSError {
            print("Error in performing Image request: \(error)")
        }
        
        return textComponents
    }
    
    
    var vnTextDetectionRequest :VNRecognizeTextRequest{
        let request = VNRecognizeTextRequest { [self] (request,error) in
            if let error = error as NSError? {
                print("Error in detecting - \(error)")
                return
            }
            else {
                guard let observations = request.results as? [VNRecognizedTextObservation]
                else {
                    return
                }
//                print("Observations are \(observations)")
                for observation in observations {
                    let text = observation.topCandidates(1).first?.string
                    guard let unwrapped = text else {return}
                    
//                    let boundingBox = observation.boundingBox
                    
                    let boundingBox = VNImageRectForNormalizedRect(observation.boundingBox, Int(self.bufferSize.width), Int(self.bufferSize.height))
                    let minY = Float(bufferSize.height) - Float(boundingBox.minY)
                    let maxY = minY + Float(boundingBox.height)
                    
                    let textComponent = TextComponent(text: unwrapped, minX: Float(boundingBox.minX), minY: minY, maxX:  Float(boundingBox.maxX), maxY: maxY)
                    
//                    let textComponent = TextComponent(text: unwrapped,
//                                                      minX: Float(boundingBox.minX),
//                                                      minY: Float(1 - boundingBox.minY),
//                                                      maxX: Float(boundingBox.maxX),
//                                                      maxY: Float(1 -  boundingBox.minY + boundingBox.maxY - boundingBox.minY))
                    self.textComponents.append(textComponent)
                    
                }
            }
        }
        return request
    }
}

