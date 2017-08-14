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
    
    var targetDate: Diary.Date = Diary.Date(year: 2017, month: 8, day: 0)
    
    let years = ["2016", "2017", "2018"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diaryTableView.backgroundColor = UIColor.mainBlueColor
        diaryTableView.estimatedRowHeight = 300
        diaryTableView.rowHeight = UITableViewAutomaticDimension
        diaryTableView.delegate = self
        diaryTableView.dataSource = self
        
        initPickerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addDiaryBtnBg.layer.cornerRadius = 20
        initTodayLabel()
        
        fetchDiaries()
    }
    
    // MARK: Methods
    func fetchDiaries() {
        startLoading()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        DiaryStore.shared.fetchDiaries(date: targetDate) {
            self.diaryTableView.reloadData()
            self.stopLoading()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    func tap(gestureReconizer: UITapGestureRecognizer) {
        yearPickerView.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "tappedDiaryCell"?:
            let controller = segue.destination as! DiaryAddViewController
            
            guard let selectedIndexPath = diaryTableView.indexPathForSelectedRow else {
                return
            }
            
            if let diary = DiaryStore.shared.currentDiaries[selectedIndexPath.row + 1] {
                controller.diary = diary
            } else {
                let diary = Diary(text: "", date: Diary.Date(year: targetDate.year, month: targetDate.month, day: selectedIndexPath.row + 1))
                controller.diary = diary
            }
            
        case "tappedEmptyCell"?:
            let controller = segue.destination as! DiaryAddViewController
            
            guard let selectedIndexPath = diaryTableView.indexPathForSelectedRow else {
                return
            }
            
            let diary = Diary(text: "", date: Diary.Date(year: targetDate.year, month: targetDate.month, day: selectedIndexPath.row + 1))
            controller.diary = diary
            
        case "tappedAddDiary"?:
            let controller = segue.destination as! DiaryAddViewController
            
            // 다른 연도, 월에 있는 경우 today 다이어리를 따로 저장해놔야 한다.
            if let diary = DiaryStore.shared.currentDiaries[CocoaDateFormatter.getDay(from: Date())] {
                controller.diary = diary
            } else {
                let components = CocoaDateFormatter.createComponents(from: Date())
                let diary = Diary(text: "", date: Diary.Date(year: components.year!, month: components.month!, day: components.day!))
                controller.diary = diary
            }
        default:
            return
        }
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
    
    func initTodayLabel() {
        yearPickLabel.text = CocoaDateFormatter.getDateExcludeTime(from: Date())
    }
    
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension DiaryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CocoaDateFormatter.getNumberOfDay(from: targetDate)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let diary = DiaryStore.shared.currentDiaries[indexPath.row + 1] {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
            cell.initViews(with: diary)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryEmptyCell", for: indexPath) as! DiaryEmptyCell
//            cell.textLabel?.text = "empty cell"
            
            return cell
        }
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
