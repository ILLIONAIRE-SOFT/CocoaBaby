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
        
        self.view.backgroundColor = UIColor(colorWithHexValue: 0xe7a396)
        
        self.registerButton.layer.cornerRadius = 4
        self.pregnantDateTextField.attributedPlaceholder = NSAttributedString(string: "아이를 임신한 날짜를 선택해 주세요", attributes: [NSForegroundColorAttributeName: UIColor.white])
        self.birthDateTextField.attributedPlaceholder = NSAttributedString(string: "아이의 출산 예정일을 선택해 주세요", attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        pregnantDateTextField.setBottomBorder()
        birthDateTextField.setBottomBorder()
        
        //pregnantDateTextField.becomeFirstResponder()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        if pregnantDate != nil && birthDate != nil {
            self.registerButton.isEnabled = true
        }
    }

    // register Baby
    
    @IBAction func registerBaby(_ sender: Any) {
        if
            let pregnantDate = pregnantDate,
            let birthDate = birthDate,
            let name = babyName
        {
            if pregnantDate.timeIntervalSince1970 > birthDate.timeIntervalSince1970 {
                let alertController = UIAlertController(title: "Fail", message: "출산 예정일은 임신 날짜 이전일 수 없습니다.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(ok)
                present(alertController, animated: true, completion: nil)
            } else if birthDate < Date() {
                let alertController = UIAlertController(title: "Fail", message: "출산 예정일은 오늘 이전일 수 없습니다.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(ok)
                present(alertController, animated: true, completion: nil)
            }else {
            BabyStore.shared.registerBaby(from: pregnantDate, to: birthDate, name: name)
            print("success")
            self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
