//
//  PomoTimerViewController.swift
//  TimeToDo
//
//  Created by Minho on 3/7/24.
//

import UIKit
import UserNotifications

final class PomoTimerViewController: BaseViewController {
    
    let viewModel = PomoTimerViewModel()
    
    let selectTodoButton: UIButton = {
        let view = UIButton()
        
        view.layer.borderColor = UIColor.tint.cgColor
        view.layer.borderWidth = 2
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.setTitleColor(.text, for: .normal)
        
        return view
    }()
    let circularProgressView: CircularProgressView = {
        let view = CircularProgressView(frame: .init(x: 0, y: 0, width: 300, height: 300), lineWidth: 10, rounded: false)
        
        view.progressColor = .systemGray6
        view.trackColor = .tint
        
        view.timeToFill = 0
        
        return view
    }()
    let timeLabel: UILabel = {
        let view = UILabel()
    
        view.font = .boldSystemFont(ofSize: 40)
        view.textAlignment = .center
        view.textColor = .text
        
        return view
    }()
    let startButton: UIButton = {
    let view = UIButton(configuration: .filled())
        
        view.tintColor = .tint
        view.setTitle("start_timer".localized(), for: .normal)
        
        return view
    }()
    let resetButton: UIButton = {
    let view = UIButton(configuration: .filled())
        
        view.tintColor = .tint
        view.setTitle("reset_timer".localized(), for: .normal)
        
        return view
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.inputViewWillAppearTrigger.value = ()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transform()
    }
    
    private func transform() {
        
        viewModel.outputTimerIsRunning.bind { [weak self] timerIsRunning in
            guard let timerIsRunning else { return }
            
            if timerIsRunning {
                self?.disableSelectTodoButton()
            } else {
                self?.enableSelectTodoButton()
            }
        }
        
        viewModel.outputTimerLabelText.bind { [weak self] timeString in
            self?.timeLabel.text = timeString
        }
        
        viewModel.outputCircularProgress.bind { [weak self] progressValue in
            guard let progressValue else { return }
            self?.circularProgressView.progress = progressValue
        }
        
        viewModel.outputStartButtonTitleText.bind { [weak self] titleText in
            self?.startButton.setTitle(titleText, for: .normal)
        }
        
        viewModel.outputTodoButtonTitleText.bind { [weak self] todoButtonTitleText in
            self?.selectTodoButton.setTitle(todoButtonTitleText, for: .normal)
        }
        
        viewModel.outputTodoIsntSelectedMessage.bind { [weak self] message in
            guard let message else { return }
            self?.showToast(message: message)
        }
    }
    
    override func configureHierarchy() {
        [selectTodoButton, circularProgressView, timeLabel, startButton, resetButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        selectTodoButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(40)
        }
        
        circularProgressView.snp.makeConstraints { make in
            make.center.equalTo(view.center)
            make.size.equalTo(300)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.center.equalTo(circularProgressView.snp.center)
            make.horizontalEdges.equalTo(circularProgressView.snp.horizontalEdges).inset(16)
            make.height.equalTo(48)
        }
        
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(48)
            make.trailing.equalTo(view.snp.centerX).offset(-16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
        }
        
        resetButton.snp.makeConstraints { make in
            make.bottom.equalTo(startButton)
            make.leading.equalTo(view.snp.centerX).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
        }
    }
    
    override func configureView() {
        super.configureView()
        selectTodoButton.addTarget(self, action: #selector(didSelectTodoButtonTapped), for: .touchUpInside)
        
        startButton.addTarget(self, action: #selector(didStartButtonTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(didResetButtonTapped), for: .touchUpInside)
    }
    
    private func enableSelectTodoButton() {
        selectTodoButton.isEnabled = true
        selectTodoButton.layer.borderColor = UIColor.tint.cgColor
        selectTodoButton.backgroundColor = .background
    }
    
    private func disableSelectTodoButton() {
        selectTodoButton.isEnabled = false
        selectTodoButton.layer.borderColor = UIColor.systemGray.cgColor
        selectTodoButton.backgroundColor = .systemGray6
    }
}

// MARK: local push 관련
extension PomoTimerViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }
}

// MARK: 버튼 이벤트 관련
extension PomoTimerViewController {
    
    @objc
    private func didSelectTodoButtonTapped() {
        
        // 뽀모도로 시간이 이미 1초라도 경과했으면 초기화에 대한 경고를 띄워줘야 한다.
        if let pomodoroHasStarted = viewModel.pomodoroHasStarted,
               pomodoroHasStarted == true {
            showAlert(title: "pomodoro_in_progress_label".localized(), message: "lose_pomodoro_alert_message_label".localized(), okTitle: "confirm_button_label".localized()) { [weak self] in
                self?.viewModel.inputResetButtonTapped.value = ()
            }
        }
        
        let vc = TodoSelectViewController()
        vc.delegate = self
        
        let nav = UINavigationController(rootViewController: vc)
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        self.present(nav, animated: true)
    }
    
    @objc
    private func didStartButtonTapped() {
        viewModel.inputStartbuttonTapped.value = ()
    }
    
    @objc
    private func didResetButtonTapped() {
        viewModel.inputResetButtonTapped.value = ()
    }
}

// MARK: TodoSelectController Protocol 관련
extension PomoTimerViewController: SendTodoData {
    func sendTodo(todo: Todo) {
        viewModel.inputSelectTodoButtonTapped.value = (todo)
    }
}
