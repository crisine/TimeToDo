//
//  PomoTimerViewModel.swift
//  TimeToDo
//
//  Created by Minho on 3/8/24.
//

import Foundation

final class PomoTimerViewModel {
    
    private var frame: CGRect?
    private var timer = Timer()
    private var count = 3
    private var isTimerRunning = false
    private let notificationIdentifier = "pomoNotify"
    
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    var inputStartbuttonTapped: Observable<Void?> = Observable(nil)
    var inputResetButtonTapped: Observable<Void?> = Observable(nil)
    
    var outputStartButtonTitleText: Observable<String?> = Observable("start_timer".localized())
    var outputTimerLabelText: Observable<String?> = Observable(nil)
    
    init() {
        transform()
    }
    
    private func transform() {
        inputViewDidLoadTrigger.bind { [weak self] _ in
            guard let time = self?.secondsToHoursMinutesSeconds(seconds: self?.count ?? 0) else { return }
            self?.outputTimerLabelText.value = self?.makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
            Notification.shared.requestNotificationAuthorization()
        }
        
        inputStartbuttonTapped.bind { [weak self] _ in
            self?.startButtonTapped()
        }
        
        inputResetButtonTapped.bind { [weak self] _ in
            self?.resetButtonTapped()
        }
    }
    
    private func startButtonTapped() {
        if isTimerRunning {
            isTimerRunning = false
            timer.invalidate()
            outputStartButtonTitleText.value = "resume_timer".localized()
            Notification.shared.removeNotification(notificationIdentifiers: [notificationIdentifier])
        } else {
            isTimerRunning = true
            outputStartButtonTitleText.value = "pause_timer".localized()
            makeNewTimer()
            // TODO: notificationIdentifier를 나중에 목적에 따른 다른 identifier를 전해주어야 함.
            // MARK: literal 하게 하지 말고, 변수로 들고 있던가 할 것.
            Notification.shared.sendNotification(seconds: Double(count), notificationIdentifier: notificationIdentifier)
        }
    }
    
    private func resetButtonTapped() {
        timer.invalidate()
        isTimerRunning = false
        count = 3 // MARK: 테스트 겸 해서 이렇게 유지
        
        let time = secondsToHoursMinutesSeconds(seconds: count)
        outputTimerLabelText.value = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        outputStartButtonTitleText.value = "start_timer".localized()
        Notification.shared.removeNotification(notificationIdentifiers: [notificationIdentifier])
    }
    
    private func makeNewTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
    }
    
    @objc private func timerCounter() {
        
        if count - 1 > 0 {
            count = count - 1
        } else {
            count = 3
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
