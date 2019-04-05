//
//  HomePostCell.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 4/5/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit

class HomePostCell: UICollectionViewCell {

	var post: Post? {
		didSet {
			guard let postImageUrl = post?.imageUrl else { return }
			photoImageView.loadImage(urlString: postImageUrl)
		}
	}

	let userProfileImageView: CustomImageView = {
		let iv = CustomImageView()
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		iv.backgroundColor = .blue
		return iv
	}()

	let photoImageView: CustomImageView = {
		let iv = CustomImageView()
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		return iv
	}()

	let usernameLabel: UILabel = {
		let label = UILabel()
		label.text = "Username"
		label.font = UIFont.boldSystemFont(ofSize: 14)
		return label
	}()

	let optionsButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("•••", for: .normal)
		button.setTitleColor(.black, for: .normal)
		return button
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)

		addSubview(userProfileImageView)
		addSubview(photoImageView)
		addSubview(optionsButton)
		addSubview(usernameLabel)

		userProfileImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 0), size: .init(width: 40, height: 40))
		userProfileImageView.layer.cornerRadius = 40 / 2

		usernameLabel.anchor(top: topAnchor, leading: userProfileImageView.trailingAnchor, bottom: photoImageView.topAnchor, trailing: optionsButton.leadingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 0))

		optionsButton.anchor(top: topAnchor, leading: nil, bottom: photoImageView.topAnchor, trailing: trailingAnchor, size: .init(width: 44, height: 0))

		photoImageView.anchor(top: userProfileImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
		photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
