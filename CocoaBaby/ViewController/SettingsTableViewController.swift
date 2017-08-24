//
//  SettingsTableViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 21/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsTableViewController: BaseTableViewController {

    @IBOutlet var dDayLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var babyNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "Gradation2")!)
        changeBgColorBasedOnTime()
        
        fetchOriginData()
    }
    
    // MARK: - Method
    func fetchOriginData() {
        if let gender = UserStore.shared.user?.gender {
            switch gender {
            case Gender.female:
                genderLabel.text = "Female"
            case Gender.male:
                genderLabel.text = "Male"
            default:
                break
            }
        }
        
        if let baby = BabyStore.shared.baby {
            babyNameLabel.text = baby.name
            let dDay = BabyStore.shared.getDday()
            dDayLabel.text = "D\(dDay.mark)\(dDay.value)"
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "selectGender":
            if let user = UserStore.shared.user {
                if let partnerUID = user.partnerUID, partnerUID != "" {
                    let alertController = UIAlertController(title: nil, message: LocalizableString.unlinkBeforeChangeGender, preferredStyle: .alert)
                    let doneAction = UIAlertAction(title: LocalizableString.done, style: .default, handler: nil)
                    alertController.addAction(doneAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    return false
                } else {
                    return true
                }
            } else {
                return false
            }
        default:
            return true
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath.section, indexPath.row) {
        case (1, 0):
            shareWithFather()
        case (1, 1):
            linkWithMother()
        case (1, 2):
            unlink()
        case (2, 0):
            break
        case (2, 1):
            logout()
        default:
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = UIColor.lightGray
        }
    }
    
    func logout() {
        let firebaseAuth = Auth.auth()
        
        let alertController = UIAlertController(title: LocalizableString.logoutMessage, message: nil, preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: LocalizableString.yes, style: .default) { (_) in
            do {
                try firebaseAuth.signOut()
            } catch let signOutError {
                print("Error sigining out: %@", signOutError)
            }
            
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            let mainSB = UIStoryboard(name: StoryboardName.main, bundle: nil)
            let viewController = mainSB.instantiateViewController(withIdentifier: StoryboardName.splashViewController)
            
            appDelegate.window?.rootViewController = viewController
            appDelegate.window?.makeKeyAndVisible()
        }
        
        let cancelAction = UIAlertAction(title: LocalizableString.no, style: .cancel, handler: nil)
        
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func shareWithFather() {
        if (UserStore.shared.user?.partnerUID) != nil {
            let alertController = UIAlertController(title: nil, message: LocalizableString.alreadyLinked, preferredStyle: .alert)
            
            let doneAction = UIAlertAction(title: LocalizableString.done, style: .default, handler: nil)
            alertController.addAction(doneAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let gender = UserStore.shared.user?.gender else {
            return
        }
        
        if gender == Gender.male {
            let alertController = UIAlertController(title: nil, message: LocalizableString.onlyMomCanShare, preferredStyle: .alert)
            
            let doneAction = UIAlertAction(title: LocalizableString.done, style: .default, handler: nil)
            alertController.addAction(doneAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        startLoading()
        
        ShareHelper.createShareSession { (shareResult) in
            self.stopLoading()
            
            switch shareResult {
            case let .success(code):
                let alertController = UIAlertController(title: "\(code)", message: LocalizableString.shareCodeMessage, preferredStyle: .alert)
                
                let doneAction = UIAlertAction(title: LocalizableString.done, style: .default) { (action) in
                    ShareHelper.removeShareSession(completion: {
                        UserStore.shared.fetchUser(completion: { (result) in
                        })
                    })
                }
                
                alertController.addAction(doneAction)
                
                self.present(alertController, animated: true, completion: nil)
            case .failure():
                let alertController = UIAlertController(title: nil, message: LocalizableString.pleaseRetryMessage, preferredStyle: .alert)
                
                let doneAction = UIAlertAction(title: LocalizableString.done, style: .default) { (action) in
                    
                }
                
                alertController.addAction(doneAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func linkWithMother() {
        
        if (UserStore.shared.user?.partnerUID) != nil {
            let alertController = UIAlertController(title: nil, message: LocalizableString.fatherAlreadyLinked, preferredStyle: .alert)
            
            let doneAction = UIAlertAction(title: LocalizableString.done, style: .default, handler: nil)
            alertController.addAction(doneAction)
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let gender = UserStore.shared.user?.gender else {
            return
        }
        
        if gender == Gender.female {
            let alertController = UIAlertController(title: nil, message: LocalizableString.onlyFatherCanLinkWithMom, preferredStyle: .alert)
            
            let doneAction = UIAlertAction(title: LocalizableString.done, style: .default, handler: nil)
            
            alertController.addAction(doneAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let alertController = UIAlertController(title: LocalizableString.enterCodeTitle, message: LocalizableString.enterCodeMessage, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.keyboardType = .numberPad
        }
        
        let doneAction = UIAlertAction(title: LocalizableString.done, style: .default) { (action) in
            if let linkCode = alertController.textFields?.first?.text {
                if let intCode = Int(linkCode) {
                    ShareHelper.linkWithPartner(sixDigits: intCode, completion: {
                        self.showComplete(message: LocalizableString.linkSuccess)
                    })
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: LocalizableString.cancel, style: .cancel, handler: nil)
        
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func unlink() {
        let alertController = UIAlertController(title: LocalizableString.unlinkTitle, message: LocalizableString.unlinkMessage, preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: LocalizableString.done, style: .default) { (action) in
            ShareHelper.unlinkWithPartner(completion: { (result) in
                switch result {
                case .success():
                    UserStore.shared.fetchUser { (result) in
                        switch result {
                        case .success(_):
                            self.showComplete(message: LocalizableString.unlinkSuccess)
                        case .failure(_):
                            return
                        }
                    }
                case .failure():
                    return
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: LocalizableString.cancel, style: .cancel, handler: nil)
        
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showComplete(message: String) {
        let alertController = UIAlertController(title: LocalizableString.success, message: message, preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: LocalizableString.done, style: .default,handler: nil)
        
        alertController.addAction(doneAction)
        
        present(alertController, animated: true, completion: nil)
    }

    
}
