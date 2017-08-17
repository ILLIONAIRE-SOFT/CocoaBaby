//
//  EditBabyDateViewController.swift
//  CocoaBaby
//
//  Created by LEOFALCON on 2017. 8. 17..
//  Copyright © 2017년 Sohn. All rights reserved.
//

import UIKit

class EditBabyDateViewController: BaseViewController, UITextFieldDelegate {

    var babyName : String?
    var pregnantDate = Date()
    var birthDate = Date()
    
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    @IBOutlet var pregnantDateLabel: UILabel!
    @IBOutlet var birthDateLabel: UILabel!
    @IBOutlet weak var pregnantDateTextField: UITextField!
    @IBOutlet weak var birthDateTextField: UITextField!
    var datePicker : UIDatePicker!
    
    var dateFormatter = DateFormatter()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pregnantDateTextField.delegate = self
        self.birthDateTextField.delegate = self

        pregnantDate = Date(timeIntervalSince1970: BabyStore.shared.baby.pregnantDate)
        birthDate = Date(timeIntervalSince1970: BabyStore.shared.baby.birthDate)
        
        self.pregnantDateLabel.text = "임신 전 마지막 생리일" // localize 필요
        self.birthDateLabel.text = "출산 예정일" // localize 필요
        
        
        self.pregnantDateTextField.tintColor = .clear
        self.birthDateTextField.tintColor = .clear
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        
        self.pregnantDateTextField.text = dateFormatter.string(from: pregnantDate)
        self.birthDateTextField.text = dateFormatter.string(from: birthDate)

        self.registerButton.layer.cornerRadius = 4
        self.registerButton.backgroundColor = .white
        self.cancelButton.layer.cornerRadius = 4
        self.cancelButton.backgroundColor = .white
        
        pregnantDateTextField.setBottomBorder()
        birthDateTextField.setBottomBorder()
        
    }
    
    @IBAction func resignKeyBoard() {
        self.resignFirstResponder()
    }
    
    
    func pickUpDate(_ textField : UITextField){
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.date
        self.datePicker.minimumDate = Date.init(timeIntervalSinceNow: -60*60*24*100)
        self.datePicker.maximumDate = Date.init(timeIntervalSinceNow: 60*60*24*400)
        textField.inputView = self.datePicker
        
        if textField == pregnantDateTextField {
            self.datePicker.setDate(pregnantDate, animated: false)
        } else {
            self.datePicker.setDate(birthDate, animated: false)
        }
        
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    //
    // Mark : relate to date Picker
    //
    
    func doneClick() {
        if pregnantDateTextField.isFirstResponder {
            
            pregnantDateTextField.text = dateFormatter.string(from: datePicker.date)
            pregnantDateTextField.resignFirstResponder()
            birthDateTextField.text = dateFormatter.string(from: datePicker.date.addingTimeInterval(60*60*24*280))
            
            pregnantDate = datePicker.date
            birthDate = datePicker.date.addingTimeInterval(60*60*24*280)
            self.registerButton.isEnabled = true
        } else {
            birthDateTextField.text = dateFormatter.string(from: datePicker.date)
            birthDateTextField.resignFirstResponder()
            
            birthDate = datePicker.date
        }
    }
    
    func cancelClick() {
        if pregnantDateTextField.isFirstResponder {
            pregnantDateTextField.resignFirstResponder()
        }
        else {
            birthDateTextField.resignFirstResponder()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == pregnantDateTextField {
            self.pickUpDate(self.pregnantDateTextField)
        } else if textField == birthDateTextField {
            self.pickUpDate(self.birthDateTextField)
        }
    }
    
    
    // register Baby
    
    @IBAction func registerBaby(_ sender: Any) {
        if pregnantDate.timeIntervalSince1970 > birthDate.timeIntervalSince1970 {
            let alertController = UIAlertController(title: "Fail", message: "출산 예정일은 임신 날짜 이전일 수 없습니다.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(ok)
            present(alertController, animated: true, completion: nil)
        }
        else if birthDate < Date() {
            let alertController = UIAlertController(title: "Fail", message: "출산 예정일은 오늘 이전일 수 없습니다.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(ok)
            present(alertController, animated: true, completion: nil)
        }
        else {
            let baby = Baby(name: BabyStore.shared.baby.name, birthDate: birthDate.timeIntervalSince1970, pregnantDate: pregnantDate.timeIntervalSince1970)
            
            BabyStore.shared.updateBaby(baby: baby, completion: { (result) in
                BabyStore.shared.fetchBaby(completion: { (baby) in
                })
                self.dismiss(animated: true, completion: nil)
            })
        }
    }

    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
