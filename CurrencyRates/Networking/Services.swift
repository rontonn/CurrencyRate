//
//  Services.swift
//  CurrencyRates
//
//  Created by Anton Romanov on 22/01/2019.
//  Copyright © 2019 Anton Romanov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum NetworkError : Error, CustomStringConvertible {
    case requestFailed(Error)
    case noStatus
    
    var description: String {
        switch self {
        case .requestFailed(let e):
            return e.localizedDescription
        case .noStatus:
            return "Could not fetch currency rates"
        }
    }
}

class Services {
    // MARK: - Singleton
    static let shared = Services()
    
    
    // MARK: - Public methods
    func getCurrencyRates(with baseCurrency: String = "EUR", completion: @escaping (JSON?, NetworkError?) -> ()) {
        
        guard let url = URL(string: "https://revolut.duckdns.org/latest?base=\(baseCurrency)") else {
            print("There is some problem with URL.")
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            if let e = response.error {
                completion(nil, .requestFailed(e))
                return
            }
            guard let status = response.response?.statusCode else {
                completion(nil, .noStatus)
                return
            }
            switch status {
            case 404:
                completion(nil, .noStatus)
            case 200:
                if let data = response.data {
                    if let json = try? JSON(data: data) {
                        completion(json, nil)
                    } else {
                        completion(nil, .noStatus)
                        return
                    }
                } else {
                    completion(nil, .noStatus)
                    return
                }
                
                
                
            default:
                completion(nil, .noStatus)
            }
        }
    }
}

