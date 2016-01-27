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


class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	
	@IBOutlet weak var feedTV: UITableView!
	var imagePicker: UIImagePickerController!
	var posts = [Post]()
	var imageSelected = false
	
	static var imageCache = NSCache()
	
	@IBAction func selectImage(sender: UITapGestureRecognizer) {
		presentViewController(imagePicker, animated: true, completion: nil)
		
	}
	
	@IBOutlet weak var imageSelectorBG: UIImageView!
	
	@IBOutlet weak var postField: materialTextField!
	
	@IBAction func makePost(sender: AnyObject) {
		print("1")
		if let txt = postField.text where txt != "" {
			print("2")
			if let img = imageSelectorBG.image where imageSelected == true {
				print("3")
				
				let urlStr = "https://api.imageshack.com/v2/images"
				let url = NSURL(string: urlStr)!
				let imgData = UIImageJPEGRepresentation(img, 0.2)!
				let keyData = "12DJKPSU5fc3afbd01b1630cc718cae3043220f3".dataUsingEncoding(NSUTF8StringEncoding)!
				let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
				
				Alamofire.upload(.POST, url, multipartFormData: { multipartFormData in
					
					multipartFormData.appendBodyPart(data: imgData, name: "fileupload", fileName: "image", mimeType: "image/jgp")
					multipartFormData.appendBodyPart(data: keyData, name: "key")
					multipartFormData.appendBodyPart(data: keyJSON, name: "formart")
					
					}, encodingCompletion: { encodingResult in
						
						switch encodingResult {
							
						case .Success(let upload, _, _):
							
							upload.responseJSON { response in
								if let info = response.result.value as? Dictionary<String, AnyObject> {
									if let dict = info["result"] as? Dictionary<String,AnyObject> {
										if let images = dict["images"]?[0] as? Dictionary<String,AnyObject> {
										if let imgLink = images["direct_link"] as? String {
											print("Link: \(imgLink)")
											let finalLink = "http://\(imgLink)"
											self.postToFirebase(finalLink)
										}
										}
									}
								}
							}
						case .Failure(let error):
							print(error)
						}
				})
				
			} else {
				self.postToFirebase(nil)
			}
			
				
			}
			
		}
		
		
	
	override func viewDidLoad() {
		super.viewDidLoad()
		feedTV.delegate = self
		feedTV.dataSource = self
		imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		
		DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapShot in
			print(snapShot.value)
			
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
			
			self.feedTV.reloadData()
		})
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
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		imagePicker.dismissViewControllerAnimated(true, completion: nil)
		imageSelectorBG.image = image
		imageSelected = true
	}
	
	func postToFirebase(imgUrl: String?) {
		var post: Dictionary<String, AnyObject> = [
			"description": postField.text!,
			"likes": 0
		]
		
		if imgUrl != nil {
			post["imageURL"] = imgUrl!
		}
		
		let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
		firebasePost.setValue(post)
		
		postField.text = ""
		
		imageSelectorBG.image = nil
		
		imageSelected = false
		
		feedTV.reloadData()
	}
}
