//
//  AddTodoViewController.swift
//  TimeToDo
//
//  Created by Minho on 3/7/24.
//

import UIKit

final class AddTodoViewController: BaseViewController {
    
    enum Section: Int, Hashable, CaseIterable {
        case date
        case pomo
    }
    
    enum ItemType {
        case dueDate, pomoTime
    }
    
    struct Item: Hashable {
        let section: Section
        let iconImage: UIImage
        let title: String
        var value: String
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
        
        view.setTitle("choose_pomodoro_time_label".localized(), for: .normal)
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
    private lazy var mainCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.isScrollEnabled = false
        return view
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    private var currentSnapShot: NSDiffableDataSourceSnapshot<Section, Item>! = nil
    
    private var itemList = [Item(section: .date, iconImage: UIImage(systemName: "calendar")!, title: "due_date_label".localized(),                           value: "", type: .dueDate),
                            Item(section: .pomo, iconImage: UIImage(systemName: "timer")!, title: "pomodoro_time_label".localized(), value: "", type: .pomoTime)]
    
    private lazy var doneButton = UIBarButtonItem(title: "done_button_label".localized(), style: .done, target: self, action: #selector(didDoneButtonTapped))
    private lazy var cancelButton = UIBarButtonItem(title: "cancel_button_label".localized(), style: .plain, target: self, action: #selector(didCancelButtonTapped))
    
    let viewModel = AddTodoViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.inputViewWillAppearTrigger.value = ()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        memoTextView.delegate = self
        mainCollectionView.delegate = self
        
        mainCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        transform()
        configureDataSource()
        updateUI()
    }
    
    private func transform() {
        
        viewModel.outputTodoTitle.bind { [weak self] title in
            self?.titleTextField.text = title
            self?.doneButton.isEnabled = true
        }
        
        viewModel.outputTodoMemo.bind { [weak self] memo in
            self?.memoTextView.text = memo
            self?.memoTextView.textColor = .text
        }
        
        viewModel.outputDueDate.bind { [weak self] dueDate in
            guard let dueDate else { return }
            self?.itemList[0].value = dueDate
            self?.updateUI()
        }
        
        viewModel.outputPomoTime.bind { [weak self] minutes in
            guard let minutes else { return }
            self?.itemList[1].value = minutes
            self?.updateUI()
        }
    }
    
    override func configureHierarchy() {
        [titleTextField, memoTextView, mainCollectionView].forEach { subview in
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
        
        mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(memoTextView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(8)
        }
        
    }
    
    override func configureView() {
        super.configureView()
        
        doneButton.tintColor = .tint
        doneButton.isEnabled = false
        
        cancelButton.tintColor = .systemRed
        
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = cancelButton
        
        titleTextField.addTarget(self, action: #selector(didTitleTextFieldChanged), for: .editingChanged)
    }
    
}

// MARK: 컬렉션 뷰 관련
extension AddTodoViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            listConfiguration.backgroundColor = .background
            listConfiguration.showsSeparators = true
            
            let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: environment)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            
            return section
        }
        
        return layout
    }
    
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
            cell, indexPath, itemidentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = itemidentifier.title
            content.image = itemidentifier.iconImage
            content.secondaryText = itemidentifier.value
            content.imageProperties.tintColor = .tint
            cell.contentConfiguration = content
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.backgroundColor = .systemGray6
            cell.backgroundConfiguration = background
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: mainCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
    }
    
    private func updateUI() {
        
        currentSnapShot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        // TODO: 직접 item 넣지 말고 ViewModel에서 들고있어야 함
        currentSnapShot.appendSections(Section.allCases)
        itemList.forEach { [weak self] itemIdentifier in
            self?.currentSnapShot.appendItems([itemIdentifier], toSection: itemIdentifier.section)
        }
        
        self.dataSource.apply(currentSnapShot, animatingDifferences: true)
    }
}

// MARK: 버튼 이벤트 관련
extension AddTodoViewController {
    
    @objc private func didDoneButtonTapped() {
        guard let todoTitle = viewModel.todoTitleString else { return }
        
        if todoTitle == "" {
            showToast(message: "제목은 필수 입력 사항입니다.")
            return
        }
        
        viewModel.inputDoneButtonTrigger.value = ()
        
        navigationController?.dismiss(animated: true)
    }
    
    @objc private func didCancelButtonTapped() {
        navigationController?.dismiss(animated: true)
    }
}

// MARK: Pomo, DueDate 데이터 전송 관련
extension AddTodoViewController: SendPomotime, SendDueDate {
    func sendPomoTime(minutes: Int) {
        viewModel.inputPomoTime.value = (minutes)
    }
    
    func sendDueDate(date: Date) {
        viewModel.inputDueDate.value = (date)
    }
}

// MARK: TextField 관련
extension AddTodoViewController: UITextFieldDelegate {
    
    @objc
    private func didTitleTextFieldChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if !text.isEmpty {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.inputTodoTitle.value = (textField.text)
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
        } else {
            viewModel.inputTextViewDidEndEditTrigger.value = (textView.text)
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if viewModel.isAddTodoTextFieldEdited == true &&
            textView.text == "todo_memo_placeholder".localized() {
            return
        } else {
            viewModel.inputTextViewDidEndEditTrigger.value = (textView.text)
        }
    }
}

// MARK: CollectionViewCell Delgate 관련
extension AddTodoViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let data = dataSource.itemIdentifier(for: indexPath) else { return }
        
        switch data.type {
        case .dueDate:
            didDueDateCellTapped()
        case .pomoTime:
            didPomoTimeCellTapped()
        }
    }
    
    private func didDueDateCellTapped() {
        let vc = DueDatePickerViewController()
        vc.delegate = self
        
        if let selectedDueDate = viewModel.todoDueDate {
            vc.sendDueDate(date: selectedDueDate)
        }
        
        let nav = UINavigationController(rootViewController: vc)
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        self.present(nav, animated: true)
    }
    
    private func didPomoTimeCellTapped() {
        let vc = PomoPickerViewController()
        vc.delegate = self
        
        if let minutes = viewModel.pomodoroMinutes {
            vc.sendPomoTime(minutes: minutes)
        }
        
        let nav = UINavigationController(rootViewController: vc)
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        self.present(nav, animated: true)
    }
}
