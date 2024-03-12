//
//  OverviewViewModel.swift
//  TimeToDo
//
//  Created by Minho on 3/10/24.
//

import Foundation

class OverviewViewModel {
    
    let repository = Repository()
    
    var inputNavigationBarCalendarButtonTrigger: Observable<Void?> = Observable(nil)
    
    var inputViewWillAppearTrigger: Observable<Void?> = Observable(nil)
    var inputProtoTypeAddTodoButtonTrigger: Observable<Void?> = Observable(nil)
    var inputProtoTypeDeleteTodoButtonTrigger: Observable<Void?> = Observable(nil)
    var inputDidSelectItemAtTrigger: Observable<Todo?> = Observable(nil)
    
    
    var outputDidSelectItemAt: Observable<Todo?> = Observable(nil)
    
    var outputTodoList: Observable<[Todo]?> = Observable(nil)
    
    init() {
        
        transform()
    }
    
    func transform() {
        
        inputNavigationBarCalendarButtonTrigger.bind { [weak self] _ in
            print("DEBUG: 아직은 별다른 처리 안 하는 중이긴 한데, output 값을 통해서 뷰에다가 캘린더를 띄워줘야 함.")
        }
        
        inputViewWillAppearTrigger.bind { [weak self] _ in
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
        
        inputDidSelectItemAtTrigger.bind { [weak self] todo in
            self?.outputDidSelectItemAt.value = todo
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
