//
//  UIViewController+Storyboard.swift
//  Cilia Mobile
//
//  Created by Ramon Vicente on 10/1/16.
//  Copyright © 2016 Cilia. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static func fromStoryboard() -> UIViewController {
        let identifier = "\(self)Identifier"
        return fromStoryboard(identifier)
    }
    
    static func fromStoryboard(identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(identifier)
    }
}
