//
//  Posts.swift
//  Social_App
//
//  Created by Gabriel Benbow on 1/25/16.
//  Copyright © 2016 Gabriel Benbow. All rights reserved.
//

import Foundation

class Post {
	private var _postDescription: String!
	private var _imageURL: String?
	private var _username: String!
	private var _likes: Int!
	private var _postKey: String!
	
	var postDescription: String? {
		return _postDescription
	}
	
	var imageURL: String? {
		
	return _imageURL
	}
	
	var likes: Int {
		return _likes
	}
	
	var username: String {
		return _username
	}
	
	init(description: String, imageURL: String, likes: Int, username: String) {
		self._postDescription = description
		self._likes = likes
		self._username = username
		self._imageURL = imageURL
		
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
	}
}