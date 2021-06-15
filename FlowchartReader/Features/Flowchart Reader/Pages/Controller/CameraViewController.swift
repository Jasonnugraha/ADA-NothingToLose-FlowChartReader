//
//  CameraViewController.swift
//  FlowchartReader
//
//  Created by Jessi Febria on 11/06/21.
//

import UIKit
import AVFoundation
import Accessibility

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var pireviewView: UIView!
    private var previewLayer: AVCaptureVideoPreviewLayer! = nil
    
    
    var rootLayer: CALayer! = nil
    let captureSession = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    
    var flowchartComponents : [FlowchartComponent]?
    var resultImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureAVCapture()
        captureSession.startRunning()
    }
    
    
    func configureAVCapture(){
        
        captureSession.beginConfiguration()
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                  for: .video, position: .unspecified)
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
              captureSession.canAddInput(videoDeviceInput)
        else { return }
        captureSession.addInput(videoDeviceInput)
        
        guard captureSession.canAddOutput(photoOutput) else { return }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
        
        captureSession.commitConfiguration()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        rootLayer = pireviewView.layer
        previewLayer.frame = rootLayer.bounds
        rootLayer.addSublayer(previewLayer)
        
        
        
        
    }
    
    @IBAction func captureTapped(_ sender: UIButton) {
        
        print("BUTTON TAPPED")
        let photoSettings = AVCapturePhotoSettings()
        if let photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
        
    }
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let previewImage = UIImage(data: imageData)
        
        captureSession.stopRunning()
        let scannedImage = getScannedImage(inputImage: previewImage!)?.rotate(radians: .pi/2)
        let monochormedImage = getMonochromeImage(inputImage: scannedImage!)?.rotate(radians: .pi/2)
        resultImage = monochormedImage
        
        flowchartComponents = FlowchartComponentReader().detect(image: CIImage(image: scannedImage!)!)
        
        performSegue(withIdentifier: "CameraToResult", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CameraToResult" {
            if let destinationVC = segue.destination as? ResultViewController {
                destinationVC.flowchartComponents = flowchartComponents
                destinationVC.resultImage = resultImage
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
        filter?.setValue(1, forKey: kCIInputSaturationKey)
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
        filterMonochrome?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")
        filterMonochrome?.setValue(1.0, forKey: "inputIntensity")
        
        guard let outputImage = filterMonochrome?.outputImage else { return nil }

        let context = CIContext()

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgimg)
        }
        
        return nil
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
