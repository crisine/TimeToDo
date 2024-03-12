//
//  DetailTodoViewController.swift
//  TimeToDo
//
//  Created by Minho on 3/7/24.
//

import UIKit

final class DetailTodoViewController: BaseViewController {
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 16)
        view.textColor = .text
        
        return view
    }()
    private let memoTextView: UITextView = {
        let view = UITextView()
        
        view.font = .systemFont(ofSize: 14)
        view.textColor = .text
        
        return view
    }()
    private let priorityLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 16)
        view.textColor = .text
        
        return view
    }()
    private let dueDateLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 14)
        view.textColor = .text
        
        return view
    }()
    
    var todo: Todo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureHierarchy() {
        [titleLabel, memoTextView, priorityLabel, dueDateLabel].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(160)
        }
        
        priorityLabel.snp.makeConstraints { make in
            make.top.equalTo(memoTextView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        dueDateLabel.snp.makeConstraints { make in
            make.top.equalTo(priorityLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    override func configureView() {
        
        // MVVM 기준으로 바뀌어야 할 듯?
        titleLabel.text = todo?.title
        memoTextView.text = todo?.memo
        priorityLabel.text = "\(todo?.priority ?? 0)"
        dueDateLabel.text = todo?.dueDate?.formatted()
    }

}
