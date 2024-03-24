//
//  ChartSubview.swift
//  TimeToDo
//
//  Created by Minho on 3/24/24.
//

import UIKit

class ChartSubview: UIView {
    
    let valueLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = .text
        view.font = .systemFont(ofSize: 16)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    private func configureHierarchy() {
        addSubview(valueLabel)
    }
    
    private func configureConstraints() {
        valueLabel.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureView() {
        backgroundColor = .systemGray5
        clipsToBounds = true
        layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateValue(_ value: String) {
        valueLabel.text = value
    }
}
