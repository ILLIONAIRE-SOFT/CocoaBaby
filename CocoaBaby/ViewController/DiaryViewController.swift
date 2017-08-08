//
//  DiaryViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 04/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit

class DiaryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var diaryTableView: UITableView!
    @IBOutlet var yearPickLabel: UILabel!
    @IBOutlet var yearPickerView: UIPickerView!
    @IBOutlet var addDiaryBtnBg: UIView!
    @IBOutlet var addDiaryBtn: UIButton!

    
    let years = ["2016", "2017", "2018"]
    
    
    // MARK : PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return years[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        yearPickLabel.text = years[row]
        //self.view.endEditing(true)
        yearPickerView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diaryTableView.backgroundColor = UIColor.mainBlueColor
       // diaryTableView.estimatedRowHeight = 300
        // diaryTableView.rowHeight = UITableViewAutomaticDimension
        diaryTableView.delegate = self
        diaryTableView.dataSource = self
        
        
        // MARK : PickerView
        var pickerRect = yearPickerView.frame
       
        pickerRect.origin.x = -5// some desired value
        pickerRect.origin.y = 2// some desired value
        yearPickerView.frame = pickerRect
        yearPickerView.delegate = self
        yearPickerView.dataSource = self
        yearPickerView.isHidden = true
        view.addSubview(yearPickerView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(gestureReconizer:)))
        yearPickLabel.addGestureRecognizer(tap)
            
        yearPickLabel.isUserInteractionEnabled = true
        
        
    }
    
    func tap(gestureReconizer: UITapGestureRecognizer) {
        print("picked!")
        yearPickerView.isHidden = false
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
        
        addDiaryBtnBg.layer.cornerRadius = 20
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
        
        //다이어리를 생성한 날짜를 기준으로 출산일까지 D-day계산해서 표시
//        cell.cellLabel.text = "\(DiaryStore.shared.getPregnantWeek(of: diary).week)"
        cell.dateLabel.text = "17.08.02"
        cell.contentsLabel.text = "오늘은 태동이 많이 느껴졌다. 우리 애기는 잘 있을까? 쪼만한 내새꾸가 배에서 꼬물 거리고 있다는게 너무 신기하다!. 남편이 오늘 딸기를 사와서 먹었다. 우리 꼬물이도 좋아하는 것 같다"
        cell.addtionalDate.text = "3"
        cell.weekLabel.text = "TUE"
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        //cell.labelBackgroundView.tag = indexPath.row
       // cell.labelBackgroundView.isUserInteractionEnabled = true
        
        return cell
    }
    

}
