//
//  UserProfileHeader.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 3/14/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit
import FirebaseDatabase

class UserProfileHeader: UICollectionViewCell {

    let profileImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .blue

        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 12, bottom: 0, right: 0), size: .init(width: 80, height: 80))
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
    }

    var user: User? {
        didSet {
            setupProfileImage()
        }
    }

    fileprivate func setupProfileImage() {
        guard let profileImageUrl = user?.profileImageUrl else { return }
        guard let url = URL(string: profileImageUrl) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch profile image:", err)
            }

            guard let data = data else { return }
            let image = UIImage(data: data)

            DispatchQueue.main.async {
                self.profileImageView.image = image
            }
        }.resume()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
