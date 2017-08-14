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
    @IBOutlet weak var keyBoardHideBtn: UIBarButtonItem!
    var toolbarBottomConstraintInitialValue: CGFloat?
    
    var diary: Diary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textViewBg.layer.cornerRadius = 4
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let diary = diary {
            updateOriginalValue(diary: diary)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.toolbarBottomConstraintInitialValue = toolbarBottomConstraint.constant
        
        enableKeyboardHideOnTap()
    }
    
    // MARK: Methods
    func updateOriginalValue(diary: Diary) {
        self.textView.text = diary.text
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
    
    @IBAction func tappedHideKeyboard(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    @IBAction func tappedDone(_ sender: UIBarButtonItem) {
        saveDiary()
    }
    
    // MARK: Methods
    func saveDiary() {
        guard var diary = diary else {
            return
        }
        
        diary.text = textView.text
        
        DiaryStore.shared.saveDiary(diary: diary) { (result) in
            switch result {
            case .success(_):
                self.dismiss(animated: true, completion: nil)
                
            case let .failure(error):
                print(error)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        
    }
    
//    func updateDiary(diary: CKDiary) {
//        CKDiaryStore.shared.updateDiary(diary: diary, text: self.textView.text)
//        
//        self.dismiss(animated: true, completion: nil)
//    }
}
