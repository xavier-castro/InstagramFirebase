//
//  CommentsController.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 4/8/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

	let cellId = "cellId"
	var post: Post?

	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView.backgroundColor = .red
		navigationItem.title = "Comments"

		collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
		collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)

		collectionView.register(CommentCell.self, forCellWithReuseIdentifier: cellId)

		fetchComments()
	}

	var comments = [Comment]()
	fileprivate func fetchComments() {
		guard let postId = post?.id else { return }
		let ref = Database.database().reference().child("comments").child(postId)
		ref.observe(.childAdded, with: { (snapshot) in
			guard let dictionary = snapshot.value as? [String: Any] else { return }
			let comment = Comment(dictionary: dictionary)
			self.comments.append(comment)
			self.collectionView.reloadData()
		}) { (error) in
			print("Failed to observe comments")
		}
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return comments.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell
		cell.comment = comments[indexPath.item]
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: view.frame.width, height: 50)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tabBarController?.tabBar.isHidden = true
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		tabBarController?.tabBar.isHidden = false
	}

	lazy var containerView: UIView = {
		let containerView = UIView()
		containerView.backgroundColor = .white
		containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)

		let submitButton = UIButton(type: .system)
		submitButton.setTitle("Submit", for: .normal)
		submitButton.setTitleColor(.black, for: .normal)
		submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
		containerView.addSubview(submitButton)
		submitButton.anchor(top: containerView.topAnchor, leading: nil, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 12), size: .init(width: 50, height: 0))

		containerView.addSubview(self.commentTextField)
		self.commentTextField.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: submitButton.leadingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 0))

		return containerView
	}()

	let commentTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Enter Comment"
		return textField
	}()

	@objc func handleSubmit() {
		print("post id:", post?.id ?? "")
		print("Inserting comment:", commentTextField.text ?? "")

		guard let uid = Auth.auth().currentUser?.uid else { return }
		let postId = post?.id ?? ""
		let values = ["text": commentTextField.text ?? "", "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String: Any]

		Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (error, reference) in
			if let error = error {
				print("Failed to insert comments:", error)
				return
			}
			print("Successfully inserted comment")
			
		}
	}

	override var inputAccessoryView: UIView? {
		get {
			return containerView
		}
	}

	override var canBecomeFirstResponder: Bool {
		return true
	}
	
}
