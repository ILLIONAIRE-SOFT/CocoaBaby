//
//  BaseViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 04/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var overlay: UIView?
    var activityIndicator: UIActivityIndicatorView?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Gradation2")!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopLoading()
        //        hideOverlay()
    }
    
    func startLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        overlay = UIView(frame: view.frame)
        overlay?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator?.center = CGPoint(x: (overlay?.bounds.width)!/2, y: (overlay?.bounds.height)!/2)
        
        overlay?.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
        
        view.addSubview(overlay!)
    }
    
    func stopLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        guard
            let overlay = overlay,
            let indicator = activityIndicator else {
                return
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            overlay.alpha = 0
        }) { (_) in
            indicator.stopAnimating()
            indicator.removeFromSuperview()
            overlay.removeFromSuperview()
        }
    }
    
    func addOverlay() {
        overlay = UIView(frame: view.frame)
        overlay?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        view.addSubview(overlay!)
    }
    
    func hideOverlay() {
        print("Hide Overlay")
        guard let overlay = overlay else {
            print("Overlay not exist")
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            print("Make overlay alpha 0")
            overlay.alpha = 0
        }) { (_) in
            overlay.removeFromSuperview()
        }
    }
    
    func changeBgColorBasedOnTime() {
        
        let date = Date()
        let currentHour = Calendar.current.component(.hour, from: date)
        if currentHour > 19 || currentHour < 6 { //Night
            // diaryTableView.backgroundColor = UIColor.init(colorWithHexValue: 0x3f305d, alpha: 1)
            self.view.backgroundColor = UIColor.init(colorWithHexValue: 0x3f305d, alpha: 1)
            
        } else if currentHour >= 6 && currentHour < 16{
            
        } else if currentHour >= 16 && currentHour <= 19 {
            // diaryTableView.backgroundColor = UIColor.init(colorWithHexValue: 0x4a3252, alpha: 1)
            self.view.backgroundColor = UIColor.init(colorWithHexValue: 0x4a3252, alpha: 1)
            
        } else {
            
        }
        
    }
    
    func showSuccessToastMessage()  {
        let message = UIView(frame: CGRect(x: 0, y: -40, width: self.view.frame.width, height: 40))
        message.backgroundColor = UIColor(colorWithHexValue: 0xFFFFFF)
        
        let label = UILabel(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: 20))
        label.textAlignment = .center
        label.text = "Saved"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 13)
        message.addSubview(label)
        
        UIApplication.shared.keyWindow?.addSubview(message)
        
        UIView.animate(withDuration: 0.5, animations: {
            message.frame.origin.y += message.frame.height
        }) { (isCompleted) in
            UIView.animateKeyframes(withDuration: 0.5, delay: 1, animations: { 
                message.frame.origin.y -= message.frame.height
            })
        }
    }

    
}
