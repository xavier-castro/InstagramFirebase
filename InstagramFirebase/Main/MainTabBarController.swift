//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 3/14/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

	func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
		let index = viewControllers?.firstIndex(of: viewController)
		if index == 2 {
			let layout = UICollectionViewFlowLayout()
			let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
			let navController = UINavigationController(rootViewController: photoSelectorController)
			present(navController, animated: true, completion: nil)
			return false
		}
		return true
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.delegate = self

		if Auth.auth().currentUser == nil {
			// Lets us wait until the mainTabBarController is inside of the UI and then we present it
			DispatchQueue.main.async {
				let loginController = LoginController()
				let navController = UINavigationController(rootViewController: loginController)
				self.present(navController, animated: true, completion: nil)
			}
			return
		}

		setupViewControllers()

	}

	func setupViewControllers() {
		let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"))
		let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"))
		let plusNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
		let likeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"))

		let layout = UICollectionViewFlowLayout()
		let userProfileController = UserProfileController(collectionViewLayout: layout)
		let userProfileNavController = UINavigationController(rootViewController: userProfileController)
		userProfileController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
		userProfileController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")

		view.backgroundColor = .white
		tabBar.tintColor = .black

		viewControllers = [
			homeNavController,
			searchNavController,
			plusNavController,
			likeNavController,
			userProfileNavController
		]

		// Modify tab bar item insets
		guard let items = tabBar.items else { return }
		for item in items {
			item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
		}

	}

	fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
		let viewController = rootViewController
		let navController = UINavigationController(rootViewController: viewController)
		navController.tabBarItem.image = unselectedImage
		navController.tabBarItem.selectedImage = selectedImage
		return navController
	}

}
