//
//  Posts.swift
//  Social_App
//
//  Created by Gabriel Benbow on 1/25/16.
//  Copyright © 2016 Gabriel Benbow. All rights reserved.
//

import Foundation
import Firebase

class Post {
	private var _postDescription: String!
	private var _imageURL: String?
	private var _username: String?
	private var _likes: Int!
	private var _postKey: String!
	private var _profileImageURL: String?
	private var _postRef: Firebase!
	
	var postDescription: String {
		return _postDescription
	}
	
	
	var imageURL: String? {
		
	return _imageURL
	}
	
	var likes: Int {
		return _likes
	}
	
	var username: String? {
		return _username
	}
	
	var postKey: String {
		return _postKey
	}
	var profileImageURL: String? {
		return _profileImageURL
	}
	
	init(description: String, imageURL: String, likes: Int, username: String, profileImgURL: String) {
		self._postDescription = description
		self._likes = likes
		self._username = username
		self._imageURL = imageURL
		self._profileImageURL = profileImageURL
		
	}
	
	init(postKey: String, dictionary: Dictionary<String, AnyObject>) {
		self._postKey = postKey
		
		if let likes = dictionary["likes"] as? Int {
			self._likes = likes
		}
		
		if let imgURL = dictionary["imageURL"] as? String {
			self._imageURL = imgURL
		}
		
		if let desc = dictionary["description"] as? String {
			self._postDescription = desc
		}
		
		if let username = dictionary["username"] as? String {
			self._username = username
		}
		
		if let profileImageURL = dictionary["profileImgUrl"] as? String {
			self._profileImageURL = profileImageURL
		}
		
		self._postRef = DataService.ds.REF_POSTS.childByAppendingPath(self.postKey)
	}
	
	func adjustLikes(addLike: Bool) {
		
		if addLike {
			_likes = _likes + 1
		} else {
			_likes = _likes - 1
		}
		
		_postRef.childByAppendingPath("likes").setValue(_likes)
		
	}
}