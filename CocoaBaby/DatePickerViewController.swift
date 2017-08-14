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
        
        pickerView.delegate = datePickerDelegate
        
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
                datePicked(2017, 7)
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
