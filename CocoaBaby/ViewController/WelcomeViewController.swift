//
//  WelcomeViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 22/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit
import WaterDrops

class WelcomeViewController: BaseViewController {

    @IBOutlet weak var startBtn: UIButton!
    var waterDropsView : WaterDropsView?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        
        self.startBtn.layer.cornerRadius = 15
        self.startBtn!.layer.borderColor = UIColor.white.withAlphaComponent(1.0).cgColor
        self.startBtn.layer.borderWidth = 1.0

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let waterDropsViewFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        waterDropsView = WaterDropsView(frame: waterDropsViewFrame,
                                        direction: .down,
                                        dropNum:100,
                                        color: UIColor.init(colorWithHexValue: 0xFFFFFF, alpha: 0.8),
                                        minDropSize: 2,
                                        maxDropSize: 6,
                                        minLength: 80,
                                        maxLength: 500,
                                        minDuration: 3,
                                        maxDuration: 6)
        
        waterDropsView?.addAnimation()
        self.waterDropsView?.isUserInteractionEnabled = false
        self.view.addSubview(waterDropsView!)
    }
    
}

