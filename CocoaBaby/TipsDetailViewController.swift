//
//  TipsDetailViewController.swift
//  CocoaBaby
//
//  Created by LEOFALCON on 2017. 8. 7..
//  Copyright © 2017년 Sohn. All rights reserved.
//

import UIKit

class TipsDetailViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    let sectionHeight : CGFloat = 30
    
    var week : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        if week == nil {
            week = 1
        }

    }

}

extension TipsDetailViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = indexPath.section == 0 ? "TipsDetailHeaderTableViewCell" : "TipsDetailContentTableViewCell"
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! TipsDetailHeaderTableViewCell
            if let week = week {
                cell.initWeekTitle(week: week)
            }
            return cell
        } else {
            let cell  = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TipsDetailContentTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let segmentedControl = UISegmentedControl(items: ["baby","mama","papa"])

            let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: sectionHeight))
            sectionView.addSubview(segmentedControl)
            
            segmentedControl.translatesAutoresizingMaskIntoConstraints = false
            
            
            let topConstraint = segmentedControl.topAnchor.constraint(equalTo: sectionView.topAnchor)
            let bottomConstraint = segmentedControl.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor)
            let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 10)
            let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor, constant : -10)
            
            topConstraint.isActive = true
            bottomConstraint.isActive = true
            leadingConstraint.isActive = true
            trailingConstraint.isActive = true

            segmentedControl.selectedSegmentIndex = 0
            segmentedControl.tintColor = .gray
            
            
            return sectionView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : sectionHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ?  80 : 1000
    }

}

