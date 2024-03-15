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
        let view = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didDoneBarButtonTapped))
        return view
    }()
    private lazy var cancelBarButton: UIBarButtonItem = {
        let view = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didCancelBarButtonTapped))
        return view
    }()
    private var selectedPomoTime: Int?
    
    var delegate: SendPomotime?
    
    private let pomoPickerView: UIPickerView =  {
        let view = UIPickerView()
        return view
    }()
    
    override func configureHierarchy() {
        view.addSubview(pomoPickerView)
    }
    
    override func configureConstraints() {
        pomoPickerView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
    }
    
    override func configureView() {
        pomoPickerView.delegate = self
        
        doneBarButton.isEnabled = false
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
extension PomoPickerViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerTitleList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPomoTime = Int(pickerTitleList[row])
        doneBarButton.isEnabled = true
    }
}
