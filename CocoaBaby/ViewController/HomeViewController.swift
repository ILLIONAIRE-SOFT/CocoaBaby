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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       // updateBabyView()
        //updateBabyInfo()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BabyStore.shared.loadBaby()
        
        if BabyStore.shared.baby == nil {
            let tutorialStoryboard = UIStoryboard(name: "Tutorial", bundle: nil)
            let viewController = tutorialStoryboard.instantiateViewController(withIdentifier: "tutorialNavigationViewController")
            self.present(viewController, animated: false, completion: nil)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func updateBabyInfo() {
    
        self.nameLabel.text = BabyStore.shared.getName()
        self.dDayLabel.text = "D-\(BabyStore.shared.getDday())"
    
    }
    
    private func updateBabyView() {
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "HomeGradation")!)
        babyView.layer.cornerRadius = babyView.frame.width/2
    }
    
}
