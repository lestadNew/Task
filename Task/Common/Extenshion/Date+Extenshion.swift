//
//  Date+Extenshion.swift
//  Task
//
//  Created by Andrey Sokolov on 16.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import Foundation

extension Date {
    
    init(seconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(seconds))
    }
    
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    func trackDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY hh:mm a"
        dateFormatter.timeZone = .current
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"

        return dateFormatter.string(from: self)
    }
}
