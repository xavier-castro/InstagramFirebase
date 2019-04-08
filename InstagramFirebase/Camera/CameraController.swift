//
//  CameraController.swift
//  InstagramFirebase
//
//  Created by Xavier Castro on 4/8/19.
//  Copyright © 2019 Xavier Castro. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate, UIViewControllerTransitioningDelegate {

	let dismissButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
		button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
		return button
	}()

	@objc func handleDismiss() {
		dismiss(animated: true, completion: nil)
	}

	let capturePhotoButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
		button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
		return button
	}()

	@objc func handleCapturePhoto() {
		print("Capturing photo")
		let settings = AVCapturePhotoSettings()
		guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else {
			return
		}
		settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
		output.capturePhoto(with: settings, delegate: self)
	}

	func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {

		let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer!)

		let previewImage = UIImage(data: imageData!)

		let containerView = PreviewPhotoContainerView()
		containerView.previewImageView.image = previewImage
		view.addSubview(containerView)
		containerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)

		print("Finish processing photo sample buffer...")

	}

	override func viewDidLoad() {
		super.viewDidLoad()
		transitioningDelegate = self
		setupCaptureSession()
		setupHUD()
	}

	let customAnimationPresentor = CustomAnimationPresentor()
	let customAnimationDismisser = CustomAnimationDismisser()
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return customAnimationPresentor
	}

	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return customAnimationDismisser
	}

	override var prefersStatusBarHidden: Bool {
		return true
	}

	private func setupHUD() {
		view.addSubview(capturePhotoButton)
		capturePhotoButton.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 24, right: 0), size: .init(width: 80, height: 80))
		capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

		view.addSubview(dismissButton)
		dismissButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 24, left: 0, bottom: 0, right: 12), size: .init(width: 50, height: 50))
	}

	let output = AVCapturePhotoOutput()
	fileprivate func setupCaptureSession() {
		let captureSession = AVCaptureSession()

		// 1. Setup inputs
		guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
			return
		}

		do {
			let input = try AVCaptureDeviceInput(device: captureDevice)
			if captureSession.canAddInput(input) {
				captureSession.addInput(input)
			}
		} catch let err {
			print("Could not setup camera input:", err)
		}

		// 2. Setup outputs
		if captureSession.canAddOutput(output) {
			captureSession.addOutput(output)
		}

		// 3. Setup output preview
		let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
		previewLayer.frame = view.bounds
		previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
		view.layer.addSublayer(previewLayer)
		captureSession.startRunning()
	}
}
