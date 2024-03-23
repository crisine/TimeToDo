//
//  UICollectionReusableView+Extension.swift
//  TimeToDo
//
//  Created by Minho on 3/23/24.
//

import UIKit

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
