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

class UserProfileController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white

        fetchUser()
    }

    fileprivate func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let username = dictionary["username"] as? String
            self.navigationItem.title = username
        }) { (err) in
            print("Failed to fetch user:", err)
        }
    }
    
}
