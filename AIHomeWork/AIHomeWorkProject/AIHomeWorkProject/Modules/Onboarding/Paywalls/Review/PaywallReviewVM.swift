//
//  PaywallReviewVM.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 28.08.24.
//

import UIKit

protocol PaywallReviewCoordinatorProtocol: AnyObject {
    func finish()
}

protocol PaywallReviewAdaptyServiceUseCaseProtocol {
    var trialPrice: String? { get }
    var weaklyPrice: String? { get }
    
    func makePurchase(type: AdaptyService.PurchaseType,
                      completion: @escaping (Bool) -> Void)
    
    func getProductPrice(type: AdaptyService.PurchaseType,
                         completion: @escaping (String?) -> Void)
    func restorePurchases(completion: @escaping (Bool) -> Void)
}

protocol PaywallReviewAlertServiceUseCaseProtocol {
    func showAlert(title: String,
                   message: String,
                   cancelTitle: String,
                   okTitle: String,
                   okHandler: @escaping () -> Void)
}

final class PaywallReviewVM {
    
    private enum PaywallActions {
        case continueDidTap
        case restoreDidTap
    }
    
    var trialPrice: String
    var weaklyPrice: String
    var changeWeaklyText: ((String) -> Void)?
    var changeTrialText: ((String) -> Void)?
    var showCrossButton: (() -> Void)?
    var stopActivityAnimation: (() -> Void)?
    
    private var isTrialIsOn: Bool = false
    
    private weak var coordinator: PaywallReviewCoordinatorProtocol?
    
    private let adaptyService: PaywallReviewAdaptyServiceUseCaseProtocol
    private let aletrService: PaywallReviewAlertServiceUseCaseProtocol
    
    init(coordinator: PaywallReviewCoordinatorProtocol,
         adaptyService: PaywallReviewAdaptyServiceUseCaseProtocol,
         alertService: PaywallReviewAlertServiceUseCaseProtocol) {
        self.coordinator = coordinator
        self.adaptyService = adaptyService
        self.aletrService = alertService
        trialPrice = adaptyService.trialPrice ?? ""
        weaklyPrice = adaptyService.weaklyPrice ?? ""
        
        getPrices()
    }
        
}

extension PaywallReviewVM: PaywallReviewViewModelProtocol{

    func switchStatusDidChanged(_ sender: Bool) {
        self.isTrialIsOn = sender
        changeText(sender)
    }
    
    func activityButtonDidTap() {
        self.makePurchase(withTrialIsOn: isTrialIsOn)
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
    
    func privacyButtonDidTap() {
        if let url = URL(string: Constant.Settings.privacy) {
            UIApplication.shared.open(url)
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
extension PaywallReviewVM {
    
    private func makePurchase(withTrialIsOn: Bool) {
        if withTrialIsOn {
            adaptyService.makePurchase(type: .trial) { [weak self] result in
                if result {
                    self?.coordinator?.finish()
                } else {
                    self?.showErrorMessage(from: .continueDidTap)
                }
                self?.stopActivityAnimation?()
            }
        } else {
            adaptyService.makePurchase(type: .weekly) { [weak self] result in
                if result {
                    self?.coordinator?.finish()
                } else {
                    self?.showErrorMessage(from: .continueDidTap)
                }
                self?.stopActivityAnimation?()
            }
        }
    }
    
    private func getPrices() {
        adaptyService.getProductPrice(type: .trial) {
            [weak self] price in
            if let price {
                self?.trialPrice = price
                if let isTrialIsOn = self?.isTrialIsOn, isTrialIsOn {
                    self?.changeWeaklyText?(price)
                }
            }
        }
        adaptyService.getProductPrice(type: .weekly) {
            [weak self] price in
            if let price {
                self?.weaklyPrice = price
                if let isTrialIsOn = self?.isTrialIsOn, !isTrialIsOn {
                    self?.changeTrialText?(price)
                }
            }
        }
    }
    
}

//MARK: - Show Cross Button On VC
extension PaywallReviewVM {
    
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

//MARK: - Change Text On VC
extension PaywallReviewVM {
    
    private func changeText(_ trialIsOn: Bool) {
        if trialIsOn {
            changeWeaklyText?(trialPrice)
        } else {
            changeTrialText?(weaklyPrice)
        }
    }
    
}

//MARK: - Alert Service Use Case
extension PaywallReviewVM {
    
    private func showErrorMessage(from action: PaywallActions) {
        aletrService.showAlert(title: "Oops...",
                               message: "Something went wrong. Please try again",
                               cancelTitle: "Cancel", okTitle: "Try again")
        { [weak self] in
            switch action {
            case .continueDidTap:
                guard let isTrialIsOn = self?.isTrialIsOn else { return }
                self?.makePurchase(withTrialIsOn: isTrialIsOn)
            case .restoreDidTap:
                self?.restoreButtonDidTap()
            }
        }
    }
    
}
