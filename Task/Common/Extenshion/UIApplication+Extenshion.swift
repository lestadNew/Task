//
//  UIApplication+Extenshion.swift
//  Task
//
//  Created by Andrey Sokolov on 12.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import UIKit

// class
extension UIApplication {
    
    func switchRootViewController(window: UIWindow, rootViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        
        if UIApplication.shared.isIgnoringInteractionEvents {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        
        if animated {
            UIView.transition(with: window, duration: 0.1, options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = rootViewController
                UIView.setAnimationsEnabled(oldState)
            }, completion: { (finished: Bool) -> () in
                if (completion != nil) {
                    completion!()
                }
            })
        } else {
            window.rootViewController = rootViewController
        }
    }
    
    /// Return top navigation controller
    /// - Parameters:
    ///   - base: start view controller for search navigation controller. Default: topViewController()
    ///   - dismiss: if need dismiss all view controllers to navigation controller set true.
    class func topNavigationController(_ base: UIViewController? = topViewController(), withDismiss dismiss: Bool) -> UINavigationController? {
        guard base != nil else {
            return nil
        }
        if base?.navigationController != nil {
            return base?.navigationController
        }
        if base is UINavigationController {
            return base as? UINavigationController
        }
        if base?.presentingViewController != nil && dismiss {
            base?.dismiss(animated: false, completion: nil)
        }
        return topNavigationController(base?.presentingViewController, withDismiss: dismiss)
    }
    
    
    /// Get top view controller
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let tabbarController = base as? UITabBarController {
            return topViewController(tabbarController)
        }
        
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        if base == nil {
            return UIApplication.shared.delegate?.window??.rootViewController
        }
        return base
    }
    
    /// Get last view controller
    class func lastViewController() -> UIViewController? {
        
        let base = UIApplication.topViewController()
        
        if let index = base?.children.firstIndex(where: { $0 is UINavigationController }) {
            return (base?.children[index] as? UINavigationController)?.viewControllers.last
        }
        
        return base
    }
    
    
    /// Status bar
    var statusBarView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 38482458
            if let statusBar = self.keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
                statusBarView.tag = tag
                self.keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else {
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
        return nil
    }
}
