//
//  TutorialSetDateViewController.swift
//  CocoaBaby
//
//  Created by LEOFALCON on 2017. 8. 2..
//  Copyright © 2017년 Sohn. All rights reserved.
//

import UIKit

class TutorialSetDateViewController: UIViewController, UITextFieldDelegate {

    var babyName : String?
    var pregnantDate : Date?
    var birthDate : Date?
    
    @IBOutlet var registerButton: UIButton!
    
    @IBOutlet weak var pregnantDateTextField: UITextField!
    @IBOutlet weak var birthDateTextField: UITextField!
    var datePicker : UIDatePicker!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pregnantDateTextField.delegate = self
        self.birthDateTextField.delegate = self
        self.registerButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func pickUpDate(_ textField : UITextField){
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.date
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

    func doneClick() {
        if pregnantDateTextField.isFirstResponder {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            
            pregnantDateTextField.text = dateFormatter.string(from: datePicker.date)
            pregnantDateTextField.resignFirstResponder()
            birthDateTextField.text = dateFormatter.string(from: datePicker.date.addingTimeInterval(60*60*24*280))
            
            pregnantDate = datePicker.date
            birthDate = datePicker.date.addingTimeInterval(60*60*24*280)
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
        pregnantDateTextField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == pregnantDateTextField {
            self.pickUpDate(self.pregnantDateTextField)
        } else if textField == birthDateTextField {
            self.pickUpDate(self.birthDateTextField)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if pregnantDateTextField.text != "" && birthDateTextField.text != "" {
            self.registerButton.isEnabled = true
        }
    }

    @IBAction func registerBaby(_ sender: Any) {
        if
            let pregnantDate = pregnantDate,
            let birthDate = birthDate,
            let name = babyName
        {
            BabyStore.shared.registerBaby(from: pregnantDate, to: birthDate, name: name)
            print("success")
            self.dismiss(animated: true, completion: nil)
        }
    }
}
