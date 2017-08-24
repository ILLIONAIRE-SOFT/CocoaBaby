//
//  EditBabyDateTableViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 24/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit

class EditBabyDateTableViewController: BaseTableViewController {
    
    var pregnantDate: Date = Date() {
        didSet {
            if let field = pregnantDateField {
                field.text = CocoaDateFormatter.getDateExcludeTime(from: pregnantDate)
            }
        }
    }
    
    var birthDate: Date = Date() {
        didSet {
            if let field = birthDateField {
                field.text = CocoaDateFormatter.getDateExcludeTime(from: birthDate)
            }
        }
    }
    
    @IBOutlet var pregnantDateField: UITextField!
    @IBOutlet var birthDateField: UITextField!
    
    var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "Gradation2")!)
        
        initViews()
    }
    
    func initViews() {
        // MARK: Save Bar Button
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: nil)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        // MARK: TextField
        pregnantDateField.delegate = self
        birthDateField.delegate = self
        
        // MARK: Date
        pregnantDate = Date(timeIntervalSince1970: BabyStore.shared.baby.pregnantDate)
        birthDate = Date(timeIntervalSince1970: BabyStore.shared.baby.birthDate)
    }
    
    func showDatePicker(_ textField: UITextField) {
        datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.minimumDate = Date.init(timeIntervalSinceNow: -60*60*24*100)
        datePicker.maximumDate = Date.init(timeIntervalSinceNow: 60*60*24*400)
        textField.inputView = self.datePicker
        
        if textField == pregnantDateField {
            self.datePicker.setDate(pregnantDate, animated: false)
        } else {
            self.datePicker.setDate(birthDate, animated: false)
        }
        
        // MARK: ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDone))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(tappedCancel))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    func tappedDone() {
        if pregnantDateField.isFirstResponder {
            pregnantDate = datePicker.date
            pregnantDateField.resignFirstResponder()
        } else {
            birthDate = datePicker.date
            birthDateField.resignFirstResponder()
        }
    }
    
    func tappedCancel() {
        if pregnantDateField.isFirstResponder {
            pregnantDateField.resignFirstResponder()
        } else if birthDateField.isFirstResponder {
            birthDateField.resignFirstResponder()
        }
    }
}

// MARK: TextField Delegate
extension EditBabyDateTableViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == pregnantDateField {
            self.showDatePicker(pregnantDateField)
        } else if textField == birthDateField {
            self.showDatePicker(birthDateField)
        }
    }
}

// MARK: Table View Delegate
extension EditBabyDateTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
