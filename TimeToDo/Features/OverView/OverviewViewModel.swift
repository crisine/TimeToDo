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
    var selectedDate: Date?
    
    // var inputCalendarBarButtonTrigger: Observable<Void?> = Observable(nil)
    
    var inputViewWillAppearTrigger: Observable<Void?> = Observable(nil)
    var inputDidSelectTodoCellTrigger: Observable<Todo?> = Observable(nil)
    var inputDidSelectCalendarCellTrigger: Observable<DateDay?> = Observable(nil)
    
    var inputTodoDoneButtonTrigger: Observable<ObjectId?> = Observable(nil)
    
    var outputDidSelectTodoCell: Observable<Todo?> = Observable(nil)
    
    var outputDateDayList: Observable<[DateDay]?> = Observable(nil)
    var graphPomodoroDataList: [Pomodoro] = []
    var outputTodoList: Observable<[Todo]?> = Observable(nil)
    
    var outputTodoDoneButtonImage: Observable<Void?> = Observable(nil)
    
    
    init() {
        transform()
    }
    
    func transform() {
        inputViewWillAppearTrigger.bind { [weak self] _ in
            self?.fetchTodo()
            self?.fetchGraphPomodoroData()
            self?.calcDateDays()
            
            guard let selectedDate = self?.calcSelectedDate() else { return }
            self?.selectedDate = selectedDate
        }
        
        inputDidSelectTodoCellTrigger.bind { [weak self] todo in
            self?.outputDidSelectTodoCell.value = todo
        }
        
        inputDidSelectCalendarCellTrigger.bind { [weak self] cell in
            guard let cell else { return }
            self?.selectedCalendarCell = cell
            
            guard let selectedDate = self?.calcSelectedDate() else { return }
            self?.selectedDate = selectedDate
            
            self?.fetchGraphPomodoroData()
            
            self?.calcDateDays()
        }
        
        inputTodoDoneButtonTrigger.bind { [weak self] todoId in
            self?.toggleTodoIdCompleted(todoId)
            self?.fetchTodo()
        }
    }

    // TODO: filtering이 필요함. 가령 현재 날짜의 Todo만 보인다던가 등..
    private func fetchTodo() {
        let todoList = Array(repository.fetchTodo())
        outputTodoList.value = (todoList)
    }
    
    private func fetchGraphPomodoroData() {
        // MARK: 1.0 버전 기준에서는 오늘에 해당하는 데이터만 가져오기
        // MARK: 다른 셀을 선택하려고 하면 위의 DateDay 구조체의 내부 값 문제때문에..
        guard let selectedDate = calcSelectedDate() else { return }
        graphPomodoroDataList = Array(repository.fetchCompletedPomodoroListOnSpecificDate(selectedDate))
    }
    
    private func calcSelectedDate() -> Date? {
        if let selectedCalendarCell {
            let selectedDay = selectedCalendarCell.dayNumber
            return combineDate(day: selectedDay, month: getCurrentMonth(), year: getCurrentYear())
        } else {
            return Date()
        }
    }
    
    private func calcDateDays() {
        let calendar = Calendar.current
        var dateDayList: [DateDay] = []
        let currentDate = Date()
        
        if let firstDayOfMonth = Calendar.firstDayOfMonth(currentDate),
           let lastDayOfMonth = Calendar.lastDayOfMonth(currentDate) {
            
            var dateIterator = firstDayOfMonth
            let dateFormatter = DateFormatter()
            
            if Locale.current.identifier == "en_US" {
                dateFormatter.dateFormat = "d EE"
            } else {
                dateFormatter.dateFormat = "dd EE"
            }
            
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
        
        outputDateDayList.value = (dateDayList)
    }
    
    private func combineDate(day: String, month: String, year: String) -> Date? {
        let currentLocale = Locale.current
        let dateFormatter = DateFormatter()
        
        // TODO: 테스트 후 en_US 로 변경
        if currentLocale.identifier == "en_US" {
            dateFormatter.dateFormat = "us_dateformat".localized()
            
            guard let date = dateFormatter.date(from: "\(month) \(day), \(year)") else {
                return nil
            }
            
            return date
        } else {
            dateFormatter.dateFormat = "kr_dateformat".localized()
            
            guard let date = dateFormatter.date(from: "\(year)-\(month)-\(day)") else {
                return nil
            }
            
            return date
        }
    }

    private func getCurrentMonth() -> String {
        let dateFormatter = DateFormatter()
    
        if Locale.current.identifier == "en_US" {
            dateFormatter.dateFormat = "MMMM"
        } else {
            dateFormatter.dateFormat = "MM"
        }
        
        return dateFormatter.string(from: Date())
    }

    private func getCurrentYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: Date())
    }
    
    private func toggleTodoIdCompleted(_ todoId: ObjectId?) {
        guard let todoId else { return }
        repository.updateTodoCompleteStatus(id: todoId)
    }
    
    private func removeAllTodos() {
        repository.removeAllTodos()
    }
}
