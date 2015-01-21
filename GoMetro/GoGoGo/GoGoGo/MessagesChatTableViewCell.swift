//
//  MessagesChatTableViewCell.swift
//  GoGoGo
//
//  Created by Byron Coetsee on 2015/01/19.
//  Copyright (c) 2015 GoMetro (Pty) Ltd. All rights reserved.
//

import UIKit

class MessagesChatTableViewCell: UITableViewCell {
	
	@IBOutlet weak var imageProfilePic: UIImageView!
	@IBOutlet weak var lblName: UILabel!
	@IBOutlet weak var lblMessage: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
