//
//  TipsDetailViewController.swift
//  CocoaBaby
//
//  Created by LEOFALCON on 2017. 8. 7..
//  Copyright © 2017년 Sohn. All rights reserved.
//

import UIKit

class TipsDetailViewController: UIViewController {
    
    @IBOutlet var tipTitle: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet weak var bottomView: UIView!
    
    var currentTitle: String = ""
    var currentContent: String = ""
    
    var tips : Tips!
    var order : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(colorWithHexValue: 0xF9F9F9, alpha: 1)
        self.view.layer.cornerRadius = 5
        self.bottomView.layer.cornerRadius = 5
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let order = order {
            tips = TipsStore.shared.Tips[order]
            tipTitle.text = tips.title
            segmentedControl.selectedSegmentIndex = 0
            self.segmentedControl.addTarget(self, action: #selector(tipTargetChanged(segControl:)), for: .valueChanged)
            tipTargetChanged(segControl: segmentedControl)
        }
        
        self.tableView.reloadData()
        self.tableView.scrollsToTop = true
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
    }
    
    func tipTargetChanged(segControl : UISegmentedControl)  {
        guard let tips = TipsStore.shared.Tips[order] else {
            return
        }
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            currentTitle = tips.babyTitle
            currentContent = tips.babyContent
        case 1:
            currentTitle = tips.mamaTitle
            currentContent = tips.mamaContent
        case 2:
            currentTitle = tips.papaTitle
            currentContent = tips.papaContent
        default:
            break
        }
        self.tableView.reloadData()
    }

    
}

extension TipsDetailViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "TipsDetailContentTableViewCell"
        
            let cell  = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TipsDetailContentTableViewCell
            cell.setContent(title : currentTitle, content: currentContent)
            return cell
    }
    

}


