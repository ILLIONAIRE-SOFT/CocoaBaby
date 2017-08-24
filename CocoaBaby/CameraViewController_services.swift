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
        self.cameraView.layer.addSublayer(self.weekUILabel.layer)

        self.weekUILabel.text = "WEEK \(BabyStore.shared.getPregnantWeek().week)"
        self.weekUILabel.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 40 )
        self.weekUILabel.textAlignment = .left
        self.weekUILabel.textColor = UIColor.white
        
        let labelWidth : CGFloat = self.weekUILabel.intrinsicContentSize.width
        let labelHeight : CGFloat = self.weekUILabel.intrinsicContentSize.height
        let labelPointX : CGFloat = margin
        let labelPointY : CGFloat = margin
        
        self.weekUILabel.layer.frame = CGRect(x: labelPointX, y: labelPointY, width: labelWidth, height: labelHeight)
    }
    
    func updateSeperateLine() {
        self.separateLine.backgroundColor = .white
        
        let separateLineWidth : CGFloat = self.weekUILabel.intrinsicContentSize.width
        let separateLineHeight : CGFloat = 1
        
        let separateLinePointX : CGFloat = margin
        let separateLinePointY : CGFloat = margin + weekUILabel.layer.frame.height
        
        self.separateLine.frame = CGRect(x: separateLinePointX, y: separateLinePointY, width: separateLineWidth, height: separateLineHeight)
        
        self.cameraView.layer.addSublayer(self.separateLine.layer)
    }
    
    func updateBabyNameLabel() {
        self.cameraView.layer.addSublayer(self.babyNameUILabel.layer)

        self.babyNameUILabel.text = "\(BabyStore.shared.getName())"
        self.babyNameUILabel.font = UIFont(name:"AppleSDGothicNeo-Light", size: 18)
        self.babyNameUILabel.textAlignment = .left
        self.babyNameUILabel.textColor = UIColor.white
        
        let babyLabelWidth : CGFloat = self.babyNameUILabel.intrinsicContentSize.width
        let babyLabelHeight : CGFloat = self.babyNameUILabel.intrinsicContentSize.height
        
        let babyLabelPointX : CGFloat = margin
        let babyLabelPointY : CGFloat = margin + weekUILabel.layer.frame.height + 10
        
        self.babyNameUILabel.layer.frame = CGRect(x: babyLabelPointX, y: babyLabelPointY, width: babyLabelWidth, height: babyLabelHeight)
    }
    
    
}

