//
//  DueDatePickerViewController.swift
//  TimeToDo
//
//  Created by Minho on 3/14/24.
//

import UIKit
import FSCalendar

protocol SendDueDate {
    func sendDueDate(date: Date)
}

class DueDatePickerViewController: BaseViewController {
    
    private let calendarView: FSCalendar = {
        
    let view = FSCalendar()
    view.appearance.selectionColor = .tint
    view.appearance.weekdayFont = .boldSystemFont(ofSize: 18)
    view.appearance.weekdayTextColor = .tint
    view.appearance.headerTitleColor = .tint
    view.appearance.headerTitleFont = .boldSystemFont(ofSize: 24)
    view.appearance.titleDefaultColor = .text
    return view
}()
    private lazy var cancelBarButton: UIBarButtonItem = {
        let view = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didCancelBarButtonTapped))
        view.tintColor = .systemRed
        return view
    }()
    private lazy var doneBarButton: UIBarButtonItem = {
        let view = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didDoneBarButtonTapped))
        view.isEnabled = false
        view.tintColor = .tint
        return view
    }()
    
    var delegate: SendDueDate?
    private var selectedDueDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.delegate = self
    }
    
    override func configureHierarchy() {
        [calendarView].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        calendarView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
    }
    
    override func configureView() {
        navigationItem.setLeftBarButton(cancelBarButton, animated: true)
        navigationItem.setRightBarButton(doneBarButton, animated: true)
        
        if let selectedDueDate {
            calendarView.select(selectedDueDate)
        }
    }
}

extension DueDatePickerViewController {
    @objc private func didCancelBarButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func didDoneBarButtonTapped() {
        guard let selectedDueDate else { return }
        delegate?.sendDueDate(date: selectedDueDate)
        dismiss(animated: true)
    }
}

extension DueDatePickerViewController: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDueDate = date
        doneBarButton.isEnabled = true
    }
}

// MARK: Date 값 전달 관련
extension DueDatePickerViewController: SendDueDate {
    func sendDueDate(date: Date) {
        selectedDueDate = date
    }
}
