//
//  BaseCollectionViewCell.swift
//  TimeToDo
//
//  Created by Minho on 3/11/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureConstraints()
        configureCell()
    }
    
    func configureHierarchy() {
        
    }
    
    func configureConstraints() {
        
    }
    
    func configureCell() {
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
