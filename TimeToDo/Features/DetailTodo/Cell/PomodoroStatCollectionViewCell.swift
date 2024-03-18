//
//  PomodoroStatCollectionViewCell.swift
//  TimeToDo
//
//  Created by Minho on 3/17/24.
//

import UIKit

final class PomodoroStatCollectionViewCell: BaseCollectionViewCell {
    
    let titleLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 24, weight: .heavy)
        view.textColor = .text
        view.textAlignment = .center
        
        return view
    }()
    private let pomodoroTimerImageView: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(systemName: "alarm")
        view.tintColor = .tint
        
        return view
    }()
    let totalTimeLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 16)
        view.textColor = .text
        
        
        return view
    }()
    let totalCountLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 16)
        view.textColor = .text
        
        
        return view
    }()
    
    override func configureHierarchy() {
        [titleLabel, pomodoroTimerImageView, totalTimeLabel, totalCountLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView.safeAreaLayoutGuide)
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(8)
        }
        
        pomodoroTimerImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            make.size.equalTo(20)
        }
        
        totalTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(pomodoroTimerImageView.snp.top)
            make.leading.equalTo(pomodoroTimerImageView.snp.trailing).offset(4)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(18)
        }
        
        totalCountLabel.snp.makeConstraints { make in
            make.top.equalTo(totalTimeLabel.snp.bottom).offset(4)
            make.leading.equalTo(totalTimeLabel.snp.leading)
            make.trailing.equalTo(totalTimeLabel.snp.trailing)
            make.height.equalTo(18)
        }
    }
    
    override func configureCell() {
        
    }
}
