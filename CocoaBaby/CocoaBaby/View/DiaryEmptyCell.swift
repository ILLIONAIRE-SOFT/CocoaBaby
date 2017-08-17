//
//  DiaryEmptyCell.swift
//  CocoaBaby
//
//  Created by Sohn on 12/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit

class DiaryEmptyCell: UITableViewCell {

    @IBOutlet var emptyLine: UIView!
    @IBOutlet weak var emptyCellDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        emptyLine.layer.cornerRadius = 4
        //emptyLine.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initCell(with date: Int) {
        self.emptyCellDate.text = "\(date)"
        
    }

}
