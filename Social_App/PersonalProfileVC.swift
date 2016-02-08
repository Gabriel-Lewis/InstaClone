//
//  PersonalProfileVC.swift
//  Social_App
//
//  Created by Gabriel Benbow on 2/5/16.
//  Copyright © 2016 Gabriel Benbow. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class PersonalProfileVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	var posts = [Post]()
	var userKey: String?
	
	@IBOutlet weak var photoCollectionCell: UICollectionView!
	@IBOutlet weak var profileImage: UIImageView!
	@IBOutlet weak var usernameLbl: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		photoCollectionCell.dataSource = self
		photoCollectionCell.delegate = self
		
		DataService.ds.REF_USER_CURRENT.childByAppendingPath("posts").observeEventType(.ChildAdded, withBlock: { snap in
			let postkey = snap.key
			
			DataService.ds.REF_POSTS.childByAppendingPath(postkey).observeEventType(.Value, withBlock: { snap in
			
				
					
				if let postDict = snap.value as? Dictionary<String,AnyObject> {
					
				let post = Post(postKey: snap.key, dictionary: postDict)
				self.posts.append(post)
					}
				self.sortList()
			})

		})
		
		
		DataService.ds.REF_USER_CURRENT.observeEventType(.Value, withBlock: { snapshot in
			
			if let userDict = snapshot.value as? Dictionary<String,AnyObject> {
				let username = userDict["username"] as! String
				let profileimgurl = userDict["profileImageUrl"] as! String
				self.usernameLbl.text = username
				
				Alamofire.request(.GET, profileimgurl).validate(contentType: ["image/*"]).response(completionHandler: {  request, response, data, err in
				
					if err == nil {
						self.profileImage.image = UIImage(data: data!)
						
					}
				})
				
			}
		})
    }
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		return CGSizeMake(105, 105)
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let post = posts[indexPath.row]
		
		if let cell = photoCollectionCell.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as? CollectionViewCell {
			
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
		self.photoCollectionCell.reloadData()
	}


}
