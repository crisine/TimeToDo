//
//  TodoSelectViewModel.swift
//  TimeToDo
//
//  Created by Minho on 3/18/24.
//

final class TodoSelectViewModel {
    
    private let repository = Repository()
    
    var fetchedTodoList: [Todo] = []
    
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    
    init() {
        transform()
    }
    
    private func transform() {
        inputViewDidLoadTrigger.bind { [weak self] _ in
            guard let fetchedTodoList = self?.repository.fetchNotCompletedTodo() else { return }
            self?.fetchedTodoList = Array(fetchedTodoList)
        }
    }
}
