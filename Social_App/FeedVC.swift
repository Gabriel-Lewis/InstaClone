//
//  FeedVC.swift
//  Social_App
//
//  Created by Gabriel Benbow on 1/25/16.
//  Copyright © 2016 Gabriel Benbow. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import AlamofireImage


class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

	
	@IBOutlet weak var feedTV: UITableView!
	
	var posts = [Post]()
	var list = [Post]()
	var postKeys = [String]()
	var post: Post!
	var following = [String]()
	var cell: PostCell!
	var user: User!
	
	//static var imageCache = NSCache()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		

		feedTV.delegate = self
		feedTV.dataSource = self
		feedTV.allowsSelection = false

		initObservers()


	}
	
	func initObservers() {
		
	DataService.ds.REF_USER_CURRENT.childByAppendingPath("following").observeSingleEventOfType(.Value, withBlock: { snapshot in
		self.following = []

		if snapshot.exists() {
			if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
				
				for snap in snapshots {
					self.following.append(snap.key)
					
					}
				}
			self.postKeys = []
			self.posts = []
			for userkeys in self.following {
				DataService.ds.REF_USERS.childByAppendingPath(userkeys).childByAppendingPath("posts").observeSingleEventOfType(.Value, withBlock: { snapshot in
					
					if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
						for snap in snapshots {
							let key = snap.key
							self.postKeys.append(key)
				
				
			
							DataService.ds.REF_POSTS.childByAppendingPath(key).observeSingleEventOfType(.Value, withBlock: { snapshot in
								
								if let postDict = snapshot.value as? Dictionary<String, AnyObject> {
									let post = Post(postKey: key, dictionary: postDict)
									self.posts.append(post)
									self.feedTV.reloadData()
									
								}
								
							})
						}
						
					}
				})
			}
			}
		


		})

	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.posts.count
	}
	

	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		let height = self.feedTV.layer.frame.height
		return height / 1.25
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let post1 = posts[indexPath.row]
		let userkey = post1.userKey
		
			
			
		if let cell = feedTV.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as? PostCell {
			
			
				
			
			
			cell.configureCell(post1, userKey: userkey)
			//			if let url = post.imageURL {
//				img = FeedVC.imageCache.objectForKey(url) as? UIImage
//			}
//			let tap = UITapGestureRecognizer(target: self, action: "handleTap:")
//			tap.numberOfTapsRequired = 1
//			cell.profileImg.addGestureRecognizer(tap)
			
			
			
			return cell
			
		} else {
			return PostCell()
		}
	
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		if segue.identifier == "showProfile" {
			let destination = segue.destinationViewController as? ProfileVC
			let user1 = posts[(sender?.row)!].userKey
			destination!.userKey = user1
			
		}
		
	}
	
	
	func handleTap(sender: UITapGestureRecognizer) {
		let touch = sender.locationInView(feedTV)
		if let indexPath = feedTV.indexPathForRowAtPoint(touch) {
			performSegueWithIdentifier("showProfile", sender: indexPath)
		}
	}
	
	func sortList() {
		self.posts.sortInPlace() { $0.date > $1.date }
		self.feedTV.reloadData()
	}
	
	
}


