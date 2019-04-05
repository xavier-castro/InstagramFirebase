//
// Created by Xavier Castro on 2019-04-05.
// Copyright (c) 2019 Xavier Castro. All rights reserved.
//

import Foundation
import Firebase

extension Database {
    static func fetchUserWithUid(uid: String, completion: @escaping () -> ()) {
        print("Fetching user with uid:", uid)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            print(user.username)
            completion()
        }) { (err) in
            print("Failed to fetch user:", err)
        }
    }
}
