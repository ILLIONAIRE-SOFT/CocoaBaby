//
//  DiaryViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 04/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit

class DiaryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var diaryTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diaryTableView.backgroundColor = UIColor.mainBlueColor
       // diaryTableView.estimatedRowHeight = 300
        // diaryTableView.rowHeight = UITableViewAutomaticDimension
        diaryTableView.delegate = self
        diaryTableView.dataSource = self
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
        
        
        //다이어리를 생성한 날짜를 기준으로 출산일까지 D-day계산해서 표시
       cell.cellLabel.text = "D-180"
        cell.contentsLabel.text = "어쩌구저쩌구 컨텐츠ddㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ"
        cell.dateLabel.text = "17.08.02"
        //cell.labelBackgroundView.tag = indexPath.row
       // cell.labelBackgroundView.isUserInteractionEnabled = true
        
        return cell
    }
    

}
