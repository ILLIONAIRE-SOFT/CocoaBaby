//
//  DiaryViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 04/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit

class DiaryViewController: BaseViewController {

    @IBOutlet var diaryTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diaryTableView.backgroundColor = UIColor.mainBlueColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
//        DiaryStore.shared.createDiary(text: "김다동", dateComponents: dateComponents) {
//            print("Save")
//        }
        
        DiaryStore.shared.fetchDiaries(year: 2017, month: 8) { 
            print("Load")
        }
    }

}
