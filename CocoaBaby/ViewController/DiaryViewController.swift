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
    @IBOutlet var yearPickLabel: UILabel!
    @IBOutlet var yearPickerView: UIPickerView!
    @IBOutlet var addDiaryBtnBg: UIView!
    
    let years = ["2016", "2017", "2018"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diaryTableView.backgroundColor = UIColor.mainBlueColor
       // diaryTableView.estimatedRowHeight = 300
        // diaryTableView.rowHeight = UITableViewAutomaticDimension
        diaryTableView.delegate = self
        diaryTableView.dataSource = self
        
        initPickerView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        addDiaryBtnBg.layer.cornerRadius = 20
        
        fetchDiaries()
    }
    
    // MARK: Methods
    func fetchDiaries() {
        CKDiaryStore.shared.fetchDiaries(year: 2017, month: 8) {
            self.diaryTableView.reloadData()
        }
    }
    
    func tap(gestureReconizer: UITapGestureRecognizer) {
        print("picked!")
        yearPickerView.isHidden = false
    }
    
    // MARK : PickerView
    func initPickerView() {
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
    
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension DiaryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CKDiaryStore.shared.currentDiaries.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
        
        cell.initViews(with: CKDiaryStore.shared.currentDiaries[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CKDiaryStore.shared.updateDiary(diary: CKDiaryStore.shared.currentDiaries[indexPath.row])
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension DiaryViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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
}
