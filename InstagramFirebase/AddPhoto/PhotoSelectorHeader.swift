//
//  PhotoSelectorHeader.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 4/2/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit

class PhotoSelectorHeader: UICollectionViewCell {
	let photoImageView: UIImageView = {
		let iv = UIImageView()
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
