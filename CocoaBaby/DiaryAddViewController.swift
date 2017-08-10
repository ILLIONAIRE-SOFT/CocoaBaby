//
//  DiaryAddViewController.swift
//  CocoaBaby
//
//  Created by dadong on 2017. 8. 9..
//  Copyright © 2017년 Sohn. All rights reserved.
//

import UIKit

class DiaryAddViewController: DiaryBaseViewController {
    
    @IBOutlet var addDiraryUIToolbar: UIToolbar!
    @IBOutlet var doneAddDiaryBtn: UIBarButtonItem!
    @IBOutlet var textViewBg: UIView!
    @IBOutlet var textView: UITextView!
    @IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
    var toolbarBottomConstraintInitialValue: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textViewBg.layer.cornerRadius = 4
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.toolbarBottomConstraintInitialValue = toolbarBottomConstraint.constant
        
        enableKeyboardHideOnTap()
    }
    
    private func enableKeyboardHideOnTap(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: duration) { () -> Void in
            self.toolbarBottomConstraint.constant = keyboardFrame.size.height
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: duration) { () -> Void in
            self.toolbarBottomConstraint.constant = self.toolbarBottomConstraintInitialValue!
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textView.resignFirstResponder()
    }
    
    @IBAction func tappedDone(_ sender: UIBarButtonItem) {
        let components = CocoaDateFormatter.createComponents(from: Date())
        
        guard
            let year = components.year,
            let month = components.month,
            let day = components.day else {
                return
        }
        
        CKDiaryStore.shared.saveDiaries(text: textView.text, year: year, month: month, day: day)
        
        self.dismiss(animated: true) {
            
        }
    }
}
