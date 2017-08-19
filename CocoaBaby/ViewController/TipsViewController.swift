//
//  TipsViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 04/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit

class TipsViewController: BaseViewController, UIScrollViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeTipsBg()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func changeTipsBg() {
        
        let date = Date()
        let currentHour = Calendar.current.component(.hour, from: date)
        if currentHour > 19 || currentHour < 6 { //Night
            
            //diaryTableView.backgroundColor = UIColor.init(colorWithHexValue: 0x3f305d, alpha: 1)
            self.view.backgroundColor = UIColor.init(colorWithHexValue: 0x3f305d, alpha: 1)
            
        } else if currentHour >= 6 || currentHour <= 16{
            //diaryTableView.backgroundColor = UIColor.init(colorWithHexValue: 0x4a3252, alpha: 1)
            self.view.backgroundColor = UIColor.init(colorWithHexValue: 0x4a3252, alpha: 1)
            
        } else if currentHour >= 16 && currentHour <= 19 {
            
        } else {
            
        }
        
    }
}
