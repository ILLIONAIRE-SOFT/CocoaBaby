//
//  SettingUINavigationController.swift
//  CocoaBaby
//
//  Created by dadong on 2017. 8. 23..
//  Copyright © 2017년 Sohn. All rights reserved.
//

import UIKit

class SettingUINavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
