//
//  Post.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 4/3/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import Foundation

struct Post {
	let imageUrl: String

	init(dictionary: [String: Any]) {
		self.imageUrl = dictionary["imageUrl"] as? String ?? ""
	}
}
