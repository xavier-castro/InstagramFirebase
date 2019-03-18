//
//  LoginController.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 3/17/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

	let signUpButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Don't have an account?  Sign Up.", for: .normal)
		return button
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .white

		view.addSubview(signUpButton)
		signUpButton.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, size: CGSize(width: 0, height: 50))
	}
}
