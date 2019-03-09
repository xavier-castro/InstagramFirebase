//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 3/8/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(plusPhotoButton)
        plusPhotoButton.frame = .init(x: 0, y: 0, width: 250, height: 250)
    }


}

