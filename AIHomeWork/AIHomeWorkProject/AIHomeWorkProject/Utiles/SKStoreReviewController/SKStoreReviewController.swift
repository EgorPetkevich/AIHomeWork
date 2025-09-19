//
//  SKStoreReviewController+Review.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 26.09.24.
//

import StoreKit

extension SKStoreReviewController {
    public static func requestReviewInCurrentScene() {
        if let scene =
            UIApplication
            .shared
            .connectedScenes
            .first(where:
                    { $0.activationState == .foregroundActive }
            ) as? UIWindowScene {
            DispatchQueue.main.async {
                requestReview(in: scene)
            }
        }
    }
}
