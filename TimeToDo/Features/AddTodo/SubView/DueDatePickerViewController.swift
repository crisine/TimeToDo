//
//  DueDatePickerViewController.swift
//  TimeToDo
//
//  Created by Minho on 3/14/24.
//

import UIKit
import FSCalendar

class DueDatePickerViewController: ModalViewController {
    
    let calendarView = FSCalendar()
    
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
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        
    }
}
