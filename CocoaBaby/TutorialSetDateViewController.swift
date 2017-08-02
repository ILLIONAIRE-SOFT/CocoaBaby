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
    
    @IBOutlet weak var pregnantDateTextField: UITextField!
    @IBOutlet weak var birthDateTextField: UITextField!
    var datePicker : UIDatePicker!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pregnantDateTextField.delegate = self

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
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
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
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        pregnantDateTextField.text = dateFormatter1.string(from: datePicker.date)
        pregnantDateTextField.resignFirstResponder()
    }
    func cancelClick() {
        pregnantDateTextField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUpDate(self.pregnantDateTextField)
    }


    

}
