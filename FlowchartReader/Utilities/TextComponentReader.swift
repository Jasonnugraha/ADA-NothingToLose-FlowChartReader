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
    
    func createVisionRequest(image: UIImage) -> [TextComponent]
    {
        guard let cgImage = image.cgImage else {
            fatalError("Failed to read image")
        }
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let vnRequests = [vnTextDetectionRequest]
        DispatchQueue.global(qos: .background).async {
            do{
                try requestHandler.perform(vnRequests)
            }catch let error as NSError {
                print("Error in performing Image request: \(error)")
            }
        }
        return textComponents
    }
    
    
    var vnTextDetectionRequest :VNRecognizeTextRequest{
        let request = VNRecognizeTextRequest { (request,error) in
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
                    print (unwrapped)
                    let boundingBox = observation.boundingBox
                    print(boundingBox)
                    let textComponent = TextComponent(text: unwrapped,
                                                      minX: Float(boundingBox.minX),
                                                      minY: Float(boundingBox.minY),
                                                      maxX: Float(boundingBox.maxX),
                                                      maxY: Float(boundingBox.maxY))
                    
                }
            }
        }
        return request
    }
}

