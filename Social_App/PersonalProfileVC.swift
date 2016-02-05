//
//  PersonalProfileVC.swift
//  Social_App
//
//  Created by Gabriel Benbow on 2/5/16.
//  Copyright © 2016 Gabriel Benbow. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class PersonalProfileVC: UIViewController {

	var userKey: String?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		//userKey = NSUserDefaults.standardUserDefaults().valueForKeyPath(KEY_UID) as? String
		//print(userKey!)
		
		DataService.ds.REF_USER_CURRENT.observeEventType(.Value, withBlock: { snapshot in
			
			if let userDict = snapshot.value as? Dictionary<String,AnyObject> {
				let username = userDict["username"] as! String
				let profileimgurl = userDict["profileImageUrl"] as! String
				print(username)
				print(profileimgurl)
			}
		})
    }


}
