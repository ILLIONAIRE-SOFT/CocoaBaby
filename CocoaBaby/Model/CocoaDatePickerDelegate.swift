//
//  CocoaDatePickerDelegate.swift
//  CocoaBaby
//
//  Created by Sohn on 14/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit

class CocoaDatePickerDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let month: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let currentYear = CocoaDateFormatter.getCalendarComponents(from: Date()).year!
    
    var targetYear: Int = 0
    var targetMonth: Int = 0
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 12
        case 1:
            return currentYear - Int(BabyStore.shared.getYearOfPregnantDate())! + 1
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 80
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0 :
            return month[row]
        case 1:
            return "\(Int(BabyStore.shared.getYearOfPregnantDate())! + row)"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            targetMonth = row + 1
        case 1:
            targetYear = row + Int(BabyStore.shared.getYearOfPregnantDate())!
        default:
            return
        }
    }
    
    
}
