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

}
