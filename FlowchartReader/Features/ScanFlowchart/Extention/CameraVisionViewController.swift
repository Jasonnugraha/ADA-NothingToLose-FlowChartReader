//
//  CameraViewController.swift
//  FlowchartReader
//
//  Created by Reza Harris on 14/06/21.
//

import UIKit
import AVFoundation
import Vision

class CameraVisionViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate {
    
    var bufferSize: CGSize = .zero
    var rootLayer: CALayer! = nil
    
    @IBOutlet weak private var previewView: ScanFlowchartView!
    private let session = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer! = nil
    private let videoDataOutput = AVCaptureVideoDataOutput()
    
    private let photoOutput = AVCapturePhotoOutput()
    
    var flowchartComponents : [FlowchartComponent]?
    var textComponents: [TextComponent]?
    var resultImage : UIImage?

    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAVCapture()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupAVCapture() {
        setTransparantNavBar()
        var deviceInput: AVCaptureDeviceInput!
        
        // Select a video device, make an input
        let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
        do {
            deviceInput = try AVCaptureDeviceInput(device: videoDevice!)
        } catch {
            print("Could not create video device input: \(error)")
            return
        }
        
        session.beginConfiguration()
        session.sessionPreset = .high// Model image size is smaller.
        
        // Add a video input
        guard session.canAddInput(deviceInput) else {
            print("Could not add video device input to the session")
            session.commitConfiguration()
            return
        }
        session.addInput(deviceInput)
        
        
        //Photo Output
        if session.canAddOutput(self.photoOutput) {
            self.session.addOutput(self.photoOutput)
            self.photoOutput.isHighResolutionCaptureEnabled = true
        }
        
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
            // Add a video data output
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            print("Could not add video data output to the session")
            session.commitConfiguration()
            return
        }
        let captureConnection = videoDataOutput.connection(with: .video)
        // Always process the frames
        captureConnection?.isEnabled = true
        do {
            try  videoDevice!.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice?.activeFormat.formatDescription)!)
            bufferSize.width = CGFloat(dimensions.width)
//            bufferSize.height = CGFloat(dimensions.height+500)
            bufferSize.height = CGFloat(dimensions.height)
            videoDevice!.unlockForConfiguration()
        } catch {
            print(error)
        }
        session.commitConfiguration()
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        rootLayer = previewView.layer
        previewLayer.frame = rootLayer.bounds
        rootLayer.addSublayer(previewLayer)
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [
            kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
            kCVPixelBufferWidthKey as String: 160,
            kCVPixelBufferHeightKey as String: 160
        ]
        settings.previewPhotoFormat = previewFormat
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let previewImage = UIImage(data: imageData)
        
//        session.stopRunning()
        let scannedImage = getScannedImage(inputImage: previewImage!)?.rotate(radians: .pi/2)
        let monochormedImage = getMonochromeImage(inputImage: scannedImage!)
        resultImage = monochormedImage
        
        flowchartComponents = FlowchartComponentReader().detect(image: CIImage(image: scannedImage!)!, bufferSize: bufferSize)
        textComponents = TextComponentReader().createVisionRequest(image: scannedImage!, bufferSizeLocal: bufferSize)
        
        performSegue(withIdentifier: "CameraToResult", sender: self)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        session.startRunning()
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CameraToResult" {
            if let destinationVC = segue.destination as? ResultViewController {
                destinationVC.flowchartComponents = flowchartComponents
                destinationVC.resultImage = resultImage
                destinationVC.textComponents = textComponents
            }
        }
    }
    
    func getScannedImage(inputImage: UIImage) -> UIImage? {

        let context = CIContext()

        let filter = CIFilter(name: "CIColorControls")
        let coreImage = CIImage(image: inputImage)

        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        //Key value are changable according to your need.
        filter?.setValue(7, forKey: kCIInputContrastKey)
        filter?.setValue(0, forKey: kCIInputSaturationKey)
        filter?.setValue(1.2, forKey: kCIInputBrightnessKey)

        if let outputImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
        let output = context.createCGImage(outputImage, from: outputImage.extent)
            return UIImage(cgImage: output!)
        }
        return nil
    }
    
    func getMonochromeImage(inputImage : UIImage) -> UIImage? {
        let filterMonochrome = CIFilter(name: "CIColorMonochrome")
        let coreImage = CIImage(image: inputImage)
        
        filterMonochrome?.setValue(coreImage, forKey: "inputImage")
        filterMonochrome?.setValue(CIColor(red: 1.0, green: 1.0, blue: 1.0), forKey: "inputColor")
        filterMonochrome?.setValue(1.0, forKey: "inputIntensity")
        
        guard let outputImage = filterMonochrome?.outputImage else { return nil }

        let context = CIContext()

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgimg)
        }
        
        return nil
    }
    
    func startCaptureSession() {
        session.startRunning()
    }
    
    // Clean up capture setup
    func teardownAVCapture() {
        previewLayer.removeFromSuperlayer()
        previewLayer = nil
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput, didDrop didDropSampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // print("frame dropped")
    }
    
    public func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
        let curDeviceOrientation = UIDevice.current.orientation
        let exifOrientation: CGImagePropertyOrientation
        
        switch curDeviceOrientation {
        case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
            exifOrientation = .left
        case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
            exifOrientation = .upMirrored
        case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
            exifOrientation = .down
        case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
            exifOrientation = .up
        default:
            exifOrientation = .up
        }
        return exifOrientation
    }
    
    func setTransparantNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
}


extension UIImage {
    
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
}
