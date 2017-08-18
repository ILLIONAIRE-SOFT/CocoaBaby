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
    @IBOutlet var contentsLabel: UILabel!
    @IBOutlet var addtionalDate: UILabel!
    @IBOutlet var weekLabel: UILabel!
    @IBOutlet var flagCommentImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        labelBackgroundView.layer.cornerRadius = 30
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func initViews(with diary: Diary) {
        self.contentsLabel.text = diary.text
        self.addtionalDate.text = "\(diary.date.day)"
        self.weekLabel.text = "\(CocoaDateFormatter.getWeekDay(from: diary))"
        
        if let comment = diary.comment {
            if comment != "" {
                flagCommentImageView.isHighlighted = true
            }
        }
        
        if weekLabel.text == "SAT" || weekLabel.text == "SUN" {
            self.weekLabel.textColor = UIColor.init(colorWithHexValue: 0xDF6C7E)
        } else {
            self.weekLabel.textColor = UIColor.darkGray
        }
    }
}
