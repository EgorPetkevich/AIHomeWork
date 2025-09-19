//
//  SettingsVM.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 2.09.24.
//

import UIKit
import StoreKit

protocol SettingsCoordinatorProtocol: AnyObject {
    func shareApp(url: URL)
    func finish()
}

protocol SettingsAdapterProtocol {
    var cellDidSelect: ((SettingsSection.Settings) -> Void)? { get set }
    func makeTableView() -> UITableView
}

protocol SettingsAdaptyServiceUseCaseProtocol {
    func restorePurchases(completion: @escaping (Bool) -> Void)
}

protocol SettingsAlertServiceUseCaseProtocol {
    func showAlert(title: String,
                   message: String,
                   cancelTitle: String,
                   okTitle: String,
                   okHandler: @escaping () -> Void)
    func showSuccessMessage(title: String, okTitle: String)
}

final class SettingsVM {
    
    weak var coordinator: SettingsCoordinatorProtocol?
    
    private var adapter: SettingsAdapterProtocol
    private let adaptyService: SettingsAdaptyServiceUseCaseProtocol
    private let alertService: SettingsAlertServiceUseCaseProtocol
    
    init(coordinator: SettingsCoordinatorProtocol? = nil, 
         adapter: SettingsAdapterProtocol,
         adaptyService: SettingsAdaptyServiceUseCaseProtocol,
         alertService: SettingsAlertServiceUseCaseProtocol) {
        self.coordinator = coordinator
        self.adapter = adapter
        self.adaptyService = adaptyService
        self.alertService = alertService
        bind()
    }
    
    private func bind() {
        adapter.cellDidSelect = { [weak self] cell in
            switch cell {
            case .privacy:
                self?.privacyDidSelect()
                return
            case .rate:
                self?.rateDidSelect()
                return
            case .restore:
                self?.restoreDidSelect()
                return
            case .share:
                self?.shareDidSelect()
                return
            case .terms:
                self?.termsDidSelect()
                return
            }
        }
    }
    
    
}

extension SettingsVM: SettingsViewModelProtocol {
    
    func makeTableView() -> UITableView {
        adapter.makeTableView()
    }
    
    func backButtonDidTap() {
        coordinator?.finish()
    }
    
}

//MARK: - AlertService Use Case
extension SettingsVM {
    
    private func showErrorMessage() {
        alertService.showAlert(title: "Oops...",
                               message: "Something went wrong. Please try again",
                               cancelTitle: "Cancel", okTitle: "Try again")
        { [weak self] in
            self?.restoreDidSelect()
        }
    }
    
    private func showSuccessMessage() {
        alertService.showSuccessMessage(title: "Success", okTitle: "Ok")
    }
    
}

//MARK: - Settings Useage
extension SettingsVM {
    
    private func privacyDidSelect() {
        if let url = URL(string: Constant.Settings.privacy) {
            UIApplication.shared.open(url)
        }
    }
    
    private func rateDidSelect() {
        SKStoreReviewController.requestReviewInCurrentScene()
    }
    
    private func restoreDidSelect() {
        adaptyService.restorePurchases { [weak self] completion in
            if completion {
                self?.showSuccessMessage()
            } else {
                self?.showErrorMessage()
            }
        }
    }
    
    private func shareDidSelect() {
        if let url = URL(string: Constant.Settings.share) {
            coordinator?.shareApp(url: url)
        }
    }
    
    private func termsDidSelect() {
        if let url = URL(string:  Constant.Settings.terms) {
            UIApplication.shared.open(url)
        }
    }
    
}


