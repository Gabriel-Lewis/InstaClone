//
//  FollowingButton.swift
//  InstaClone
//
//  Created by Gabriel Benbow on 2/15/16.
//  Copyright © 2016 Gabriel Benbow. All rights reserved.
//

import UIKit

class FollowingButton: UIButton {
	override func awakeFromNib() {
		layer.cornerRadius = 4
		layer.backgroundColor = UIColor.clearColor().CGColor
		
		layer.borderColor =  UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0).CGColor
		layer.borderWidth = 1
		
	}
	
}
