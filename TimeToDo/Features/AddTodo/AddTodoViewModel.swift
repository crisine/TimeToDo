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
    
    var todoTitleString: String?
    var todoMemoString: String?
    var dueDate: Date?
    var pomodoroMinutes: Int?
    
    var isAddTodoTextFieldEdited: Bool {
        return addTodoTextFieldEdited
    }
    
    var pickerViewComponetTitleList: [[String]] {
        return [pomodoroNumbers, pomodoroTimes]
    }
    
    var inputTodoTitle: Observable<String?> = Observable(nil)
    var inputTodoMemo: Observable<String?> = Observable(nil)
    var inputDoneButtonTrigger: Observable<Todo?> = Observable(nil)
    var inputTextViewDidBeginEditTrigger: Observable<Void?> = Observable(nil)
    var inputPomoTime: Observable<Int?> = Observable(nil)
    var inputDueDate: Observable<Date?> = Observable(nil)
    
    var outputPomoTime: Observable<String?> = Observable(nil)
    var outputDueDate: Observable<String?> = Observable(nil)
    
    init() {
        inputTodoTitle.bind { [weak self] todoTitle in
            guard let todoTitle else { return }
            self?.todoTitleString = todoTitle
        }
        
        inputTodoMemo.bind { [weak self] todoMemo in
            guard let todoMemo else { return }
            self?.todoMemoString = todoMemo
        }
        
        inputDoneButtonTrigger.bind { [weak self] todo in
            guard let todo else { return }
            self?.addTodo(todo: todo)
        }
        
        inputTextViewDidBeginEditTrigger.bind { [weak self] _ in
            self?.addTodoTextFieldEdited.toggle()
        }
        
        inputPomoTime.bind { [weak self] minutes in
            guard let minutes else { return }
            self?.outputPomoTime.value = (String(minutes))
        }
        
        inputDueDate.bind { [weak self] dueDate in
            guard let dueDate else { return }
            self?.outputDueDate.value = (self?.dateToFormattedDateString(date: dueDate))
        }
    }
    
    private func addTodo(todo: Todo) {
        repository.addTodo(todo)
    }
    
    private func dateToFormattedDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd EE"
        return dateFormatter.string(from: date)
    }
}
