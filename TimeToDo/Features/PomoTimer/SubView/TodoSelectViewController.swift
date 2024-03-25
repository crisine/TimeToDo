//
//  TodoSelectViewController.swift
//  TimeToDo
//
//  Created by Minho on 3/17/24.
//

import UIKit

protocol SendTodoData {
    func sendTodo(todo: Todo)
}

final class TodoSelectViewController: BaseViewController {
    
    enum Section: Int, CaseIterable {
        case main
    }
    
    
    private let viewModel = TodoSelectViewModel()
    var delegate: SendTodoData?
    
    private let titleTextLabel: UILabel = {
        let view = UILabel()
        
        view.text = "choose_task_to_do".localized()
        view.textColor = .text
        view.font = .boldSystemFont(ofSize: 24)
        view.textAlignment = .center
        
        return view
    }()
    private lazy var todoCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.delegate = self
        return view
    }()
    private let emptyViewLabel: UILabel = {
        let view = UILabel()
        
        view.numberOfLines = 0
        view.text = "empty_pomodoro_to_do".localized() + "\n" + "empty_please_add_to_do".localized()
        view.font = .systemFont(ofSize: 24)
        view.textAlignment = .center
        view.textColor = .text
        view.isHidden = true
        
        return view
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Todo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.inputViewDidLoadTrigger.value = ()
        
        configureDataSource()
        updateSnapShot()
    }
    
    private func transform() {
        viewModel.outputViewDidLoad.bind { _ in
            self.emptyViewLabel.isHidden = false
            self.todoCollectionView.isHidden = true
        }
    }
    
    
    override func configureHierarchy() {
        [titleTextLabel, todoCollectionView, emptyViewLabel].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        
        titleTextLabel.snp.makeConstraints { make in
            make.top.equalTo(view).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(26)
        }
        
        todoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleTextLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(4)
        }
        
        emptyViewLabel.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        transform()
    }
    
}

// MARK: CollectionView 관련
extension TodoSelectViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            
            let layoutSection: NSCollectionLayoutSection
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(52))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            layoutSection = NSCollectionLayoutSection(group: group)
            layoutSection.interGroupSpacing = 4
            layoutSection.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
            
            return layoutSection
        }
        
        return layout
    }
    
    private func todoCellRegistration() -> UICollectionView.CellRegistration<TodoCollectionViewCell, Todo> {
        UICollectionView.CellRegistration<TodoCollectionViewCell, Todo> { cell, indexPath, itemIdentifier in
            
            // TODO: OverViewVC에서 셀 버튼에 Gesture 붙여서 셀 알아오는 것 때문에 cell.updateUI() 형식으로 일원화하려고 해도 시간상 지금 불가능하여 현행방식 유지
            let titleText = itemIdentifier.isCompleted == true ? itemIdentifier.title.strikeThrough() : NSAttributedString(string: itemIdentifier.title)
            cell.todoTitleLabel.attributedText = titleText
            
            cell.doneButton.isHidden = true
            
            cell.dueDateLabel.text = itemIdentifier.dueDate?.toString
            cell.subStackView.isHidden = itemIdentifier.dueDate != nil ? false : true
            
        }
    }
    
    private func configureDataSource() {
        
        let todoCellRegistration = todoCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: todoCollectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            
            if let section = Section(rawValue: indexPath.section) {
                switch section {
                case .main:
                    let cell = self?.todoCollectionView.dequeueConfiguredReusableCell(using: todoCellRegistration, for: indexPath, item: itemIdentifier)
                    
                    return cell
                }
            } else {
                return nil
            }
        })
    }
    
    private func updateSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Todo>()
        
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(viewModel.fetchedTodoList)
        
        dataSource.apply(snapshot)
    }
}

// MARK: CollectionView Delegate
extension TodoSelectViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let todo = dataSource.itemIdentifier(for: indexPath) else { return }
        delegate?.sendTodo(todo: todo)
        dismiss(animated: true)
    }
    
}
