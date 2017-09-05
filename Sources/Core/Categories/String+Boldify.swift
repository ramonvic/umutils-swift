//
//  String+Boldify.swift
//  Umobi
//
//  Created by Ramon Vicente on 18/07/17.
//  Copyright © 2017 Umobi. All rights reserved.
//

import Foundation

public extension NSAttributedString {
    public func boldify(with string: String) -> NSAttributedString {
        return self.setAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 15)!], string: string)
    }

    public func setAttributes(_ attrs: [String : Any]?, string: String) -> NSAttributedString {
        let nsString = self.string as NSString
        let attributedString = NSMutableAttributedString(attributedString: self)

        let range = nsString.range(of: string)

        if range.location != NSNotFound {
            attributedString.setAttributes(attrs, range: range)
        }

        return attributedString
    }
}

public extension NSString {
    public func boldify(with string: String) -> NSAttributedString {
        let attributedString = NSAttributedString(string: self as String)
        return attributedString.boldify(with:string)
    }

    public func setAttributes(_ attrs: [String : Any]?, string: String) -> NSAttributedString {
        return NSAttributedString(string: self as String).setAttributes(attrs, string: string)
    }
}

public extension String {
    public func boldify(with string: String) -> NSAttributedString {
        return (self as NSString).boldify(with:string)
    }

    public func setAttributes(_ attrs: [String : Any]?, string: String) -> NSAttributedString {
        return (self as NSString).setAttributes(attrs, string: string)
    }
}
