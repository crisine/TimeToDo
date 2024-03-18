//
//  DetailTodoViewModel.swift
//  TimeToDo
//
//  Created by Minho on 3/11/24.
//

import Foundation

class DetailTodoViewModel {
  
    private let repository = Repository()
    
    var selectedTodo: Todo?
    
    var inputViewWillAppearTrigger: Observable<Void?> = Observable(nil)
    
    var outputViewWillAppearTrigger: Observable<[PomodoroStat]?> = Observable(nil)
    
    init() {
        inputViewWillAppearTrigger.bind { [weak self] _ in
            self?.fetchPomodoroStat()
        }
    }
    
    private func fetchPomodoroStat() {
        guard let selectedTodo else { return }

        let pomodoroInAllTime = Array(repository.fetchPomodoro(todoId: selectedTodo.id))

        let currentCalendar = Calendar.current
        
        let pomodoroInToday = pomodoroInAllTime.filter { currentCalendar.isDateInToday($0.endedTime) }
        let pomodoroStatInToday = PomodoroStat(totalPomodoroCount: pomodoroInToday.count, totalPomodoroMinutes: pomodoroInToday.reduce(0, { partialResult, pomodoro in
            partialResult + pomodoro.elapsedMinutes
        }))
        
        let pomodoroInWeek = pomodoroInAllTime.filter { isInCurrentWeek(date: $0.endedTime) }
        let pomodoroStatInWeek = PomodoroStat(totalPomodoroCount: pomodoroInWeek.count, totalPomodoroMinutes: pomodoroInWeek.reduce(0, { partialResult, pomodoro in
            partialResult + pomodoro.elapsedMinutes
        }))
        
        let pomodoroStatInAllTime = PomodoroStat(totalPomodoroCount: pomodoroInAllTime.count, totalPomodoroMinutes: pomodoroInAllTime.reduce(0, { partialResult, pomodoro in
            partialResult + pomodoro.elapsedMinutes
        }))
        
        let pomodoroStatArray: [PomodoroStat] = [pomodoroStatInToday, pomodoroStatInWeek, pomodoroStatInAllTime]
        
        guard !pomodoroStatArray.isEmpty else { return }
        outputViewWillAppearTrigger.value = (pomodoroStatArray)
    }
    
    
    private func isInCurrentWeek(date: Date) -> Bool {
        let calendar = Calendar.current
        let currentDate = Date()
        
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)) else {
            return false
        }
        
        guard let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek) else {
            return false
        }
        
        guard let selectedDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)) else {
            return false
        }
        
        let result = selectedDate >= startOfWeek && selectedDate <= endOfWeek
        return result
    }
}
