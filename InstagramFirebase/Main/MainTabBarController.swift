//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 3/14/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)

        let navController = UINavigationController(rootViewController: userProfileController)

        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        tabBar.tintColor = .black

        viewControllers = [navController]

    }
}
