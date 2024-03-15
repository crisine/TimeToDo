//
//  AddTodoViewController.swift
//  TimeToDo
//
//  Created by Minho on 3/7/24.
//

import UIKit

final class AddTodoViewController: BaseViewController {
    
    enum Section: Int, Hashable {
        case date
        case pomo
    }
    
    enum ItemType {
        case dueDate, pomoTime
    }
    
    struct Item: Hashable {
        let iconImage: UIImage
        let title: String
        let type: ItemType
    }
    
    private let titleTextField: UITextField = {
        let view = UITextField()
        
        view.placeholder = "todo_title_placeholder".localized()
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: view.frame.height))
        view.leftView = paddingView
        view.leftViewMode = .always
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        
        view.backgroundColor = .systemGray6
        
        view.font = .systemFont(ofSize: 14)
        
        return view
    }()
    private let memoTextView: UITextView = {
        let view = UITextView()
        
        view.textContainerInset = UIEdgeInsets(top: 6, left: 2, bottom: 6, right: 2)
        view.text = "todo_memo_placeholder".localized()
        view.textColor = .systemGray3
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        
        view.backgroundColor = .systemGray6
        
        view.font = .systemFont(ofSize: 14)
        
        return view
    }()
    private let pomoPickerButton: UIButton = {
        let view = UIButton(configuration: .filled())
        
        view.setTitle("뽀모도로 시간 선택하기", for: .normal)
        view.titleLabel?.font = .boldSystemFont(ofSize: 24)
        view.setImage(UIImage(systemName: "alarm"), for: .normal)
        view.tintColor = .systemRed
        return view
    }()
    private let dueDatePickerButton: UIButton = {
        let view = UIButton(configuration: .filled())
        
        view.setTitle("마감일 선택하기", for: .normal)
        view.titleLabel?.font = .boldSystemFont(ofSize: 24)
        view.setImage(UIImage(systemName: "calendar.badge.clock"), for: .normal)
        view.tintColor = .tint
        
        return view
    }()
    private let mainTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = .yellow
        view.isScrollEnabled = false
        return view
    }()
    
    private var dataSource: UITableViewDiffableDataSource<Section, Item>! = nil
    private var currentSnapShot: NSDiffableDataSourceSnapshot<Section, Item>! = nil
    
    private let viewModel = AddTodoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memoTextView.delegate = self
        
        mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        transform()
        configureDataSource()
        updateUI()
    }
    
    private func transform() {
        viewModel.outputDueDateSwitchIsOn.bind { _ in
            self.updateUI()
        }
    }
    
    override func configureHierarchy() {
        [titleTextField, memoTextView, pomoPickerButton, dueDatePickerButton, mainTableView].forEach { subview in
            view.addSubview(subview)
        }
    }
    
    override func configureConstraints() {
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(32)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(120)
        }
        
//        dueDatePickerButton.snp.makeConstraints { make in
//            make.top.equalTo(memoTextView.snp.bottom).offset(16)
//            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
//            make.height.equalTo(32)
//        }
//        
//        pomoPickerButton.snp.makeConstraints { make in
//            make.top.equalTo(dueDatePickerButton.snp.bottom).offset(8)
//            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
//            make.height.equalTo(32)
//        }
        
        mainTableView.snp.makeConstraints { make in
            make.top.equalTo(memoTextView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
        
    }
    
    override func configureView() {
        navigationItem.title = "새로운 할 일 추가"
        
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didDoneButtonTapped))
        doneButton.tintColor = .tint
        
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didCancelButtonTapped))
        cancelButton.tintColor = .systemRed
        
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = cancelButton
        
        dueDatePickerButton.addTarget(self, action: #selector(didDueDatePickerButtonTapped), for: .touchUpInside)
    }
    
}

// MARK: 컬렉션 뷰 관련
extension AddTodoViewController {
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: mainTableView) { [weak self] (tableView: UITableView, indexPath: IndexPath, item: Item) -> UITableViewCell? in
            guard let self else { return nil }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            var content = cell.defaultContentConfiguration()
            
            content.text = item.title
            content.image = item.iconImage
            
            switch item.type {
            case .dueDate:
                let enableDueDateSwitch = UISwitch()
                enableDueDateSwitch.addTarget(self, action: #selector(didDueDateSwitchEnabled), for: .touchUpInside)
                cell.accessoryView = enableDueDateSwitch
            case .pomoTime:
                let enablePomoTimeSwitch = UISwitch()
                cell.accessoryView = enablePomoTimeSwitch
            }
            
            cell.contentConfiguration = content
            return cell
        }
        
        self.dataSource.defaultRowAnimation = .fade
    }
    
    private func updateUI() {
        
        currentSnapShot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        // TODO: 직접 item 넣지 말고 ViewModel에서 들고있어야 함
        currentSnapShot.appendSections([.date, .pomo])
        currentSnapShot.appendItems([Item(iconImage: UIImage(systemName: "calendar")!, title: "마감 날짜", type: .dueDate)], toSection: .date)
        currentSnapShot.appendItems([Item(iconImage: UIImage(systemName: "timer")!, title: "뽀모도로 시간", type: .pomoTime)], toSection: .pomo)
        
        if viewModel.dueDateSwitchIsOn == true {
            currentSnapShot.appendItems([Item(iconImage: UIImage(), title: "가나다", type: .dueDate)])
        }
        
        
        self.dataSource.apply(currentSnapShot, animatingDifferences: true)
    }
}

// MARK: 버튼 이벤트 관련
extension AddTodoViewController {
    
    @objc private func didDoneButtonTapped() {
        guard let title = titleTextField.text else { return }
        
        if title == "" {
            showToast(message: "제목은 필수 입력 사항입니다.")
            return
        }
        
        let todo = Todo(title: title, memo: memoTextView.text, createdDate: Date(), modifiedDate: Date())
        
        viewModel.inputDoneButtonTrigger.value = todo
        
        navigationController?.dismiss(animated: true)
    }
    
    @objc private func didCancelButtonTapped() {
        navigationController?.dismiss(animated: true)
    }
    
    @objc private func didDueDatePickerButtonTapped() {
        let vc = DueDatePickerViewController()
        
        let nav = UINavigationController(rootViewController: vc)
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        self.present(nav, animated: true)
    }
    
    @objc private func didPomoPickerButtonTapped() {
        let vc = PomoPickerViewController()
        vc.delegate = self
        
        let nav = UINavigationController(rootViewController: vc)
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        self.present(nav, animated: true)
    }
    
    @objc private func didDueDateSwitchEnabled(sender: UISwitch) {
        viewModel.inputDueDateSwitchIsOn.value = sender.isOn
    }
}

// MARK: Pomo, DueDate 데이터 전송 관련
extension AddTodoViewController: SendPomotime {
    func sendPomoTime(minutes: Int) {
        
    }
}

// MARK: PickerView Delegate 관련
extension AddTodoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return viewModel.numberOfRowsInComponent(component)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return viewModel.titleForRow(component, rowNumber: row)
    }
}

// MARK: TextView Delegate 관련
extension AddTodoViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "todo_memo_placeholder".localized() &&
            !viewModel.isAddTodoTextFieldEdited {
            textView.text = nil
            textView.textColor = .text
            viewModel.inputTextViewDidBeginEditTrigger.value = ()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "todo_memo_placeholder".localized()
            textView.textColor = .systemGray3
            viewModel.inputTextViewDidBeginEditTrigger.value = ()
        }
    }
}
