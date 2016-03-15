//
//  PostCell.swift
//  Social_App
//
//  Created by Gabriel Benbow on 1/25/16.
//  Copyright © 2016 Gabriel Benbow. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import AlamofireImage

class PostCell: UITableViewCell {

	@IBOutlet weak var profileImg: UIImageView!
	@IBOutlet weak var mainImg: UIImageView!
	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var likesLabel: UILabel!
	@IBOutlet weak var heartImg: UIImageView!
	@IBOutlet weak var usernameLabl: UILabel!
	var likeRef: Firebase!
	var url: String!
	
	var _post: Post!
	var post: Post? {
		return _post
	}
	
	var _user: User!
	var user: User! {
	return _user
	}
	
	
	var feedVC: FeedVC?

	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		let tap = UITapGestureRecognizer(target: self, action: "likeTapped:")
		tap.numberOfTapsRequired = 1
		self.heartImg.addGestureRecognizer(tap)
		self.heartImg.userInteractionEnabled = true
		
		
	}
	
	override func drawRect(rect: CGRect) {
		profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
	}
	
	func configureCell(post: Post, userKey: String) {
		
		
		likeRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postKey)
		
		self._post = post
		
		let UserRef = DataService.ds.REF_USERS.childByAppendingPath(userKey)
		UserRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
			if let userDict = snapshot.value as? Dictionary<String, AnyObject> {
				let username = userDict["username"] as! String
				self.usernameLabl.text = username
				
				let profile = userDict["profileImageUrl"] as! String
				Alamofire.request(.GET, profile).validate(contentType: ["image/*"]).response(completionHandler: {
					request, response, data, err in
					
					if err == nil {
						let pImg = UIImage(data: data!)!
						self.profileImg.image = pImg
					}
				})
			}
			})
//		DataService.ds.REF_USERS.childByAppendingPath(userKey).observeSingleEventOfType(.Value, withBlock: { snapshot in
//			
//			if let userDict = snapshot.value as? Dictionary<String,AnyObject> {
//				
//				self._user = User(userKey: userKey, dictionary: userDict)
//				self.usernameLabl.text = self.user.username
//				
//				let url = self.user.profileImageURL
//				self.getProfileImage(url)
//			}
//		})

		self.title.text = post.postDescription
		self.likesLabel.text = "\(post.likes)"
		
	
		Alamofire.request(.GET, post.imageURL!).response(completionHandler: { request, response, data, err in
		 
				
				self.mainImg.image = UIImage(data: data!)
			
			
			
			if post.imageURL != nil {
				
			} else {
			print("failed!")
			self.mainImg.hidden = true
		}
		})
		
			
		
	likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
		if snapshot.exists() {
			self.heartImg.image = UIImage(named: "heart-full")
			
			} else {
			self.heartImg.image = UIImage(named: "heart-empty")
							}
		})
	}
	
	func getProfileImage(url: String) {
		Alamofire.request(.GET, url).response(completionHandler: { request, response, data, err in
		 
			
			self.profileImg.image = UIImage(data: data!)
			
		})
	}
	
	func likeTapped(sender: UITapGestureRecognizer) {
		self.likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
			if snapshot.exists() {
				self.likeRef.removeValue()
				self.heartImg.image = UIImage(named: "heart-empty")
				self._post.adjustLikes(false)
			
				
			} else {
				self.likeRef.setValue(true)
				self.heartImg.image = UIImage(named: "heart-full")
				self._post.adjustLikes(true)

				
			}
		})
	}

	
	
	
	}