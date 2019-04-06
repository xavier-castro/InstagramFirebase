//
//  UserProfileHeader.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 3/14/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {

	var user: User? {
		didSet {
			guard let profileImageUrl = user?.profileImageUrl else { return }
			profileImageView.loadImage(urlString: profileImageUrl)
			usernameLabel.text = user?.username
			setupEditFollowButton()
		}
	}

	fileprivate func setupEditFollowButton() {
		guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else {
			return
		}
		guard let userId = user?.uid else {
			return
		}

		if currentLoggedInUserId == userId {
			// Edit profile
		} else {
			// Check if following
			Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
				if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
					self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
				} else {
					self.setupFollowStyle()
				}
			}, withCancel: { (err) in
				print("Failed to check if following:", err)
			})
		}
	}

	@objc fileprivate func handleEditProfileOrFollow() {
		Database.database().reference().child("following")
		guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else {
			return
		}
		let ref = Database.database().reference().child("following").child(currentLoggedInUserId)
		guard let userId = user?.uid else {
			return
		}

		// Unfollow
		if editProfileFollowButton.titleLabel?.text == "Unfollow" {
			Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).removeValue(completionBlock: { (err, ref) in
				if let err = err {
					print("Failed to unfollow:", err)
					return
				}
				print("Successfully unfollowed user:", self.user?.username ?? "")
				self.setupFollowStyle()
			})
		} else {
			let values = [userId: 1]
			ref.updateChildValues(values) { (err, ref) in
				if let err = err {
					print("Failed to follow user:", err)
					return
				}
				print("Successfully followed user:", self.user?.username ?? "")
				self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
				self.editProfileFollowButton.backgroundColor = .white
				self.editProfileFollowButton.setTitleColor(.black, for: .normal)
			}
		}
	}

	fileprivate func setupFollowStyle() {
		self.editProfileFollowButton.setTitle("Follow", for: .normal)
		self.editProfileFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237, alpha: 1)
		self.editProfileFollowButton.setTitleColor(.white, for: .normal)
		self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
	}

	let profileImageView: CustomImageView = {
		let iv = CustomImageView()
		return iv
	}()

	let gridButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
		return button
	}()

	let listButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
		button.tintColor = UIColor(white: 0, alpha: 0.2)
		return button
	}()

	let bookmarkButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
		button.tintColor = UIColor(white: 0, alpha: 0.2)
		return button
	}()

	let usernameLabel: UILabel = {
		let label = UILabel()
		label.text = "username"
		label.font = UIFont.boldSystemFont(ofSize: 14)
		return label
	}()

	let postsLabel: UILabel = {
		let label = UILabel()

		let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])

		attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))

		label.attributedText = attributedText

		label.textAlignment = .center
		label.numberOfLines = 2
		return label
	}()

	let followersLabel: UILabel = {
		let label = UILabel()

		let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])

		attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))

		label.attributedText = attributedText

		label.textAlignment = .center
		label.numberOfLines = 2
		return label
	}()

	let followingLabel: UILabel = {
		let label = UILabel()

		let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])

		attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))

		label.attributedText = attributedText

		label.textAlignment = .center
		label.numberOfLines = 2
		return label
	}()

	lazy var editProfileFollowButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Edit Profile", for: .normal)
		button.tintColor = UIColor(white: 0, alpha: 1)
		button.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
		button.layer.borderWidth = 1
		button.layer.cornerRadius = 3
		button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
		return button
	}()


	override init(frame: CGRect) {
		super.init(frame: frame)

		addSubview(profileImageView)
		profileImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 12, bottom: 0, right: 0), size: .init(width: 80, height: 80))
		profileImageView.layer.cornerRadius = 80 / 2
		profileImageView.clipsToBounds = true

		setupBottomToolbar()

		addSubview(usernameLabel)
		usernameLabel.anchor(top: profileImageView.bottomAnchor, leading: leadingAnchor, bottom: gridButton.topAnchor, trailing: trailingAnchor, padding: .init(top: 4, left: 12, bottom: 0, right: 12), size: .init(width: 0, height: 0))

		setupUserStatsView()
	}

	fileprivate func setupUserStatsView() {
		let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
		stackView.distribution = .fillEqually
		addSubview(stackView)
		stackView.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12), size: CGSize(width: 0, height: 50))

		addSubview(editProfileFollowButton)
		editProfileFollowButton.anchor(top: stackView.bottomAnchor, leading: stackView.leadingAnchor, bottom: nil, trailing: stackView.trailingAnchor, padding: UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 35))
	}

	fileprivate func setupBottomToolbar() {

		let topDividerView = UIView()
		topDividerView.backgroundColor = .lightGray

		let bottomDividerView = UIView()
		bottomDividerView.backgroundColor = .lightGray

		let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
		stackView.distribution = .fillEqually

		addSubview(stackView)
		stackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, size: CGSize(width: 0, height: 50))

		addSubview(topDividerView)
		topDividerView.anchor(top: stackView.topAnchor, leading: stackView.leadingAnchor, bottom: nil, trailing: stackView.trailingAnchor, size: CGSize(width: 0, height: 0.5))

		addSubview(bottomDividerView)
		bottomDividerView.anchor(top: stackView.bottomAnchor, leading: stackView.leadingAnchor, bottom: nil, trailing: stackView.trailingAnchor, size: CGSize(width: 0, height: 0.5))

	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
