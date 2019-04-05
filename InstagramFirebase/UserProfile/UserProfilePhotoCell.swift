//
//  UserProfilePhotoCell.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 4/3/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: UICollectionViewCell {

	var post: Post? {
		didSet {
			guard let imageUrl = post?.imageUrl else { return }
			photoImageView.loadImage(urlString: imageUrl)
		}
	}

	let photoImageView: CustomImageView = {
		let iv = CustomImageView()
		iv.backgroundColor = .red
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		return iv
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)

		addSubview(photoImageView)
		photoImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
