//
//  TipsDetailViewController.swift
//  CocoaBaby
//
//  Created by LEOFALCON on 2017. 8. 7..
//  Copyright © 2017년 Sohn. All rights reserved.
//

import UIKit

class TipsDetailViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tipsDetailTableView: UITableView!
    var tipList = ["지금 아기는요","엄마의 몸 상태","아빠는 이렇게 해주세요"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tipsDetailTableView.backgroundColor = UIColor(patternImage: UIImage(named: "Gradation2")!)
        self.tipsDetailTableView.separatorStyle = .none

        self.tipsDetailTableView.delegate = self
        self.tipsDetailTableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tipList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tipsDetailTableView.dequeueReusableCell(withIdentifier: "TipsDetailViewCell", for: indexPath) as! TipsTableViewCell
        
        cell.title.text = tipList[indexPath.row]
        
        return cell
    }
}
