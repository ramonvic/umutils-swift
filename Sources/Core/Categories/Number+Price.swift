//
//  Number+Price.swift
//  SPA at home
//
//  Created by Ramon Vicente on 11/04/17.
//  Copyright © 2017 SPA at home. All rights reserved.
//

import Foundation

extension NSNumber {

    public var priceString: String {
        let numberFormatter = NumberFormatter()
        if #available(iOS 9.0, *) {
            numberFormatter.numberStyle = .currencyAccounting
        } else {
            numberFormatter.numberStyle = .currency
        }
        numberFormatter.locale = Locale(identifier: "pt_BR")
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        let absSelf = NSNumber(value: abs(self.doubleValue))
        let formatted = numberFormatter.string(from: absSelf) ?? ""
        return self.doubleValue >= 0 ? formatted : "- " + formatted
    }
}

extension Double {
    public var priceString: String {
        return (self as NSNumber).priceString
    }
}

extension Float {
    public var priceString: String {
        return (self as NSNumber).priceString
    }
}

extension Int {
    public var priceString: String {
        return (self as NSNumber).priceString
    }
}
