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
        
       // BabyStore.shared.registerBaby(from: Date(), to: Date(), name: "dadong")
        BabyStore.shared.loadBaby()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        updateBabyView()
        updateBabyInfo()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateBabyInfo() {
    
        self.nameLabel.text = BabyStore.shared.getName()
        self.dDayLabel.text = "D-\(BabyStore.shared.getDday())"
    
    }
    
    private func updateBabyView() {
        
        babyView.layer.cornerRadius = 64
    }
    
}
