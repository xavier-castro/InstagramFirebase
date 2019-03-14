//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 3/8/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: BUTTONS AND LABELS

    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
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

    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = false
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244, alpha: 1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()

    // MARK: OBJC FUNCTIONS

    @objc func handleSignUp() {
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let username = usernameTextField.text, username.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let err = error {
                print("Failed to create user:", err)
                return
            }
            print("Successfully created user:", user?.user.uid ?? "")
            guard let image = self.plusPhotoButton.imageView?.image else { return }
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
            let filename = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child(filename)
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                if let err = err {
                    print("Failed to upload profile image:", err)
                    return
                }
                storageRef.downloadURL(completion: { (downloadURL, err) in
                    if let err = err {
                        print("Failed to fetch downloadURL:", err)
                        return
                    }
                    guard let profileImageUrl = downloadURL?.absoluteString else { return }
                    print("Successfully uploaded profile image:", profileImageUrl)
                    guard let uid = user?.user.uid else { return }
                    let dictionaryValues = ["username": username, "profileImageUrl": profileImageUrl]
                    let values = [uid: dictionaryValues]
                    Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                        if let err = err {
                            print("Failed to save user info into database:", err)
                            return
                        }
                        print("Successfully saved user info to database")
                    })
                })
            })
        }
    }

    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        if isFormValid {
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237, alpha: 1)
            signUpButton.isEnabled = true
        } else {
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244, alpha: 1)
            signUpButton.isEnabled = false
        }

    }

    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(plusPhotoButton)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: CGSize(width: 140, height: 140))
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        setupInputFields()

    }

    fileprivate func setupInputFields() {

        let stackView = UIStackView(arrangedSubviews: [
            emailTextField,
            usernameTextField,
            passwordTextField,
            signUpButton
            ])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 15

        view.addSubview(stackView)
        stackView.anchor(top: plusPhotoButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 40, bottom: 0, right: 40), size: CGSize(width: 0, height: 220))
    }
}

