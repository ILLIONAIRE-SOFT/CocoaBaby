//
//  SettingsViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 04/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

    @IBOutlet var editBabyButton: UIButton!
    @IBOutlet var dataBackupButton: UIButton!
    @IBOutlet var sendEmailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    func initViews() {
        editBabyButton.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        editBabyButton.layer.cornerRadius = 16
        
        dataBackupButton.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        dataBackupButton.layer.cornerRadius = 16
        
        sendEmailButton.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        sendEmailButton.layer.cornerRadius = 16
    }
    
}
