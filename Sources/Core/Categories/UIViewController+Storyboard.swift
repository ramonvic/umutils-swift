//
//  UIViewController+Storyboard.swift
//  Cilia Mobile
//
//  Created by Ramon Vicente on 10/1/16.
//  Copyright © 2016 Cilia. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public class func fromStoryboard() -> UIViewController {
        let identifier = "\(self)Identifier"
        return fromStoryboard(identifier: identifier)
    }
    
    public class func fromStoryboard(identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
}
