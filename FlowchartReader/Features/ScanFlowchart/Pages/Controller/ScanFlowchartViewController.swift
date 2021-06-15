//
//  ScanFlowchartViewController.swift
//  FlowchartReader
//
//  Created by Reza Harris on 14/06/21.
//

import UIKit
import AVFoundation
import Vision
import CoreMotion

enum DetectionStatus: String {
    case NoDetected = "No Object Detected"
    case Hold = "Hold"
    case Closer = "a Little Closer"
    case TooClose = "Too Close"
}


class ScanFlowchartViewController: CameraVisionViewController {
    
    private var detectionOverlay: CALayer! = nil
    
    // Vision parts
    private var requests = [VNRequest]()
    
    // Time Interval for Speech
    var timer = Timer()
    var objectDetected = DetectionStatus.NoDetected.rawValue
    var countingHoldTime = 0
    
    // Sign for detect device orientation
    var coreMotionManager: CMMotionManager!
    var portraitOrientation = true
    
    let screenRect = UIScreen.main.bounds
    
    
    @discardableResult
    func setupVision() -> NSError? {
        // Setup Vision parts
        let error: NSError! = nil
        
//        coreMotionManager = CMMotionManager()
//        coreMotionManager.startAccelerometerUpdates()
        
        guard let modelURL = Bundle.main.url(forResource: "FlowchartObjectsBeta", withExtension: "mlmodelc") else {
            return NSError(domain: "VisionObjectRecognitionViewController", code: -1, userInfo: [NSLocalizedDescriptionKey: "Model file is missing"])
        }
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                DispatchQueue.main.async(execute: {
//                    if let accelerometerData = self.coreMotionManager.accelerometerData {
//                        var gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
//                        if gravity.dx > 0 && gravity.dy > 0 && !self.portraitOrientation{
//                            self.portraitOrientation = true
//                            self.setupLayers()
//                        } else if (gravity.dx < 3 && gravity.dy < 0 && self.portraitOrientation) {
//                            self.portraitOrientation = false
//                            self.setupLayers()
//                        }
//                    }
                    // portrait: (x > 0, y > 0)
                    // landscape: (x < 3, y < 0)
                    if let results = request.results {
                        self.drawVisionRequestResults(results)
                    }
                })
            })
            objectRecognition.imageCropAndScaleOption = .scaleFill
            self.requests = [objectRecognition]
        } catch let error as NSError {
            print("Model loading went wrong: \(error)")
        }
        
        return error
    }
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting() {
        let utterance: AVSpeechUtterance!
        
        switch objectDetected {
        case DetectionStatus.Hold.rawValue:
            utterance = AVSpeechUtterance(string: "\(DetectionStatus.Hold.rawValue)")
            if countingHoldTime < 4 {
                countingHoldTime += 1
            }

            if countingHoldTime == 3 {
                timer.invalidate()
                capturePhoto()
            }
        case DetectionStatus.TooClose.rawValue:
            utterance = AVSpeechUtterance(string: "\(DetectionStatus.TooClose.rawValue)")
            countingHoldTime = 0
        case DetectionStatus.Closer.rawValue:
            utterance = AVSpeechUtterance(string: "\(DetectionStatus.Closer.rawValue)")
            countingHoldTime = 0
        case DetectionStatus.NoDetected.rawValue:
            countingHoldTime = 0
            utterance = AVSpeechUtterance(string: "\(DetectionStatus.NoDetected.rawValue)")
        default:
            countingHoldTime = 0
            utterance = AVSpeechUtterance(string: "\(DetectionStatus.NoDetected.rawValue)")
        }

        utterance.rate = 0.55
        utterance.volume = 0.8

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    func drawVisionRequestResults(_ results: [Any]) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        detectionOverlay.sublayers = nil // remove all the old recognized objects
        if results.count == 0 && objectDetected != DetectionStatus.NoDetected.rawValue {
            objectDetected = DetectionStatus.NoDetected.rawValue
        }
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                continue
            }
            
            if objectObservation.boundingBox.minX < 0 || objectObservation.boundingBox.maxY > 1 && objectDetected != DetectionStatus.TooClose.rawValue {
                objectDetected = DetectionStatus.TooClose.rawValue
            }
            
            if objectObservation.boundingBox.minX > 0 && objectObservation.confidence < 0.4 && objectDetected != DetectionStatus.Closer.rawValue {
                objectDetected = DetectionStatus.Closer.rawValue
            }
            
            if objectObservation.boundingBox.minX > 0 && objectObservation.confidence >= 0.4 && objectDetected != DetectionStatus.Hold.rawValue && objectObservation.boundingBox.maxY < 1 {
                objectDetected = DetectionStatus.Hold.rawValue
            }
            
            // Select only the label with the highest confidence.
            let topLabelObservation = objectObservation.labels[0]
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(bufferSize.width), Int(bufferSize.height))
            
            let shapeLayer = self.createRoundedRectLayerWithBounds(objectBounds)
//            shapeLayer.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
            
            let textLayer = self.createTextSubLayerInBounds(objectBounds,
                                                            identifier: topLabelObservation.identifier,
                                                            confidence: topLabelObservation.confidence)
            shapeLayer.addSublayer(textLayer)
            detectionOverlay.addSublayer(shapeLayer)
        }
        self.updateLayerGeometry()
        CATransaction.commit()
    }
    
    override func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let exifOrientation = exifOrientationFromDeviceOrientation()
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exifOrientation, options: [:])
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
    
    override func setupAVCapture() {
        super.setupAVCapture()
        
//        // setup Vision parts
        setupLayers()
        updateLayerGeometry()
        setupVision()
        
        // start the capture
        startCaptureSession()
    }
    
    func setupLayers() {
        detectionOverlay = CALayer() // container layer that has all the renderings of the observations
        detectionOverlay.name = "DetectionOverlay"
        // TODO: Cek orientasi sedang portrait atau landscape, if landsacpe jalanin kode sekarang, kalau portrait, x,y harus diganti menyesuaikan screen
        // di cek dl dia potrait atau landscape, nandi CG Rect nya berbeda
        
//        if (portraitOrientation){
//            detectionOverlay.bounds = CGRect(x: 0,
//                                             y: 0,
//                                             width: bufferSize.width,
//                                             height: bufferSize.height)
//        } else {
//            detectionOverlay.bounds = CGRect(x: 100,
//                                             y: 100,
//                                             width: bufferSize.width,
//                                             height: bufferSize.height)
//        }
        
        detectionOverlay.bounds = CGRect(x: 0,
                                         y: 0,
                                         width: bufferSize.width,
                                         height: bufferSize.height)
//        detectionOverlay.frame = rootLayer.bounds
        detectionOverlay.position = CGPoint(x: rootLayer.bounds.minX, y:rootLayer.bounds.minY)
        rootLayer.addSublayer(detectionOverlay)
        
        let buttonCapture = createButton()
        self.view.addSubview(buttonCapture)
    }
    
    func updateLayerGeometry() {
        let bounds = rootLayer.bounds
        var scale: CGFloat
        
        let xScale: CGFloat = bounds.size.width / bufferSize.height
        let yScale: CGFloat = bounds.size.height / bufferSize.width
        
        scale = fmax(xScale, yScale)
        if scale.isInfinite {
            scale = 1.0
        }
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        
        // rotate the layer into screen orientation and scale and mirror
        detectionOverlay.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: scale, y: -scale))
        // center the layer
        detectionOverlay.position = CGPoint(x: bounds.midX, y: bounds.midY)
        
        CATransaction.commit()
        
    }
    
    func createTextSubLayerInBounds(_ bounds: CGRect, identifier: String, confidence: VNConfidence) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.name = "Object Label"
        let formattedString = NSMutableAttributedString(string: String(format: "\(identifier)\nConfidence:  %.2f", confidence))
        let largeFont = UIFont(name: "Helvetica", size: 24.0)!
        formattedString.addAttributes([NSAttributedString.Key.font: largeFont], range: NSRange(location: 0, length: identifier.count))
        textLayer.string = formattedString
        textLayer.bounds = CGRect(x: 0, y: 0, width: bounds.size.height - 10, height: bounds.size.width - 10)
        textLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        textLayer.shadowOpacity = 0.7
        textLayer.shadowOffset = CGSize(width: 2, height: 2)
        textLayer.foregroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.0, 0.0, 0.0, 1.0])
        textLayer.contentsScale = 2.0 // retina rendering
        // rotate the layer into screen orientation and scale and mirror
        textLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: 1.0, y: -1.0))
        return textLayer
    }
    
    func createRoundedRectLayerWithBounds(_ bounds: CGRect) -> CALayer {
        let shapeLayer = CALayer()
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        shapeLayer.name = "Found Object"
//        shapeLayer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.2, 1.0, 0.5, 0.8])
        shapeLayer.borderWidth = 50
        shapeLayer.borderColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.2, 1.0, 0.5, 0.8])
        shapeLayer.cornerRadius = 7
        return shapeLayer
    }
    
    func createButton() -> UIButton {
        let captureIcon = UIImage(named: "CapturePhoto")
        let button = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width / 2 - 50, y: UIScreen.main.bounds.height - 200, width: 100, height: 100))
        button.setImage(captureIcon, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(sayCheese), for: .touchUpInside)
        return button
        
    }
    
    @objc
    func sayCheese(sender: UIButton!) {
        timer.invalidate()
        capturePhoto()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.setNavigationBarHidden(true, animated: false)
        AppUtility.lockOrientation(.portrait)
        scheduledTimerWithTimeInterval()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
}
