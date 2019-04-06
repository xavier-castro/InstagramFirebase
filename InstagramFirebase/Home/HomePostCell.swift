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
			usernameLabel.text = post?.user.username
			guard let profileImageUrl = post?.user.profileImageUrl else { return }
			userProfileImageView.loadImage(urlString: profileImageUrl)
			setupAttributedCaption()
		}
	}

	fileprivate func setupAttributedCaption() {
		guard let post = self.post else { return }

		let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])

		attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))

		attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))

		let timeAgoDisplay = post.creationDate.timeAgoDisplay()

		attributedText.append(NSAttributedString(string: timeAgoDisplay, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray]))

		captionLabel.attributedText = attributedText
	}

	let userProfileImageView: CustomImageView = {
		let iv = CustomImageView()
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
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

	let likeButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
		return button
	}()

	let commentButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
		return button
	}()

	let sendMessageButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
		return button
	}()

	let bookmarkButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
		return button
	}()

	let captionLabel: UILabel = {
		let label = UILabel()
		let attributedText = NSMutableAttributedString(string: "Username", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
		attributedText.append(NSAttributedString(string: " Some caption text that will perhaps wrap onto the next line.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))

		attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))

		attributedText.append(NSAttributedString(string: "1 week ago", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray]))
		label.attributedText = attributedText
		label.numberOfLines = 0
		return label
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

		setupActionButtons()

		addSubview(captionLabel)
		captionLabel.anchor(top: likeButton.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 8))
	}

	fileprivate func setupActionButtons() {
		let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sendMessageButton])
		stackView.distribution = .fillEqually
		addSubview(stackView)
		stackView.anchor(top: photoImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 4, bottom: 0, right: 0), size: .init(width: 120, height: 50))

		addSubview(bookmarkButton)
		bookmarkButton.anchor(top: photoImageView.bottomAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 4), size: .init(width: 40, height: 50))
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
