//
//  BaseTableViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 21/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    var overlay: UIView?
    var activityIndicator: UIActivityIndicatorView?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.clearsSelectionOnViewWillAppear = true
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
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = UIColor.lightGray
        }
    }

}
