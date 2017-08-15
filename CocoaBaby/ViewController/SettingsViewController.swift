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
    @IBOutlet var dataBackupButton: UIButton!
    @IBOutlet var sendEmailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    func initViews() {
        editBabyButton.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        editBabyButton.layer.cornerRadius = 16
        
        dataBackupButton.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        dataBackupButton.layer.cornerRadius = 16
        
        sendEmailButton.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        sendEmailButton.layer.cornerRadius = 16
    }
    
    @IBAction func tappedLogout(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
        } catch let signOutError {
            print("Error sigining out: %@", signOutError)
        }
    }
    
    @IBAction func tappedShare(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "646223", message: "상대방 휴대폰에서 위의 번호를 입력하세요.\n 연결이 완료되기 전에 이 창을 끄지 마십시오.", preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
            ShareHelper.removeShareSession(completion: { 
                print("share quit")
            })
        }
        
        alertController.addAction(doneAction)
        
        startLoading()
        ShareHelper.createShareSession {
            self.stopLoading()
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func tappedLink(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Enter Code", message: "Enter mom's code", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.keyboardType = .numberPad
        }
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
            if let linkCode = alertController.textFields?.first?.text {
                if let intCode = Int(linkCode) {
                    ShareHelper.linkWithPartner(sixDigits: intCode, completion: {
                        print("link complete")
                    })
                }
            }
        }
        
        alertController.addAction(doneAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
