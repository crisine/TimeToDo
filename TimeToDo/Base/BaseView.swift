//
//  BaseView.swift
//  TimeToDo
//
//  Created by Minho on 3/7/24.
//

import UIKit
import SnapKit

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .background
        
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    func configureHierarchy() {}
    
    func configureConstraints() {}
    
    func configureView() {}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
