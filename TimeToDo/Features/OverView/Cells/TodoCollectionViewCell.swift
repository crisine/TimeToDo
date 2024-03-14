//
//  TodoCollectionViewCell.swift
//  TimeToDo
//
//  Created by Minho on 3/13/24.
//

import UIKit
import SnapKit

class TodoCollectionViewCell: BaseCollectionViewCell {
    
    let backView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        view.backgroundColor = .clear
        return view
    }()
    let doneButton: UIButton = {
        let view = UIButton(type: .custom)
        view.tintColor = .tint
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        view.setImage(UIImage(systemName: "circle", withConfiguration: imageConfig), for: .normal)
        
        return view
    }()
    let todoTitleLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 14)
        view.textColor = .text
        
        return view
    }()
    let subTitleStackView: UIStackView = {
        let view = UIStackView()
        
        return view
    }()
    
    override func configureHierarchy() {
        [backView, doneButton, todoTitleLabel, subTitleStackView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        backView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(4)
        }
        
        doneButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.size.equalTo(32)
        }
        
        todoTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide).offset(-8)
            make.leading.equalTo(doneButton.snp.trailing).offset(16)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(20)
        }
        
        subTitleStackView.snp.makeConstraints { make in
            make.leading.equalTo(todoTitleLabel.snp.leading)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(todoTitleLabel)
        }
    }
    
    override func configureCell() {
        
//        contentView.backgroundColor = .systemGray6
//        contentView.clipsToBounds = true
//        contentView.layer.cornerRadius = 8
        
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 8
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.25
        backView.layer.shadowOffset = CGSize(width: 2, height: 2)
        backView.layer.shadowRadius = 3
        backView.layer.masksToBounds = false
        
        doneButton.clipsToBounds = true
        doneButton.layer.cornerRadius = 20
    }
}
