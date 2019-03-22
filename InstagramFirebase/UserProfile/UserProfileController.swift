//
//  UserProfileController.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 3/14/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let headerId = "headerId"
	let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white

        fetchUser()

        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)

		collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)

		setupLogoutButton()

    }

	fileprivate func setupLogoutButton() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
	}

	@objc func handleLogout() {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
			do {
				try Auth.auth().signOut()

				// We need to present some kind of loginController
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
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }

            self.user = User(dictionary: dictionary)

            self.navigationItem.title = self.user?.username
            self.collectionView?.reloadData()

        }) { (err) in
            print("Failed to fetch user:", err)
        }
    }

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 7
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
		cell.backgroundColor = .purple
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

struct User {
    let username: String
    let profileImageUrl: String

    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
