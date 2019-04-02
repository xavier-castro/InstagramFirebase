//
//  PhotoSelectorCell.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 4/1/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit

class PhotoSelectorCell: UICollectionViewCell {

	let photoImageView: UIImageView = {
		let iv = UIImageView()
		iv.backgroundColor = .lightGray
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		return iv
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)

		addSubview(photoImageView)
		photoImageView.fillSuperview()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
