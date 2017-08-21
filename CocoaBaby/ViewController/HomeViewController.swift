//
//  HomeViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 02/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit
import CloudKit
import WaterDrops

class HomeViewController: BaseViewController {
    

    @IBOutlet weak var bgView: UIImageView!
    @IBOutlet var babyImageView: UIImageView!
    @IBOutlet var babyView: BabyView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dDayLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var weekLabel: UILabel!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var captureScreenButton: UIButton!
    
    var waterDropsView : WaterDropsView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        babyImageView.image = UIImage(named: "CocoaBaby")?.withRenderingMode(.alwaysTemplate)
        babyImageView.tintColor = UIColor.mainBlueColor
        
        changeBg()
        
        let waterDropsViewFrame = CGRect(x: 0, y: 0, width: self.babyView.frame.width, height: self.babyView.frame.height)

        waterDropsView = WaterDropsView(frame: waterDropsViewFrame,
                                            direction: .up,
                                            dropNum: 10,
                                            color: UIColor.init(colorWithHexValue: 0xFFFFFF, alpha: 0.6),
                                            minDropSize: 4,
                                            maxDropSize: 10,
                                            minLength: 40,
                                            maxLength: 270,
                                            minDuration: 8,
                                            maxDuration: 14)
        waterDropsView?.addAnimation()
        self.waterDropsView?.isUserInteractionEnabled = false
        self.babyView.addSubview(waterDropsView!)
        
        babyImageView.image = UIImage(named: "CocoaBaby")?.withRenderingMode(.alwaysTemplate)
        babyImageView.tintColor = UIColor.mainBlueColor
        self.beginBabyAnimation()

        updateBabyInfo()
        updateInfoLabel(week: BabyStore.shared.getPregnantWeek().week)
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
    
    @IBAction func captureScreen() {
        //Create the UIImage
        self.cameraButton.isHidden = true
        self.captureScreenButton.isHidden = true
        
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 0)
        self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        self.cameraButton.isHidden = false
        self.captureScreenButton.isHidden = false
    }

    // MARK: - Actions
    
    @IBAction func presentCameraView() {
        let cameraSB = UIStoryboard(name: "Camera", bundle: nil)
        let viewController = cameraSB.instantiateViewController(withIdentifier: "CameraViewController")
        
        self.present(viewController, animated: true, completion: nil)
    }
    @IBAction func showBalloon() {
        
        
        babyImageView.clipsToBounds = false
        
        let babySay = "엄마, 보고싶어요!\n두줄이면 어떻게?"
        
        let babySayLabel = UILabel()
        babySayLabel.text = babySay
        babySayLabel.textAlignment = .center
        babySayLabel.font = UIFont(name: "Helvetica Neue", size: 11)
        babySayLabel.numberOfLines = 0
        
        babySayLabel.frame = CGRect(x: 0, y: 0, width: babyImageView.frame.width * 0.85, height: babyImageView.frame.height * 0.22)
        let arrow = UIView(frame: CGRect(x: babySayLabel.frame.width/2, y: babySayLabel.frame.height - 10, width: 20, height: 20))
        
        babySayLabel.backgroundColor = .white
        arrow.backgroundColor = .white
        
        babySayLabel.layer.masksToBounds = true
        babySayLabel.layer.cornerRadius = babySayLabel.frame.height/2
        arrow.layer.cornerRadius = 15
        
        babySayLabel.alpha = 0
        arrow.alpha = 0
        
        
        babyImageView.addSubview(babySayLabel)
        babyImageView.addSubview(arrow)
        
        UIView.animate(withDuration: 2, animations: {
            babySayLabel.alpha = 1
            arrow.alpha = 1
        }) { (isCompleted) in
            UIView.animate(withDuration: 2
                , delay : 1, animations: {
                    babySayLabel.alpha = 0
                    arrow.alpha = 0
            })
        }

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
    
    func changeBg() {
        
        let date = Date()
        let currentHour = Calendar.current.component(.hour, from: date)
        if currentHour > 19 || currentHour < 6 { //Night
            
            UIGraphicsBeginImageContext(self.view.frame.size)
            UIImage(named: "cocoaBabyBgNight")?.draw(in: self.view.bounds)

            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
            
            
        } else if currentHour >= 6 && currentHour <= 16{ //morning
            UIGraphicsBeginImageContext(self.view.frame.size)
            UIImage(named: "cocoaBabyBgNormal")?.draw(in: self.view.bounds)
            
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
            
            //self.babyView.backgroundColor = UIColor.init(colorWithHexValue: 0x000000, alpha: 0.7)

        } else if currentHour >= 16 && currentHour <= 19 {
            UIGraphicsBeginImageContext(self.view.frame.size)
            UIImage(named: "cocoaBabyBgAfternoon")?.draw(in: self.view.bounds)
            
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
            
        } else {
            UIGraphicsBeginImageContext(self.view.frame.size)
            UIImage(named: "cocoaBabyBgNormal")?.draw(in: self.view.bounds)
            
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
            
            //self.babyView.backgroundColor = UIColor.init(colorWithHexValue: 0x000000, alpha: 0.7)
        }
        
    }
    
}



class BabyView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.frame.width/2
    }
    
}

