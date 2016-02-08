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

class PersonalProfileVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

	var userKey: String?
	
	@IBOutlet weak var photoCollectionCell: UICollectionView!
	@IBOutlet weak var profileImage: UIImageView!
	@IBOutlet weak var usernameLbl: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		//userKey = NSUserDefaults.standardUserDefaults().valueForKeyPath(KEY_UID) as? String
		//print(userKey!)
		
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
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		return CollectionViewCell()
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 1
	}


}
