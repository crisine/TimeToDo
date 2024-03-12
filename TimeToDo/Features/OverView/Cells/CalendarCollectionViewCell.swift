//
//  CalendarCollectionViewCell.swift
//  TimeToDo
//
//  Created by Minho on 3/11/24.
//

import UIKit
import SnapKit

class CalendarCollectionViewCell: BaseCollectionViewCell {
    
    let dayLabel: UILabel = {
        let view = UILabel()
        
        view.font = .boldSystemFont(ofSize: 16)
        view.textColor = .text
        view.textAlignment = .center
        
        return view
    }()
    let dayNumberImageView: UIImageView = {
        let view = UIImageView()
        
        view.contentMode = .scaleAspectFit
        view.tintColor = .tint
        
        return view
    }()
    
    override func configureHierarchy() {
        [dayLabel, dayNumberImageView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(4)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(4)
        }
        
        dayNumberImageView.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom).offset(4)
            make.centerX.equalTo(contentView.safeAreaLayoutGuide)
            make.size.equalTo(40)
        }
    }
    
    override func configureCell() {
        
    }
    
}
