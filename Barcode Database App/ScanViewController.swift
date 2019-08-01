//
//  ScanViewController.swift
//  Barcode Database App
//
//  Created by Amber King on 2019-07-21.
//  Copyright © 2019 Amber King. All rights reserved.
//

import UIKit
import AVFoundation

class CameraView: UIView {
    
    override class var layerClass: AnyClass {
        get {
            return AVCaptureVideoPreviewLayer.self
        }
    }
    
    override var layer: AVCaptureVideoPreviewLayer {
        get {
            return super.layer as! AVCaptureVideoPreviewLayer
        }
    }
    
    func updateOrientation() {
        let videoOrientation: AVCaptureVideoOrientation
        
        switch UIDevice.current.orientation {
        case .portrait:
            videoOrientation = .portrait
        case .portraitUpsideDown:
            videoOrientation = .portraitUpsideDown
        case .landscapeLeft:
            videoOrientation = .landscapeRight
        case .landscapeRight:
            videoOrientation = .landscapeLeft
        default:
            videoOrientation = .portrait
        }
        
        layer.connection? .videoOrientation = videoOrientation
    }
    
}

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var cameraView: CameraView!
    
    let session = AVCaptureSession()
    let sessionQueue = DispatchQueue(label: "Session Queue")
    
    var message = ""
    var isShowingInfo = false
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if !isShowingInfo,
            metadataObjects.count > 0,
            metadataObjects.first is AVMetadataMachineReadableCodeObject,
            let scan = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            
            message = scan.stringValue ?? ""
            print(message)
            
            isShowingInfo = true
            
            performSegue(withIdentifier: "scan", sender: self)
        }
    }
    
    override func loadView() {
        cameraView = CameraView()
        
        view = cameraView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Scan"
        
        session.beginConfiguration()
        
        if let videoDevice = AVCaptureDevice.default(for: .video) {
            if let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice), session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if (session.canAddOutput(metadataOutput)) {
                session.addOutput(metadataOutput)
                
                metadataOutput.metadataObjectTypes = [
                    .code128,
                    .code39,
                    .code93,
                    .ean13,
                    .ean8,
                    .qr,
                    .upce
                ]
                
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            }
        }
        
        session.commitConfiguration()
        
        cameraView.layer.session = session
        cameraView.layer.videoGravity = .resizeAspectFill
        
        cameraView.updateOrientation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sessionQueue.async {
            self.session.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sessionQueue.async {
            self.session.stopRunning()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        cameraView.updateOrientation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        isShowingInfo = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ProductViewController {
            vc.barcode = message
        }
    }
    
}


