//
//  Box.swift
//  CurrencyRates
//
//  Created by Anton Romanov on 22/01/2019.
//  Copyright © 2019 Anton Romanov. All rights reserved.
//

import Foundation

class Box<T> {
    // MARK: - Properties
    typealias Listener = (T) -> ()
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    // MARK: - Lifecycle
    init(_ value: T) {
        self.value = value
    }
    
    
    // MARK: - Public methods
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
