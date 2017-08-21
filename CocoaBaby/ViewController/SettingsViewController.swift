//
//  SettingsViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 04/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController: BaseViewController {
    
    @IBOutlet var editBabyButton: UIButton!
    @IBOutlet var editDateButton: UIButton!
    @IBOutlet var sendEmailButton: UIButton!
    @IBOutlet var genderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        changeSettingBg()
    }
    
    func initViews() {
        editBabyButton.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        editBabyButton.layer.cornerRadius = 16
        
        editDateButton.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        editDateButton.layer.cornerRadius = 16
        
        sendEmailButton.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        sendEmailButton.layer.cornerRadius = 16
        
        genderButton.setTitle("I'm \(UserStore.shared.user?.gender ?? "female")", for: .normal)
    }
    
    @IBAction func tappedLogout(_ sender: UIButton) {
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
    
    @IBAction func tappedShare(_ sender: UIButton) {
        
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
    
    @IBAction func tappedLink(_ sender: UIButton) {
        
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
    
    @IBAction func tappedUnlink(_ sender: UIButton) {
        
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
