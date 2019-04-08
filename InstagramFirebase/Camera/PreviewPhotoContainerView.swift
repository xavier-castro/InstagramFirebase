//
// Created by Xavier Castro on 2019-04-08.
// Copyright (c) 2019 Xavier Castro. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView: UIView {

    let previewImageView: UIImageView = {
        let iv = UIImageView()
		iv.contentMode = .scaleAspectFill
        return iv
    }()

    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()

    @objc func handleCancel() {
        self.removeFromSuperview()
    }

    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()

    @objc func handleSave() {
        print("Handling save...")
        guard let previewImage = previewImageView.image else {
            return
        }
        let library = PHPhotoLibrary.shared()

        library.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
        }, completionHandler: { success, error in
            if let error = error {
                print("Failed to save image to photo library:", error)
                return
            }
            print("Successfully saved image to library")

            DispatchQueue.main.async {
                let savedLabel = UILabel()
                savedLabel.text = "Saved Successfully"
                savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
                savedLabel.textColor = .white
                savedLabel.numberOfLines = 0
                savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                savedLabel.textAlignment = .center

                savedLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
                savedLabel.center = self.center

                self.addSubview(savedLabel)

                savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)

                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                }, completion: { completed in
                    print("Completed animation")

                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                        savedLabel.alpha = 0
                    }, completion: { _ in
                        savedLabel.removeFromSuperview()
                    })
                })
            }

        })
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow

        addSubview(previewImageView)
        previewImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)

        addSubview(cancelButton)
        cancelButton.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 12, bottom: 0, right: 0), size: .init(width: 50, height: 50))

        addSubview(saveButton)
        saveButton.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 24, bottom: 24, right: 0), size: .init(width: 50, height: 50))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
