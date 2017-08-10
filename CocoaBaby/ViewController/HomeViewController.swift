//
//  HomeViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 02/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit
import CloudKit
//import EasyAnimation

class HomeViewController: BaseViewController {
    
    @IBOutlet var babyImageView: UIImageView!
    @IBOutlet var babyView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dDayLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var weekLabel: UILabel!
    @IBOutlet weak var waterDrop: UIView!
    @IBOutlet weak var waterDropTwo: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        babyImageView.image = UIImage(named: "CocoaBaby")?.withRenderingMode(.alwaysTemplate)
        babyImageView.tintColor = UIColor.mainBlueColor
        //EasyAnimation.enable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateBabyInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateBabyView()
        
        print(CKShareMetadata())
        
        if BabyStore.shared.baby == nil {
            let tutorialStoryboard = UIStoryboard(name: "Tutorial", bundle: nil)
            let viewController = tutorialStoryboard.instantiateViewController(withIdentifier: "tutorialNavigationViewController")
            present(viewController, animated: false, completion: nil)
        }
        
<<<<<<< HEAD
        FirebaseDataController.shared.saveUser()
        
        // MARK: WaterDropOne
        waterDrop.layer.cornerRadius = 5
        // position
        UIView.animate(withDuration: 5.0) {
            self.waterDrop.layer.position.y = -200.0
           // self.waterDrop.layer.position.x =
        }
        // alpha
        UIView.animate(withDuration: 12, animations: {
            self.waterDrop.alpha = 1.0
           // self.waterd
        })
        UIView.animate(withDuration: 12, animations: {
            self.waterDrop.alpha = 1.0
        })
        UIView.animate(withDuration: 2, animations: {
            self.waterDrop.alpha = 0.0
        })
        
        // MARK: WaterDropTwo
        waterDropTwo.layer.cornerRadius = 3
        // position
        
        UIView.animate(withDuration: 3.0) {
            UIView.setAnimationDelay(1.0)
            self.waterDropTwo.layer.position.y = -200.0
            // self.waterDrop.layer.position.x =
        }
        // alpha
        UIView.animate(withDuration: 16, animations: {
          // UIView.setAnimationDelay(1.0)
            self.waterDropTwo.alpha = 1.0
            // self.waterd
        })
        UIView.animate(withDuration: 16, animations: {
           // UIView.setAnimationDelay(1.0)
            self.waterDropTwo.alpha = 1.0
        })
        UIView.animate(withDuration: 2, animations: {
            UIView.setAnimationDelay(1.0)
            self.waterDropTwo.alpha = 0.0
        })

=======
//        FirebaseDataController.shared.saveUser()
//        FirebaseDataController.shared.saveDiary(year: 2017, month: 8, day: 9)
//        FirebaseDataController.shared.fetchDiaries(year: 2017, month: 8) { (_) in
        
//        }
>>>>>>> e0f32d94cd1996a40478f475f48cafed5c78b6e4
    }
    
    
    
    // MARK: - Methods
    private func updateBabyInfo() {
        self.nameLabel.text = BabyStore.shared.getName()
        let dDay = BabyStore.shared.getDday()
        self.dDayLabel.text = "D\(dDay.mark)\(dDay.value)"
        self.infoLabel.text = "1주차에는 5대 영양소를 골고루!"
        self.weekLabel.text = "Week \(BabyStore.shared.getPregnantWeek().week)"
    }
    
    private func updateBabyView() {
        babyView.layer.cornerRadius = babyView.frame.width/2
    }
    
   

}
