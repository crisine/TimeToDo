//
//  String+Extension.swift
//  TimeToDo
//
//  Created by Minho on 3/7/24.
//

import Foundation
import UIKit

extension String {
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
}
