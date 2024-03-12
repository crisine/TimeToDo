//
//  Calendar+Extension.swift
//  TimeToDo
//
//  Created by Minho on 3/12/24.
//

import Foundation

extension Calendar {
    
    static func firstDayOfMonth(_ currentDate: Date) -> Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        
        guard let firstDayOfMonth = calendar.date(from: components) else {
            return nil
        }
        
        return firstDayOfMonth
    }
    
    static func lastDayOfMonth(_ currentDate: Date) -> Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        
        guard let firstDayOfMonth = calendar.date(from: components) else {
            return nil
        }
        
        let lastDayOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: firstDayOfMonth)
        
        return lastDayOfMonth
    }
    
}
