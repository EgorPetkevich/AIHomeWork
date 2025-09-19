//
//  СameraCaptureView.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 5.09.24.
//

import UIKit
import SnapKit

final class СameraCaptureView: UIView {
    
    private enum Constants {
        //MARK: - Text
        static let subTitleText: String = "Capture a photo of the task\nwith your camera"
        
        //MARK: - Constrais
        static let captureButtonShapeHeight: CGFloat = 74.0
        static let captureButtonShapeRadius: CGFloat = captureButtonShapeHeight / 2
        static let captureButtonShapeLineWidth: CGFloat = 4
        static let capturePhotoButtonHeight: CGFloat = 64.0
        static let capturePhotoButtonRadius: CGFloat = capturePhotoButtonHeight / 2
        static let flashlightButtonHeight: CGFloat = 44
        static let flashlightButtonRadius: CGFloat = flashlightButtonHeight / 2
        static let photoFromGalleryHeight: CGFloat = 52
        static let photoFromGalleryRadius: CGFloat = 8
    }
    
    
    
    private let target: Any?
    private let capturePhotoAction: Selector
    private let lightAction: Selector
    private let openLibraryAction: Selector
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.subTitleText
        label.font = .regularFont(size: 12.0)
        label.textColor = .appLightGrey
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var capturePhotoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .appRed
        button.addAction(target, action: capturePhotoAction)
        return button
    }()
    
    private lazy var captureButtonShapeView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var flashlightButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .appBgGray
        button.setImage(.MainApp.Camera.splashOffImage, for: .normal)
        button.addAction(target, action: lightAction)
        return button
    }()
    
    private lazy var openLibraryButton: UIButton = {
        let button = UIButton()
        button.addAction(target, action: openLibraryAction)
        button.backgroundColor = .clear
        return button
    }()
    
    private lazy var photoFromGalleryImageView: UIImageView = {
        return UIImageView(image: .AppIcon.galleryNotFoundImage)
    }()
    
    init(target: Any?, 
         capturePhotoAction: Selector,
         splashAction: Selector,
         openLibraryAction: Selector
    ) {
        self.target = target
        self.capturePhotoAction = capturePhotoAction
        self.lightAction = splashAction
        self.openLibraryAction = openLibraryAction
        super.init(frame: .zero)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        createCaptureButtonShape()
    }
    
}

// MARK: - Properties
extension СameraCaptureView {
    
    var photoFromGallery: UIImage? {
        get { photoFromGalleryImageView.image }
        set { photoFromGalleryImageView.image = newValue }
    }
    
    var capturePhotoButtonIsEnabled: Bool {
        get { capturePhotoButton.isEnabled }
        set { capturePhotoButton.isEnabled = newValue }
    }
    
    func changeLightButtonState(flashMode: FlashlightMode) {
        DispatchQueue.main.async { [weak self] in
            if flashMode == .on {
                self?.flashlightButton.setImage(.MainApp.Camera.splashOnImage, 
                                                for: .normal)
            } else {
                self?.flashlightButton.setImage(.MainApp.Camera.splashOffImage, 
                                                for: .normal)
            }
        }
    }
    
}

// MARK: - UI Setup
extension СameraCaptureView {
    
    private func setupUI() {
        self.backgroundColor = .appBg
        self.addSubview(subTitleLabel)
        self.addSubview(captureButtonShapeView)
        self.addSubview(flashlightButton)
        self.addSubview(photoFromGalleryImageView)
        self.addSubview(openLibraryButton)
        openLibraryButton.layer.zPosition = .greatestFiniteMagnitude
        
        flashlightButton.cornerRadius = Constants.flashlightButtonRadius
        captureButtonShapeView.addSubview(capturePhotoButton)
        capturePhotoButton.cornerRadius = Constants.capturePhotoButtonRadius
        photoFromGalleryImageView.layer.masksToBounds = true
        photoFromGalleryImageView.cornerRadius = Constants.photoFromGalleryRadius
        
    }
}

// MARK: - Constraints Setup
extension СameraCaptureView {
    
    private func setupConstraints() {
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10.0)
            make.centerX.equalToSuperview()
        }
        
        captureButtonShapeView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).inset(-12.0)
            make.centerX.equalToSuperview()
            make.size.equalTo(Constants.captureButtonShapeHeight)
        }
        
        capturePhotoButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(Constants.capturePhotoButtonHeight)
        }
        
        flashlightButton.snp.makeConstraints { make in
            make.size.equalTo(Constants.flashlightButtonHeight)
            make.centerY.equalTo(captureButtonShapeView.snp.centerY)
            make.right.equalToSuperview().inset(16.0)
        }
        
        photoFromGalleryImageView.snp.makeConstraints { make in
            make.size.equalTo(Constants.photoFromGalleryHeight)
            make.centerY.equalTo(captureButtonShapeView.snp.centerY)
            make.left.equalToSuperview().inset(16.0)
        }
        
        openLibraryButton.snp.makeConstraints { make in
            make.size.equalTo(photoFromGalleryImageView.snp.size)
            make.center.equalTo(photoFromGalleryImageView.snp.center)
        }
        
    }
}

//MARK: - Helpers
extension СameraCaptureView {
    
    private func createCaptureButtonShape() {
        captureButtonShapeView.layoutIfNeeded()
        
        let backgroundLayer = CAShapeLayer()
        let radius: CGFloat = Constants.captureButtonShapeRadius
        let lineWidth: CGFloat = Constants.captureButtonShapeLineWidth
        let centerPoint = CGPoint(x: captureButtonShapeView.bounds.midX,
                                  y: captureButtonShapeView.bounds.midY)
        
        let backgroundPath = UIBezierPath(arcCenter: centerPoint,
                                          radius: radius,
                                          startAngle: 0,
                                          endAngle: 2 * CGFloat.pi,
                                          clockwise: true)
        backgroundLayer.path = backgroundPath.cgPath
        backgroundLayer.strokeColor = UIColor.appBgGray.cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineWidth = lineWidth
        captureButtonShapeView.layer.addSublayer(backgroundLayer)
    }

    
}
