//
//  TipsDetailViewController.swift
//  CocoaBaby
//
//  Created by LEOFALCON on 2017. 8. 7..
//  Copyright © 2017년 Sohn. All rights reserved.
//

import UIKit

class TipsDetailViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var weekTitle: UILabel!
    @IBOutlet var babyTipTitle: UILabel!
    @IBOutlet var babyTip: UILabel!
    @IBOutlet var motherTipTitle: UILabel!
    @IBOutlet var motherTip: UILabel!
    @IBOutlet var fatherTipTitle: UILabel!
    @IBOutlet var fatherTip: UILabel!
    
    @IBOutlet var contentsView: UIView!
    override func viewDidLoad() {

        
        babyTip.lineBreakMode = .byWordWrapping
        babyTip.numberOfLines = 0;

        motherTip.lineBreakMode = .byWordWrapping
        motherTip.numberOfLines = 0;

        fatherTip.lineBreakMode = .byWordWrapping
        fatherTip.numberOfLines = 0;

        babyTip.text = "지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는"
        motherTip.text = "지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는"
        fatherTip.text = "지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는지금 아기는"
    }


}
