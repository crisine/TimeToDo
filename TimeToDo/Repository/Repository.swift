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
        print(realm.configuration.fileURL)
        return realm.objects(Todo.self)
    }
    
    func fetchTodo(id: ObjectId) -> Results<Todo> {
        return realm.objects(Todo.self).where { todo in
            todo.id == id
        }
    }
    
    func fetchPomodoro(todoId: ObjectId) -> Results<Pomodoro> {
        return realm.objects(Pomodoro.self).where { pomodoro in
            pomodoro.todoId == todoId
        }
    }
    
    func fetchNotCompletedPomodoroTodo() -> Results<Todo> {
        return realm.objects(Todo.self).where { todo in
            todo.isCompleted == false &&
            todo.estimatedPomodoroMinutes != nil
        }
    }
    
    func fetchCompletedPomodoroListOnSpecificDate(_ date: Date) -> Results<Pomodoro> {
        return realm.objects(Pomodoro.self).where { pomodoro in
            let calendar = Calendar.current
            let start = calendar.startOfDay(for: date)
            let end = calendar.date(byAdding: DateComponents(day: 1), to: start)!
            
            return pomodoro.startedTime >= start && pomodoro.endedTime <= end
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
