//
//  SearchVC.swift
//  InstaClone
//
//  Created by Gabriel Benbow on 2/10/16.
//  Copyright © 2016 Gabriel Benbow. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

	@IBOutlet weak var searchbar: UISearchBar!
	
	@IBOutlet weak var SearchTableView: UITableView!
	
	var users = [String]()
	var filteredUsers = []
	

	
	var searchActive = false
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		SearchTableView.delegate = self
		SearchTableView.dataSource = self
		searchbar.delegate = self
		
		
		
		
    }
	
	func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
		searchActive = true
	}
	
	func searchBarTextDidEndEditing(searchBar: UISearchBar) {
		searchActive = false
		
	}
	
	func searchBarCancelButtonClicked(searchBar: UISearchBar) {
		searchActive = false
		self.users = []
		self.SearchTableView.reloadData()
		
	}
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		searchActive = false
		UIApplication.sharedApplication().sendAction("resignFirstResponder", to:nil, from:nil, forEvent:nil)

	}
	
	
	
	
	func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
		if searchBar.text == "" || searchBar.text == nil {
			searchActive = false
			self.users = []
			SearchTableView.reloadData()
		} else {
			searchActive = true
			let lowercase = searchText.lowercaseString
			
			self.getSearchData(lowercase)
			self.users = []

			
			
		}
	}
	
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if searchActive {
		return self.users.count
		}
		else {
			return 0
		}
	}
	
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let user = users[indexPath.row]
		if let cell = SearchTableView.dequeueReusableCellWithIdentifier("profilecell") as? ProfileCell {
			
			
			cell.configureCell(user)
			return cell
			
		} else {
			
		return UITableViewCell()
		}
	}
	

	
	func getSearchData(searchText: String) {
		
		let ref = Firebase(url: "https://ph-watch.firebaseio.com/usernames")
		
		ref.queryOrderedByKey().queryStartingAtValue(searchText).queryEndingAtValue("\(searchText)\u{f8ff}").observeEventType(.ChildAdded, withBlock: { snapshot in
			
			if snapshot != nil {
			
				let value = snapshot.value as! String
				self.users.append(value)
			}
			self.SearchTableView.reloadData()
		})
		
		
		
	}
	
	
	
}


