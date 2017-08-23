//
//  CameraViewController_camera.swift
//  TravelCam
//
//  Created by LEOFALCON on 2017. 8. 6..
//  Copyright © 2017년 LeFal. All rights reserved.
//

import UIKit
import AVFoundation

extension CameraViewController : AVCapturePhotoCaptureDelegate {
    
    func frontCamera(_ front : Bool)  {
        do {
            try captureSession.removeInput(AVCaptureDeviceInput(device: captureDevice))
        } catch {
            print("error")
        }
        
        let position :AVCaptureDevicePosition = front ? .front : .back
            let captureDeviceDiscoverySession = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: position)
            let devices = captureDeviceDiscoverySession?.devices
            for device in devices! {
                captureDevice = device
                do {
                    try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
            }catch {}
        }
    }
    
    func beginSession(){
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        self.cameraView.layer.addSublayer(previewLayer!)
        previewLayer?.frame = self.cameraView.layer.bounds
        
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        captureSession.startRunning()
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
    }

    // focus
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !self.frontCamera {
            
            let screenSize = cameraView.bounds.size
            if let touchPoint = touches.first {
                let x = touchPoint.location(in: cameraView).y / screenSize.height
                let y = 1.0 - touchPoint.location(in: cameraView).x / screenSize.width
                let focusPoint = CGPoint(x: x, y: y)
                
                if let device = captureDevice {
                    do {
                        try device.lockForConfiguration()
                        
                        device.focusPointOfInterest = focusPoint
                        device.focusMode = .continuousAutoFocus
                        device.exposurePointOfInterest = focusPoint
                        device.exposureMode = AVCaptureExposureMode.continuousAutoExposure
                        device.unlockForConfiguration()
                    }
                    catch {
                    }
                }
            }
        }
    }

    @IBAction func captureCamera(_ sender: Any) {
        let sessionQueue = DispatchQueue(label: "captureSession")
        guard let videoPreviewLayerOrientation = previewLayer?.connection.videoOrientation
            else {return}
        sessionQueue.async {
            if let videoConnection = self.photoOutput.connection(withMediaType: AVMediaTypeVideo) {
                videoConnection.videoOrientation = videoPreviewLayerOrientation
            }
            let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecJPEG])
            self.photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        guard error == nil, let photoSampleBuffer = photoSampleBuffer else {
            print("Error capturing photo: \(String(describing: error))")
            return
        }
        
        self.photoSampleBuffer = photoSampleBuffer
        self.previewPhotoSampleBuffer = previewPhotoSampleBuffer
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishCaptureForResolvedSettings resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        guard error == nil else {
            print("Error in capture process: \(String(describing: error))")
            return
        }
        
        if let photoSampleBuffer = self.photoSampleBuffer {
            guard let jpegData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(
                forJPEGSampleBuffer: photoSampleBuffer,
                previewPhotoSampleBuffer: previewPhotoSampleBuffer) else { return }
            
            let image = UIImage(data: jpegData)
            let cropImage = ImageService.cropImageToSquare(image: image!)
            
            let mergeImage = ImageService.merge(image: cropImage!, cameraViewLabel: self.weekUILabel, cameraViewWidth: self.cameraView.frame.width, babyNameViewLabel: self.babyNameUILabel)
            ShareImageService.showShareViewController(presentViewController: self, image: mergeImage)
            
            self.cameraView.backgroundColor = UIColor(patternImage: image!)
        }
    }
    
    
    @IBAction func changeCamera(_ sender: Any) {
        frontCamera = !frontCamera
        captureSession.beginConfiguration()
        let inputs = captureSession.inputs as! [AVCaptureInput]
        for oldInput : AVCaptureInput in inputs {
            captureSession.removeInput(oldInput)
        }
        frontCamera(frontCamera)
        captureSession.commitConfiguration()
    }
}
