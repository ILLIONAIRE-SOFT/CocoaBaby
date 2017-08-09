//
//  DiaryViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 04/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit

class DiaryViewController: BaseViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var diaryTableView: UITableView!
    @IBOutlet var yearPickLabel: UILabel!
    @IBOutlet var yearPickerView: UIPickerView!
    @IBOutlet var addDiaryBtnBg: UIView!
    @IBOutlet var addDiaryBtn: UIButton!
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
    }
    
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
        
        fetchDiaries()
    }
    
    func fetchDiaries() {
        CKDiaryStore.shared.fetchDiaries(year: 2017, month: 8) { 
            self.diaryTableView.reloadData()
        }
    }
    
    
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension DiaryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CKDiaryStore.shared.currentDiaries.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
        
        //        cell.cellLabel.text = "\(DiaryStore.shared.getPregnantWeek(of: diary).week)"
//        cell.dateLabel.text = CKDiaryStore.shared.currentDiaries[indexPath.row].
        cell.contentsLabel.text = CKDiaryStore.shared.currentDiaries[indexPath.row].text
        cell.addtionalDate.text = "\(CKDiaryStore.shared.currentDiaries[indexPath.row].day)"
        cell.weekLabel.text = "\(CKDiaryStore.shared.currentDiaries[indexPath.row].month)"
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
}
