//
//  Post.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 4/3/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import Foundation

struct Post {

	let user: User
	let imageUrl: String
	let caption: String

	init(user: User, dictionary: [String: Any]) {
		self.user = user
		self.imageUrl = dictionary["imageUrl"] as? String ?? ""
		self.caption = dictionary["caption"] as? String ?? ""
	}
}
