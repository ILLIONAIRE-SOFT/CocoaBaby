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
    var stillImageOutput : AVCaptureStillImageOutput = AVCaptureStillImageOutput()
    
    @IBOutlet var flashBtn: UIButton!
    @IBOutlet var guideBtn: UIButton!
    
    var guideImageView = UIImageView()
    var isGuideActive : Bool = false

    
    @IBOutlet var guideLineBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

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
        
        guideBtn.isSelected = true
        guideImageView.isHidden = false
    }
    @IBAction func modalDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toggleGuide(_ sender: UIButton) {
        if !isGuideActive {
            guideImageView.isHidden = false
            isGuideActive = true
            self.guideBtn.isSelected = true
        } else {
            guideImageView.isHidden = true
            isGuideActive = false
            self.guideBtn.isSelected = false
        }
    }
}



