//
//  CameraViewController_services.swift
//
//  Created by LEOFALCON on 2017. 8. 6..
//  Copyright © 2017년 LeFal. All rights reserved.
//

import UIKit
import AVFoundation

extension CameraViewController {
    
    @IBAction func activateFlash(_ sender: Any) {
        if captureDevice!.hasTorch {
            do {
                try captureDevice!.lockForConfiguration()
                captureDevice?.torchMode = captureDevice!.isTorchActive ? .off : .on
                
                captureDevice!.unlockForConfiguration()
            } catch { }
        }
    }
    
    func updateWeekLabel() {
        self.weekUILabel.text = "Week \(BabyStore.shared.getPregnantWeek().week)"
        self.weekUILabel.font = UIFont(name: "Helvetica Neue", size: 13)
        self.weekUILabel.textAlignment = .center
        self.weekUILabel.layer.backgroundColor = UIColor.white.withAlphaComponent(0.7).cgColor
        
        let labelWidth : CGFloat = self.weekUILabel.intrinsicContentSize.width + self.cameraView.frame.width/10
        let labelHeight : CGFloat = self.weekUILabel.intrinsicContentSize.height * 1.7
        
        let labelPointX : CGFloat = self.cameraView.frame.width/2 - labelWidth/2
        let labelPointY : CGFloat = self.cameraView.frame.height/40
        
        
        let point = CGPoint(x: labelPointX, y: labelPointY)
        let size = CGSize(width: labelWidth, height: labelHeight)
        
        self.weekUILabel.layer.cornerRadius = labelHeight/2
        
        self.weekUILabel.layer.frame = CGRect(origin: point , size: size)
        self.cameraView.layer.addSublayer(self.weekUILabel.layer)
    }
    
}

