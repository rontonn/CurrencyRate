//
//  DataManager.swift
//  CurrencyRates
//
//  Created by Anton Romanov on 23/01/2019.
//  Copyright © 2019 Anton Romanov. All rights reserved.
//

import Foundation
import SwiftyJSON

class DataManager {
    // MARK: - Properties
    static let notificationPayloadKey = "payload"
    
    
    // MARK: - Lifecycle
    init() {
        subscribeForNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Public methods
    
    func subscribeForNotifications() {
        // default implementation does nothing
    }
    
    func subscribeFor(notification: Notification.Name, onComplete: Selector) {
        NotificationCenter.default.addObserver(self, selector: onComplete, name: notification, object: nil)
    }
    
    func postNotification(notification: Notification.Name, withPayload payload:Any! = nil) {
        var userInfoToPost:[String:Any]? = nil
        if (payload != nil) {
            userInfoToPost = [DataManager.notificationPayloadKey: payload]
        }
        
        NotificationCenter.default.post(name    : notification,
                                        object  : self,
                                        userInfo: userInfoToPost)
    }
    
}
