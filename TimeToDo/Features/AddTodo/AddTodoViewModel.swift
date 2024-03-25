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
    
    var modifyTodo: Todo?
    
    var todoTitleString: String?
    var todoMemoString: String?
    var todoDueDate: Date?
    var pomodoroMinutes: Int?
    
    var isAddTodoTextFieldEdited: Bool {
        return addTodoTextFieldEdited
    }
    
    var inputViewWillAppearTrigger: Observable<Void?> = Observable(nil)
    
    var inputTodoTitle: Observable<String?> = Observable(nil)
    var inputTodoMemo: Observable<String?> = Observable(nil)
    var inputTextViewDidBeginEditTrigger: Observable<Void?> = Observable(nil)
    var inputTextViewDidEndEditTrigger: Observable<String?> = Observable(nil)
    var inputPomoTime: Observable<Int?> = Observable(nil)
    var inputDueDate: Observable<Date?> = Observable(nil)
    var inputDoneButtonTrigger: Observable<Void?> = Observable(nil)
    
    var outputTodoTitle: Observable<String?> = Observable(nil)
    var outputTodoMemo: Observable<String?> = Observable(nil)
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
            
            if let modifyTodo = self?.modifyTodo {
                
                let modifiedTodo = Todo(title: todoTitleString, memo: self?.todoMemoString, dueDate: self?.todoDueDate, estimatedPomodoroMinutes: self?.pomodoroMinutes)
                
                self?.modifyTodo(todo: modifyTodo, modifiedTodo: modifiedTodo)
                return
                
            } else {
                let todo = Todo(title: todoTitleString, memo: self?.todoMemoString, dueDate: self?.todoDueDate, estimatedPomodoroMinutes: self?.pomodoroMinutes)
                
                self?.addTodo(todo: todo)
            }
        }
        
        inputViewWillAppearTrigger.bind { [weak self] _ in
            self?.fillItems()
        }
    }
    
    private func fillItems() {
        guard let modifyTodo else { return }
        todoTitleString = modifyTodo.title
        outputTodoTitle.value = todoTitleString
        
        todoMemoString = modifyTodo.memo
        if let memo = modifyTodo.memo {
            self.addTodoTextFieldEdited = true
            outputTodoMemo.value = memo
        }
        
        todoDueDate = modifyTodo.dueDate
        if let dueDate = modifyTodo.dueDate {
            outputDueDate.value = dueDate.toString
        }
    
        pomodoroMinutes = modifyTodo.estimatedPomodoroMinutes
        if let estimatedPomodoroMinutes = modifyTodo.estimatedPomodoroMinutes {
            outputPomoTime.value = String(estimatedPomodoroMinutes)
        }
            
    }
    
    private func addTodo(todo: Todo) {
        repository.addTodo(todo)
    }
    
    private func modifyTodo(todo: Todo, modifiedTodo: Todo) {
        repository.updateTodo(todo: todo, modifiedTodo: modifiedTodo)
    }
}
