//
//  DueDatePickerViewController.swift
//  TimeToDo
//
//  Created by Minho on 3/14/24.
//

import UIKit
import FSCalendar

class DueDatePickerViewController: BaseViewController {
    
    let calendarView: FSCalendar = {
        let view = FSCalendar()
        view.appearance.selectionColor = .tint
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
    }
}
