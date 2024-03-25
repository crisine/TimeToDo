//
//  PomoPickerViewController.swift
//  TimeToDo
//
//  Created by Minho on 3/15/24.
//

import UIKit

protocol SendPomotime {
    func sendPomoTime(minutes: Int)
}

class PomoPickerViewController: BaseViewController {
    
    private let pickerTitleList = (1...1440).map { String($0) }
    private lazy var doneBarButton: UIBarButtonItem = {
        let view = UIBarButtonItem(title: "done_button_label".localized(), style: .done, target: self, action: #selector(didDoneBarButtonTapped))
        view.tintColor = .tint
        return view
    }()
    private lazy var cancelBarButton: UIBarButtonItem = {
        let view = UIBarButtonItem(title: "cancel_button_label".localized(), style: .plain, target: self, action: #selector(didCancelBarButtonTapped))
        view.tintColor = .systemRed
        return view
    }()
    private let pomoPickerView: UIPickerView =  {
        let view = UIPickerView()
        return view
    }()
    
    private var selectedPomoTime: Int?
    
    var delegate: SendPomotime?
    
    override func viewWillAppear(_ animated: Bool) {
        
        if selectedPomoTime == nil {
            selectedPomoTime = 25
            return pomoPickerView.selectRow(24, inComponent: 0, animated: true)
        } else {
            return pomoPickerView.selectRow(selectedPomoTime! - 1, inComponent: 0, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pomoPickerView.delegate = self
        pomoPickerView.dataSource = self
    }
    
    override func configureHierarchy() {
        view.addSubview(pomoPickerView)
    }
    
    override func configureConstraints() {
        pomoPickerView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
    }
    
    override func configureView() {
        navigationItem.setLeftBarButton(cancelBarButton, animated: true)
        navigationItem.setRightBarButton(doneBarButton, animated: true)
    }
}

// MARK: 버튼 이벤트 관련
extension PomoPickerViewController {
    
    @objc private func didCancelBarButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func didDoneBarButtonTapped() {
        guard let selectedPomoTime else { return }
        delegate?.sendPomoTime(minutes: selectedPomoTime)
        dismiss(animated: true)
    }
}

// MARK: UIPickerView 설정 관련
extension PomoPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerTitleList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerTitleList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPomoTime = Int(pickerTitleList[row])
    }
}

// MARK: Pomodoro 시간 값 전달 관련
extension PomoPickerViewController: SendPomotime {
    func sendPomoTime(minutes: Int) {
        selectedPomoTime = minutes
    }
}
