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
        let waterDropViewFrame = CGRect(x: 0, y: 0, width: self.babyView.frame.width, height: self.babyView.frame.height)
        
        let waterDropView = WaterDropView(frame: waterDropViewFrame,
                                          direction: .up,
                                          waterDropNum: 10,
                                          color: UIColor.init(colorWithHexValue: 0xFFFFFF, alpha: 0.6),
                                          minDropSize: 4,
                                          maxDropSize: 10,
                                          minLength: 40,
                                          maxLength: 270,
                                          minDuration: 8,
                                          maxDuration: 14)
        self.babyView.addSubview(waterDropView)
        
        babyImageView.image = UIImage(named: "CocoaBaby")?.withRenderingMode(.alwaysTemplate)
        babyImageView.tintColor = UIColor.mainBlueColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateBabyInfo()
        updateInfoLabel(week: BabyStore.shared.getPregnantWeek().week)
        self.beginBabyAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
    
    // MARK: - Actions
    
    @IBAction func presentCameraView() {
        let cameraSB = UIStoryboard(name: "Camera", bundle: nil)
        let viewController = cameraSB.instantiateViewController(withIdentifier: "CameraViewController")
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    
    func beginBabyAnimation () {
        UIImageView.animate(withDuration: 8.0, delay:0, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
            UIImageView.setAnimationRepeatCount(10)
            self.babyImageView.transform = CGAffineTransform(translationX: -12, y: -7)
            self.babyImageView.transform = CGAffineTransform.identity.rotated(by: 0.3)
            
        }, completion: {completion in
            self.babyImageView.transform = CGAffineTransform(translationX: 14, y: 8)
        })
        
    }
    
}



class BabyView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.frame.width/2
    }
    
}

