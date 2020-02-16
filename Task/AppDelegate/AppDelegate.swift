//
//  AppDelegate.swift
//  Task
//
//  Created by Andrey Sokolov on 12.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        if !UserDefaults.standard.bool(forKey: Constant.tempFirstLoad) {
            KeychainService.standard.token = nil
            UserDefaults.standard.set(true, forKey: Constant.tempFirstLoad)
        }
        
        return RootRouter.shared.application(didFinishLaunchingWithOptions: launchOptions, window: window!)
        
    }


}

