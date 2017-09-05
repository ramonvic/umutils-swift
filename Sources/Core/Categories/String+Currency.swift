//
//  String+Price.swift
//  SPAPartner
//
//  Created by Ramon Vicente on 03/09/17.
//  Copyright © 2017 SPA at home. All rights reserved.
//

import Foundation

extension String {
    public var currency: Double {
        var amountWithPrefix = self

        let regex = (try? NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive))!
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix,
                                                          options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                          range: NSMakeRange(0, self.characters.count),
                                                          withTemplate: "")
        let double = (amountWithPrefix as NSString).doubleValue
        return (double / 100)
    }
}
