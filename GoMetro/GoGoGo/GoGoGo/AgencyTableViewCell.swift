//
//  AngecyTableViewCell.swift
//  GoGoGo
//
//  Created by Byron Coetsee on 2015/01/21.
//  Copyright (c) 2015 GoMetro (Pty) Ltd. All rights reserved.
//

import UIKit

class AgencyTableViewCell: UITableViewCell {
	
	@IBOutlet weak var imageAngency: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}

}
