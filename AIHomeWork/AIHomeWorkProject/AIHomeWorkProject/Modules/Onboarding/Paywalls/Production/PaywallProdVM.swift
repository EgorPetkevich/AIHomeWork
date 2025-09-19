//
//  PaywallProdVM.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 28.08.24.
//

import UIKit

protocol PaywallProdCoordinatorProtocol: AnyObject {
    func finish()
}

protocol PaywallProdAdaptyServiceUseCaseProtocol {
    var productWeaklyPrice: String? { get }
    
    func makePurchase(type: AdaptyService.PurchaseType,
                      completion: @escaping (Bool) -> Void)
    
    func getProductPrice(type: AdaptyService.PurchaseType,
                         completion: @escaping (String?) -> Void)
    func restorePurchases(completion: @escaping (Bool) -> Void)
}

protocol PaywallProdAlertServiceUseCaseProtocol {
    func showAlert(title: String,
                   message: String,
                   cancelTitle: String,
                   okTitle: String,
                   okHandler: @escaping () -> Void)
}

final class PaywallProdVM {
    
    private enum PaywallActions {
        case continueDidTap
        case restoreDidTap
    }
    
    var weaklyPrice: String
    var showCrossButton: (() -> Void)?
    var stopActivityAnimation: (() -> Void)?
    var changeWeaklyText: ((_ price: String) -> Void)?
    
    private weak var coordinator: PaywallProdCoordinatorProtocol?
    
    private let adaptyService: PaywallProdAdaptyServiceUseCaseProtocol
    private let alertService: PaywallProdAlertServiceUseCaseProtocol
    
    init(coordinator: PaywallProdCoordinatorProtocol,
         adaptyService: PaywallProdAdaptyServiceUseCaseProtocol,
         alertService: PaywallProdAlertServiceUseCaseProtocol) {
        self.coordinator = coordinator
        self.adaptyService = adaptyService
        self.alertService = alertService
        self.weaklyPrice = adaptyService.productWeaklyPrice ?? ""
        
        getPrices()
    }
    
}

extension PaywallProdVM: PaywallProdViewModelProtocol {
    
    func activityButtonDidTap() {
        makePurchase()
    }
    
    func privacyButtonDidTap() {
        if let url = URL(string: Constant.Settings.privacy) {
            UIApplication.shared.open(url)
        }
    }
    
    func restoreButtonDidTap() {
        adaptyService.restorePurchases { [weak self] completion in
            if completion {
                self?.coordinator?.finish()
            } else {
                self?.showErrorMessage(from: .restoreDidTap)
            }
        }
    }
    
    func termsButtonDidTap() {
        if let url = URL(string: Constant.Settings.terms) {
            UIApplication.shared.open(url)
        }
    }
    
    func crossButtonDidTap() {
        coordinator?.finish()
    }
    
    //MARK: - View Controller life cycle
    func viewDidAppear() {
        showCloseButton()
    }
    
}

//MARK: - Adapty Service Use Case
extension PaywallProdVM {
    
    private func makePurchase() {
        adaptyService.makePurchase(type: .weekly) { [weak self] result in
            if result {
                self?.coordinator?.finish()
            } else {
                self?.showErrorMessage(from: .continueDidTap)
            }
            self?.stopActivityAnimation?()
        }
    }
    
    private func getPrices() {
        adaptyService.getProductPrice(type: .weekly) {
            [weak self] price in
            if let price {
                self?.weaklyPrice = price
                self?.changeWeaklyText?(price)
            }
        }
    }
    
}

//MARK: - Show Cross Button On VC
extension PaywallProdVM {
    
    private func showCloseButton() {
        let _ = Timer.scheduledTimer(
            withTimeInterval:
                TimeInterval(ParametersHelper.getTimer()),
            repeats: false,
            block: { [weak self] timer in
                self?.showCrossButton?()
            })
    }
    
}

//MARK: - Alert Service Use Case
extension PaywallProdVM {
    
    private func showErrorMessage(from action: PaywallActions) {
        alertService.showAlert(title: "Oops...",
                               message: "Something went wrong. Please try again",
                               cancelTitle: "Cancel", okTitle: "Try again")
        { [weak self] in
            switch action {
            case .continueDidTap:
                self?.makePurchase()
            case .restoreDidTap:
                self?.restoreButtonDidTap()
            }
        }
    }
    
}

