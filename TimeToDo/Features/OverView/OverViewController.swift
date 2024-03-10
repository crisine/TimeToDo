//
//  OverViewController.swift
//  TimeToDo
//
//  Created by Minho on 3/7/24.
//

import UIKit
import RealmSwift
import SnapKit

final class OverviewViewController: BaseViewController {
    
    lazy var prototypeCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
        return view
    }()
    let prototypeAddButton: UIButton = {
        let view = UIButton(configuration: .filled())
        
        view.tintColor = .tint
        view.setImage(UIImage(systemName: "plus"), for: .normal)
        
        return view
    }()
    let prototypeRemoveButton: UIButton = {
        let view = UIButton(configuration: .filled())
        
        view.setImage(UIImage(systemName: "trash.circle"), for: .normal)
        view.tintColor = .tint
        
        return view
    }()
    
    let viewModel = OverviewViewModel()
    
    private var dataSource: UICollectionViewDiffableDataSource<OverviewSection, Todo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transform()
        configureDataSource()
        
        viewModel.inputViewDidLoadTrigger.value = ()
    }
    
    override func configureHierarchy() {
        [prototypeCollectionView, prototypeAddButton, prototypeRemoveButton].forEach { subview in
            view.addSubview(subview)
        }
    }
    
    override func configureConstraints() {
        prototypeCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        prototypeAddButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.size.equalTo(48)
        }
        
        prototypeRemoveButton.snp.makeConstraints { make in
            make.bottom.equalTo(prototypeAddButton.snp.top).offset(-16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.size.equalTo(48)
        }
    }
    
    override func configureView() {
        prototypeAddButton.clipsToBounds = true
        prototypeAddButton.layer.cornerRadius = 24
        
        prototypeRemoveButton.clipsToBounds = true
        prototypeRemoveButton.layer.cornerRadius = 24
        
        prototypeAddButton.addTarget(self, action: #selector(didPrototypeAddButtonTapped), for: .touchUpInside)
        prototypeRemoveButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
}


// MARK: collectionView 관련
extension OverviewViewController {
    func updateSnapshot(todoList: [Todo]) {
        var snapshot = NSDiffableDataSourceSnapshot<OverviewSection, Todo>()
        
        snapshot.appendSections([.todo])
        snapshot.appendItems(todoList, toSection: .todo)
        
        dataSource.apply(snapshot)
    }
    
    private func configureDataSource() {
        
        // 셀 형식에 대한 선언
        let cellRegistraion: UICollectionView.CellRegistration<UICollectionViewListCell, Todo>!
        
        // 셀 내에 값을 넣어주기
        cellRegistraion = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            
            print("Cell Registration Handler")
            
            // cell 내부 컨텐츠 설정
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.title
            content.textProperties.color = .black
            
            content.secondaryText = itemIdentifier.memo
            content.secondaryTextProperties.color = .lightGray
            
            content.image = UIImage(systemName: "timer")
            
            cell.contentConfiguration = content
            
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.backgroundColor = .systemGray6
            backgroundConfig.cornerRadius = 16
            
            cell.backgroundConfiguration = backgroundConfig
        })
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: prototypeCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistraion,
                                                                    for: indexPath,
                                                                    item: itemIdentifier)
            
            return cell
        })
    }
    
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.backgroundColor = .background
        configuration.showsSeparators = true
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }
    
    func transform() {
        viewModel.outputTodoList.bind { [weak self] todoList in
            guard let todoList else { return }
            self?.updateSnapshot(todoList: todoList)
        }
    }
}

// MARK: 버튼 이벤트 관련
extension OverviewViewController {
    @objc private func didPrototypeAddButtonTapped() {
        // mainView.viewModel.inputProtoTypeAddTodoButtonTrigger.value = ()
        let nav = UINavigationController(rootViewController: AddTodoViewController())
        present(nav, animated: true)
    }
    
    @objc private func deleteButtonTapped() {
        viewModel.inputProtoTypeDeleteTodoButtonTrigger.value = ()
    }
}
