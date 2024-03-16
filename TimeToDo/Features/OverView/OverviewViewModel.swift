//
//  OverviewViewModel.swift
//  TimeToDo
//
//  Created by Minho on 3/10/24.
//

import Foundation
import RealmSwift

class OverviewViewModel {
    
    private let repository = Repository()
    
    var todayDayInt: Int = Date().dayToInt
    var selectedCalendarCell: DateDay?
    
    var inputCalendarBarButtonTrigger: Observable<Void?> = Observable(nil)
    
    var inputViewWillAppearTrigger: Observable<Void?> = Observable(nil)
    var inputDidSelectItemAtTrigger: Observable<Todo?> = Observable(nil)
    var inputDidSelectCalendarCellTrigger: Observable<DateDay?> = Observable(nil)
    
    var inputTodoDoneButtonTrigger: Observable<ObjectId?> = Observable(nil)
    
    var outputDidSelectItemAt: Observable<Todo?> = Observable(nil)
    var outputDateDayList: Observable<[DateDay]?> = Observable(nil)
    var outputTodoList: Observable<[Todo]?> = Observable(nil)
    
    var outputTodoDoneButtonImage: Observable<Void?> = Observable(nil)
    
    
    init() {
        transform()
    }
    
    func transform() {
        
//        inputCalendarBarButtonTrigger.bind { [weak self] _ in
//            
//        }
        
        inputViewWillAppearTrigger.bind { [weak self] _ in
            self?.fetchTodo()
            self?.calcDateDays()
        }
        
        inputDidSelectItemAtTrigger.bind { [weak self] todo in
            self?.outputDidSelectItemAt.value = todo
            self?.calcDateDays()
        }
        
        inputDidSelectCalendarCellTrigger.bind { [weak self] cell in
            guard let cell else { return }
            self?.selectedCalendarCell = cell
            self?.calcDateDays()
        }
        
        inputTodoDoneButtonTrigger.bind { [weak self] todoId in
            self?.toggleTodoIdCompleted(todoId)
            self?.fetchTodo()
        }
    }

    // TODO: filtering이 필요함. 가령 현재 날짜의 Todo만 보인다던가 등..
    private func fetchTodo() {
        let todoList = Array(repository.fetchTodo().filter { todo in
            todo.isDeleted == false
        })
        print("fetchTodo: \(todoList)")
        outputTodoList.value = todoList
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
                
                let todayString = dateFormatter.string(from: Date()).split(separator: " ").map { String($0) }[0]
                let isToday = separatedDateString[0] == todayString ? true : false
                var isSelected: Bool
                
                if let selectedCalendarCell {
                    isSelected = selectedCalendarCell.dayNumber == separatedDateString[0] ? true : false
                } else {
                    isSelected = isToday == true ? true : false
                }
                
                dateDayList.append(DateDay(dayNumber: separatedDateString[0], weekday: separatedDateString[1], isToday: isToday, isSelected: isSelected))
                
                guard let nextDateIterator = calendar.date(byAdding: .day, value: 1, to: dateIterator) else { return }
                
                dateIterator = nextDateIterator
            }
        }
        
        outputDateDayList.value = dateDayList
    }
    
    private func toggleTodoIdCompleted(_ todoId: ObjectId?) {
        guard let todoId else { return }
        print("toggling todo")
        repository.updateTodoCompleteStatus(id: todoId)
    }
    
    private func removeAllTodos() {
        repository.removeAllTodos()
    }
}
