//
//  CalendarCollectionViewCell.swift
//  TimeToDo
//
//  Created by Minho on 3/11/24.
//

import UIKit
import SnapKit

class CalendarCollectionViewCell: BaseCollectionViewCell {
    
    let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        return view
    }()
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
        [backView, dayLabel, dayNumberImageView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        backView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(4)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(4)
        }
        
        dayNumberImageView.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom)
            make.centerX.equalTo(contentView.safeAreaLayoutGuide)
            make.size.equalTo(40)
        }
    }
    
    override func configureCell() {
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 8
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.25
        backView.layer.shadowOffset = CGSize(width: 2, height: 2)
        backView.layer.shadowRadius = 3
        backView.layer.masksToBounds = false
    }
    
}
