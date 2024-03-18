//
//  PomoTimerViewModel.swift
//  TimeToDo
//
//  Created by Minho on 3/8/24.
//

import Foundation

final class PomoTimerViewModel {
    
    private let repository = Repository()
    
    private var frame: CGRect?
    private var timer = Timer()
    private var count = 0
    private var startedTime: Date?
    private var isTimerRunning = false
    private let notificationIdentifier = "pomoNotify"
    
    private var selectedTodo: Todo?
    
    var inputViewWillAppearTrigger: Observable<Void?> = Observable(nil)
    var inputSelectTodoButtonTapped: Observable<Todo?> = Observable(nil)
    var inputStartbuttonTapped: Observable<Void?> = Observable(nil)
    var inputResetButtonTapped: Observable<Void?> = Observable(nil)
    
    var outputStartButtonTitleText: Observable<String?> = Observable("start_timer".localized())
    var outputTimerLabelText: Observable<String?> = Observable(nil)
    var outputTodoButtonTitleText: Observable<String?> = Observable(nil)
    
    init() {
        transform()
    }
    
    private func transform() {
        inputViewWillAppearTrigger.bind { [weak self] _ in
            guard let time = self?.secondsToHoursMinutesSeconds(seconds: self?.count ?? 0) else { return }
            self?.outputTimerLabelText.value = self?.makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
            self?.outputTodoButtonTitleText.value = self?.selectedTodo != nil ? self?.selectedTodo?.title : "할 일을 선택하세요"
            Notification.shared.requestNotificationAuthorization()
        }
        
        inputSelectTodoButtonTapped.bind { [weak self] todo in
            guard let todo else { return }
            self?.selectedTodo = todo
            
            /*
             이제 여기서 해야 하는 것
             1. todo 에 적혀있는 estimated time을 기준으로 timestring을 만들어준다.
             2. 뷰모델에서 들고 있는 count값을 estimated time * 60 만큼 설정해준다. (그리고 되도록이면 count 이름도 변경하자. pomoSecondsLeft 라든지.)
             3. 그 값이 다 떨어지면 repository 이용해서 todo에 pomodoro 값 달아준다.
                [주의할 점]
                a. 타이머가 가는 동안에는 작업을 선택할 수 없도록 버튼을 disable 해 둔다.
             */
            
            guard let estimatedPomodoroMinutes = todo.estimatedPomodoroMinutes else { return }
            self?.count = estimatedPomodoroMinutes * 60
            
            self?.outputTimerLabelText.value = self?.makeTimeString(hours: 0, minutes: estimatedPomodoroMinutes, seconds: 0)
            self?.outputTodoButtonTitleText.value = (todo.title)
        }
        
        inputStartbuttonTapped.bind { [weak self] _ in
            self?.startButtonTapped()
        }
        
        inputResetButtonTapped.bind { [weak self] _ in
            self?.resetButtonTapped()
        }
    }
    
    private func startButtonTapped() {
        guard selectedTodo != nil else { return }
        
        if isTimerRunning {
            isTimerRunning = false
            timer.invalidate()
            outputStartButtonTitleText.value = "resume_timer".localized()
            Notification.shared.removeNotification(notificationIdentifiers: [notificationIdentifier])
        } else {
            startedTime = startedTime == nil ? Date() : nil
            isTimerRunning = true
            outputStartButtonTitleText.value = "pause_timer".localized()
            makeNewTimer()
            Notification.shared.sendNotification(seconds: Double(count), notificationIdentifier: notificationIdentifier)
        }
    }
    
    private func resetButtonTapped() {
        guard let selectedTodo else { return }
        
        timer.invalidate()
        isTimerRunning = false
        startedTime = nil
        
        guard let estimatedPomodoroMinutes = selectedTodo.estimatedPomodoroMinutes else { return }
        count = estimatedPomodoroMinutes * 60
        
        let time = secondsToHoursMinutesSeconds(seconds: count)
        outputTimerLabelText.value = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        outputStartButtonTitleText.value = "start_timer".localized()
        Notification.shared.removeNotification(notificationIdentifiers: [notificationIdentifier])
    }
    
    private func makeNewTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
    }
    
    @objc private func timerCounter() {
        
        if count - 1 >= 0 {
            count = count - 1
        } else {
            // MARK: 타이머가 다 된 경우
            // MARK: 1.0 버전 기준에서는 초기화를 누르는 경우의 시간을 적립하지 않는 것으로 정의한다.
            guard let selectedTodo, 
                  let estimatedPomodoroMinutes = selectedTodo.estimatedPomodoroMinutes,
                  let startedTime else { 
                
                print("선택된 todo가 없거나, startedTime이 없습니다. \(selectedTodo), \(startedTime)")
                return }
            
            let pomodoro = Pomodoro(todoId: selectedTodo.id, elapsedMinutes: estimatedPomodoroMinutes, startedTime: startedTime, endedTime: Date())
            
            repository.addPomodoro(pomodoro)
            
            
            count = estimatedPomodoroMinutes * 60
            self.startedTime = nil
            isTimerRunning = false
            timer.invalidate()
            outputStartButtonTitleText.value = "start_timer".localized()
        }
        
        let time = secondsToHoursMinutesSeconds(seconds: count)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        outputTimerLabelText.value = timeString
    }
    
    private func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        return ((seconds / 3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60))
    }
    
    private func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += " : "
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
    }
}
