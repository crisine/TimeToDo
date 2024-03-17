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
        
        view.font = .systemFont(ofSize: 16)
        view.textColor = .text
        view.textAlignment = .center
        
        return view
    }()
    let pomodoroTimerImageView: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(systemName: "alarm")
        view.tintColor = .tint
        
        return view
    }()
    let totalTimeLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 14)
        view.textColor = .text
        
        return view
    }()
    let totalCountLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 14)
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
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            make.size.equalTo(40)
        }
        
        totalTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(pomodoroTimerImageView.snp.top).offset(4)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(26)
        }
        
        totalCountLabel.snp.makeConstraints { make in
            make.bottom.equalTo(pomodoroTimerImageView.snp.bottom).offset(-4)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(16)
        }
    }
    
    override func configureCell() {
        
    }
}
