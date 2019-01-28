//
//  ViewModel.swift
//  CurrencyRates
//
//  Created by Anton Romanov on 23/01/2019.
//  Copyright © 2019 Anton Romanov. All rights reserved.
//

import Foundation

class ViewModel {
    // MARK: - Properties
    var passingObject:Any? = nil
    var passedObject:Box<Any?>  = Box(nil)
    
    
    // MARK: - Lifecycle methods
    init() {
        passedObject.bind { [unowned self] (value) in
            self.handlePassedObject(value: value)
        }
        subscribeForNotifications()
    }
    
    deinit {
        unsubscribeFromAllNotifications()
    }

    
    // MARK: - Custom public/internal methods
    /**
     Override this method for handle passed object from one view model to another
     */
    func handlePassedObject(value:Any?) {
        
    }
    
    /**
     Override this method for notification subscribing
     */
    func subscribeForNotifications() {
        // default implementation does nothing
    }
    
    func subscribeFor(notification: Notification.Name, onComplete: Selector) {
        NotificationCenter.default.addObserver(self, selector: onComplete, name: notification, object: nil)
    }
    
    func viewWillAppearTrigger() {
        unsubscribeFromAllNotifications() // to prevent notification subscription doubles
        subscribeForNotifications()
    }
    
    func viewDidDisappearTrigger() {
        unsubscribeFromAllNotifications()
    }
    
    
    // MARK: - Custom private methods
    private func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}

