//
//  UITableView+Extenshion.swift
//  Task
//
//  Created by Andrey Sokolov on 16.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func insertIndexWithoutAnimation(indexPath: IndexPath) {
        UIView.setAnimationsEnabled(false)
        self.beginUpdates()
        self.insertRows(at: [indexPath], with: .none)
        self.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
}
