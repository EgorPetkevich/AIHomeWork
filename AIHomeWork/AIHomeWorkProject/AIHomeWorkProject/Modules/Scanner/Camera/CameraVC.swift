//
//  CameraVC.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 5.09.24.
//

import UIKit
import AVFoundation
import SnapKit

protocol CameraViewModelProtocol {
    var toggleFlashlight: ((FlashlightMode) -> Void)? { get set }
    var lastImageFromGallery: ((UIImage?) -> Void)? { get set }
        
    func getCameraPreview() -> AVCaptureVideoPreviewLayer?
    
    // view controller life cycle
    func viewWillAppear()
    func viewDidDisappear()
    
    // buttons on action
    func backButtonDidTap()
    func captureButtonDidTap()
    func flashlightButtonDidTap()
    func openGalleryButtonDidTap()
}

final class CameraVC: UIViewController {
    
    private enum Constants {
        
        //MARK: - Text
        static let titleText: String = "Take a photo"
        
        //MARK: - Constrains
        static let backArrowButtonSize: CGSize = CGSize(width: 30.0,
                                                        height: 24.0)
        static let cameraCaptureViewHeight: CGFloat = 200.0
    }
    
    private var viewModel: CameraViewModelProtocol
    
    private var cameraPreview: AVCaptureVideoPreviewLayer?
    private lazy var cameraView: UIView = .contentView()
    
    private lazy var titleLabel: UILabel = .titleLabel(Constants.titleText,
                                                       size: 20.0)
    private lazy var cameraCaptureView: СameraCaptureView =
    СameraCaptureView(target: self,
                      capturePhotoAction: #selector(captureButtonDidTap),
                      splashAction: #selector(flashlightButtonDidTap),
                      openLibraryAction: #selector(openGalleryButtonDidTap))
    
    
    private lazy var backArrowButton: UIButton = .backArrowButton()
        .addAction(self, action: #selector(backButtonDidTap))
    
    init(viewModel: CameraViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - View Controller Life Cycle
extension CameraVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraPreview = viewModel.getCameraPreview()
        setupLayer()
        setupUI()
        setupConstrains()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraCaptureView.capturePhotoButtonIsEnabled = true
        viewModel.viewWillAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
    
}

//MARK: - UI Setup
extension CameraVC {
    
    private func setupUI() {
        view.backgroundColor = .appBg
        view.addSubview(titleLabel)
        view.addSubview(backArrowButton)
        view.addSubview(cameraView)
        view.addSubview(cameraCaptureView)
    }
    
}

//MARK: - Constrains Setup
extension CameraVC {
    
    private func setupConstrains() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(19.0)
        }
        
        backArrowButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(21.0)
            make.size.equalTo(Constants.backArrowButtonSize)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(19.0)
        }
        
        cameraView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(108)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(cameraCaptureView.snp.top)
        }
        
        cameraCaptureView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(Constants.cameraCaptureViewHeight)
        }
    }
    
}

//MARK: - Layer Setup
extension CameraVC {
    
    private func setupLayer() {
        cameraView.layer.masksToBounds = true
        cameraView.frame = view.frame
        cameraPreview?.frame = self.cameraView.layer.bounds
        cameraPreview?.videoGravity = .resizeAspectFill
        cameraView.layer.bounds = self.view.layer.bounds
        cameraView.layer.addSublayer(cameraPreview ?? AVCaptureVideoPreviewLayer())
    }
    
}

//MARK: - Bind View Model
extension CameraVC {
    
    private func bindViewModel() {
        viewModel.lastImageFromGallery = { [weak cameraCaptureView] image in
            cameraCaptureView?.photoFromGallery = image
        }
        
        viewModel.toggleFlashlight = { [weak cameraCaptureView] flashMode in
            cameraCaptureView?.changeLightButtonState(flashMode: flashMode)
        }
    }
    
    
}

//MARK: - Buttons Actions
extension CameraVC {
    
    @objc private func backButtonDidTap() {
        self.viewModel.backButtonDidTap()
    }
    
    @objc private func captureButtonDidTap() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        cameraCaptureView.capturePhotoButtonIsEnabled = false
        viewModel.captureButtonDidTap()
    }
    
    @objc private func flashlightButtonDidTap() {
        viewModel.flashlightButtonDidTap()
    }
    
    @objc private func openGalleryButtonDidTap() {
        viewModel.openGalleryButtonDidTap()
    }
    
}
