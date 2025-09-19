//
//  HomeAdapter.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 1.09.24.
//

import UIKit
import SnapKit

final class HomeAdapter: NSObject {
    
    var onSubjectCellSelected: ((Subjects) -> Void)?
    
    private let sections: [HomeSections] = [.first(FirstSectionRows.allCases),
                                            .second(SecondSectionRows.allCases)]
    
    private(set) var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
    
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    override init() {
        super.init()
        setupCollectionView()
    }
}

//MARK: - Collection View Setup
extension HomeAdapter {
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HorizontalCollectionCell.self)
    }
    
}

extension HomeAdapter: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell: HorizontalCollectionCell = collectionView.dequeue(at: indexPath)
        
        cell.onSubjectCellSelected = self.onSubjectCellSelected
        
        cell.setup(row: indexPath.row)
        return cell
    }
}

extension HomeAdapter: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, 
                      height: collectionView.bounds.height / 2)
    }
    
}

extension HomeAdapter: HomeAdapterProtocol {
    
    func collectionViewReloadData() {
        collectionView.reloadData()
    }
    
    func makeCollectionView() -> UICollectionView {
        return collectionView
    }
    
}
