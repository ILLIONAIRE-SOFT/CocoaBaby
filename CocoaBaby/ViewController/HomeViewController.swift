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
                                          color: UIColor.red,
                                          minDropSize: 5,
                                          maxDropSize: 10,
                                          minLength: 30,
                                          maxLength: 100,
                                          minDuration: 3,
                                          maxDuration: 5)
        self.babyView.addSubview(waterDropView)

        
        babyImageView.image = UIImage(named: "CocoaBaby")?.withRenderingMode(.alwaysTemplate)
        babyImageView.tintColor = UIColor.mainBlueColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateBabyInfo()
        updateInfoLabel(week: BabyStore.shared.getPregnantWeek().week)
<<<<<<< HEAD
        
        let waterDropView = WaterDropView(frame: self.babyView.frame,
                                          direction: .up,
                                          waterDropNum: 10,
                                          color: UIColor(colorWithHexValue: 0xE3BCC3, alpha: 0.7),
                                          minDropSize: 5,
                                          maxDropSize: 10,
                                          minLength: 0,
                                          maxLength: 100,
                                          minDuration: 3,
                                          maxDuration: 5)
        self.view.addSubview(waterDropView)

=======
>>>>>>> 7d66847d53f539aa7f8b69700f3ab283a703051e
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
    
}


class BabyView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.frame.width/2
    }
    
}
