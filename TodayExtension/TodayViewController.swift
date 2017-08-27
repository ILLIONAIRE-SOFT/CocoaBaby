//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Sohn on 25/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet var dDayLabel: UILabel!
    @IBOutlet var weekLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.

        initLabels()
    }
    
    func initLabels() {
        
        if let birthDate = UserDefaults.init(suiteName: "group.ILSO.CocoaBaby")?.value(forKey: "babyBirthDate") {
            
            let dDay = TodayHelper.getDday(to: birthDate as! Double)
            dDayLabel.text = "D-\(dDay)"
        } else {
            print("Birth date is not exist")
        }
        
        if let pregnantDate = UserDefaults.init(suiteName: "group.ILSO.CocoaBaby")?.value(forKey: "babyPregnantDate") {
            
            let currentWeek = TodayHelper.getCurrentWeek(from: pregnantDate as! Double)
            weekLabel.text = "Week \(currentWeek)"
        } else {
            print("Pregnant date is not exist")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
