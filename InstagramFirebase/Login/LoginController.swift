//
//  LoginController.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 3/17/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

	let instagramLogoImage: UIImageView = {
		let image = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
		image.contentMode = .scaleAspectFit
		return image
	}()

	let signUpButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Don't have an account?  Sign Up.", for: .normal)
		button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
		return button
	}()

	@objc func handleShowSignUp() {
		let signUpController = SignUpController()
		navigationController?.pushViewController(signUpController, animated: true)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.isNavigationBarHidden = true

		view.backgroundColor = .white

		view.addSubview(instagramLogoImage)
		instagramLogoImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, size: CGSize(width: 0, height: 50))

		view.addSubview(signUpButton)
		signUpButton.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, size: CGSize(width: 0, height: 200))
	}
}
