//
//  SelectGenderTableViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 23/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit

class SelectGenderTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "Gradation2")!)

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        switch indexPath.row {
        case 0:
            tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.accessoryType = .none
        case 1:
            tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.accessoryType = .none
        default:
            break
        }
    }

}
