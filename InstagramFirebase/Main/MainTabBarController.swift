//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 3/14/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

		if Auth.auth().currentUser == nil {
			// Lets us wait until the mainTabBarController is inside of the UI and then we present it
			DispatchQueue.main.async {
				let loginController = LoginController()
				self.present(loginController, animated: true, completion: nil)
			}
			return
		}

        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)

        let navController = UINavigationController(rootViewController: userProfileController)

        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        tabBar.tintColor = .black

        viewControllers = [navController]

    }
}
