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


class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

	
	@IBOutlet weak var feedTV: UITableView!
	
	var posts = [Post]()
	var postKeys = [String]()
	var post: Post!
	var user: User!
	var following = [String]()
	static var imageCache = NSCache()
	var cell: PostCell!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	

		feedTV.delegate = self
		feedTV.dataSource = self
		DataService.ds.REF_USER_CURRENT.childByAppendingPath("following").observeEventType(.Value, withBlock: { snapshot in
			
			for snap in snapshot.value as! Dictionary<String, AnyObject> {
				
				self.following.append(snap.0)
				//print(self.following)
			}
			
			self.getFollowersPostKeys()
			
		})
		
		
		
		
//		DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapShot in
//			
//			if let snapshots = snapShot.children.allObjects as? [FDataSnapshot] {
//				self.posts = []
//				for snap in snapshots {
//					
//					if let postDict = snap.value as? Dictionary<String,AnyObject> {
//						let key = snap.key
//						let post = Post(postKey: key, dictionary: postDict)
//						self.posts.append(post)
//					}
//				}
//			}
//			self.sortList()
//		})
	}
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(true)
		

	}

	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return posts.count
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let post = posts[indexPath.row]
		if let cell = feedTV.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
			cell.request?.cancel()
			var img: UIImage?
			
			if let url = post.imageURL {
				img = FeedVC.imageCache.objectForKey(url) as? UIImage
			}
			
			cell.configureCell(post, img: img)
			
			return cell
			
		} else {
			return PostCell()
		}
	}

	
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		if segue.identifier == "showProfile" {
			let destination = segue.destinationViewController as? ProfileVC
			let cell = sender as! PostCell
			let selectedRow = feedTV.indexPathForCell(cell)
			let user1 = posts[(selectedRow?.row)!].userKey
			destination!.userKey = user1
			
		}
		
	}
	
	
	func sortList() {
		posts.sortInPlace() { $0.date > $1.date }
		
		self.feedTV.reloadData()
	}
	
	func someThing() {
	
		
		

	}
	
	
	
	func getFollowersPostKeys() {
		var x = 0
		
		while x != following.count {
			
			let userkey = following[x]
			
			DataService.ds.REF_USERS.childByAppendingPath(userkey).childByAppendingPath("posts").observeEventType(.Value, withBlock: { snapshot in
				for snap in snapshot.value as! Dictionary<String, AnyObject> {
					self.postKeys.append(snap.0)
					
				}
				self.getPosts()
			})
			x++
			if x == self.following.count {
				
				
			}
			
			
		}
		
	
		
	}
	
	func getPosts() {
		
		var x = 0
		
		while x != postKeys.count {
			self.posts = []

			let postkey = postKeys[x]
			
			DataService.ds.REF_POSTS.childByAppendingPath(postkey).observeEventType(.Value, withBlock: { snapshot in
				
				let postDict = snapshot.value as! Dictionary<String, AnyObject>
				let post = Post(postKey: snapshot.key, dictionary: postDict)
				self.posts.append(post)
				self.sortList()
			
			})
			
			x++
			if x == self.postKeys.count {
				print(x)
							}
			
		}
		
	}
	
	
	
	
}


