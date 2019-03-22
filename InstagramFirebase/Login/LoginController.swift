//
//  LoginController.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 3/17/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

	let logoContainerView: UIView = {
		let view = UIView()
		let logoImageView = UIImageView(image: #imageLiteral(resourceName: "logo2").withRenderingMode(.alwaysTemplate))
		logoImageView.tintColor = .white
		logoImageView.contentMode = .scaleAspectFill
		view.addSubview(logoImageView)
		logoImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: CGSize(width: 200, height: 50))
		logoImageView.centerInSuperview()
		view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175, alpha: 1)
		return view
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

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.isNavigationBarHidden = true

		view.backgroundColor = .white

		view.addSubview(logoContainerView)
		logoContainerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: CGSize(width: 0, height: 150))

		view.addSubview(signUpButton)
		signUpButton.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, size: CGSize(width: 0, height: 200))
	}
}
