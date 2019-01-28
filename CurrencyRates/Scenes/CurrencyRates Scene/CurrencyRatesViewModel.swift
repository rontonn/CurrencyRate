//
//  CurrencyRatesViewModel.swift
//  CurrencyRates
//
//  Created by Anton Romanov on 22/01/2019.
//  Copyright © 2019 Anton Romanov. All rights reserved.
//

import Foundation
import FlagKit

class CurrencyRatesViewModel: ViewModel {
    // MARK: - Properties
    let allCountries = Flag.all
    let resultingRates: Box<[Currency]> = Box([Currency]())
    let error: Box<NetworkError?> = Box(nil)
    var isEditingRate: Bool = false
    var indexPathForSelectedRow: IndexPath!
    
    private var editingRate: Double = 1.0
    private var defaultValueForBaseCurrency: Double = 1.0
    private var baseCurrency: String = "EUR"
    private var previousBaseCurrencyValue: String = "EUR"
    private var positionToBeSwappedInt: Int?
    private var currenciesArray: [Currency] = [Currency]()
    private var refreshCurrencyRatesTimer:Timer!
    
    // MARK: - Lifecycle methods
    override init() {
        super.init()
        
        startRefreshCurrencyRatesTimer()
    }
    
    // MARK: - Overridden methods
    override func subscribeForNotifications() {
        super.subscribeForNotifications()
        
        subscribeFor(notification: .currencyRatesFetchedWithSUCCESS, onComplete: #selector(handleNotifRatesFetchedWithSUCCESS))
        subscribeFor(notification: .currencyRatesFetchingFAILED, onComplete: #selector(handleNotifRatesFetchingFAILED))
    }
    
    override func viewWillAppearTrigger() {
        super.viewWillAppearTrigger()
        getCurrencyRates()
        startRefreshCurrencyRatesTimer()
    }
    
    override func viewDidDisappearTrigger() {
        super.viewDidDisappearTrigger()
        
        stopRefreshCurrencyRatesTimer()
    }

    // MARK: - Custom private methods
    private func updateRates(with multiplier: Double, andIndex index: Int) -> [Currency] {
        
        var tempArray = currenciesArray
        for i in index..<tempArray.count {
            let tempResult = multiplier * tempArray[i].currencyRate
            tempArray[i].currencyRate = tempResult.getNumberWith3DecimalDigits
        }
        
        return tempArray
    }
    
    private func startRefreshCurrencyRatesTimer() {
        stopRefreshCurrencyRatesTimer()
        
        refreshCurrencyRatesTimer = Timer.scheduledTimer(timeInterval : 1.0,
                                                  target       : self,
                                                  selector     : #selector(handleResendBlockingTimerFire),
                                                  userInfo     : nil,
                                                  repeats      : true)
    }
    
    private func stopRefreshCurrencyRatesTimer() {
        if (refreshCurrencyRatesTimer != nil) {
            refreshCurrencyRatesTimer.invalidate()
            refreshCurrencyRatesTimer = nil
        }
    }
    
    #if DEBUG
    public func exposeSetUpCurrencyRates(with rates: CurrencyRates) {
        return setUpCurrencyRates(with: rates)
    }
    #endif
    
    private func setUpCurrencyRates(with rates: CurrencyRates) {
        var tempArrayWithAllSetRates = [Currency]()
        let complexCasesDict = ["NZ" : "NZD",
                                "AU" : "AUD",
                                "GB" : "GBP",
                                "DK" : "DKK",
                                "NO" : "NOK",
                                "IL" : "ILS",
                                "US" : "USD",
                                "EU" : "EUR",
                                "CH" : "CHF",
                                "ZA" : "ZAR"]
        
        let tempArrayOfCurrencyCodes = Array(rates.currencyRates.keys)
        
        for countryCodeAndCurrencyCode in Locale.currency {
            
            if tempArrayOfCurrencyCodes.contains(countryCodeAndCurrencyCode.value) && !Array(complexCasesDict.values).contains(countryCodeAndCurrencyCode.value) {
                
                localLoop: for country in allCountries {
                    if country.countryCode == countryCodeAndCurrencyCode.key {
                        
                        let description = Locale.current.localizedString(forCurrencyCode: countryCodeAndCurrencyCode.value) ?? "N/A"
                        
                        if countryCodeAndCurrencyCode.value == rates.baseCurrency {
                            
                            tempArrayWithAllSetRates.insert(Currency(currencyCode: countryCodeAndCurrencyCode.value, currencyFullName: description, currencyRate: 1.0, currencyFlagImage: country.image(style: .circle)), at: 0)
                        } else {
                            tempArrayWithAllSetRates.append(Currency(currencyCode: countryCodeAndCurrencyCode.value, currencyFullName: description, currencyRate: rates.currencyRates[countryCodeAndCurrencyCode.value] ?? 0.0, currencyFlagImage: country.image(style: .circle)))
                        }
    
                        break localLoop
                    }
                }
            }
        }
        
        for (countryCode, currencyCode) in complexCasesDict {
            addComplexCases(withCountryCode: countryCode, currencyCode: currencyCode, rates: rates, arrayToBeFilled: &tempArrayWithAllSetRates)
        }
        currenciesArray = tempArrayWithAllSetRates
        
        swapPositions(inside: &currenciesArray)
        
        var startingIndex = 0
        if isEditingRate {
            defaultValueForBaseCurrency = 1.0
            
            if editingRate == 0.0 {
                defaultValueForBaseCurrency = 0.0
            }
            startingIndex = 1
        }
        
        if previousBaseCurrencyValue != baseCurrency {
            resultingRates.value = updateRates(with: editingRate, andIndex: startingIndex)
        } else {
            resultingRates.value = updateRates(with: defaultValueForBaseCurrency, andIndex: startingIndex)
        }
        
        
    }
    
    private func addComplexCases(withCountryCode countryCode: String, currencyCode: String, rates: CurrencyRates, arrayToBeFilled: inout [Currency]) {
        let description = Locale.current.localizedString(forCurrencyCode: currencyCode) ?? "N/A"
        
        if let country = Flag(countryCode: countryCode) {
            if currencyCode == rates.baseCurrency {
                arrayToBeFilled.insert(Currency(currencyCode: currencyCode, currencyFullName: description, currencyRate: 1.0, currencyFlagImage: country.image(style: .circle)), at: 0)
            } else {
                arrayToBeFilled.append(Currency(currencyCode: currencyCode, currencyFullName: description, currencyRate: rates.currencyRates[currencyCode] ?? 0.0, currencyFlagImage: country.image(style: .circle)))
            }
        }
    }
    
    private func swapPositions(inside array: inout [Currency]) {
        
        var positionToBeFound = 0
        for i in (1..<array.count).reversed() {
            if array[i].currencyCode == previousBaseCurrencyValue {
                
                positionToBeFound = i
            }
        }
        if let swapPos = positionToBeSwappedInt {
            array.swapAt(positionToBeFound, swapPos)
        }
    }
    
    
    // MARK: - Notification handlers
    @objc func handleNotifRatesFetchedWithSUCCESS(notification:Notification) {
        let userInfo = notification.userInfo as! [String: CurrencyRates]
        let currencyRates = userInfo[DataManager.notificationPayloadKey]
        if let rates = currencyRates {
            setUpCurrencyRates(with: rates)
        }
        
    }
    
    @objc func handleNotifRatesFetchingFAILED(notification:Notification) {
        let userInfo = notification.userInfo as! [String: NetworkError]
        let networkError = userInfo[DataManager.notificationPayloadKey]
        if let error = networkError {
            print("\(type(of: self)): There is network error: \(error).")
        }
    }
    
    // MARK: Timer handling
    @objc func handleResendBlockingTimerFire() {
        getCurrencyRates()
    }
    
    
    // MARK: - Public functions
    func getCurrencyRates() {
        CurrencyRateManager.shared.getCurrencyRates(with: baseCurrency)
    }
    
    func editRate(with stringRate: String) {
        isEditingRate = true
        
        if let rate = Double(stringRate) {
            editingRate = rate
            
        } else if stringRate.isEmpty {
            editingRate = 0
        }

        resultingRates.value = updateRates(with: editingRate, andIndex: 1)
    }
    
    func performUpdates(with rateIndex: IndexPath) {
        indexPathForSelectedRow = rateIndex
        previousBaseCurrencyValue = baseCurrency
        baseCurrency = resultingRates.value[rateIndex.row].currencyCode
        
        if rateIndex.row != 0 {
            editingRate = resultingRates.value[rateIndex.row].currencyRate
        }
        
        positionToBeSwappedInt = rateIndex.row
        indexPathForSelectedRow = IndexPath(row: 0, section: 0)
        
        getCurrencyRates()
    }
}

