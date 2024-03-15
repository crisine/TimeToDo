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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.outputTimerLabelText.bind { [weak self] timeString in
            self?.timeLabel.text = timeString
        }
        
        viewModel.outputStartButtonTitleText.bind { [weak self] titleText in
            self?.startButton.setTitle(titleText, for: .normal)
        }
        
        viewModel.inputViewDidLoadTrigger.value = ()
    }
    
    override func configureHierarchy() {
        [timeLabel, startButton, resetButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(160)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
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
        startButton.addTarget(self, action: #selector(didStartButtonTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(didResetButtonTapped), for: .touchUpInside)
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
    private func didStartButtonTapped() {
        viewModel.inputStartbuttonTapped.value = ()
    }
    
    @objc
    private func didResetButtonTapped() {
        viewModel.inputResetButtonTapped.value = ()
    }
}