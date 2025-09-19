//
//  LoadingCell.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 18.09.24.
//

import UIKit
import SnapKit
import Lottie

final class LoadingCell: UITableViewCell {
    
    private var timer: Timer?
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .AIExpertChat.girlImage
        return imageView
    }()
    
    private lazy var animationView: LottieAnimationView = .loadingCellAnimation
    private lazy var contenView: UIView = {
        let view = UIView()
        view.backgroundColor = .appDarkGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setup() {
        animationView.play()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5,
                                     repeats: true,
                                     block: { [weak self] timer in
            self?.animationView.play()
        })
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        addSubview(iconImageView)
        addSubview(contenView)
        contenView.addSubview(animationView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contenView.roundCornersExeptBottomLeft(cornerRadius: 16.0)
    }
    
    private func setupConstraints() {
        contenView.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(8.0)
            make.verticalEdges.equalToSuperview().inset(8)
            make.height.equalTo(43.0)
            make.width.equalTo(65.0)
        }
        
        animationView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(8.0)
            make.size.equalTo(32.0)
        }
    }
    
}

