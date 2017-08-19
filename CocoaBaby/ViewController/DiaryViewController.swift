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
    @IBOutlet var addDiaryBtnBg: UIView!
    let months: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    var targetDate: Diary.Date = Diary.Date(year: 2017, month: 8, day: 0) {
        didSet {
            self.yearPickLabel.text = "\(months[targetDate.month - 1]) \(targetDate.year)"
            self.fetchDiaries()
        }
    }
    
    let pickerDelegate = CocoaDatePickerDelegate()
    let datePicker = CocoaDatePickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diaryTableView.backgroundColor = UIColor.mainBlueColor
        diaryTableView.estimatedRowHeight = 300
        diaryTableView.rowHeight = UITableViewAutomaticDimension
        diaryTableView.delegate = self
        diaryTableView.dataSource = self
        changeDiaryBg()
        
        initRefreshControl()
        initTodayLabel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addDiaryBtnBg.layer.cornerRadius = 20
        self.diaryTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
                controller.isUpdate = true
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "tappedEmptyCell":
            if UserStore.shared.user?.gender == "male" {
                return false
            } else {
                return true
            }
        case "tappedAddDiary":
            if UserStore.shared.user?.gender == "male" {
                return false
            } else {
                return true
            }
        default:
            return true
        }
    }
    
    // MARK: Methods
    func fetchDiaries() {
        startLoading()
        
        DiaryStore.shared.fetchDiaries(date: targetDate) {
            self.diaryTableView.reloadData()
            self.stopLoading()
            
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func initTodayLabel() {
        let components = CocoaDateFormatter.getCalendarComponents(from: Date())
        
        guard
            let year = components.year,
            let month = components.month else {
                return
        }
        
        targetDate = Diary.Date(year: year, month: month, day: 0)
    }
    
    func initRefreshControl() {
        refreshControl.addTarget(self, action: #selector(fetchDiaries), for: .valueChanged)
        refreshControl.tintColor = UIColor.white
        
        diaryTableView.addSubview(refreshControl)
    }
    
    func initDatePicker() {
        datePicker.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        datePicker.frame = CGRect(x: 0, y: 0, width: 160, height: 100)
        datePicker.layer.cornerRadius = 16
        datePicker.delegate = pickerDelegate
        
        self.view.addSubview(datePicker)
    }
    
    func showDatePicker() {
        let diarySB = UIStoryboard(name: "Diary", bundle: nil)
        let modalViewCotroller = diarySB.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
        modalViewCotroller.modalPresentationStyle = .overCurrentContext
        modalViewCotroller.currentDate = targetDate
        modalViewCotroller.datePicked = { (year, month) in
            guard
                let year = year,
                let month = month else {
                    return
            }
            self.targetDate = Diary.Date(year: year, month: month, day: 0)
        }
        present(modalViewCotroller, animated: true, completion: nil)
    }
    
    @IBAction func tappedCalendar(_ sender: UIButton) {
        showDatePicker()
    }
    
    func changeDiaryBg() {
        
        let date = Date()
        let currentHour = Calendar.current.component(.hour, from: date)
        if currentHour > 19 || currentHour < 6 { //Night
            
            diaryTableView.backgroundColor = UIColor.init(colorWithHexValue: 0x3f305d, alpha: 1)
            self.view.backgroundColor = UIColor.init(colorWithHexValue: 0x3f305d, alpha: 1)

        } else if currentHour >= 6 || currentHour <= 16{
            diaryTableView.backgroundColor = UIColor.init(colorWithHexValue: 0x4a3252, alpha: 1)
            self.view.backgroundColor = UIColor.init(colorWithHexValue: 0x4a3252, alpha: 1)
            
        } else if currentHour >= 16 && currentHour <= 19 {
            
        } else {
            
        }
        
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
            cell.initCell(with: indexPath.row + 1)
            
            return cell
        }
    }
}
