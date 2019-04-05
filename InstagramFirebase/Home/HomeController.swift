//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 4/5/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

	let cellId = "cellId"
	var posts = [Post]()

	let logoImageView: UIImageView = {
		let iv = UIImageView(image: #imageLiteral(resourceName: "logo2").withRenderingMode(.alwaysOriginal))
		iv.contentMode = .scaleAspectFit
		return iv
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView.backgroundColor = .white

		collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)

		setupNavigationItems()

		fetchPosts()
	}

	fileprivate func fetchPosts() {
		guard let uid = Firebase.Auth.auth().currentUser?.uid else { return }
		let ref = Firebase.Database.database().reference().child("posts").child(uid)
		ref.observeSingleEvent(of: .value, with: { (snapshot) in
			guard let dictionaries = snapshot.value as? [String: Any] else { return }
			dictionaries.forEach({ (key, value) in
				guard let dictionary = value as? [String: Any] else { return }
				let post = Post(dictionary: dictionary)
				self.posts.append(post)
			})
			self.collectionView?.reloadData()
		}) { (err) in
			print("Failed to fetch posts:", err)
		}
	}

	func setupNavigationItems() {
		navigationItem.titleView = logoImageView
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

		var height: CGFloat = 40 + 8 + 8 // Username + UserProfileImageView
		height += view.frame.width
		height += 50
		height += 60

		return CGSize(width: view.frame.width, height: height)
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return posts.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
		cell.post = posts[indexPath.item]
		return cell
	}

}
