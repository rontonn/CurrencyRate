//
//  CurrencyRateManager.swift
//  CurrencyRates
//
//  Created by Anton Romanov on 23/01/2019.
//  Copyright © 2019 Anton Romanov. All rights reserved.
//


import UIKit

class CurrencyRateManager: DataManager {
    // MARK: - Properties
    static let shared = CurrencyRateManager()
    
    
    // MARK: - Public methods
    func getCurrencyRates(with baseCurrency: String) {
        
        Services.shared.getCurrencyRates(with: baseCurrency) { [unowned self] (json, errorMessage) in
            if let rawData = json {
                let rates = CurrencyRates(from: rawData)
                self.postNotification(notification: .currencyRatesFetchedWithSUCCESS, withPayload: rates)
                
            } else if let error = errorMessage {
                self.postNotification(notification: .currencyRatesFetchingFAILED, withPayload: error)
            }
        }
    }
}
