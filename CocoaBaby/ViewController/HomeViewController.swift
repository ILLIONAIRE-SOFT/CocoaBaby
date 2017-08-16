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
    @IBOutlet weak var waterDrop: UIView!
    @IBOutlet weak var waterDropTwo: UIView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        babyImageView.image = UIImage(named: "CocoaBaby")?.withRenderingMode(.alwaysTemplate)
        babyImageView.tintColor = UIColor.mainBlueColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateBabyInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // MARK: WaterDropOne
        waterDrop.layer.cornerRadius = 5
        // position
        UIView.animate(withDuration: 5, delay: 0, options: [.repeat], animations: {
            self.waterDrop.frame.origin.y = 70
            self.waterDrop.alpha = 1.0
            self.waterDrop.alpha = 0.0
      
        }, completion: nil)
      
        // MARK: WaterDropTwo
        waterDropTwo.layer.cornerRadius = 3
        // position
        UIView.animate(withDuration: 5, delay: 1, options: [.repeat], animations: {
            self.waterDropTwo.frame.origin.y = 800
            self.waterDropTwo.alpha = 1.0
            self.waterDropTwo.alpha = 0.0
            
        }, completion: nil)
        
    }
    
    
    
    
    // MARK: - Methods
    private func updateBabyInfo() {
        self.nameLabel.text = BabyStore.shared.getName()
        let dDay = BabyStore.shared.getDday()
        self.dDayLabel.text = "D\(dDay.mark)\(dDay.value)"
        self.infoLabel.text = "1주차에는 5대 영양소를 골고루!"
        self.weekLabel.text = "Week \(BabyStore.shared.getPregnantWeek().week)"
    }

}

class BabyView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.frame.width/2
    }
    
}
