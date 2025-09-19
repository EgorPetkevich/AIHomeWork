//
//  ImageCell.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 19.09.24.
//

import UIKit
import SnapKit

final class ImageCell: UITableViewCell {
    
    private lazy var taskImageView: UIImageView =  {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var fileManager = FileManagerService.instansce
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setup(imagePath: String) {
        let image = fileManager.read(directory: .TaskImages, with: imagePath)
        taskImageView.image = image
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        addSubview(taskImageView)
        taskImageView.layer.masksToBounds = true
        taskImageView.cornerRadius = 16.0
    }
    
    private func setupConstraints() {
        taskImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(8.0)
            make.width.lessThanOrEqualTo(300.0)
            make.height.lessThanOrEqualTo(400.0)
        }
    }
    
}

