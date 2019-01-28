//
//  CurrencyRatesTests.swift
//  CurrencyRatesTests
//
//  Created by Anton Romanov on 27/01/2019.
//  Copyright © 2019 Anton Romanov. All rights reserved.
//

import XCTest
import SwiftyJSON

@testable import CurrencyRates

class CurrencyRatesTests: XCTestCase {
    var viewModel: CurrencyRatesViewModel!
    var jsonData: JSON!
    
    func testBaseCurrencyValue() {
        let baseCurrency = "EUR"
        let expectation = self.expectation(description: "Fetching currency rates...")
        
        Services.shared.getCurrencyRates(with: baseCurrency) { [unowned self] (json, errorMessage) in
           self.jsonData = json
           expectation.fulfill()
        }
        waitForExpectations(timeout: 3.0, handler: nil)
        
        if let data = jsonData {
            XCTAssertEqual(baseCurrency, CurrencyRates(from: data).baseCurrency)
        }
    }
    
    func testCountOfRatesInViewModel() {
        viewModel = CurrencyRatesViewModel()
        let baseCurrency = "EUR"
        let expectation = self.expectation(description: "Fetching currency rates...")
        
        Services.shared.getCurrencyRates(with: baseCurrency) { [unowned self] (json, errorMessage) in
            self.jsonData = json
            expectation.fulfill()
        }
        waitForExpectations(timeout: 3.0, handler: nil)
        
        if let data = jsonData {
            viewModel.exposeSetUpCurrencyRates(with: CurrencyRates(from: data))
        }
        
        XCTAssertEqual(viewModel.resultingRates.value.count, CurrencyRates(from: jsonData).currencyRates.count)
    }
    
    func testBaseCurrencyIsTheFirstCurrency() {
        viewModel = CurrencyRatesViewModel()
        let baseCurrency = "EUR"
        let expectation = self.expectation(description: "Fetching currency rates...")
        
        Services.shared.getCurrencyRates(with: baseCurrency) { [unowned self] (json, errorMessage) in
            self.jsonData = json
            expectation.fulfill()
        }
        waitForExpectations(timeout: 3.0, handler: nil)
        
        if let data = jsonData {
            viewModel.exposeSetUpCurrencyRates(with: CurrencyRates(from: data))
        }
        
        let firstElement = viewModel.resultingRates.value[0]
        
        XCTAssertEqual(firstElement.currencyCode, baseCurrency)
    }
    
    func testNumberWith3DecimalsExtension() {
        let value = 3.14124987763761236
        XCTAssertEqual(value.getNumberWith3DecimalDigits, 3.141)
    }
}
