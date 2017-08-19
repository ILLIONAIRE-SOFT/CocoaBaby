//
//  CameraViewController.swift
//  CustomCameraPractice
//
//  Created by LEOFALCON on 2017. 8. 4..
//  Copyright © 2017년 LeFal. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    
    let weekUILabel = UILabel()
    var mapImageView = UIImageView()
    
    @IBOutlet var cameraView: UIView!
    let captureSession = AVCaptureSession()
    var captureDevice : AVCaptureDevice?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var frontCamera : Bool = false
    var photoOutput : AVCapturePhotoOutput = AVCapturePhotoOutput()
    var photoSetting : AVCapturePhotoSettings = AVCapturePhotoSettings()
    
    @IBOutlet var flashBtn: UIButton!
    @IBOutlet var guideBtn: UIButton!
    
    var photoSampleBuffer: CMSampleBuffer?
    var previewPhotoSampleBuffer: CMSampleBuffer?
    
    var guideImageView = UIImageView()
    var isGuideActive : Bool = false

    
    @IBOutlet var guideLineBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        captureSession.sessionPreset  = AVCaptureSessionPresetPhoto
        frontCamera(frontCamera)
        if captureDevice != nil {
            beginSession()
        }
        updateWeekLabel()
        guideBtn.setTitleColor(.yellow, for: .selected)
        guideBtn.setTitleColor(.white, for: .normal)
        
        guideImageView = UIImageView(frame: cameraView.frame)
        guideImageView.image = UIImage(named: "camera_guide")
        view.addSubview(guideImageView)
        
        
        // if no cameraGuide set userDefault value as true
        if UserDefaults.standard.object(forKey: "cameraGuide" ) == nil {
            UserDefaults.standard.set(true, forKey: "cameraGuide")
        }
        
        guideBtn.isSelected = UserDefaults.standard.bool(forKey: "cameraGuide")
        guideImageView.isHidden = !UserDefaults.standard.bool(forKey: "cameraGuide")
    }
    @IBAction func modalDismiss(_ sender: Any) {
        captureSession.stopRunning()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toggleGuide(_ sender: UIButton) {
        if !isGuideActive {
            guideImageView.isHidden = false
            isGuideActive = true
            self.guideBtn.isSelected = true
            UserDefaults.standard.set(true, forKey: "cameraGuide")
        } else {
            guideImageView.isHidden = true
            isGuideActive = false
            self.guideBtn.isSelected = false
            UserDefaults.standard.set(false, forKey: "cameraGuide")
        }
    }
}



