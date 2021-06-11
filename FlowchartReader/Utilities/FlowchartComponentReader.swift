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

    func detect(image: CIImage){
        guard let model = try? VNCoreMLModel(for: FlowchartComponentDetector_1().model ) else {
            fatalError("loading coreML model failed")
        }

        let request = VNCoreMLRequest(model: model) { requesthere, error in

            guard let results = requesthere.results as? [VNRecognizedObjectObservation] else {
                fatalError("model failed to process image")
            }

            for result in results {
                let objectName = result.labels.first?.identifier
                let objectConfidence = result.confidence

                let final_image = UIImage(ciImage: image)

//                let objectBounds = VNImageRectForNormalizedRect(result.boundingBox, Int(final_image.size.width), Int(final_image.size.height))


//                let rect=result.boundingBox
//                let x=rect.origin.x*final_image.size.width
//                let w=rect.width*final_image.size.width
//                let h=rect.height*final_image.size.height
//                let y=final_image.size.height*(1-rect.origin.y)-h
//                let conv_rect=CGRect(x: x, y: y, width: w, height: h)

//                print(objectBounds)


                print(result.boundingBox)
                print("\(objectName) - \(objectConfidence)")


            }

        }

        let handler = VNImageRequestHandler(ciImage: image)

        do {
            try handler.perform([request])
        } catch {
            print(error)
        }

    }


}
