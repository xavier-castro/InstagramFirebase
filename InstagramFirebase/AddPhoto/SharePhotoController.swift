//
//  SharePhotoController.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 4/2/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit

class SharePhotoController: UIViewController {

	var selectedImage: UIImage? {
		didSet {
			self.imageView.image = selectedImage
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240, alpha: 1)

		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))

		setupImageAndTextViews()

	}

	let imageView: UIImageView = {
		let iv = UIImageView()
		iv.backgroundColor = .red
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		return iv
	}()

	let textView: UITextView = {
		let tv = UITextView()
		tv.font = UIFont.systemFont(ofSize: 14)
		return tv
	}()

	fileprivate func setupImageAndTextViews() {
		let containerView = UIView()
		containerView.backgroundColor = .white

		view.addSubview(containerView)
		containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 100))

		containerView.addSubview(imageView)
		imageView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: nil, padding: .init(top: 8, left: 8, bottom: 8, right: 0), size: .init(width: 84, height: 84))

		containerView.addSubview(textView)
		textView.anchor(top: containerView.topAnchor, leading: imageView.trailingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 0, left: 4, bottom: 0, right: 0))
	}

	@objc private func handleShare() {
		print("Sharing photo")
	}

	override var prefersStatusBarHidden: Bool {
		return true
	}

}
