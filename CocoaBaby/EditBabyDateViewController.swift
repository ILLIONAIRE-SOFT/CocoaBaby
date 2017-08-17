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
    var pregnantDate : Date?
    var birthDate : Date?
    
    @IBOutlet var registerButton: UIButton!
    
    @IBOutlet var pregnantDateLabel: UILabel!
    @IBOutlet var birthDateLabel: UILabel!
    @IBOutlet weak var pregnantDateTextField: UITextField!
    @IBOutlet weak var birthDateTextField: UITextField!
    var datePicker : UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pregnantDateTextField.delegate = self
        self.birthDateTextField.delegate = self
        self.registerButton.isEnabled = false
        
        
        self.pregnantDateLabel.text = "임신 전 마지막 생리일이 언제인가요?" // localize 필요
        self.birthDateLabel.text = "출산 예정일이 언제인가요?" // localize 필요
        
        
        self.pregnantDateTextField.tintColor = .clear
        self.birthDateTextField.tintColor = .clear
        
        
        self.registerButton.layer.cornerRadius = 4
        self.registerButton.backgroundColor = .white
        
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
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale.current
            
            pregnantDateTextField.text = dateFormatter.string(from: datePicker.date)
            pregnantDateTextField.resignFirstResponder()
            birthDateTextField.text = dateFormatter.string(from: datePicker.date.addingTimeInterval(60*60*24*280))
            
            pregnantDate = datePicker.date
            birthDate = datePicker.date.addingTimeInterval(60*60*24*280)
            self.registerButton.isEnabled = true
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if pregnantDate != nil && birthDate != nil {
            self.registerButton.isEnabled = true
        }
    }
    
    // register Baby
    
    @IBAction func registerBaby(_ sender: Any) {
        if
            let pregnantDate = pregnantDate,
            let birthDate = birthDate
        {
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
    }

}