//
//  HomeViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 02/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var babyView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dDayLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BabyStore.shared.loadBaby()
        
       
        updateBabyInfo()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
         updateBabyView()
        
        if BabyStore.shared.baby == nil {
            let tutorialStoryboard = UIStoryboard(name: "Tutorial", bundle: nil)
            let viewController = tutorialStoryboard.instantiateViewController(withIdentifier: "tutorialNavigationViewController")
            present(viewController, animated: false, completion: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func updateBabyInfo() {
        
        self.nameLabel.text = BabyStore.shared.getName()
        self.dDayLabel.text = "D-\(BabyStore.shared.getDday())"
        self.infoLabel.text = "1주차에는 5대 영양소를 골고루!"
    }
    
    private func updateBabyView() {
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Gradation2")!)
        babyView.layer.cornerRadius = babyView.frame.width/2
    }
    
}
