//
//  DataEvents.swift
//  CurrencyRates
//
//  Created by Anton Romanov on 23/01/2019.
//  Copyright © 2019 Anton Romanov. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    // MARK: - Fetching currencies rates notifications
    static let currencyRatesFetchedWithSUCCESS = Notification.Name("Currency rates fetch with SCUCCESS.")
    static let currencyRatesFetchingFAILED = Notification.Name("Currency rates fetching FAILED!")

}
