//
//  TipsTableViewCell.swift
//  CocoaBaby
//
//  Created by LEOFALCON on 2017. 8. 7..
//  Copyright © 2017년 Sohn. All rights reserved.
//

import UIKit

class TipsTableViewCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.title.layer.cornerRadius = 15
        self.title.layer.backgroundColor = UIColor.clear.cgColor
        self.title.layer.borderColor = UIColor.white.cgColor
        self.title.layer.borderWidth = 1
        self.title.textColor = UIColor.white
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
