//
//  PomoTimerView.swift
//  TimeToDo
//
//  Created by Minho on 3/7/24.
//

import UIKit

final class PomoTimerView: BaseView {
    
    private let prototypeLabel: UILabel = {
        let view = UILabel()
        
        view.font = .boldSystemFont(ofSize: 40)
        view.textColor = .text
        view.textAlignment = .center
        
        return view
    }()
    
    override func configureHierarchy() {
        [prototypeLabel].forEach { subview in
            addSubview(subview)
        }
    }
    
    override func configureConstraints() {
        prototypeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(48)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
        }
    }
    
    override func configureView() {
        prototypeLabel.text = "PomoTimer"
    }
    
}
