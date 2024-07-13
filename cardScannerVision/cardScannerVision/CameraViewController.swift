//
//  CameraViewController.swift
//  cardScannerVision
//
//  Created by Cynthia Denisse Verdiales Moreno on 29/02/24.
//
import UIKit
import Vision
import AVFoundation

class CameraViewController: UIViewController {
    var delegate: CameraViewControllerDelegate?
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupCameraFeed()
        self.setupVideoOutput()
    }
    
    func setupCameraFeed() {
        captureSession = AVCaptureSession()
        captureSession?.beginConfiguration()
        guard let captureSession = captureSession else { return }
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
      
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                print("Could not add video input")
                return
            }
            
            let videoOutput = AVCaptureVideoDataOutput()
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            } else {
                print("Could not add video output")
            }
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.frame = view.layer.bounds
            videoPreviewLayer?.videoGravity = .resizeAspectFill
            view.layer.addSublayer(videoPreviewLayer!)
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self = self
                captureSession.commitConfiguration()
                captureSession.startRunning()
                DispatchQueue.main.async {
                    self?.addRectangleOverlay()
                }
            }
            
            
        } catch {
            print("Error configuring capture session: \(error)")
            captureSession.commitConfiguration()
            return
        }
      
    }
    
    func addRectangleOverlay() {
        let overlayLayer = CALayer()
        overlayLayer.frame = CGRect(x: 10, y: 100, width: view.safeAreaLayoutGuide.layoutFrame.size.width - 2 * 10 , height: view.safeAreaLayoutGuide.layoutFrame.size.height / 3)
        overlayLayer.borderColor = UIColor(red: 46/255, green: 79/255, blue: 119/255, alpha: 1.0).cgColor
        overlayLayer.borderWidth = 2
        overlayLayer.backgroundColor = UIColor(red: 46/255, green: 79/255, blue: 119/255, alpha: 1.0).cgColor
        overlayLayer.opacity = 0.3
        DispatchQueue.main.async {
            self.videoPreviewLayer?.addSublayer(overlayLayer)
        }
    }
    
    func setupVideoOutput() {
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String: Any]
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if captureSession?.canAddOutput(videoOutput) ?? false {
            captureSession?.addOutput(videoOutput)
        }
    }
    
    func isValidCardFormat(cardNumber: String) -> Bool {
        guard cardNumber.count >= 13 else {return false}
        
        let firstDigit = cardNumber.prefix(1)
        
        switch firstDigit {
            //3: AMERICAN EXPRESS, 4: VISA, 5: MASTERCARD, 6: DISCOVER CARD
        case "3", "4", "5", "6":
            return true
        default:
            return false
        }
        
    }

}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
       
        let request = VNRecognizeTextRequest { [weak self] (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
           
            for observation in observations {
                let topCandidate = observation.topCandidates(1).first
                guard let recognizedText = topCandidate else {continue}
                
                if recognizedText.confidence > 0.8 {
                    let extractedCardNumbers = self?.extractCardNumbers(from: [recognizedText.string])
                    if var cardNumbers = extractedCardNumbers?.first, cardNumbers.count >= 13 {
                        
                        DispatchQueue.main.async {
                           // cardNumbers = cardNumbers.grouping(every: 4, with: " ")
                            self?.delegate?.getCardNumbers(cardNumbers)
                            self?.captureSession?.stopRunning()
                            self?.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        request.recognitionLevel = .accurate
       
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    func extractCardNumbers(from strings: [String]) -> [String]{
        var cardNumbers: [String] = []
        let potentialNumbers = strings.joined(separator: " ")
        let regex = try! NSRegularExpression(pattern: "\\b(?:\\d[ -]*?){13,19}\\b")
        let matches = regex.matches(in: potentialNumbers, range: NSRange(potentialNumbers.startIndex..., in: potentialNumbers))
        cardNumbers = matches.compactMap {
            Range($0.range, in: potentialNumbers).map { String(potentialNumbers[$0]) }
        }
        
        return cardNumbers
    }
}

protocol CameraViewControllerDelegate: AnyObject {
    func getCardNumbers(_ cardNumbers: String)
}
