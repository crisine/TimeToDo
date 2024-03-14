//
//  SettingViewController.swift
//  TimeToDo
//
//  Created by Minho on 3/7/24.
//

import UIKit

final class SettingViewController: BaseViewController {
    
    private let prototypeLabel: UILabel = {
        let view = UILabel()
        
        view.font = .boldSystemFont(ofSize: 40)
        view.textColor = .text
        view.textAlignment = .center
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureHierarchy() {
        [prototypeLabel].forEach { subview in
            view.addSubview(subview)
        }
    }
    
    override func configureConstraints() {
        prototypeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(48)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
    }
    
    override func configureView() {
        prototypeLabel.text = "Setting View"
    }
    
}
