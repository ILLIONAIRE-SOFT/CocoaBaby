//
//  TutorialSetNameViewController.swift
//  CocoaBaby
//
//  Created by LEOFALCON on 2017. 8. 2..
//  Copyright © 2017년 Sohn. All rights reserved.
//

import UIKit

class TutorialSetNameViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var babyNameTextField : UITextField!
    @IBOutlet var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        babyNameTextField.setBottomBorder()
        self.navigationController?.navigationBar.isHidden = true
        nextButton.isEnabled = false
        
        babyNameTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resignKeyBoard() {
        self.resignFirstResponder()
    }
    
    @IBAction func babyNameTextFieldEditChange(_ textField: UITextField) {
        if textField.text == "" {
            nextButton.isEnabled = false
        }else {
            nextButton.isEnabled = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "#" || string == "$" || string == "!"{
            return false
        }
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
