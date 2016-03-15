//
//  ImageDetailVC.swift
//  Social_App
//
//  Created by Gabriel Benbow on 1/29/16.
//  Copyright © 2016 Gabriel Benbow. All rights reserved.
//

import UIKit
import Alamofire
import Firebase


class ImageDetailVC: UIViewController {

	@IBOutlet weak var image: UIImageView!
	@IBOutlet weak var label: UILabel!
	var eventData: NSIndexPath!
	var posts = [Post]()
	var post: Post!
	
	override func viewDidLoad() {
        super.viewDidLoad()
			
			DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapShot in
				
				if let snapshots = snapShot.children.allObjects as? [FDataSnapshot] {
					self.posts = []
					for snap in snapshots {
						
						if let postDict = snap.value as? Dictionary<String,AnyObject> {
							let key = snap.key
							let post = Post(postKey: key, dictionary: postDict)
							self.posts.append(post)
						}
					}
					
				}
				//self.sortList()
				self.configureView(self.posts[self.eventData.row])
			})
		
    }
	
	func configureView(post: Post) {
		label.text = post.postDescription
		let url = post.imageURL
		//image.image = FeedVC.imageCache.objectForKey(url!) as? UIImage
	}
	
//	func sortList() {
//		posts.sortInPlace() { $0.date > $1.date }
//		
//	}
}
