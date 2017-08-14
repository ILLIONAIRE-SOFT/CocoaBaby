//
//  TipsDetailContentTableViewCell.swift
//  CocoaBaby
//
//  Created by LEOFALCON on 2017. 8. 14..
//  Copyright © 2017년 Sohn. All rights reserved.
//

import UIKit

class TipsDetailContentTableViewCell: UITableViewCell {

    @IBOutlet var content: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }

    func setContent(content : String)  {
        self.content.text = content
    }
    
}
