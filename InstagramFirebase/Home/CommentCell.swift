//
//  CommentCell.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 4/8/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {

	var comment: Comment? {
		didSet {
			textLabel.text = comment?.text
		}
	}

	let textLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14)
		label.numberOfLines = 0
		label.backgroundColor = .lightGray
		return label
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(textLabel)
		textLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 4, left: 4, bottom: 4, right: 4))
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
