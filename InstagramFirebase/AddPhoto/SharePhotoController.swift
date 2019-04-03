//
//  SharePhotoController.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 4/2/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit

class SharePhotoController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white

		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))

	}

	@objc private func handleShare() {
		print("Sharing photo")
	}

	override var prefersStatusBarHidden: Bool {
		return true
	}

}
