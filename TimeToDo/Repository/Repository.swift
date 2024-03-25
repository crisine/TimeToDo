//
//  Repository.swift
//  TimeToDo
//
//  Created by Minho on 3/10/24.
//

import RealmSwift
import Foundation

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

    func addPomodoro(_ pomodoro: Pomodoro) {
        do {
            try realm.write {
                realm.add(pomodoro)
            }
        } catch {
            dump(error)
        }
    }
    
    // MARK: Read
    func fetchTodo() -> Results<Todo> {
        print(realm.configuration.fileURL ?? "no url")
        return realm.objects(Todo.self).where{ $0.isDeleted == false }
    }
    
    func fetchTodo(id: ObjectId) -> Results<Todo> {
        return realm.objects(Todo.self).where { todo in
            todo.id == id
        }
    }
    
    func fetchPomodoro(todoId: ObjectId) -> Results<Pomodoro> {
        return realm.objects(Pomodoro.self).where { pomodoro in
            pomodoro.todoId == todoId &&
            pomodoro.isDeleted == false
        }
    }
    
    func fetchNotCompletedPomodoroTodo() -> Results<Todo> {
        return realm.objects(Todo.self).where { todo in
            todo.isDeleted == false &&
            todo.isCompleted == false &&
            todo.estimatedPomodoroMinutes != nil
        }
    }
    
    func fetchCompletedPomodoroListOnSpecificDate(_ date: Date) -> Results<Pomodoro> {
        return realm.objects(Pomodoro.self).where { pomodoro in
            let calendar = Calendar.current
            let start = calendar.startOfDay(for: date)
            let end = calendar.date(byAdding: DateComponents(day: 1), to: start)!
            
            return pomodoro.startedTime >= start && pomodoro.endedTime <= end && pomodoro.isDeleted == false
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
    
    func updateTodo(todo: Todo, modifiedTodo: Todo) {
        do {
            try realm.write {
                
                todo.title = modifiedTodo.title
                todo.memo = modifiedTodo.memo
                todo.dueDate = modifiedTodo.dueDate
                todo.estimatedPomodoroMinutes = modifiedTodo.estimatedPomodoroMinutes
                todo.modifiedDate = Date()
                
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
                todo.isDeleted = true
            }
            removePomodoro(todoId: todo.id)
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
    
    func removePomodoro(todoId: ObjectId) {
        do {
            try realm.write {
                realm.objects(Pomodoro.self).where { pomo in
                    pomo.todoId == todoId
                }.forEach { pomo in
                    pomo.isDeleted = true
                }
            }
        } catch {
            dump(error)
        }
    }
}
