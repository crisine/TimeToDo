//
//  OverviewViewModel.swift
//  TimeToDo
//
//  Created by Minho on 3/10/24.
//

import Foundation

class OverviewViewModel {
    
    let repository = Repository()
    
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    var inputProtoTypeAddTodoButtonTrigger: Observable<Void?> = Observable(nil)
    var inputProtoTypeDeleteTodoButtonTrigger: Observable<Void?> = Observable(nil)
    
    var outputTodoList: Observable<[Todo]?> = Observable(nil)
    
    init() {
        
        transform()
    }
    
    func transform() {
        inputViewDidLoadTrigger.bind { [weak self] _ in
            self?.fetchTodo()
        }
        
        inputProtoTypeAddTodoButtonTrigger.bind { [weak self] _ in
            print("버튼 바인딩됨")
            let todo = Todo(title: "apple", createdDate: Date(), modifiedDate: Date())
            self?.repository.addTodo(todo)
            self?.fetchTodo()
        }
        
        inputProtoTypeDeleteTodoButtonTrigger.bind { [weak self] _ in
            self?.removeAllTodos()
            self?.fetchTodo()
        }
    }

    private func fetchTodo() {
        let todoList = Array(repository.fetchTodo().filter { todo in
            todo.isDeleted == false
        })
        outputTodoList.value = todoList
    }
    
    private func removeAllTodos() {
        repository.removeAllTodos()
    }
}
