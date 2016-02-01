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

class PostCell: UITableViewCell {

	@IBOutlet weak var profileImg: UIImageView!
	@IBOutlet weak var mainImg: UIImageView!
	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var likesLabel: UILabel!
	@IBOutlet weak var heartImg: UIImageView!
	@IBOutlet weak var usernameLabl: UILabel!
	
	var likeRef: Firebase!
	var _post: Post!
	var post: Post? {
		return _post
	}
	
	var user: User? {
		return _user
	}
	
	var _user: User!
	
	var request: Request?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		let tap = UITapGestureRecognizer(target: self, action: "likeTapped:")
		tap.numberOfTapsRequired = 1
		heartImg.addGestureRecognizer(tap)
		heartImg.userInteractionEnabled = true
		
		
	}
	
	override func drawRect(rect: CGRect) {
		profileImg.layer.cornerRadius = 10
		
	}
	
	func configureCell(post: Post, img: UIImage?) {
		
		self._post = post
		likeRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postKey)
		self.usernameLabl.text = post.username
		self.title.text = post.postDescription
		self.likesLabel.text = "\(post.likes)"
		
		// profile image start
		
		Alamofire.request(.GET, post.profileImageURL!).validate(contentType: ["image/*"]).response(completionHandler: {
			request, response, data, err in
			
			if err == nil {
				let pImg = UIImage(data: data!)!
				self.profileImg.image = pImg
			}
			})
		
		// profile image stop
			
			if img != nil {
				
				self.mainImg.image = img
			} else {
				
				Alamofire.request(.GET, post.imageURL!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, err in
					
					if err == nil {
						
						//Add If let!!!
						let img = UIImage(data: data!)!
						self.mainImg.image = img
						FeedVC.imageCache.setObject(img, forKey: self._post.imageURL!)
						self.mainImg.hidden = false
						
					}
				})
			}
			
			if post.imageURL != nil {
		} else {
			print("failed!")
			self.mainImg.hidden = true
		}
		
		likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
			
			if let doesNotExist = snapshot.value as? NSNull {
				self.heartImg.image = UIImage(named: "heart-empty")
			} else {
				self.heartImg.image = UIImage(named: "heart-full")
			}
		})
	}
	
	func likeTapped(sender: UITapGestureRecognizer) {
		likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
		if let doesNotExist = snapshot.value as? NSNull {
			self.heartImg.image = UIImage(named: "heart-full")
			self._post.adjustLikes(true)
			self.likeRef.setValue(true)
		} else {
			self.heartImg.image = UIImage(named: "heart-empty")
			self._post.adjustLikes(false)
			self.likeRef.removeValue()
		}
	})
		
		
	}
	
	
	
	
	}
	
	



