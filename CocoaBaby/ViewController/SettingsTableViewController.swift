//
//  SettingsTableViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 21/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit
import FirebaseAuth
import FacebookCore
import FBSDKLoginKit

class SettingsTableViewController: BaseTableViewController {

    @IBOutlet var dDayLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var babyNameLabel: UILabel!
    @IBOutlet var shareCodeLabel: UILabel!
    @IBOutlet var linkWithMomLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "Gradation2")!)
        changeBgColorBasedOnTime()
        
        fetchOriginData()
        setForGender()
    }
    
    // MARK: - Method
    func fetchOriginData() {
        if let gender = UserStore.shared.user?.gender {
            switch gender {
            case Gender.female:
                genderLabel.text = "Mom"
            case Gender.male:
                genderLabel.text = "Dad"
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
    
    func setForGender() {
        let gender = UserStore.shared.user?.gender
        
        if gender == Gender.female {
            shareCodeLabel.textColor = .white
            linkWithMomLabel.textColor = .darkGray
        } else {
            shareCodeLabel.textColor = .darkGray
            linkWithMomLabel.textColor = .white
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "selectGender":
            if let user = UserStore.shared.user {
                if let partnerUID = user.partnerUID, partnerUID != "" {
                    let alertController = UIAlertController(style: .done, title: nil, message: LocalizableString.unlinkBeforeChangeGender, doneHandler: nil)
                    
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
    
    func logout() {
        let firebaseAuth = Auth.auth()
        
        let alertController = UIAlertController(style: .doneCancel, title: LocalizableString.logoutMessage, message: nil) { (action) in
            do {
                try firebaseAuth.signOut()
            } catch let signOutError {
                print("Error sigining out: %@", signOutError)
            }
            
            FBSDKLoginManager().logOut()
            
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            let mainSB = UIStoryboard(name: StoryboardName.main, bundle: nil)
            let viewController = mainSB.instantiateViewController(withIdentifier: StoryboardName.splashViewController)
            
            appDelegate.window?.rootViewController = viewController
            appDelegate.window?.makeKeyAndVisible()
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    func shareWithFather() {
        if (UserStore.shared.user?.partnerUID) != nil {
            let alertController = UIAlertController(style: .done, title: nil, message: LocalizableString.alreadyLinked, doneHandler: nil)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let gender = UserStore.shared.user?.gender else {
            return
        }
        
        if gender == Gender.male {
            let alertController = UIAlertController(style: .done, title: nil, message: LocalizableString.onlyMomCanShare, doneHandler: nil)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        startLoading()
        ShareHelper.createShareSession { (shareResult) in
            self.stopLoading()
            
            switch shareResult {
            case let .success(code):
                let alertController = UIAlertController(style: .done, title: "\(code)", message: LocalizableString.shareCodeMessage, doneHandler: { (action) in
                    ShareHelper.removeShareSession(completion: {
                        UserStore.shared.fetchUser(completion: { (result) in
                        })
                    })
                })

                self.present(alertController, animated: true, completion: nil)
            case .failure():
                let alertController = UIAlertController(style: .done, title: nil, message: LocalizableString.pleaseRetryMessage, doneHandler: nil)
                
                self.present(alertController, animated: true, completion: nil)
            case .noDeviceToken():
                let alertController = UIAlertController(style: .done, title: nil, message: LocalizableString.pleaseAllowNotification, doneHandler: nil)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func linkWithMother() {
        
        if (UserStore.shared.user?.partnerUID) != nil {
            let alertController = UIAlertController(style: .done, title: nil, message: LocalizableString.fatherAlreadyLinked, doneHandler: nil)
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let gender = UserStore.shared.user?.gender else {
            return
        }
        
        if gender == Gender.female {
            let alertController = UIAlertController(style: .done, title: nil, message: LocalizableString.onlyFatherCanLinkWithMom, doneHandler: nil)
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let _ = UserStore.shared.user?.deviceToken else {
            let alertController = UIAlertController(style: .done, title: nil, message: LocalizableString.pleaseAllowNotification, doneHandler: nil)
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
        guard let user = UserStore.shared.user else {
            return
        }
        
        if let partnerUID = user.partnerUID, partnerUID != "" {
            let alertController = UIAlertController(style: .doneCancel, title: LocalizableString.unlinkTitle, message: LocalizableString.unlinkMessage, doneHandler: { (action) in
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
            })
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(style: .done, title: LocalizableString.unlinkTitle, message: LocalizableString.notLinked, doneHandler: nil)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func showComplete(message: String) {
        let alertController = UIAlertController(style: .done, title: LocalizableString.success, message: message, doneHandler: nil)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Tableview nondynamic function
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = UIColor.lightGray
        }
    }

}

// MARK: - TableView Delegate, Datasource
extension SettingsTableViewController {
    
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
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        switch (indexPath.section, indexPath.row) {
        case (1, 0):
            if UserStore.shared.user?.gender == Gender.male {
                return nil
            } else {
                return indexPath
            }
        case (1, 1):
            if UserStore.shared.user?.gender == Gender.female {
                return nil
            } else {
                return indexPath
            }
        default:
            return indexPath
        }
    }
    
}
