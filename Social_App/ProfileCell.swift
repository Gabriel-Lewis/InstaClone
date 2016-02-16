//
//  ProfileCell.swift
//  InstaClone
//
//  Created by Gabriel Benbow on 2/10/16.
//  Copyright © 2016 Gabriel Benbow. All rights reserved.
//

import UIKit
import Alamofire
import Firebase


class ProfileCell: UITableViewCell {

	@IBOutlet weak var profileImage: UIImageView!
	@IBOutlet weak var usernameLabel: UILabel!
	

	var UserRef: Firebase!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		
				
    }
	
	override func drawRect(rect: CGRect) {
		profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
	}

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func configureCell(userKey: String) {
		
		
		UserRef = DataService.ds.REF_USERS.childByAppendingPath(userKey)
		UserRef.observeEventType(.Value, withBlock: { snapshot in
			if let userDict = snapshot.value as? Dictionary<String, AnyObject> {
				let username = userDict["username"] as! String
				self.usernameLabel.text = username
				
				let profile = userDict["profileImageUrl"] as! String
				Alamofire.request(.GET, profile).validate(contentType: ["image/*"]).response(completionHandler: {
					request, response, data, err in
					
					if err == nil {
						let pImg = UIImage(data: data!)!
						self.profileImage.image = pImg
					}
				})
				
			}
			
		})
	}
	
	
	

}
