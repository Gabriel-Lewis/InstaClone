//
//  UsernameVC.swift
//  Social_App
//
//  Created by Gabriel Benbow on 1/28/16.
//  Copyright © 2016 Gabriel Benbow. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class UsernameVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	var imageSelected = false
	var imagePicker: UIImagePickerController!
	var user: User!
	
	@IBOutlet weak var userNameLbl: UITextField!
	@IBOutlet weak var profileImage: UIImageView!
	
	@IBOutlet weak var buttonLabel: UIButton!
	@IBAction func createUser(Sender: AnyObject){
		
		if userNameLbl.text != "" && imageSelected == true {
		let usernametext = userNameLbl.text!.lowercaseString
		DataService.ds.REF_USER_CURRENT.childByAppendingPath("username").setValue(usernametext)
			let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
		DataService.ds.REF_USERNAMES.childByAppendingPath(usernametext).setValue(uid)
		pictureUpload()
		
		NSUserDefaults.standardUserDefaults().setObject(usernametext, forKey: USERNAME)
		performSegueWithIdentifier("loggedInWithUsername", sender: nil)
		} else {
			showErrorAlert("Missing Username/Profile Image", msg: "Select a profile image, and username to continue")
		}
	}
	
	@IBAction func ImagePicker(sender: AnyObject) {
		presentViewController(imagePicker, animated: true, completion: nil)
		
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		dismissViewControllerAnimated(true, completion: nil)
		profileImage.image = image
		imageSelected = true
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		imagePicker = UIImagePickerController()
		imagePicker.delegate = self
    }
	
	func postProfileImageToFireB(url: String) {
		NSUserDefaults.standardUserDefaults().setObject(url, forKey: "profileImageUrl")
		DataService.ds.REF_USER_CURRENT.childByAppendingPath("profileImageUrl").setValue(url)
	}
	
	func pictureUpload() {
		
		if let img = profileImage.image where imageSelected == true {
			
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
											let finalLink = "http://\(imgLink)"
											self.postProfileImageToFireB(finalLink)
										}
									}
								}
							}
						}
					case .Failure(let error):
						print(error)
					}
			})
		}
	}
	
	func showErrorAlert(title: String, msg: String) {
		let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
		let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
		alert.addAction(action)
		presentViewController(alert, animated: true, completion: nil)
	}
	
	
	
	
}
