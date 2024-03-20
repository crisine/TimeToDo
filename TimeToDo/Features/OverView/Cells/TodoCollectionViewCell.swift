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
        view.distribution = .fillEqually
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

    let subStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.isHidden = true
        return view
    }()
    
    private let dueDateView: UIView = {
        let view = UIView()
        return view
    }()
    let calenderImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "calendar.badge.clock")
        view.tintColor = .tint
        view.contentMode = .scaleAspectFit
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
        
        subStackView.addArrangedSubview(dueDateView)
        
        [calenderImageView, dueDateLabel].forEach {
            dueDateView.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        backView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(4)
        }
        
        doneButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView).offset(8)
            make.size.equalTo(40)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.leading.equalTo(doneButton.snp.trailing).offset(4)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(8)
        }
        
        calenderImageView.snp.makeConstraints { make in
            make.centerY.equalTo(dueDateView)
            make.leading.equalTo(dueDateView)
        }
        
        dueDateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dueDateView)
            make.leading.equalTo(calenderImageView.snp.trailing).offset(4)
        }
    }
    
    override func configureCell() {
        
    }
    
    override func prepareForReuse() {
        backView.backgroundColor = .systemGray6
        todoTitleLabel.textColor = .text
    }
    
    func updateUI() {
        
    }
}
