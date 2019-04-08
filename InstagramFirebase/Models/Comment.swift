//
//  Comment.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 4/8/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import Foundation

struct Comment {
	let text: String
	let uid: String

	init(dictionary: [String: Any]) {
		self.text = dictionary["text"] as? String ?? ""
		self.uid = dictionary["uid"] as? String ?? ""
	}
}
