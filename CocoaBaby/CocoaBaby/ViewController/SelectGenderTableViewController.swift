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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectOriginalGender()
    }
    
    func selectOriginalGender() {
        let indexPath: IndexPath
        
        if let gender = UserStore.shared.user?.gender {
            if gender == Gender.female {
                indexPath = IndexPath(row: 0, section: 0)
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            } else if gender == Gender.male {
                indexPath = IndexPath(row: 1, section: 0)
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
        }
    }
    
    func changeGender(gender: String) {
        UserStore.shared.updateUser(post: [UserPayloadName.gender.rawValue:gender]) { (result) in
            switch result {
            case .success(_):
                UserStore.shared.fetchUser(completion: { (result) in
                    switch result {
                    case .success(_):
                        break
                    case .failure(_):
                        break
                    }
                })
            case .failure(_):
                break
            }
        }
    }
    
    // MARK: Table View Delegate, Data Source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        switch indexPath.row {
        case 0:
            tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.accessoryType = .none
            changeGender(gender: Gender.female)
        case 1:
            tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.accessoryType = .none
            changeGender(gender: Gender.male)
        default:
            break
        }
    }
    
    
}
