//
//  PomoTimerViewModel.swift
//  TimeToDo
//
//  Created by Minho on 3/8/24.
//

import Foundation

final class PomoTimerViewModel {
    
    private let repository = Repository()
    
    private var circularViewProgressValue = 1.0
    private var timer = Timer()
    private var pomodoroSeconds = 0
    private var startedTime: Date?
    private var isTimerRunning = false
    private let notificationIdentifier = "pomoNotify"
    var pomodoroHasStarted: Bool?
    
    private var dateBeforeSceneResigned: Date?
    
    private var selectedTodo: Todo?
    
    var inputViewWillAppearTrigger: Observable<Void?> = Observable(nil)
    var inputSelectTodoButtonTapped: Observable<Todo?> = Observable(nil)
    var inputStartbuttonTapped: Observable<Void?> = Observable(nil)
    var inputResetButtonTapped: Observable<Void?> = Observable(nil)
    
    var outputTimerIsRunning: Observable<Bool?> = Observable(nil)
    var outputStartButtonTitleText: Observable<String?> = Observable("start_timer".localized())
    var outputTimerLabelText: Observable<String?> = Observable(nil)
    var outputTodoButtonTitleText: Observable<String?> = Observable(nil)
    var outputCircularProgress: Observable<Double?> = Observable(nil)
    var outputTodoIsntSelectedMessage: Observable<String?> = Observable(nil)
    
    init() {
        transform()
        sceneDelegateNotification()
    }
    
    private func transform() {
        inputViewWillAppearTrigger.bind { [weak self] _ in
            guard let time = self?.secondsToHoursMinutesSeconds(seconds: self?.pomodoroSeconds ?? 0) else { return }
            self?.outputTimerLabelText.value = self?.makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
            self?.outputTodoButtonTitleText.value = self?.selectedTodo != nil ? self?.selectedTodo?.title : "choose_task_to_do".localized()
            
            guard let selectedTodo = self?.selectedTodo else { return }
            if self?.repository.fetchTodo(id: selectedTodo.id).first?.isCompleted == true {
                self?.resetButtonTapped()
                self?.selectedTodo = nil
            }
        }
        
        inputSelectTodoButtonTapped.bind { [weak self] todo in
            guard let todo else { return }
            self?.selectedTodo = todo
            
            guard let estimatedPomodoroMinutes = todo.estimatedPomodoroMinutes else { return }
            self?.pomodoroSeconds = estimatedPomodoroMinutes * 60
            
            let hours = estimatedPomodoroMinutes / 60
            
            self?.outputTimerLabelText.value = self?.makeTimeString(hours: hours, minutes: estimatedPomodoroMinutes % 60, seconds: 0)
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
        Notification.shared.requestNotificationAuthorization()
        
        guard let selectedTodo else {
            return outputTodoIsntSelectedMessage.value = ("please_choose_task_to_do".localized())
        }
        
        if startedTime == nil {
            startedTime = Date()
            pomodoroHasStarted = true
        }
        
        if isTimerRunning {
            pauseTimer()
        } else {
            runTimer()
        }
    }
    
    private func runTimer() {
        isTimerRunning = true
        outputStartButtonTitleText.value = "pause_timer".localized()
        
        makeNewTimer()
        registerPomodoroNotification()
        outputTimerIsRunning.value = (true)
    }
    
    private func pauseTimer() {
        isTimerRunning = false
        timer.invalidate()
        outputStartButtonTitleText.value = "resume_timer".localized()
        removePomodoroNotification()
        outputTimerIsRunning.value = (false)
    }
    
    private func registerPomodoroNotification() {
        guard let selectedTodo else {
            return outputTodoIsntSelectedMessage.value = ("please_choose_task_to_do".localized())
        }
        
        Notification.shared.sendNotification(title: selectedTodo.title, body: "pomodoro_timer_ended".localized(), seconds: Double(pomodoroSeconds), notificationIdentifier: notificationIdentifier)
    }
    
    private func removePomodoroNotification() {
        Notification.shared.removeNotification(notificationIdentifiers: [notificationIdentifier])
    }
    
    private func resetButtonTapped() {
        resetPomodoroStatus()
        resetTimer()
        removePomodoroNotification()
        outputTimerIsRunning.value = (false)
    }
    
    private func makeNewTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
    }
    
    private func resetTimer() {
        guard let selectedTodo else { return }
        guard let estimatedPomodoroMinutes = selectedTodo.estimatedPomodoroMinutes else { return }
        pomodoroSeconds = estimatedPomodoroMinutes * 60
        
        let time = secondsToHoursMinutesSeconds(seconds: pomodoroSeconds)
        outputTimerLabelText.value = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        outputStartButtonTitleText.value = "start_timer".localized()
    }
    
    private func resetPomodoroStatus() {
        timer.invalidate()
        isTimerRunning = false
        startedTime = nil
        circularViewProgressValue = 0
        outputCircularProgress.value = (circularViewProgressValue)
        outputTimerIsRunning.value = isTimerRunning
        pomodoroHasStarted = false
    }
    
    @objc private func timerCounter() {
        guard let estimatedPomodoroMinutes = selectedTodo?.estimatedPomodoroMinutes else { return }
        
        if pomodoroSeconds - 1 >= 0 {
            pomodoroSeconds = pomodoroSeconds - 1
            circularViewProgressValue = 1.0 - (Double(pomodoroSeconds) / Double(estimatedPomodoroMinutes * 60))
            outputCircularProgress.value = (circularViewProgressValue)
        } else {
            // MARK: 타이머가 다 된 경우
            // MARK: 1.0 버전 기준에서는 초기화를 누르는 경우의 시간을 적립하지 않는 것으로 정의한다.
            guard let selectedTodo, 
                  let estimatedPomodoroMinutes = selectedTodo.estimatedPomodoroMinutes,
                  let startedTime else { return }
            
            let pomodoro = Pomodoro(todoId: selectedTodo.id, elapsedMinutes: estimatedPomodoroMinutes, startedTime: startedTime, endedTime: Date())
            
            repository.addPomodoro(pomodoro)
            
            resetPomodoroStatus()
            resetTimer()
        }
        
        let time = secondsToHoursMinutesSeconds(seconds: pomodoroSeconds)
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
    
    private func sceneDelegateNotification() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "sceneWillResignActive"), object: nil, queue: nil) { [weak self] _ in
            self?.dateBeforeSceneResigned = Date()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "sceneWillEnterForeground"), object: nil, queue: nil) { [weak self] _ in
            guard let dateBeforeSceneResigned = self?.dateBeforeSceneResigned else { return }
            guard let pomodoroSeconds = self?.pomodoroSeconds else { return }

            let currentDate = Date()
            let timeIntervalSeconds = Int(currentDate.timeIntervalSince(dateBeforeSceneResigned))
            
            if timeIntervalSeconds > pomodoroSeconds {
                self?.pomodoroSeconds = 0
            } else {
                self?.pauseTimer()
                self?.pomodoroSeconds -= timeIntervalSeconds
                self?.runTimer()
            }
        }
    }
}
