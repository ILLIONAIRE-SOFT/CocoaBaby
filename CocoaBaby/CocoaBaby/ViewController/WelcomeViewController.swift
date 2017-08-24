//
//  WelcomeViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 22/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit

class WelcomeViewController: BaseViewController {

    @IBOutlet weak var startBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        
        self.startBtn.layer.cornerRadius = 15
        self.startBtn!.layer.borderColor = UIColor.white.withAlphaComponent(1.0).cgColor
        self.startBtn.layer.borderWidth = 1.0

    }
    
}
