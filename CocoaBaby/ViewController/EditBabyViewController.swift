//
//  EditBabyViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 08/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit

class EditBabyViewController: BaseViewController {
    
    @IBOutlet var nameField: UITextField!
    
    var name: String? = nil
    var pregnantDate: Date? = nil
    var birthDate: Date? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.returnKeyType = .done
        nameField.delegate = self
        
        initGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.placeholder = BabyStore.shared.getName()
    }
    
    func initGesture() {
        let tapView = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        self.view.addGestureRecognizer(tapView)
    }
    
    // MARK: Methods
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: IBActions
    @IBAction func tappedSave(_ sender: UIButton) {
        
        if let nameFieldText = nameField.text {
            if nameFieldText != "" {
                name = nameFieldText
            } else {
                name = nil
            }
        }
        
        BabyStore.shared.updateBaby(name: name, pregnantDate: pregnantDate, birthDate: birthDate) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension EditBabyViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
