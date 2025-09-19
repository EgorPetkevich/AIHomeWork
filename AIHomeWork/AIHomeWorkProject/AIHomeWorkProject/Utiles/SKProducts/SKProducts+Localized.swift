//
//  SKProducts+Localized.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 25.09.24.
//

import StoreKit

extension SKProduct {
    var localizedCurrencyPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
