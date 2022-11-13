//
//  UserDetailsTableViewCell.swift
//  users
//
//  Created by User on 12.11.2022.
//

import UIKit

class UserDetailsTableViewCell: UITableViewCell {
    
    
    @IBOutlet var info: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
