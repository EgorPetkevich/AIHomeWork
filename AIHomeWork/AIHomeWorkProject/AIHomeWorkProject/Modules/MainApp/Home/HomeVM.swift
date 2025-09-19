//
//  HomeVM.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 30.08.24.
//

import UIKit

protocol HomeCoordinatorProtocol: AnyObject {
    func openTask(type: Subjects)
    func openSettings()
    func openChatsHistory()
    func showPaywallReview()
    func showPaywallProdTrial()
    func showPaywallProd()
}

protocol HomeAdapterProtocol {
    var onSubjectCellSelected: ((Subjects) -> Void)? { get set }
    
    func collectionViewReloadData()
    func makeCollectionView() -> UICollectionView
}

protocol HomeAdaptyServiceUseCaseProtocol {
    var isPremium: Bool { get }
    var remoteConfig: RemoteConfig? { get }
}

final class HomeVM {
    
    private weak var coordinator: HomeCoordinatorProtocol?
    
    private var adapter: HomeAdapterProtocol
    private let adaptyService: HomeAdaptyServiceUseCaseProtocol
    
    init(coordinator: HomeCoordinatorProtocol, 
         adapter: HomeAdapterProtocol,
         adaptyService: HomeAdaptyServiceUseCaseProtocol) {
        self.coordinator = coordinator
        self.adapter = adapter
        self.adaptyService = adaptyService
        bind()
    }
    
}

//MARK: - Home Adapter Bind
extension HomeVM {
    
    private func bind() {
        adapter.onSubjectCellSelected = { [weak coordinator] subject in
            coordinator?.openTask(type: subject)
        }
    }
    
}

extension HomeVM: HomeViewModelProtocol {
    
    //MARK: - View Controller Life Cycle
    func viewWillAppear() {
        adapter.collectionViewReloadData()
    }
    
    func askExpertButtonDidTap() {
        //FIXME: uncoment
        if !showPaywall() {
            coordinator?.openChatsHistory()
        }
//        coordinator?.openChatsHistory()
    }
    
    func settingButtonDidTap() {
        coordinator?.openSettings()
    }
    
    func makeCollectionView() -> UICollectionView {
        adapter.makeCollectionView()
    }
    
}

//MARK: - ShowPaywall
extension HomeVM {
    
    private func showPaywall() -> Bool {
        
        guard self.adaptyService.isPremium == false else { return false }
        
        guard
            let review = adaptyService.remoteConfig?.review,
            let supportTrial = adaptyService.remoteConfig?.supportTrial
        else {
            coordinator?.showPaywallReview()
            return true
        }
        
        if review {
            coordinator?.showPaywallReview()
        } else if review == false {
            if supportTrial {
                coordinator?.showPaywallProdTrial()
                return true
            } else {
                coordinator?.showPaywallProd()
                return true
            }
        }
        return true
    }
    
}
