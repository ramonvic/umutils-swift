//
//  UIButton+Styles.swift
//  SPA at home
//
//  Created by Ramon Vicente on 19/03/17.
//  Copyright © 2017 SPA at home. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    open override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1: 0.7
        }
    }
}
