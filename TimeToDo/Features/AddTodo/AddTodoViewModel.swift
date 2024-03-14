//
//  AddTodoViewModel.swift
//  TimeToDo
//
//  Created by Minho on 3/10/24.
//

import Foundation

class AddTodoViewModel {
    
    private let repository = Repository()
    
    private let pomodoroNumbers = (1...100).map { "\(String($0))회" }
    private let pomodoroTimes = (1...1440).map { "\(String($0))분" }
    
    private var addTodoTextFieldEdited = false
    
    var isAddTodoTextFieldEdited: Bool {
        return addTodoTextFieldEdited
    }
    
    var pickerViewComponetTitleList: [[String]] {
        return [pomodoroNumbers, pomodoroTimes]
    }
    
    var inputDoneButtonTrigger: Observable<Todo?> = Observable(nil)
    var inputTextViewDidBeginEditTrigger: Observable<Void?> = Observable(nil)
    
    init() {
        inputDoneButtonTrigger.bind { [weak self] todo in
            guard let todo else { return }
            self?.addTodo(todo: todo)
        }
        
        inputTextViewDidBeginEditTrigger.bind { [weak self] _ in
            self?.addTodoTextFieldEdited.toggle()
        }
    }
    
    func numberOfRowsInComponent(_ component: Int) -> Int {
        if component == 0 {
            return pomodoroNumbers.count
        } else {
            return pomodoroTimes.count
        }
    }
    
    func titleForRow(_ component: Int, rowNumber: Int) -> String {
        if component == 0 {
            return pomodoroNumbers[rowNumber]
        } else {
            return pomodoroTimes[rowNumber]
        }
    }
    
    private func addTodo(todo: Todo) {
        repository.addTodo(todo)
    }
}
