//
//  UserProfileController.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 3/14/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let headerId = "headerId"
	let cellId = "cellId"
	var posts = [Post]()
	var userId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
		collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
		fetchUser()
		setupLogoutButton()
//		fetchOrderedPosts()
    }

	fileprivate func fetchOrderedPosts() {
		guard let uid = self.user?.uid else {
			return
		}
		let ref = Firebase.Database.database().reference().child("posts").child(uid)

		ref.queryOrdered(byChild: "creationDate").observe(.childAdded) { (snapshot) in
			guard let dictionary = snapshot.value as? [String: Any] else { return }
			guard let user = self.user else { return }
			let post = Post(user: user, dictionary: dictionary)
			self.posts.append(post)
			self.collectionView.reloadData()
		}
	}

	fileprivate func setupLogoutButton() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
	}

	@objc func handleLogout() {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
			do {
				try Auth.auth().signOut()
				let loginController = LoginController()
				let navController = UINavigationController(rootViewController: loginController)
				self.present(navController, animated: true, completion: nil)

			} catch let signOutError {
				print("Failed to sign out:", signOutError)
			}
		}))
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		present(alertController, animated: true, completion: nil)
	}

    var user: User?
    fileprivate func fetchUser() {
		let uid = userId ?? Auth.auth().currentUser?.uid ?? ""
		Database.fetchUserWithUid(uid: uid) { (user) in
			self.user = user
			self.navigationItem.title = self.user?.username
			self.collectionView.reloadData()
			self.fetchOrderedPosts()
		}
    }

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return posts.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
		cell.post = posts[indexPath.item]
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (view.frame.width - 2) / 3
		return CGSize(width: width, height: width)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserProfileHeader
        header.user = self.user
        return header
    }
    
}
