//
//  User.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 4/5/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import Foundation

struct User {
	let uid: String
	let username: String
	let profileImageUrl: String

	init(uid: String, dictionary: [String: Any]) {
		self.username = dictionary["username"] as? String ?? ""
		self.profileImageUrl = dictionary["profileImageUrl"]  as? String ?? ""
		self.uid = uid
	}
}
