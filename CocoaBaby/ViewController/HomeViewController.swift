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
    
    // 말풍선 만들기 위한 뷰
    @IBOutlet var babyAroundView: UIView!
    @IBOutlet var speechBubble: UIImageView!
    var isSpeechBubbleAnimated : Bool = false
    @IBOutlet var speechBubbleLabel: UILabel!
    @IBOutlet weak var popSpeechBubble: UIButton!
    

    var waterDropsView : WaterDropsView?
    var backgroundImageName: String = "cocoaBabyBgNormal"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocalization()
        speechBubble.alpha = 0
        speechBubbleLabel.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        babyImageView.image = setBabyImage(week: BabyStore.shared.getPregnantWeek().week).withRenderingMode(.alwaysTemplate)
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
    // 만약 Info 가 없으면 여기서 처음으로 업데이트
    
    
    private func updateInfoLabel(week: Int) {
        if InfosStore.shared.Infos == nil {
            InfosStore.shared.fetchInfos(completion: { (infos) in
                if let babyInfos = infos?[week]?.babyInfos {
                    let randomNum = arc4random_uniform(UInt32(babyInfos.count))
                    self.infoLabel.text = babyInfos[Int(randomNum)]
                }
            })
        } else {
            if let babyInfos = InfosStore.shared.Infos[week]?.babyInfos {
                let randomNum = arc4random_uniform(UInt32(babyInfos.count))
                self.infoLabel.text = babyInfos[Int(randomNum)]
            }
        }
    }
    
    // 지역설정이 한국이나 언어설정이 한국어가 아니면 말풍선이랑 인포 라벨빼도록
    func checkLocalization()  {
        guard Locale.current.languageCode == "ko" || Locale.current.regionCode == "KR" else {
            infoLabel.isHidden = true
            popSpeechBubble.isEnabled = false
            popSpeechBubble.isHidden = true
            return
        }
    }
    
    @IBAction func captureScreen() {
        //Create the UIImage
        self.cameraButton.isHidden = true
        self.captureScreenButton.isHidden = true
        
        
        // make rectangle size image
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 0)
        self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // make square size image
        self.view.backgroundColor = UIColor.clear
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 0)
        self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let backgroundClearImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let backgroundView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.height, height: self.view.frame.height))
        
        let imageName = "\(backgroundImageName)Square"
        backgroundView.image = UIImage(named: imageName)
        
        let imageView = UIImageView(image: backgroundClearImage)
        imageView.frame = CGRect(x: backgroundView.frame.width/2 - self.view.frame.width/2, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        backgroundView.addSubview(imageView)
        
        UIGraphicsBeginImageContextWithOptions(backgroundView.frame.size, false, 0)
        backgroundView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let squareImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.captureScreenButton.isHidden = false
        self.cameraButton.isHidden = false
        self.changeBg()

        // present action Sheet
        
        let actionSheet = UIAlertController(title: LocalizableString.captureBabyTitle, message: nil, preferredStyle: .actionSheet)
        let captureRectangle = UIAlertAction(title: LocalizableString.captureRectangle, style: .default) { _ -> Void in
            self.captureAnimataion(completion: {
                if let image = image {
                    ShareImageService.showShareViewController(presentViewController: self, image: image)
                }
            })
        }
        let captureSquare = UIAlertAction(title: LocalizableString.captureSquare, style: .default) { _ -> Void in
            self.captureAnimataion(completion: {
                if let squareImage = squareImage {
                    ShareImageService.showShareViewController(presentViewController: self, image: squareImage)
                }
            })
        }
        let cancel = UIAlertAction(title: LocalizableString.cancel, style: .cancel, handler: nil)
        
        actionSheet.addAction(captureRectangle)
        actionSheet.addAction(captureSquare)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }

    func captureAnimataion(completion : @escaping () -> ())  {
        let captureWhiteView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        captureWhiteView.backgroundColor = .white
        self.view.addSubview(captureWhiteView)
        captureWhiteView.isHidden = false
        UIView.animate(withDuration: 1.2, animations: {
            captureWhiteView.alpha = 0
        }) { (isCompleted) in
            captureWhiteView.isHidden = true
            completion()
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func presentCameraView() {
        let cameraSB = UIStoryboard(name: "Camera", bundle: nil)
        let viewController = cameraSB.instantiateViewController(withIdentifier: "CameraViewController")
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func showBalloon() {
        
        self.popSpeechBubble.isUserInteractionEnabled = false
        
        let moveRangeX = self.babyAroundView.frame.width/5
        let moveRangeY = 15
        
        let randomX = arc4random_uniform(UInt32(moveRangeX))
        let randomY = arc4random_uniform(UInt32(moveRangeY))
        
        let babyWeek = BabyStore.shared.getPregnantWeek().week
        
        guard let babySpeechTexts = InfosStore.shared.Infos[babyWeek]?.babySpeech else { return }
        
        let randomSpeechNum = arc4random_uniform(UInt32(babySpeechTexts.count))
        
        
        speechBubbleLabel.text = babySpeechTexts[Int(randomSpeechNum)]
        
        // 애니메이션이 진행중이 아닐때만 동작할수 있도록
        if !isSpeechBubbleAnimated {
            isSpeechBubbleAnimated = true
            
            // 랜덤만큼 프레임을 옮긴 뒤에
            self.speechBubble.frame.origin.x += CGFloat(randomX)
            self.speechBubble.frame.origin.y += (CGFloat(randomY) - 15)
            self.speechBubbleLabel.frame.origin.x += CGFloat(randomX)
            self.speechBubbleLabel.frame.origin.y += (CGFloat(randomY) - 15)

            
            UIView.animate(withDuration: 1, animations: {
                // 알파값을 1로 만들어주고
                self.speechBubble.alpha = 1
                self.speechBubbleLabel.alpha = 1
            }) { (isCompleted) in
                UIView.animate(withDuration: 2, delay: 2, animations: {
                    // 1초가 기다린뒤 다시 알파를 0으로 만들어준다
                    self.speechBubble.alpha = 0
                    self.speechBubbleLabel.alpha = 0
                }, completion: { (isCompeted) in
                    // 그리고 다시 프레임을 원래 위치로 돌려놓는다.
                    self.speechBubble.frame.origin.x -= CGFloat(randomX)
                    self.speechBubble.frame.origin.y -= (CGFloat(randomY) - 15)
                    self.speechBubbleLabel.frame.origin.x -= CGFloat(randomX)
                    self.speechBubbleLabel.frame.origin.y -= (CGFloat(randomY) - 15)

                    self.isSpeechBubbleAnimated = false
                     self.popSpeechBubble.isUserInteractionEnabled = true
                })
            }
        }
    }
    
    func beginBabyAnimation () {
        UIImageView.animate(withDuration: 8.0, delay:0, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
            UIImageView.setAnimationRepeatCount(20)
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
            backgroundImageName = "cocoaBabyBgNight"
            
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        } else if currentHour >= 6 && currentHour < 16{ //morning
            UIGraphicsBeginImageContext(self.view.frame.size)
            UIImage(named: "cocoaBabyBgNormal")?.draw(in: self.view.bounds)
            backgroundImageName = "cocoaBabyBgNormal"
            
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
            
        } else if currentHour >= 16 && currentHour <= 19 {
            UIGraphicsBeginImageContext(self.view.frame.size)
            UIImage(named: "cocoaBabyBgAfternoon")?.draw(in: self.view.bounds)
            backgroundImageName = "cocoaBabyBgAfternoon"
            
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
            
        } else {
            UIGraphicsBeginImageContext(self.view.frame.size)
            UIImage(named: "cocoaBabyBgNormal")?.draw(in: self.view.bounds)
            
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        }
    }
    
    func setBabyImage(week : Int) -> UIImage {
        if BabyStore.shared.baby.birthDate < Date().timeIntervalSince1970 {
            self.speechBubble.isHidden = true
            self.popSpeechBubble.isEnabled = false
            return UIImage(named: "babyweekBorn")!
        }

        switch week {
        case -100...1:
            return UIImage(named: "babyweek0")!
        case 2:
            return UIImage(named: "babyweek2")!
        case 3:
            return UIImage(named: "babyweek3")!
        case 4:
            return UIImage(named: "babyweek4")!
        case 5...6:
            return UIImage(named: "babyweek5")!
        case 7...8:
            return UIImage(named: "babyweek7")!
        case 9...10:
            return UIImage(named: "babyweek9")!
        case 11...12:
            return UIImage(named: "babyweek11")!
        case 13...15:
            return UIImage(named: "babyweek13")!
        case 16...17:
            return UIImage(named: "babyweek16")!
        case 18...23:
            return UIImage(named: "babyweek18")!
        case 24...27:
            return UIImage(named: "babyweek24")!
        case 28...29:
            return UIImage(named: "babyweek28")!
        case 30...100:
            return UIImage(named: "babyweek30")!
        default:
            break
        }
        return UIImage(named: "babyweek13")!
    }

}

class BabyView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.frame.width/2
    }
}

