//
//  SharePhotoController.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 4/2/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit
import Firebase

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
		guard let caption = textView.text, caption.count > 0 else { return }
		guard let image = selectedImage else { return }
		guard let uploadData = image.jpegData(compressionQuality: 0.5) else { return }
		navigationItem.rightBarButtonItem?.isEnabled = false
		let filename = NSUUID().uuidString
		let storageRef = Storage.storage().reference().child("posts").child(filename)
		storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
			if let err = err {
				self.navigationItem.rightBarButtonItem?.isEnabled = true
				print("Failed to upload post image:", err)
				return
			}

			storageRef.downloadURL(completion: { (downloadUrl, err) in
				if let err = err {
					print("Failed to fetch downloadUrl:", err)
					return
				}
				guard let imageUrl = downloadUrl?.absoluteString else { return }
				print("Successfully uploaded post image:", imageUrl)
				self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
			})
		}
	}

	fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
		guard let postImage = selectedImage else { return }
		guard let caption = textView.text else { return }
		guard let uid = Firebase.Auth.auth().currentUser?.uid else { return }
		let userPostRef = Firebase.Database.database().reference().child("posts").child(uid)
		let ref = userPostRef.childByAutoId()
		let values = ["imageUrl": imageUrl, "caption": caption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970] as [String: Any]
		ref.updateChildValues(values) { (err, ref) in
			if let err = err {
				self.navigationItem.rightBarButtonItem?.isEnabled = true
				print("Failed to save post to DB", err)
				return
			}
			print("Successfully saved post to DB")
			self.dismiss(animated: true, completion: nil)
		}
	}

	override var prefersStatusBarHidden: Bool {
		return true
	}

}
