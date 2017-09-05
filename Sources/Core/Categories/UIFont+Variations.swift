//
//  UIFont+Variations.swift
//  SpaAtHome
//
//  Created by Ramon Vicente on 16/08/17.
//  Copyright © 2017 Spa At Home. All rights reserved.
//

import UIKit

extension UIFont {

    fileprivate func withTraits(_ traits: UIFontDescriptorSymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits)) else { return self }
        return UIFont(descriptor: descriptor, size: 0)
    }

    public var bold: UIFont {
        return withTraits(.traitBold)
    }

    public var italic: UIFont {
        return withTraits(.traitItalic)
    }

    public var boldItalic: UIFont {
        return withTraits(.traitBold, .traitItalic)
    }
}
