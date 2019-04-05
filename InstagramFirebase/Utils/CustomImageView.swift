//
//  CustomImageView.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 4/5/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {

	var lastUrlUsedToLoadImage: String?

	func loadImage(urlString: String) {
		print("Loading image...")

		lastUrlUsedToLoadImage = urlString

		guard let url = URL(string: urlString) else { return }
		URLSession.shared.dataTask(with: url) { (data, response, err) in
			if let err = err {
				print("Failed to fetch post image:", err)
				return
			}

			if url.absoluteString != self.lastUrlUsedToLoadImage {
				return
			}

			guard let imageData = data else { return }
			let photoImage = UIImage(data: imageData)
			DispatchQueue.main.async {
				self.image = photoImage
			}
			}.resume()
	}
}