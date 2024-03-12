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
    var outputDateDayList: Observable<[DateDay]?> = Observable(nil)
    
    init() {
        
        transform()
    }
    
    func transform() {
        
        inputNavigationBarCalendarButtonTrigger.bind { [weak self] _ in
            print("DEBUG: 아직은 별다른 처리 안 하는 중이긴 한데, output 값을 통해서 뷰에다가 캘린더를 띄워줘야 함.")
        }
        
        inputViewWillAppearTrigger.bind { [weak self] _ in
            // self?.fetchTodo()
            self?.calcDateDays()
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
//        outputTodoList.value = todoList
    }
    
    private func calcDateDays() {
        let calendar = Calendar.current
        var dateDayList: [DateDay] = []
        let currentDate = Date()
        
        if let firstDayOfMonth = Calendar.firstDayOfMonth(currentDate),
           let lastDayOfMonth = Calendar.lastDayOfMonth(currentDate) {
            
            var dateIterator = firstDayOfMonth
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd EE"
            
            while dateIterator <= lastDayOfMonth {
            
                let separatedDateString = dateFormatter.string(from: dateIterator).split(separator: " ").map { String($0) }
                
                print(separatedDateString)
                
                dateDayList.append(DateDay(dayNumber: separatedDateString[0], weekday: separatedDateString[1]))
                
                guard let nextDateIterator = calendar.date(byAdding: .day, value: 1, to: dateIterator) else { return }
                
                dateIterator = nextDateIterator
            }
        }
        
        print(dateDayList)
        
        outputDateDayList.value = dateDayList
    }
    
    private func removeAllTodos() {
        repository.removeAllTodos()
    }
}
