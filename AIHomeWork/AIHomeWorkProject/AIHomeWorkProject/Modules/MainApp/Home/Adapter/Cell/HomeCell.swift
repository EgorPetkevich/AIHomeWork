//
//  HomeCell.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 1.09.24.
//

import UIKit
import SnapKit

protocol HomeCellSetupProtocol {
    var title: String { get }
    var image: UIImage { get }
}

final class HomeCell: UICollectionViewCell {
    
    private enum Constants {
        static var cellCornerRadius: CGFloat = 24.0
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldFont(size: 20.0)
        label.textColor = .appBlack
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
        setupSelectedBackgroundView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectedBackgroundView?.frame = contentView.frame
    }
    
    
    func setup(_ type: HomeCellSetupProtocol) {
        titleLabel.text = type.title
        iconImageView.image = type.image
    }
    
}

//MARK: - UI Setup
extension HomeCell {
    
    private func setupUI() {
        self.backgroundColor = .appDarkGray
        self.cornerRadius = Constants.cellCornerRadius
        addSubview(titleLabel)
        addSubview(iconImageView)
    }
    
}

//MARK: - Constrains Setup
extension HomeCell {
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15.0)
            make.left.equalToSuperview().inset(13.0)
        }
             
        iconImageView.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
        }
    }
    
}

//MARK: - Selected Background View Setup
extension HomeCell {
    
    private func setupSelectedBackgroundView() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = .appActiveSelect
        selectedBackgroundView = bgColorView
        
        selectedBackgroundView?.layer.cornerRadius = Constants.cellCornerRadius
        selectedBackgroundView?.layer.masksToBounds = true
        selectedBackgroundView?.layer.zPosition =
        CGFloat(Float.greatestFiniteMagnitude)
    }
    
}
