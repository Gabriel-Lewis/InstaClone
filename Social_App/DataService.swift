//
//  DataService.swift
//  Social_App
//
//  Created by Gabriel Benbow on 1/24/16.
//  Copyright © 2016 Gabriel Benbow. All rights reserved.
//

import Foundation
import Firebase

let BASE_URL = "https://ph-watch.firebaseio.com"

class DataService {
	static let ds = DataService()
	
	private var _REF_BASE = Firebase(url: "\(BASE_URL)")
	private var _REF_POSTS = Firebase(url: "\(BASE_URL)/posts")
	private var _REF_USERS = Firebase(url: "\(BASE_URL)/users")
	
	
	var REF_BASE: Firebase {
		return _REF_BASE
		
	}
	
	var REF_POSTS: Firebase {
		return _REF_POSTS
	}
	
	var REF_USERS: Firebase {
		return _REF_USERS
	}
	
	func createFirebaseUser(uid: String, user: Dictionary<String, String>) {
		REF_USERS.childByAppendingPath(uid).setValue(user)
	}
	
	var REF_USER_CURRENT: Firebase {
		
		let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
		
		let user = Firebase(url: "\(REF_USERS)").childByAppendingPath(uid)
			
		return user!
	}
	
	
	
}