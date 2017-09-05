//
//  String+Validations.swift
//  Umobi
//
//  Created by Ramon Vicente on 19/03/17.
//  Copyright © 2017 Umobi. All rights reserved.
//

import Foundation

public extension String {
    
    public var isValidEmail: Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: self)
    }
}
