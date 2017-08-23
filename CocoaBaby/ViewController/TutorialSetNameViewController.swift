//
//  TutorialSetNameViewController.swift
//  CocoaBaby
//
//  Created by LEOFALCON on 2017. 8. 2..
//  Copyright © 2017년 Sohn. All rights reserved.
//

import UIKit

class TutorialSetNameViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet var babyNameTextField : UITextField!
    @IBOutlet var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        babyNameTextField.delegate = self
        babyNameTextField.setBottomBorder()
        self.navigationController?.navigationBar.isHidden = true
        nextButton.isEnabled = false
        
        babyNameTextField.textColor = .white
        babyNameTextField.attributedPlaceholder = NSAttributedString(string: "아이의 태명을 입력해 주세요", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        self.nextButton.layer.cornerRadius = 5
    }
    
    @IBAction func resignKeyBoard() {
        self.babyNameTextField.resignFirstResponder()
    }
    
    @IBAction func babyNameTextFieldEditChange(_ textField: UITextField) {
        if textField.text == "" {
            nextButton.isEnabled = false
        }else {
            nextButton.isEnabled = true
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSetDate" {
            let destinationViewController = segue.destination as! TutorialSetDateViewController
            
            if let babyName = babyNameTextField.text {
                destinationViewController.babyName = babyName
            }
        }
    }

}
