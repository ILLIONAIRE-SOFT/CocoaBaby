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
    
    @IBOutlet var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.returnKeyType = .done
        nameField.delegate = self
        
        self.saveButton.layer.cornerRadius = 4
        self.saveButton.backgroundColor = .white
        
        self.nameField.text = BabyStore.shared.baby.name
        
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
        print("tapped")
        if let nameFieldText = nameField.text {
            if nameFieldText != "" {
                name = nameFieldText
                let baby = Baby(name: name!, birthDate: BabyStore.shared.baby.birthDate, pregnantDate: BabyStore.shared.baby.pregnantDate)
                BabyStore.shared.updateBaby(baby: baby) { (_) in
                    self.showSuccessToastMessage()
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                name = nil
                let alertController = UIAlertController(title: nil, message: "태명이 유효하지 않습니다.", preferredStyle: .alert)
                let doneAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(doneAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
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
