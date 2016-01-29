//
//  User.swift
//  Social_App
//
//  Created by Gabriel Benbow on 1/28/16.
//  Copyright © 2016 Gabriel Benbow. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Alamofire

class User {
	
	private var _profileImageURL: String!
	private var _username: String!
	private var _userKey: String!
	private var _userRef: Firebase!
	
	var profileImageURL: String! {
		return _profileImageURL
	}
	
	var username: String! {
		return _username
	}
	
	var userKey: String! {
		return _userKey
	}
	
	init(username: String, profileImageUrl: String) {
		self._profileImageURL = profileImageUrl
		self._username = username
	}
	
	init(userKey: String, dictionary: Dictionary<String, AnyObject>) {
		self._userKey = userKey
		
		
		
		if let username = dictionary["username"] as? String {
			self._username = username
		}
		
		self._userRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath(self.userKey)
	}
	
	
}