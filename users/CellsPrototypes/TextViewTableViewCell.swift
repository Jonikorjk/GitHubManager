//
//  TextViewTableViewCell.swift
//  users
//
//  Created by User on 22.11.2022.
//

import UIKit

class TextViewTableViewCell: UITableViewCell {
    @IBOutlet var additionalInfo: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
