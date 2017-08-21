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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "Gradation2")!)
        
        self.clearsSelectionOnViewWillAppear = true
        
        changeSettingBg()
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
            return
        }
        
    }
    
    func logout() {
        let firebaseAuth = Auth.auth()
        
        let alertController = UIAlertController(title: "Do you want logout?", message: nil, preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Yes", style: .default) { (_) in
            do {
                try firebaseAuth.signOut()
            } catch let signOutError {
                print("Error sigining out: %@", signOutError)
            }
            
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            let mainSB = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainSB.instantiateViewController(withIdentifier: "SplashViewController")
            
            appDelegate.window?.rootViewController = viewController
            appDelegate.window?.makeKeyAndVisible()
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func shareWithFather() {
        
        if (UserStore.shared.user?.partnerUID) != nil {
            let alertController = UIAlertController(title: nil, message: "You already linked, if you want change partner. Unlink your partner.", preferredStyle: .alert)
            
            let doneAction = UIAlertAction(title: "Done", style: .default, handler: nil)
            alertController.addAction(doneAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let gender = UserStore.shared.user?.gender else {
            return
        }
        
        if gender == "male" {
            let alertController = UIAlertController(title: nil, message: "Only mom can share code", preferredStyle: .alert)
            
            let doneAction = UIAlertAction(title: "Done", style: .default, handler: nil)
            alertController.addAction(doneAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        startLoading()
        
        ShareHelper.createShareSession { (shareResult) in
            self.stopLoading()
            
            switch shareResult {
            case let .success(code):
                let alertController = UIAlertController(title: "\(code)", message: "상대방 휴대폰에서 위의 번호를 입력하세요.\n 연결이 완료되기 전에 이 창을 끄지 마십시오.", preferredStyle: .alert)
                
                let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
                    ShareHelper.removeShareSession(completion: {
                        print("share quit")
                    })
                }
                
                alertController.addAction(doneAction)
                
                self.present(alertController, animated: true, completion: nil)
            case .failure():
                let alertController = UIAlertController(title: nil, message: "잠시 후 다시 시도해주십시오.", preferredStyle: .alert)
                
                let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
                    
                }
                
                alertController.addAction(doneAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func linkWithMother() {
        
        if (UserStore.shared.user?.partnerUID) != nil {
            let message = NSLocalizedString("Alert.FatherAlreadyLinked", comment: "")
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            
            let doneAction = UIAlertAction(title: "Done", style: .default, handler: nil)
            alertController.addAction(doneAction)
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let gender = UserStore.shared.user?.gender else {
            return
        }
        
        if gender == "female" {
            let alertController = UIAlertController(title: nil, message: "Only father can link with mom change your gender.", preferredStyle: .alert)
            
            let doneAction = UIAlertAction(title: "Done", style: .default, handler: nil)
            
            alertController.addAction(doneAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let alertController = UIAlertController(title: "Enter Code", message: "Enter mom's code", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.keyboardType = .numberPad
        }
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
            if let linkCode = alertController.textFields?.first?.text {
                if let intCode = Int(linkCode) {
                    ShareHelper.linkWithPartner(sixDigits: intCode, completion: {
                        self.showComplete()
                    })
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func unlink() {
        
        let alertController = UIAlertController(title: "Unlink with partner", message: "You can`t see partner's diary", preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
            ShareHelper.unlinkWithPartner(completion: { (result) in
                switch result {
                case .success():
                    UserStore.shared.fetchUser { (result) in
                        switch result {
                        case .success(_):
                            self.showComplete()
                        case .failure(_):
                            return
                        }
                    }
                case .failure():
                    return
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showComplete() {
        let alertController = UIAlertController(title: "Success", message: "Link complete", preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Done", style: .default, handler: nil)
        
        alertController.addAction(doneAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func changeSettingBg() {
        
        let date = Date()
        let currentHour = Calendar.current.component(.hour, from: date)
        if currentHour > 19 || currentHour < 6 { //Night
            
            //diaryTableView.backgroundColor = UIColor.init(colorWithHexValue: 0x3f305d, alpha: 1)
            self.view.backgroundColor = UIColor.init(colorWithHexValue: 0x3f305d, alpha: 1)
            
        } else if currentHour >= 6 || currentHour <= 16{
            //diaryTableView.backgroundColor = UIColor.init(colorWithHexValue: 0x4a3252, alpha: 1)
            self.view.backgroundColor = UIColor.init(colorWithHexValue: 0x4a3252, alpha: 1)
            
        } else if currentHour >= 16 && currentHour <= 19 {
            
        } else {
            
        }
    }
    
}
