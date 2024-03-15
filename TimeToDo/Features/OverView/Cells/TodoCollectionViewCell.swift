//
//  TodoCollectionViewCell.swift
//  TimeToDo
//
//  Created by Minho on 3/13/24.
//

import UIKit
import SnapKit

class TodoCollectionViewCell: BaseCollectionViewCell {
    
    private let backView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private let mainStackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .vertical
        view.distribution = .fillProportionally
        return view
    }()
    private let primaryStackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .horizontal
        view.distribution = .fillProportionally
        return view
    }()
    let doneButton: UIButton = {
        let view = UIButton(type: .custom)
        view.tintColor = .tint
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        view.setImage(UIImage(systemName: "circle", withConfiguration: imageConfig), for: .normal)
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        
        return view
    }()
    let todoTitleLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 14)
        view.textColor = .text
        
        return view
    }()
    
    private let subStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        return view
    }()
    let calenderImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "calendar.badge.clock")
        view.tintColor = .tint
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()
    let dueDateLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        view.textColor = .systemGray
        return view
    }()
    
    override func configureHierarchy() {
        [backView, doneButton, mainStackView].forEach {
            contentView.addSubview($0)
        }
        
        [primaryStackView, subStackView].forEach {
            mainStackView.addArrangedSubview($0)
        }
        
        primaryStackView.addArrangedSubview(todoTitleLabel)
        
        [calenderImageView, dueDateLabel].forEach {
            subStackView.addArrangedSubview($0)
        }
    }
    
    override func configureConstraints() {
        backView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(4)
        }
        
        doneButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView.snp.leading).offset(8)
            make.size.equalTo(40)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.leading.equalTo(doneButton.snp.trailing).offset(4)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(8)
        }
        
        subStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(mainStackView).inset(8)
        }
        
        calenderImageView.snp.makeConstraints { make in
            make.width.equalTo(24)
        }
    }
    
    override func configureCell() {
        
    }
}
