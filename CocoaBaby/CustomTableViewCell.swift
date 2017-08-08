//
//  CustomTableViewCell.swift
//  CocoaBaby
//
//  Created by dadong on 2017. 8. 7..
//  Copyright © 2017년 Sohn. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
   
    @IBOutlet var labelBackgroundView: UIView!
    @IBOutlet var cellLabel: UILabel!
    @IBOutlet var contentsLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var addtionalDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        labelBackgroundView.layer.cornerRadius = 5
        
       // labelBackgroundView.layer.borderWidth = 0.5
       //labelBackgroundView.layer.borderColor = UIColor.lightGray.cgColor
//        labelBackgroundView.layer.masksToBounds = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
