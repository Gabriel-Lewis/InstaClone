//
//  materialTextField.swift
//  Social_App
//
//  Created by Gabriel Benbow on 1/23/16.
//  Copyright © 2016 Gabriel Benbow. All rights reserved.
//

import UIKit

class materialTextField: UITextField {
	override func awakeFromNib() {
		layer.cornerRadius = 2.0
		layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
		layer.shadowOpacity = 0.8
		layer.shadowRadius = 5.0
		layer.shadowOffset = CGSizeMake(0.0, 2.0)
	}
	override func textRectForBounds(bounds: CGRect) -> CGRect {
		return CGRectInset(bounds, 10, 0)
	}
	//
	override func editingRectForBounds(bounds:CGRect) -> CGRect {
		return CGRectInset(bounds, 10, 0)
	}
}
