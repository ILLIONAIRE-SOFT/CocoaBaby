//
//  HomeViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 02/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit
import CloudKit

class HomeViewController: BaseViewController {
    
    @IBOutlet var babyImageView: UIImageView!
    @IBOutlet var babyView: BabyView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dDayLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var weekLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        babyImageView.image = UIImage(named: "CocoaBaby")?.withRenderingMode(.alwaysTemplate)
        babyImageView.tintColor = UIColor.mainBlueColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateBabyInfo()
        updateInfoLabel(week: BabyStore.shared.getPregnantWeek().week)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

     animateRandomWaterDrop(num: 10)
//        
//        // WaterDropThree
//        var waterDropThree = UIView(frame: CGRect(x: 170, y: 480, width: 8, height: 8))
//        waterDropThree.backgroundColor = UIColor.init(colorWithHexValue: 0xE3BCC3, alpha: 1)
//        waterDropThree.layer.cornerRadius = 4
//        
//        self.view.addSubview(waterDropThree)
//        // position
//        UIView.animate(withDuration: 3, delay: 1.5, options: [.repeat], animations: {
//            
//            waterDropThree.frame.origin.y = 400
//            waterDropThree.alpha = 1.0
//            waterDropThree.alpha = 0.0
//            
//        }, completion: nil)
//
//        
//        // WaterDropfour
//        var waterDropfour = UIView(frame: CGRect(x: 200, y: 480, width: 5, height: 5))
//        waterDropfour.backgroundColor = UIColor.init(colorWithHexValue: 0xE3BCC3, alpha: 1)
//        waterDropfour.layer.cornerRadius = 2
//        
//        self.view.addSubview(waterDropfour)
//        // position
//        UIView.animate(withDuration: 5, delay: 0.5, options: [.repeat], animations: {
//            
//            waterDropfour.frame.origin.y = 400
//            waterDropfour.alpha = 1.0
//            waterDropfour.alpha = 0.0
//            
//        }, completion: nil)
//        
//        // WaterDropfive
//        var waterDropfive = UIView(frame: CGRect(x: 240, y: 470, width: 6, height: 6))
//        waterDropfive.backgroundColor = UIColor.init(colorWithHexValue: 0xE3BCC3, alpha: 1)
//        waterDropfive.layer.cornerRadius = 3
//        
//        self.view.addSubview(waterDropfive)
//        // position
//        UIView.animate(withDuration: 4, delay: 0.5, options: [.repeat], animations: {
//            
//            waterDropfive.frame.origin.y = 340
//            waterDropfive.alpha = 1.0
//            waterDropfive.alpha = 0.0
//            
//        }, completion: nil)
    }
    
    // MARK: - Methods
    private func updateBabyInfo() {
        self.nameLabel.text = BabyStore.shared.getName()
        let dDay = BabyStore.shared.getDday()
        self.dDayLabel.text = "D\(dDay.mark)\(dDay.value)"
        
        let week = BabyStore.shared.getPregnantWeek().week
        
        updateInfoLabel(week: week)
        self.weekLabel.text = "Week \(week)"
    }
    
    
    // Info label content randomly
    // 만약 Tips 가 없으면 여기서 처음으로 업데이트
    
    
    private func updateInfoLabel(week: Int) {
        let randomNum = arc4random_uniform(2)
        if TipsStore.shared.Tips == nil {
            TipsStore.shared.fetchTips(completion: { (tips) in
                self.infoLabel.text = TipsStore.shared.Tips[week]?.babyTitle
            })
        }
        else if UserStore.shared.user?.gender == "female" {
            if randomNum == 1 {
                self.infoLabel.text = TipsStore.shared.Tips[week]?.babyTitle
            } else {
                self.infoLabel.text = TipsStore.shared.Tips[week]?.mamaTitle
            }
        } else {
            if randomNum == 1 {
                self.infoLabel.text = TipsStore.shared.Tips[week]?.babyTitle
            } else {
                self.infoLabel.text = TipsStore.shared.Tips[week]?.papaTitle
            }
        }
    }
    
    private func animateRandomWaterDrop (num : Int)  {
        
        for _ in 1...num {
//            let randomX: CGFloat = CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.width)))
//            let randomY: CGFloat =  CGFloat(arc4random_uniform(40))
            
            let randomX: CGFloat = CGFloat(arc4random_uniform(UInt32(babyView.bounds.width))) + CGFloat((self.babyView.frame.width)/4)
            let randomY: CGFloat = CGFloat(arc4random_uniform(UInt32(babyView.bounds.height))) + CGFloat(self.babyView.frame.height)
            let randomSize: CGFloat =  CGFloat(4) + CGFloat(arc4random_uniform(5))
            let randomDelay: TimeInterval = TimeInterval(1) + TimeInterval(arc4random_uniform(2))
            let randomDuration: TimeInterval = TimeInterval(7) + TimeInterval(arc4random_uniform(10)/2)
//            let randomDuration: TimeInterval = TimeInterval(0)
            let randomIncrease: CGFloat = CGFloat(arc4random_uniform(150))
            
            let waterDrop = UIView(frame: CGRect(x: randomX, y: randomY, width: randomSize, height: randomSize))
            waterDrop.backgroundColor = UIColor.init(colorWithHexValue: 0xE3BCC3, alpha: 0.7)
            waterDrop.layer.cornerRadius = randomSize/2
            
            self.view.addSubview(waterDrop)
            UIView.animate(withDuration: randomDuration, delay: randomDelay, options: [.repeat], animations: {
                
                waterDrop.alpha = 1.0
                
            }, completion: nil)
            
            // position
            UIView.animate(withDuration: randomDuration, delay: randomDelay, options: [.repeat], animations: {
                
                 waterDrop.frame.origin.y = randomY - (self.babyView.frame.height) - randomIncrease*4
                //waterDrop.frame.origin.y = randomY + randomIncrease
                waterDrop.alpha = 0.0
                
            }, completion: nil)
        }
    }

    
    // MARK: - Actions
    
    @IBAction func presentCameraView() {
        let cameraSB = UIStoryboard(name: "Camera", bundle: nil)
        let viewController = cameraSB.instantiateViewController(withIdentifier: "CameraViewController")
        
        self.present(viewController, animated: true, completion: nil)
        

    }

}


class BabyView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.frame.width/2
    }
    
}
