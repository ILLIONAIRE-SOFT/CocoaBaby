//
//  WelcomeViewController.swift
//  CocoaBaby
//
//  Created by Sohn on 22/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit

class WelcomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        self.hidesBottomBarWhenPushed = true
    }
    
}
