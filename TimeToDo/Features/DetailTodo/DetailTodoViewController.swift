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
        
        view.font = .systemFont(ofSize: 32, weight: .medium)
        view.numberOfLines = 0
        view.textColor = .text
        
        return view
    }()
    private let titleLableUnderLineView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .systemGray4
        
        return view
    }()
    
    
    private let memoHolderLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 16)
        view.textColor = .systemGray3
        view.text = "Additional Description"
        
        return view
    }()
    private let memoTextView: UITextView = {
        let view = UITextView()
        
        view.font = .systemFont(ofSize: 14)
        view.isEditable = false
        view.isSelectable = false
        view.textColor = .text
        view.backgroundColor = .systemGray6
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        
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
    
    let viewModel = DetailTodoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHierarchy() {
        [titleLabel, titleLableUnderLineView, memoHolderLabel, memoTextView, priorityLabel, dueDateLabel].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.lessThanOrEqualTo(80)
        }
        
        titleLableUnderLineView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(0.5)
        }
        
        memoHolderLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLableUnderLineView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(20)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(memoHolderLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
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
        guard let todo = viewModel.selectedTodo else { return }
        
        // TODO: MVVM 기준으로 바뀌어야 할 듯?
        titleLabel.text = todo.title
        memoTextView.text = todo.memo
        priorityLabel.text = "\(todo.priority ?? 0)"
        dueDateLabel.text = todo.dueDate?.formatted()
        
        navigationController?.navigationBar.tintColor = .tint
        navigationController?.navigationBar.topItem?.title = ""
    }

}
