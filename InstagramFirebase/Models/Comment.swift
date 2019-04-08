//
//  Comment.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 4/8/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import Foundation

struct Comment {

	let user: User
	let text: String
	let uid: String

	init(user: User, dictionary: [String: Any]) {
		self.user = user
		self.text = dictionary["text"] as? String ?? ""
		self.uid = dictionary["uid"] as? String ?? ""
	}
}
