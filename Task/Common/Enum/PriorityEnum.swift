//
//  PriorityEnum.swift
//  Task
//
//  Created by Andrey Sokolov on 16.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import Foundation

enum PriorityEnum: Int {
    case hight
    case medium
    case low
    
    var name: String {
        switch self {
        case .hight: return "High"
        case .medium: return "Normal"
        case .low: return "Low"
        }
    }
}
