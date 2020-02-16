//
//  File.swift
//  Task
//
//  Created by Andrey Sokolov on 12.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import UIKit

struct AlertService {
    
    let textOK = "ОK"
    let textCancel = "Cancel"
    
    func show(title: String? = nil, message: String? = nil, action: (()->())? = nil) {
        
        let topViewController = UIApplication.topViewController()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: textOK, style: .default, handler: { _ in
            action?()
        }))
        
        if UIApplication.topViewController() is UIAlertController { return }
        topViewController?.present(alert, animated: true, completion: nil)
    }
}
