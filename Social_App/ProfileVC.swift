//
//  ProfileVC.swift
//  Social_App
//
//  Created by Gabriel Benbow on 2/1/16.
//  Copyright © 2016 Gabriel Benbow. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class ProfileVC: UIViewController {
	var user: User!
	var userKey = ""
	
	@IBOutlet weak var profileImg: UIImageView!
	@IBOutlet weak var usernameLbl: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
			let userRef = DataService.ds.REF_USERS.childByAppendingPath(userKey)
		
		userRef.observeEventType(.Value, withBlock: { snapshot in
		
			if let userDict = snapshot.value as? Dictionary<String,AnyObject> {
				let username = userDict["username"] as! String
				self.usernameLbl.text = username
				let profileImgUrl = userDict["profileImageUrl"] as! String
				
				Alamofire.request(.GET, profileImgUrl).validate(contentType: ["image/*"]).response(completionHandler: {
					request, response, data, err in
					
					if err == nil {
						let pImg = UIImage(data: data!)!
						self.profileImg.image = pImg
					}
				})
				
				
			}

		})
		
		
		
		}
}