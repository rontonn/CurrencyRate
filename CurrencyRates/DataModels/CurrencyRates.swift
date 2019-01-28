//
//  CurrencyRates.swift
//  CurrencyRates
//
//  Created by Anton Romanov on 22/01/2019.
//  Copyright © 2019 Anton Romanov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CurrencyRates {
    // MARK: - Properties
    var baseCurrency: String
    var actualDate: String
    var currencyRates: [String : Double]
    
    
    // MARK: - Lifecycle
    init(from rawData: JSON) {
        
        self.baseCurrency = rawData["base"].stringValue
        self.actualDate = rawData["date"].stringValue
        if var tempDict = rawData["rates"].dictionaryObject as? [String : Double] {
            tempDict[self.baseCurrency] = 1.0
            self.currencyRates = tempDict
        } else {
            self.currencyRates = [String : Double]()
        }
    }
}
