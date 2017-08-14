//
//  TipsDetailHeaderTableViewCell.swift
//  CocoaBaby
//
//  Created by LEOFALCON on 2017. 8. 14..
//  Copyright © 2017년 Sohn. All rights reserved.
//

import UIKit

class TipsDetailHeaderTableViewCell: UITableViewCell {

    @IBOutlet var weekTitle : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.clear
        self.layer.backgroundColor = UIColor.clear.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initWeekTitle(week : Int)  {
        self.weekTitle?.text = "Week \(week)"
    }
    
}
