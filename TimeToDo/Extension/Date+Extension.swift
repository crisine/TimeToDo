//
//  Date+Extension.swift
//  TimeToDo
//
//  Created by Minho on 3/15/24.
//

import Foundation

extension Date {
    
    var toString: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd EE"
        return formatter.string(from: self)
    }
    
    var dayToInt: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return Int(formatter.string(from: self)) ?? 0
    }
}
