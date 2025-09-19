//
//  LoadingImageView.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 19.09.24.
//

import UIKit
import SnapKit

class LoadingImageView: UIView {
    
    private let target: Any?
    private let action: Selector
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    private lazy var loadingSpinner: CustomLoadingSpinnerView = 
    CustomLoadingSpinnerView()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelBackgoundButton: UIButton = {
        let button = UIButton()
        button.setImage(.appiconGrayXmark, for: .normal)
        button.backgroundColor = .lightGray.withAlphaComponent(0.7)
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }()
        
    init(target: Any?, action: Selector) {
        self.target = target
        self.action = action
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setupUI()
        setupConstraints()
    }
    
    func startActivityIndicator() {
        hideIndicator(false)
        loadingSpinner.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {  [weak self] in
            self?.loadingSpinner.progress = 0.75
        }
    }
    
    func finishActivityIndicator(completion: (() -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.loadingSpinner.progress = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.hideIndicator(true)
            completion?()
        }
       
    }
    
    private func hideIndicator(_ sender: Bool) {
        self.cancelBackgoundButton.isHidden = !sender
        self.loadingSpinner.isHidden = sender
        self.overlayView.isHidden = sender
        self.cancelButton.isHidden = sender
    }
}

// MARK: - Properties
extension LoadingImageView {
    
    var image: UIImage? {
        get { backgroundImageView.image }
        set {
            backgroundImageView.image = newValue
            startActivityIndicator()
        }
    }
    
}
    
//MARK: - UI Setup
extension LoadingImageView {
    
    private func setupUI() {
        self.backgroundColor = .clear
        self.layer.masksToBounds = true
        self.cornerRadius = 8.0
        self.addSubview(backgroundImageView)
        self.backgroundImageView.addSubview(overlayView)
        self.backgroundImageView.addSubview(cancelBackgoundButton)
        overlayView.addSubview(loadingSpinner)
        overlayView.addSubview(cancelButton)
        overlayView.isUserInteractionEnabled = true
        backgroundImageView.isUserInteractionEnabled = true
        cancelBackgoundButton.clipsToBounds = true
        cancelBackgoundButton.cornerRadius = 9.0
    }
    
}

//MARK: - Constrains Setup with SnapKit
extension LoadingImageView {
    
    private func setupConstraints() {
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loadingSpinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(38.0)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(45.0)
        }
        
        cancelBackgoundButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(6.0)
            make.size.equalTo(18.0)
        }
    }
    
}

//MARK: - On Actions
extension LoadingImageView {
    
    @objc func cancelLoading() {
        self.loadingSpinner.stopAnimating()
        self.removeFromSuperview()
    }
    
    func show(on view: UIView?, image: UIImage) {
        self.image = image
        view?.addSubview(self)
        self.snp.makeConstraints { make in
            make.size.equalTo(80.0)
            make.horizontalEdges.verticalEdges.equalToSuperview()
        }
    }

    func hide() {
        self.loadingSpinner.stopAnimating()
        self.removeFromSuperview()
    }
}
