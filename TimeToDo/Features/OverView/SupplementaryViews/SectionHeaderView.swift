//
//  SectionHeaderView.swift
//  TimeToDo
//
//  Created by Minho on 3/23/24.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    
    var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .text
        view.font = .boldSystemFont(ofSize: 24)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    private func configureHierarchy() {
        addSubview(titleLabel)
    }
    
    private func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(4)
        }
    }
    
    private func configureView() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
