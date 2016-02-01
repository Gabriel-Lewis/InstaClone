//
//  ViewController.swift
//  Social_App
//
//  Created by Gabriel Benbow on 1/23/16.
//  Copyright © 2016 Gabriel Benbow. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController {
	
	@IBOutlet weak var emailField: materialTextField!
	@IBOutlet weak var passwordField: materialTextField!
	
	@IBAction func EmailAttemptLogin(sender: AnyObject) {
		if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
			DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error, authData in
				
				if error != nil {
					print(error)
					
					if error.code == STATUS_NONEXIST_ACCOUNT {

						DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { error, result in
							
							if error != nil {
								
							self.showErrorAlert("Could not create Account", msg: "Problem Creating Account")
								
							} else {
								
								NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
								DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: {
									err, authData in
									
									let user = ["provider": authData.provider!]
									DataService.ds.createFirebaseUser(authData.uid, user: user)
								})
								self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
							}
						})
					} else {
						self.showErrorAlert("Login Error", msg: "The specified password is incorrect")
					}
				} else { self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)}
				
			})
		} else {
			showErrorAlert("Email and Password Required", msg: "Enter both Email and password to login")
		}
	}
	
	func showErrorAlert(title: String, msg: String) {
		let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
		let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
		alert.addAction(action)
		presentViewController(alert, animated: true, completion: nil)
	}

	@IBAction func fbButtonPressed(sender: AnyObject!) {
		let loginManager = FBSDKLoginManager()
		
		loginManager.logInWithReadPermissions(["email"], fromViewController: nil, handler: { (result, FBerror) -> Void in
			
			if  FBerror != nil {
				print("facebook login failed \(FBerror)")
			} else if result.isCancelled {
				print("login canceled")
			} else {
				let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
				
				DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { (error, authData) -> Void in
					if error != nil {
						print("login failed \(error)")
					} else {
						
						NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
						self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
						//If let
						let user = ["provider": authData.provider!]
						DataService.ds.createFirebaseUser(authData.uid, user: user)
						
					}
				})
			}
		})
	}

	
	
	
}