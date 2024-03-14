//
//  AddTodoViewController.swift
//  TimeToDo
//
//  Created by Minho on 3/7/24.
//

import UIKit

final class AddTodoViewController: BaseViewController {
    
    private let titleTextField: UITextField = {
        let view = UITextField()
        
        view.placeholder = "todo_title_placeholder".localized()
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: view.frame.height))
        view.leftView = paddingView
        view.leftViewMode = .always
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        
        view.backgroundColor = .systemGray6
        
        view.font = .systemFont(ofSize: 14)
        
        return view
    }()
    private let memoTextView: UITextView = {
        let view = UITextView()
        
        view.textContainerInset = UIEdgeInsets(top: 6, left: 2, bottom: 6, right: 2)
        view.text = "todo_memo_placeholder".localized()
        view.textColor = .systemGray3
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        
        view.backgroundColor = .systemGray6
        
        view.font = .systemFont(ofSize: 14)
        
        return view
    }()
    private let pomoPickerButton: UIButton = {
        let view = UIButton(configuration: .filled())
        view.setImage(UIImage(systemName: "alarm"), for: .normal)
        view.tintColor = .systemRed
        return view
    }()
    private let dueDatePickerButton: UIButton = {
        let view = UIButton(configuration: .filled())
        
        view.setImage(UIImage(systemName: "calendar.badge.clock"), for: .normal)
        view.tintColor = .tint
        
        return view
    }()
    
    private let viewModel = AddTodoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memoTextView.delegate = self
    }
    
    override func configureHierarchy() {
        [titleTextField, memoTextView, pomoPickerButton, dueDatePickerButton].forEach { subview in
            view.addSubview(subview)
        }
    }
    
    override func configureConstraints() {
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(32)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(120)
        }
        
        dueDatePickerButton.snp.makeConstraints { make in
            make.top.equalTo(memoTextView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(32)
        }
        
        pomoPickerButton.snp.makeConstraints { make in
            make.top.equalTo(dueDatePickerButton.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(32)
        }
        
    }
    
    override func configureView() {
        navigationItem.title = "새로운 할 일 추가"
        
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didDoneButtonTapped))
        doneButton.tintColor = .tint
        
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didCancelButtonTapped))
        cancelButton.tintColor = .systemRed
        
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = cancelButton
        
        dueDatePickerButton.addTarget(self, action: #selector(didDueDatePickerButtonTapped), for: .touchUpInside)
    }
    
}

// MARK: 버튼 이벤트 관련
extension AddTodoViewController {
    
    @objc private func didDoneButtonTapped() {
        guard let title = titleTextField.text else { return }
        
        if title == "" {
            showToast(message: "제목은 필수 입력 사항입니다.")
            return
        }
        
        let todo = Todo(title: title, memo: memoTextView.text, createdDate: Date(), modifiedDate: Date())
        
        viewModel.inputDoneButtonTrigger.value = todo
        
        navigationController?.dismiss(animated: true)
    }
    
    @objc private func didCancelButtonTapped() {
        navigationController?.dismiss(animated: true)
    }
    
    @objc private func didDueDatePickerButtonTapped() {
        let nav = UINavigationController(rootViewController: DueDatePickerViewController())
        present(nav, animated: true)
    }
}

// MARK: PickerView Delegate 관련
extension AddTodoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return viewModel.numberOfRowsInComponent(component)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return viewModel.titleForRow(component, rowNumber: row)
    }
}

// MARK: TextView Delegate 관련
extension AddTodoViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "todo_memo_placeholder".localized() &&
            !viewModel.isAddTodoTextFieldEdited {
            textView.text = nil
            textView.textColor = .text
            viewModel.inputTextViewDidBeginEditTrigger.value = ()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "todo_memo_placeholder".localized()
            textView.textColor = .systemGray3
            viewModel.inputTextViewDidBeginEditTrigger.value = ()
        }
    }
}
