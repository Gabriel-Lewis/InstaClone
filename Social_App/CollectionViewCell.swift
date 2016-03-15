//
//  CollectionViewCell.swift
//  Social_App
//
//  Created by Gabriel Benbow on 2/7/16.
//  Copyright © 2016 Gabriel Benbow. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class CollectionViewCell: UICollectionViewCell {
	
	@IBOutlet weak var image: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
	}
	
	
	var _post: Post!
	
	var post: Post? {
		return _post
	}
	
	func configureCell(post: Post) {
		self._post = post
		DataService.ds.REF_POSTS.childByAppendingPath(post.postKey).observeEventType(.Value, withBlock: { snapshot in
			if let postDict = snapshot.value as? Dictionary<String,AnyObject> {
				let pic = postDict["imageURL"] as? String
				Alamofire.request(.GET, pic!).validate(contentType: ["image/*"]).response(completionHandler: {
				request, response, data, err in
					if err == nil {
						let pimg = UIImage(data: data!)!
						self.image.image = pimg
					}
				})
			}
		})
	}
}
