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
			print(post?.imageUrl ?? "")
			guard let imageUrl = post?.imageUrl else { return }
			guard let url = URL(string: imageUrl) else { return }
			URLSession.shared.dataTask(with: url) { (data, response, err) in
				if let err = err {
					print("Failed to fetch post image:", err)
					return
				}
				guard let imageData = data else { return }
				let photoImage = UIImage(data: imageData)
				DispatchQueue.main.async {
					self.photoImageView.image = photoImage
				}
			}.resume()
		}
	}

	let photoImageView: UIImageView = {
		let iv = UIImageView()
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
