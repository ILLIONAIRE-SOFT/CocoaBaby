//
//  EditBabyNameTableViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 23/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit

class EditBabyNameTableViewController: BaseTableViewController {

    @IBOutlet var babyNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "Gradation2")!)
        
        initViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateOriginName()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let gender = UserStore.shared.user?.gender, gender == Gender.female {
            babyNameField.becomeFirstResponder()
        }
    }
    
    // MARK: - Methods
    func initViews() {
        
        if let gender = UserStore.shared.user?.gender, gender == Gender.female {
            let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(updateBabyName))
            
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
        } else {
            babyNameField.isUserInteractionEnabled = false
        }
    }
    
    func updateBabyName() {
        
        guard let name = babyNameField.text, name != "" else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        let baby = Baby(name: name, birthDate: BabyStore.shared.baby.birthDate, pregnantDate: BabyStore.shared.baby.pregnantDate)
        
        BabyStore.shared.updateBaby(baby: baby) { (_) in
            self.showSuccessToastMessage()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func updateOriginName() {
        if let baby = BabyStore.shared.baby {
            babyNameField.text = baby.name
        }
    }

}
