//
//  UIViewController+Notification.swift
//  Cilia Mobile
//
//  Created by Ramon Vicente on 8/22/16.
//  Copyright © 2016 Cilia. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func addObserver(selector aSelector: Selector, name aName: String?, object anObject: AnyObject? = nil) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: aSelector, name: aName, object: anObject);
    }
    
    func postNotification(name aName: String, object anObject: AnyObject? = nil, userInfo aUserInfo: [NSObject : AnyObject]? = nil) {
        NSNotificationCenter.defaultCenter().postNotificationName(aName, object: anObject, userInfo: aUserInfo)
    }
}