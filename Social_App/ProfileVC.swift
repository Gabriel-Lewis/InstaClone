//
//  ProfileVC.swift
//  Social_App
//
//  Created by Gabriel Benbow on 2/1/16.
//  Copyright © 2016 Gabriel Benbow. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class ProfileVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
	var user: User!
	var userKey: String!
	var posts = [Post]()
	var followingRef: Firebase!
	var followersRef: Firebase!

	
	@IBOutlet weak var photoCollection: UICollectionView!
	@IBOutlet weak var profileImg: UIImageView!
	@IBOutlet weak var usernameLbl: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
		photoCollection.dataSource = self
		photoCollection.delegate = self
		
		getPosts()
		getUser()
		
		}
	@IBAction func followBtnPressed(sender: AnyObject) {
		followingRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("following").childByAppendingPath(userKey)
		followingRef.setValue(true)
		
		let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
		
		followingRef = DataService.ds.REF_USERS.childByAppendingPath(userKey).childByAppendingPath("followers").childByAppendingPath(uid)
		followingRef.setValue(true)
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		
		let numberOfCell: CGFloat = 3
		let cellWidth = (self.photoCollection.bounds.size.width / numberOfCell) - 1
		return CGSizeMake(cellWidth, cellWidth)
	}
	
	
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let post = posts[indexPath.row]
		if let cell = photoCollection.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as? CollectionViewCell {
			
			cell.configureCell(post)
			return cell
		}
		else {
			return UICollectionViewCell()
		}
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return posts.count
	}
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func sortList() {
		posts.sortInPlace() { $0.date > $1.date }
		self.photoCollection.reloadData()
	}
	
	func getPosts() {
		DataService.ds.REF_USERS.childByAppendingPath(userKey).childByAppendingPath("posts").observeEventType(.ChildAdded, withBlock: { snap in
			let postkey = snap.key
			
			DataService.ds.REF_POSTS.childByAppendingPath(postkey).observeEventType(.Value, withBlock: { snap in
				
				
				
				if let postDict = snap.value as? Dictionary<String,AnyObject> {
					
					let post = Post(postKey: snap.key, dictionary: postDict)
					self.posts.append(post)
				}
				self.sortList()
			})
			
		})
		
	}
	
	func getUser() {
		let userRef = DataService.ds.REF_USERS.childByAppendingPath(userKey)
		
		userRef.observeEventType(.Value, withBlock: { snapshot in
			
			if let userDict = snapshot.value as? Dictionary<String,AnyObject> {
				let username = userDict["username"] as! String
				self.usernameLbl.text = username
				let profileImgUrl = userDict["profileImageUrl"] as! String
				
				Alamofire.request(.GET, profileImgUrl).validate(contentType: ["image/*"]).response(completionHandler: {
					request, response, data, err in
					
					if err == nil {
						let pImg = UIImage(data: data!)!
						self.profileImg.image = pImg
					}
				})
			}
		})
	}
	

}