//
//  TipsDetailContentTableViewCell.swift
//  CocoaBaby
//
//  Created by LEOFALCON on 2017. 8. 14..
//  Copyright © 2017년 Sohn. All rights reserved.
//

import UIKit

class TipsDetailContentTableViewCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var content: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.title.textColor = UIColor.darkGray
        self.content.textColor = UIColor.darkGray
        self.backgroundColor = UIColor.clear

    }

    func setContent(title: String, content: String)  {
        self.title.text = title
        self.content.text = content
        let stringValue = content
        let attrString = NSMutableAttributedString(string: stringValue)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        style.minimumLineHeight = 20
        style.alignment = .justified
        attrString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: stringValue.characters.count))
        self.content.attributedText = attrString

    }
    
    
}
