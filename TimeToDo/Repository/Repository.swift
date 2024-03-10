//
//  Repository.swift
//  TimeToDo
//
//  Created by Minho on 3/10/24.
//

import RealmSwift

class Repository {

    private let realm = try! Realm()
    
    func fetchTodo() -> Results<Todo> {
        return realm.objects(Todo.self)
    }
    
    func addTodo(_ todo: Todo) {
        do {
            try realm.write {
                realm.add(todo)
            }
        } catch {
            dump(error)
        }
    }
    
    func removeTodo(_ todo: Todo) {
        do {
            try realm.write {
                realm.delete(todo)
            }
        } catch {
            dump(error)
        }
    }
    
    func removeAllTodos() {
        do {
            try realm.write {
                let allTodos = realm.objects(Todo.self)
                allTodos.forEach { todo in
                    todo.isDeleted = true
                }
            }
        } catch {
            dump(error)
        }
    }
}
