//
//  HorizontalCollectionCell.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 2.09.24.
//

import UIKit
import SnapKit

final class HorizontalCollectionCell: UICollectionViewCell {
    
    var verticalRow: Int = 0
    
    var onSubjectCellSelected: ((Subjects) -> Void)?
    
    private let sections: [HomeSections] = [.first(FirstSectionRows.allCases),
                                            .second(SecondSectionRows.allCases)]
    
    private(set) var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        setupConstrains()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
    }
    
    func setup(row: Int) {
        verticalRow = row
        collectionView.reloadData()
    }
    
}

//MARK: - Collection View Setup
extension HorizontalCollectionCell {
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeCell.self)
        self.contentView.addSubview(collectionView)
    }
    
}

//MARK: - Constrains Setup
extension HorizontalCollectionCell {
    
    private func setupConstrains() {
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview()
        }
    }
    
}

extension HorizontalCollectionCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return sections[verticalRow].numberOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let section = sections[verticalRow]
        
        switch section {
        case .first(let row):
            let cell: HomeCell = collectionView.dequeue(at: indexPath)
            cell.setup(row[indexPath.row])
            return cell
        case .second(let row):
            let cell: HomeCell = collectionView.dequeue(at: indexPath)
            cell.setup(row[indexPath.row])
            return cell
        }
    }
}

extension HorizontalCollectionCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        let section = sections[verticalRow]
        switch section {
        case .first(let row):
            switch row[indexPath.row] {
            case .chemistry:
                onSubjectCellSelected?(Subjects.chemistry)
            case .grammar:
                onSubjectCellSelected?(Subjects.grammar)
            case .math:
                onSubjectCellSelected?(Subjects.math)
            }
        case .second(let row):
            switch row[indexPath.row] {
            case .biology:
                onSubjectCellSelected?(Subjects.biology)
            case .litSummary:
                onSubjectCellSelected?(Subjects.litSummary)
            case .physics:
                onSubjectCellSelected?(Subjects.physics)
            }
        }
    }
    
}

extension HorizontalCollectionCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 164, height: collectionView.bounds.height - 10)
    }
}
