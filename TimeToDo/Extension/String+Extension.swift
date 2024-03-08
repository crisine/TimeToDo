//
//  String+Extension.swift
//  TimeToDo
//
//  Created by Minho on 3/7/24.
//

import Foundation

extension String {
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
