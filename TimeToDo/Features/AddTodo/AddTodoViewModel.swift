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
    var todoDueDate: Date?
    var pomodoroMinutes: Int?
    
    var isAddTodoTextFieldEdited: Bool {
        return addTodoTextFieldEdited
    }
    
    var pickerViewComponetTitleList: [[String]] {
        return [pomodoroNumbers, pomodoroTimes]
    }
    
    var inputTodoTitle: Observable<String?> = Observable(nil)
    var inputTodoMemo: Observable<String?> = Observable(nil)
    var inputTextViewDidBeginEditTrigger: Observable<Void?> = Observable(nil)
    var inputTextViewDidEndEditTrigger: Observable<String?> = Observable(nil)
    var inputPomoTime: Observable<Int?> = Observable(nil)
    var inputDueDate: Observable<Date?> = Observable(nil)
    var inputDoneButtonTrigger: Observable<Void?> = Observable(nil)
    
    var outputPomoTime: Observable<String?> = Observable(nil)
    var outputDueDate: Observable<String?> = Observable(nil)
    
    init() {
        inputTodoTitle.bind { [weak self] todoTitle in
            guard let todoTitle else { return }
            self?.todoTitleString = todoTitle
        }
        
        inputTextViewDidBeginEditTrigger.bind { [weak self] _ in
            self?.addTodoTextFieldEdited.toggle()
        }
        
        inputTextViewDidEndEditTrigger.bind { [weak self] memoString in
            self?.todoMemoString = memoString
        }
        
        inputPomoTime.bind { [weak self] minutes in
            guard let minutes else { return }
            self?.pomodoroMinutes = minutes
            self?.outputPomoTime.value = (String(minutes))
        }
        
        inputDueDate.bind { [weak self] dueDate in
            guard let dueDate else { return }
            self?.todoDueDate = dueDate
            self?.outputDueDate.value = (dueDate.toString)
        }
        
        inputDoneButtonTrigger.bind { [weak self] _ in
            
            guard let todoTitleString = self?.todoTitleString else { return }
            
            let todo = Todo(title: todoTitleString, memo: self?.todoMemoString, dueDate: self?.todoDueDate, estimatedPomodoroMinutes: self?.pomodoroMinutes)
            self?.addTodo(todo: todo)
        }
    }
    
    private func addTodo(todo: Todo) {
        repository.addTodo(todo)
    }
}
