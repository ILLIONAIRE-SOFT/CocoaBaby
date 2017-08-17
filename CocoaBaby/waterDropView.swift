//
//  waterDropView.swift
//  CocoaBaby
//
//  Created by LEOFALCON on 2017. 8. 16..
//  Copyright © 2017년 Sohn. All rights reserved.
//

import Foundation
import UIKit

class WaterDropView: UIView {
    
    convenience init(frame: CGRect, direction: WaterDirection, waterDropNum: Int, color: UIColor,minDropSize : CGFloat, maxDropSize: CGFloat, minLength: CGFloat, maxLength: CGFloat, minDuration : TimeInterval,maxDuration : TimeInterval) {
        self.init(frame: frame)
        let config = ViewConfig(color: color, minDropSize: minDropSize, maxDropSize: maxDropSize, minLength: minLength, maxLength: maxLength, minDuration: minDuration, maxDuration: maxDuration)
        
        if direction == WaterDirection.up {
            makeUpRandomWaterDrops(num: waterDropNum, config: config)
        } else {
            makeDownRandomWaterDrops(num: waterDropNum, config: config)
        }
        
    }
    
    private func makeDownRandomWaterDrops(num : Int, config : ViewConfig) {
        for _ in 1...num {
            downRandomWaterDrop(config: config)
        }
    }
    
    private func makeUpRandomWaterDrops(num : Int, config : ViewConfig) {
        for _ in 1...num {
            upRandomWaterDrop(config: config)
        }
    }
    
    
    private func downRandomWaterDrop(config : ViewConfig) {
        let randomX: CGFloat = CGFloat(arc4random_uniform(UInt32(self.frame.width)))
        let randomSize: CGFloat = CGFloat(arc4random_uniform(UInt32(config.maxDropSize - config.minDropSize))) + config.minDropSize
        let randomDuration: TimeInterval = TimeInterval(arc4random_uniform(UInt32(config.maxDuration - config.minDuration))) + config.minDuration
        
        let randomIncrease: CGFloat =  CGFloat(arc4random_uniform(UInt32(config.maxLength - config.minLength))) + config.minLength
        
        
        let waterDrop = UIView(frame: CGRect(x: randomX, y: 0, width: randomSize, height: randomSize))
        waterDrop.backgroundColor = config.color
        waterDrop.layer.cornerRadius = randomSize/2
        
        self.addSubview(waterDrop)
        
        // position
        UIView.animate(withDuration: randomDuration, animations: {
            waterDrop.frame.origin.y += randomIncrease
            waterDrop.alpha = 0.0
        }, completion: { (Bool) -> Void in
            waterDrop.removeFromSuperview()
            self.downRandomWaterDrop(config: config)
        })
    }
    
    private func upRandomWaterDrop(config : ViewConfig) {
        let randomX: CGFloat = CGFloat(arc4random_uniform(UInt32(self.frame.width)))
        let randomSize: CGFloat = CGFloat(arc4random_uniform(UInt32(config.maxDropSize - config.minDropSize))) + config.minDropSize
        let randomDuration: TimeInterval = TimeInterval(arc4random_uniform(UInt32(config.maxDuration - config.minDuration))) + config.minDuration
        
        let randomDecrease: CGFloat =  CGFloat(arc4random_uniform(UInt32(config.maxLength - config.minLength))) + config.minLength
        
        let waterDrop = UIView(frame: CGRect(x: randomX, y: self.frame.height, width: randomSize, height: randomSize))
        waterDrop.backgroundColor = config.color
        waterDrop.layer.cornerRadius = randomSize/2
        
        self.addSubview(waterDrop)
        
        // position
        UIView.animate(withDuration: randomDuration, animations: {
            waterDrop.frame.origin.y -= randomDecrease
            waterDrop.alpha = 0.0
        }, completion: { (Bool) -> Void in
            waterDrop.removeFromSuperview()
            self.upRandomWaterDrop(config: config)
        })
    }
    
    struct ViewConfig {
        let color : UIColor
        let minDropSize : CGFloat
        let maxDropSize: CGFloat
        let minLength : CGFloat
        let maxLength : CGFloat
        let minDuration : TimeInterval
        let maxDuration : TimeInterval
    }
    
}

enum WaterDirection {
    case up
    case down
}

