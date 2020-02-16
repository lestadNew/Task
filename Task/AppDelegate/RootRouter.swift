//
//  RootRouter.swift
//  Task
//
//  Created by Andrey Sokolov on 12.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import UIKit

/// RootRouter
class RootRouter {
    
    /// Get window for navigation
    fileprivate(set) var window: UIWindow!
    
    // MARK: - SINGLETON
    static let shared: RootRouter = {
        let instance = RootRouter()
        return instance
    }()
    
    var needReconnectToSocket: Bool = false
    
    /// Get top view controller
    var topViewController: UIViewController? {
        return UIApplication.topViewController()
    }
    
    /// Get last view controller
    var lastViewController: UIViewController? {
        return UIApplication.lastViewController()
    }
    
    // MARK: - APPLICATION DIDFINISHLAUCHING WITH OPTIONS
    func application(didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?, window: UIWindow) -> Bool {
        self.window = window
        
        checkRootController()
        return true
    }

    // MARK: -
    // MARK: load
    
    func loadSignIn(toWindow window: UIWindow) {
        let controller = LoginController()
        
        let nc = UINavigationController(rootViewController: controller)
        
        UIApplication.shared.switchRootViewController(window: window,
                                                      rootViewController: nc,
                                                      animated: true,
                                                      completion: nil)
    }
    
    func loadTask(toWindow window: UIWindow) {
        let controller = TaskController()
        
        let nc = UINavigationController(rootViewController: controller)
        
        UIApplication.shared.switchRootViewController(window: window,
                                                      rootViewController: nc,
                                                      animated: true,
                                                      completion: nil)
    }
    
    // MARK: -
    // MARK: login
    
    func checkRootController(complete: (()->())? = nil) {
       
        /// get token, account
        guard let expired = KeychainService.standard.token?.expired, expired.hours(from: Date()) < 24 else {
            loadSignIn(toWindow: self.window)
            return
        }
        
        loadTask(toWindow: self.window)
    }
}
