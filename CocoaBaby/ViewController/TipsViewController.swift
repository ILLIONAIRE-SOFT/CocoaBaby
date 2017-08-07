//
//  TipsViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 04/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit

class TipsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    var weeks = ["week 1", "week 2","week 3", "week 4", "week 5"]
    
    @IBOutlet var tipsTabelView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tipsTabelView.backgroundColor = UIColor(patternImage: UIImage(named: "Gradation2")!)
        self.tipsTabelView.delegate = self
        self.tipsTabelView.dataSource = self
        
        self.tipsTabelView.separatorStyle = .none
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tipsTabelView.dequeueReusableCell(withIdentifier: "TipsTabelViewCell", for: indexPath) as! TipsTableViewCell
        
        cell.title.text = self.weeks[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let tipsDetailViewController = storyBoard.instantiateViewController(withIdentifier: "TipsDetailViewController") as! TipsDetailViewController
        
        self.navigationController?.pushViewController(tipsDetailViewController, animated: true)
    }

}
