//
//  Repository.swift
//  TimeToDo
//
//  Created by Minho on 3/10/24.
//

import RealmSwift

class Repository {

    private let realm = try! Realm()
    
    // MARK: Create
    func addTodo(_ todo: Todo) {
        do {
            try realm.write {
                realm.add(todo)
            }
        } catch {
            dump(error)
        }
    }

    
    // MARK: Read
    func fetchTodo() -> Results<Todo> {
        return realm.objects(Todo.self)
    }
    
    func fetchTodo(id: ObjectId) -> Results<Todo> {
        return realm.objects(Todo.self).where { todo in
            todo.id == id
        }
    }
    
    
    // MARK: Update
    func updateTodoCompleteStatus(id: ObjectId) {
        do {
            let todo = fetchTodo(id: id).first
            try realm.write {
                todo?.isCompleted?.toggle()
            }
        } catch {
            dump(error)
        }
    }
    
    func updateTodo(_ todo: Todo) {
        do {
            try realm.write {
                realm.add(todo, update: .modified)
            }
        } catch {
            dump(error)
        }
    }
    
    
    // MARK: Delete
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
