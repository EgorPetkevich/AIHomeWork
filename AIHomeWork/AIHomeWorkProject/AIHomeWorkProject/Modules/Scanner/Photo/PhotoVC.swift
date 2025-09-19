//
//  PhotoVC.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 8.09.24.
//

import UIKit
import SnapKit
import Lottie

protocol PhotoViewModelProtocol {
    var delayAnimation: (() -> Void)? { get set }
    var setupOnScanning: (() -> Void)? { get set }
    var taskNotRecognizedDismiss: (() -> Void)? { get set }
    var taskNotRecognizedPresent: (() -> Void)? { get set }

    func viewDidDisappear()
    func backButtonDidTap()
    func solutionButtonDidTap(taskImage: UIImage?)
    func retakePhotoButtonDidTap()
}

final class PhotoVC: UIViewController {
    
    private enum Constants {
        //MARK: - Text
        static var titleText: String = "Photo"
        static var subTitleText: String = "Please crop your task"
        static var soluctionButtonText: String = "Get solution"
        static var retakePhotoButtonText: String = "Retake photo"
        static var titleOnScanningText: String = "Scanning"
        static var titleCropDidTapText: String = "Crop a task"
        
        //MARK: - Constains
        static var tableViewHeight: CGFloat = 360.0
        static var backArrowButtonSize: CGSize = CGSize(width: 30.0,
                                                        height: 24.0)
        static var retakePhotoButtonSize: CGSize = CGSize(width: 140.0,
                                                          height: 38.0)
        
    }
    
    private var viewModel: PhotoViewModelProtocol
    
    private var currentScanningFrame: CGRect?
    
    private var scanningAnimationView: LottieAnimationView = .scanningAnimation
    
    private lazy var titleLabel: UILabel = .titleLabel(Constants.titleText,
                                                       size: 20.0)
    private lazy var subTitleLabel: UILabel =
        .subTitleLabel(Constants.subTitleText,
                       size: 12.0,
                       textColor: .appLightGrey)
    
    private lazy var photoImageView = UIImageView()
    private let scanningFrameView = ScanningFrameView()
    private var overlayView = DynamicOverlayView()
    private lazy var actionView: UIView = .contentView()
    
    private lazy var cropButton: UIButton = 
        .cropButton()
        .addAction(self, action: #selector(cropButtonDidTap))
    
    private lazy var solutionButton: ActivityButton =
    ActivityButton(
        target: self,
        action: #selector(solutionButtonDidTap)
    ).setTitle(Constants.soluctionButtonText)
    
    private lazy var retakePhotoButton: UIButton =
        .clearButton(Constants.retakePhotoButtonText, tintColor: .appBlack)
        .addAction(self, action: #selector(retakePhotoButtonDidTap))
    
    private lazy var backArrowButton: UIButton = .backArrowButton()
        .addAction(self, action: #selector(backButtonDidTap))
    
    private lazy var shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .appShadow
        return view
    }()
    
    init(viewModel: PhotoViewModelProtocol,
         image: UIImage) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.photoImageView.image = image
        
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Bind View Model
extension PhotoVC {
    
    private func bindViewModel() {
        viewModel.delayAnimation = { [weak self] in
            self?.playScanningAnimation()
        }
        
        viewModel.setupOnScanning = { [weak self] in
            self?.configureScanningState()
        }
        
        viewModel.taskNotRecognizedDismiss = { [weak self] in
            self?.shadowView.isHidden = true
        }
        
        viewModel.taskNotRecognizedPresent = { [weak self] in
            self?.shadowView.isHidden = false
        }
    }
    
    private func playScanningAnimation() {
        scanningAnimationView.play()
    }
    
}

//MARK: - View Controller Life Cycle
extension PhotoVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanningFrameView.delegate = self
        setupUI()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureScanningFrame()
        overlayView.frame = photoImageView.bounds
        overlayView.transparentRect = scanningFrameView.frame
        bringScanningFrameToFront()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resetToInitialState()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
    
}


extension PhotoVC: ScanningFrameViewDelegate {
    
    func scanningFrameViewDidUpdate(_ scanningFrameView: ScanningFrameView) {
        overlayView.transparentRect = scanningFrameView.frame
    }
    
}

//MARK: - Configure State
extension PhotoVC {
    
    private func resetToInitialState() {
        scanningAnimationView.isHidden = true
        photoImageView.isUserInteractionEnabled = true
        cropButton.isHidden = false
        overlayView.isHidden = true
        scanningFrameView.isHidden = true
        solutionButton.isUserInteractionEnabled = true
        backArrowButton.setImage(.AppIcon.leftArrowImage, for: .normal)
        titleLabel.text = Constants.titleText
    }
    
    private func configureScanningState() {
        scanningAnimationView.isHidden = false
        photoImageView.isUserInteractionEnabled = false
        cropButton.isHidden = true
        backArrowButton.setImage(.AppIcon.xMarkImage, for: .normal)
        titleLabel.text = Constants.titleOnScanningText
    }
    
}

//MARK: - UI Setup
extension PhotoVC {
    
    private func setupUI() {
        view.backgroundColor = .appBg
        view.addSubview(titleLabel)
        view.addSubview(backArrowButton)
        view.addSubview(photoImageView)
        view.addSubview(actionView)
        view.addSubview(cropButton)
        view.addSubview(shadowView)
        
        shadowView.layer.zPosition = .greatestFiniteMagnitude
        shadowView.isHidden = true
        
        photoImageView.addSubview(scanningAnimationView)
        scanningAnimationView.contentMode = .scaleAspectFill
        
        photoImageView.addSubview(scanningFrameView)
        
        overlayView = DynamicOverlayView(frame: photoImageView.bounds)
        photoImageView.addSubview(overlayView)
        overlayView.transparentRect = scanningFrameView.frame
        
        actionView.addSubview(subTitleLabel)
        actionView.addSubview(solutionButton)
        actionView.addSubview(retakePhotoButton)
    }
    
    private func configureScanningFrame() {
        if let currentScanningFrame {
            scanningFrameView.frame = currentScanningFrame
        } else {
            scanningFrameView.center = photoImageView.center
            scanningFrameView.frame = 
            CGRect(x: scanningFrameView.frame.minX,
                   y:  scanningFrameView.frame.minY - 120,
                   width: photoImageView.frame.width - 70,
                   height: 120)
        }
    }
    
    private func bringScanningFrameToFront() {
        scanningFrameView.layer.zPosition = .greatestFiniteMagnitude
    }
    
}

//MARK: - Constrains Setup
extension PhotoVC {

    private func setupConstraints() {
        shadowView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(50)
            make.height.equalTo(57.0)
        }
        
        backArrowButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(21.0)
            make.size.equalTo(Constants.backArrowButtonSize)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        cropButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16.0)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(108.0)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(actionView.snp.top)
        }
        
        actionView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(17.0)
            make.centerX.equalToSuperview()
            make.height.equalTo(14.0)
        }
        
        solutionButton.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).inset(-17.0)
            make.bottom.equalToSuperview().inset(88.0)
            make.horizontalEdges.equalToSuperview().inset(16.0)
        }
        
        retakePhotoButton.snp.makeConstraints { make in
            make.size.equalTo(Constants.retakePhotoButtonSize)
            make.top.equalTo(solutionButton.snp.bottom).inset(-16.0)
            make.centerX.equalToSuperview()
        }
        
        scanningAnimationView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview()
        }
        
    }
    
}

//MARK: - Buttons Actions
extension PhotoVC {
    
    @objc private func backButtonDidTap() {
        self.viewModel.backButtonDidTap()
    }
    
    @objc private func solutionButtonDidTap() {
        solutionButton.isUserInteractionEnabled = false
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        currentScanningFrame = scanningFrameView.frame
        solutionButton.strartActivityAnimation()
        
        DispatchQueue.main.async { [weak solutionButton] in
            solutionButton?.stopActivityAnimation()
        }
        
        self.viewModel.solutionButtonDidTap(taskImage: getTaskImage())
    }
    
    @objc private func cropButtonDidTap() {
        titleLabel.text = Constants.titleCropDidTapText
        cropButton.isHidden = true
        overlayView.isHidden = false
        scanningFrameView.isHidden = false
    }
    
    @objc private func retakePhotoButtonDidTap() {
        viewModel.retakePhotoButtonDidTap()
    }
    
}

//MARK: - Get Image from PhotoImageView
extension PhotoVC {
    
    private func getTaskImage() ->  UIImage? {
        if cropButton.isHidden {
            return .cropImageUnderFrame(
                photoImageView: photoImageView,
                transparentRect: scanningFrameView.frame)
        } else {
            return photoImageView.image?.fixedOrientation()
        }
    }
    
}
