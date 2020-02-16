//
//  UIViewContoller+Extenshion.swift
//  Task
//
//  Created by Andrey Sokolov on 12.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Get name view controller
    var viewControllerName: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }    
}
