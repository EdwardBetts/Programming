//
//  Global.swift
//  GoGoGo
//
//  Created by Byron Coetsee on 2015/01/20.
//  Copyright (c) 2015 GoMetro (Pty) Ltd. All rights reserved.
//

import Foundation
import UIKit

var pref: settings = settings()

class settings: UIViewController {
	
	func buildColour(content: String) -> UIColor
	{
		var rgb: [String] = content.componentsSeparatedByString(",")
		var red: CGFloat = CGFloat((rgb[0] as NSString).floatValue)/255
		var green: CGFloat = CGFloat((rgb[1] as NSString).floatValue)/255
		var blue: CGFloat = CGFloat((rgb[2] as NSString).floatValue)/255
		
		return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
	}	
}