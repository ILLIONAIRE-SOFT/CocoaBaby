//
//  DatePickerViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 14/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {
    
    var datePicked: ((_ year: Int?, _ month: Int?) -> ())?
    var currentDate: Diary.Date?
    let datePickerDelegate = CocoaDatePickerDelegate()
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        
        let tapBackground = UITapGestureRecognizer(target: self, action: #selector(tappedBackground))
        self.view.addGestureRecognizer(tapBackground)
        
        datePickerDelegate.targetYear = (currentDate?.year)!
        datePickerDelegate.targetMonth = (currentDate?.month)!
        
        pickerView.delegate = datePickerDelegate
        
        pickerView.selectRow((currentDate?.year)! - 2010, inComponent: 0, animated: false)
        pickerView.selectRow((currentDate?.month)! - 1, inComponent: 1, animated: false)
        
        initViews()
    }
    
    private func initViews() {
        self.containerView.layer.cornerRadius = 12
    }

    func tappedBackground() {
        
        dismiss(animated: true) { 
            if let datePicked = self.datePicked {
                datePicked(2017, 7)
            }
        }
    }
    
    @IBAction func tappedDone(_ sender: UIButton) {
        dismiss(animated: true) {
            if let datePicked = self.datePicked {
                datePicked(self.datePickerDelegate.targetYear, self.datePickerDelegate.targetMonth)
            }
        }
    }
    
    @IBAction func tappedCancel(_ sender: UIButton) {
        dismiss(animated: true) {
            if let datePicked = self.datePicked {
                datePicked(nil, nil)
            }
        }
    }

}
