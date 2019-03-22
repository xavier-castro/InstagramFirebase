//
//  LoginController.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 3/17/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController {

	let logoContainerView: UIView = {
		let view = UIView()
		let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white").withRenderingMode(.alwaysTemplate))
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

		let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])

		attributedTitle.append(NSAttributedString(string: "Sign Up.", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237, alpha: 1)]))

		button.setAttributedTitle(attributedTitle, for: .normal)

		button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
		return button
	}()

	let emailTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Email"
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
		textField.borderStyle = .roundedRect
		textField.font = UIFont.systemFont(ofSize: 14)
		textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
		return textField
	}()

	let usernameTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Username"
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
		textField.borderStyle = .roundedRect
		textField.font = UIFont.systemFont(ofSize: 14)
		textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
		return textField
	}()

	let passwordTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Password"
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
		textField.borderStyle = .roundedRect
		textField.font = UIFont.systemFont(ofSize: 14)
		textField.isSecureTextEntry = true
		textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
		return textField
	}()

	let loginButton: UIButton = {
		let button = UIButton(type: .system)
		button.isEnabled = false
		button.setTitle("Login", for: .normal)
		button.layer.cornerRadius = 5
		button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244, alpha: 1)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
		button.setTitleColor(.white, for: .normal)
		button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
		return button
	}()

	@objc func handleLogin() {
		guard let email = emailTextField.text else { return }
		guard let password = passwordTextField.text else { return }

		Auth.auth().signIn(withEmail: email, password: password) { (user, err) in

			if let err = err {
				print("Failed to sign in with email:", err)
				return
			}

			print("Succesafully logged back in with user:", user?.user.uid ?? "")
			guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
			mainTabBarController.setupViewControllers()
			self.dismiss(animated: true, completion: nil)
			
		}
	}

	@objc func handleShowSignUp() {
		let signUpController = SignUpController()
		navigationController?.pushViewController(signUpController, animated: true)
	}

	@objc func handleTextInputChange() {
		let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
		if isFormValid {
			loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237, alpha: 1)
			loginButton.isEnabled = true
		} else {
			loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244, alpha: 1)
			loginButton.isEnabled = false
		}

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

		setupInputFields()
	}

	fileprivate func setupInputFields() {
		let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])

		stackView.axis = .vertical
		stackView.spacing = 10
		stackView.distribution = .fillEqually

		view.addSubview(stackView)
		stackView.anchor(top: logoContainerView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 40, left: 40, bottom: 0, right: 40), size: .init(width: 0, height: 140))
	}
}
