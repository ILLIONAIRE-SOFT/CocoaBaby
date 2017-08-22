//
//  TabBarViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 02/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundImage = UIImage(named: "transparentBackground")
        tabBar.shadowImage = UIImage(named: "transparentBackground")
        tabBar.unselectedItemTintColor = UIColor.white
        
        guard Locale.current.languageCode == "ko" || Locale.current.regionCode == "KR" else {
            self.viewControllers?[2] = (self.viewControllers?[3])!
            self.viewControllers?.removeLast()
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Tab Bar viewWillAppear")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appDelegate.isNeedHandleDiaryResponse {
            self.selectedIndex = 1
            appDelegate.isNeedHandleDiaryResponse = false
        }
        
        if appDelegate.isNeedHandleWriteDiaryQuickAction {
            self.selectedIndex = 1
            appDelegate.isNeedHandleWriteDiaryQuickAction = false
        }
    }

}
