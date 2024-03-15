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
    private lazy var mainCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.isScrollEnabled = false
        return view
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    private var currentSnapShot: NSDiffableDataSourceSnapshot<Section, Item>! = nil
    
    private var itemList = [Item(section: .date, iconImage: UIImage(systemName: "calendar")!, title: "마감 날짜",                           value: "", type: .dueDate),
                            Item(section: .pomo, iconImage: UIImage(systemName: "timer")!, title: "뽀모도로 시간", value: "", type: .pomoTime)]
    
    private let viewModel = AddTodoViewModel()
    
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
        navigationItem.title = "새로운 할 일 추가"
        
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didDoneButtonTapped))
        doneButton.tintColor = .tint
        
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didCancelButtonTapped))
        cancelButton.tintColor = .systemRed
        
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = cancelButton
    }
    
}

// MARK: 컬렉션 뷰 관련
extension AddTodoViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.backgroundColor = .background
        configuration.showsSeparators = true
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
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
        
        let todo = Todo(title: todoTitle, memo: viewModel.todoMemoString, modifiedDate: Date(), dueDate: viewModel.dueDate, estimatedPomodoroMinutes: viewModel.pomodoroMinutes)
        
        viewModel.inputDoneButtonTrigger.value = (todo)
        
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

extension AddTodoViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
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
        
        let nav = UINavigationController(rootViewController: vc)
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        self.present(nav, animated: true)
    }
}
