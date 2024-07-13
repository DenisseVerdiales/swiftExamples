//
//  ViewController.swift
//  cardScannerVision
//
//  Created by Cynthia Denisse Verdiales Moreno on 29/02/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var button = UIButton(type: .system)
    var label = UILabel(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
    }

    func setup(){
        
        button.setImage(UIImage(systemName: "arrowtriangle.down.circle"), for: .normal)
        button.frame = CGRect(x: view.frame.width - 60, y: 60, width: 50, height: 50)
        button.addTarget(self, action: #selector(showScanner), for: .touchUpInside)
        view.addSubview(button)
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10).isActive = true
    }
    
    func showCardScanner() {
        checkCameraPermission { granted in
            if granted {
                let cameraVC = CameraViewController()
                cameraVC.delegate = self
                cameraVC.modalPresentationStyle = .overFullScreen
                self.present(cameraVC, animated: true, completion: nil)
            }
        }
    }
    
    func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
                
            }
        case .denied:
            completion(false)
        case .restricted:
            completion(false)
        @unknown default:
            completion(false)
        
        }
    
    }

    @objc func showScanner() {
        showCardScanner()
    }
    
}

extension ViewController: CameraViewControllerDelegate {
    func getCardNumbers(_ cardNumbers: String) {
        print(cardNumbers)
        label.text = cardNumbers
    }
    
}

