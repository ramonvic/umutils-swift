//
//  UIWindow+ViewControllers.swift
//  SPA at home
//
//  Created by Ramon Vicente on 26/04/17.
//  Copyright © 2017 SPA at home. All rights reserved.
//

import UIKit

public extension UIWindow {
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }

    public static func getVisibleViewControllerFrom(_ viewController: UIViewController?) -> UIViewController? {
        if let navController = viewController as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(navController.visibleViewController)
        } else if let tabController = viewController as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tabController.selectedViewController)
        } else if
            let viewController = viewController,
            viewController.responds(to: Selector(("rootViewController"))),
            let rootViewController = viewController.value(forKey: "rootViewController") as? UIViewController {
            return UIWindow.getVisibleViewControllerFrom(rootViewController)
        } else {
            if let presentedViewController = viewController?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(presentedViewController)
            } else {
                return viewController
            }
        }
    }
}
