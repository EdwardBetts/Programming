//
//  MessagesChatInviteTableViewCell.swift
//  GoGoGo
//
//  Created by Byron Coetsee on 2015/01/19.
//  Copyright (c) 2015 GoMetro (Pty) Ltd. All rights reserved.
//

import UIKit

class MessagesChatInviteTableViewCell: UITableViewCell {
	
	@IBOutlet weak var imageProfilePic: UIImageView!
	@IBOutlet weak var lblRequestMessage: UILabel!
	@IBOutlet weak var btnAccept: UIButton!
	@IBOutlet weak var btnDeny: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
