//
//  UIView+Extenshion.swift
//  Task
//
//  Created by Andrey Sokolov on 16.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var rootSuperview: UIView? {
        return superview != nil ? superview?.rootSuperview : self
    }
}
