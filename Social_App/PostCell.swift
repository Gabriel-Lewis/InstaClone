//
//  PostCell.swift
//  Social_App
//
//  Created by Gabriel Benbow on 1/25/16.
//  Copyright © 2016 Gabriel Benbow. All rights reserved.
//

import UIKit
import Alamofire

class PostCell: UITableViewCell {

	@IBOutlet weak var profileImg: UIImageView!
	@IBOutlet weak var mainImg: UIImageView!
	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var likesLabel: UILabel!
	
	var post: Post!
	var request: Request?
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override func drawRect(rect: CGRect) {
		profileImg.layer.cornerRadius = 10
		
	}
	
	func configureCell(post: Post, img: UIImage?) {
		self.post = post
		self.title.text = post.postDescription
		self.likesLabel.text = "\(post.likes)"
		
		if post.imageURL != nil {
			
			if img != nil {
				self.mainImg.image = img
			} else {
				
				Alamofire.request(.GET, post.imageURL!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, err in
					
					if err == nil {
						//Add If let!!!
						let img = UIImage(data: data!)!
						self.mainImg.image = img
						FeedVC.imageCache.setObject(img, forKey: self.post.imageURL!)
					}
					
					}) 
			}
		} else {
			self.mainImg.hidden = true
		}
	}
}
