//
//  OverViewController.swift
//  TimeToDo
//
//  Created by Minho on 3/7/24.
//

import UIKit
import RealmSwift
import SnapKit

enum OverviewSection: Int, Hashable, CaseIterable {
    case calendar
    case graph
    case todo
}


final class OverviewViewController: BaseViewController {
    
    lazy var mainCollectionView: UICollectionView = {
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
    
    private var dataSource: UICollectionViewDiffableDataSource<OverviewSection, DateDay>!
    private let sections = OverviewSection.allCases
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.inputViewWillAppearTrigger.value = ()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainCollectionView.delegate = self
        navigationItem.title = "OverView"
        
        configureNavigationBar()
        transform()
        configureDataSource()
    }
    
    func transform() {
        viewModel.outputDateDayList.bind { [weak self] dateDay in
            guard let dateDay else { return }
            self?.updateSnapshot(dateDayList: dateDay)
        }
        
        viewModel.outputDidSelectItemAt.bind { [weak self] todo in
            guard let todo else { return }
            
            let vc = DetailTodoViewController()
            vc.todo = todo
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func configureHierarchy() {
        [mainCollectionView, prototypeAddButton, prototypeRemoveButton].forEach { subview in
            view.addSubview(subview)
        }
    }
    
    override func configureConstraints() {
        mainCollectionView.snp.makeConstraints { make in
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
    
    private func configureCollectionView() {
        // mainCollectionView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.identifier)
        // GraphCell, TodoCell, ...
        mainCollectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
    }
    
    func updateSnapshot(dateDayList: [DateDay]) {
        var snapshot = NSDiffableDataSourceSnapshot<OverviewSection, DateDay>()
        
        snapshot.appendSections([.calendar])
        snapshot.appendItems(dateDayList, toSection: .calendar)
        
        dataSource.apply(snapshot)
    }
    
    private func configureDataSource() {
        
        // 셀 형식에 대한 선언
        let cellRegistraion: UICollectionView.CellRegistration<CalendarCollectionViewCell, DateDay>!
        
        // 셀 내에 값을 넣어주기
        cellRegistraion = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            
            cell.dayLabel.text = itemIdentifier.weekday
            cell.dayNumberImageView.image = UIImage(systemName: "\(itemIdentifier.dayNumber).square.fill")
            
        })
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistraion,
                                                                    for: indexPath,
                                                                    item: itemIdentifier)
            
            return cell
        })
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnviornment in
            guard let self else { return nil }
            let section = self.sections[sectionIndex]
            switch section {
            case .calendar:
                // MARK: fractionalWidth, Height로 비율 정하기
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                // MARK: layoutSize에서 width, height의 값은 고정 70pt 씩 정사각형으로 줌
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(70), heightDimension: .absolute(70)), subitems: [item])
                
                // MARK: item을 group에 넣고, group을 section에 넣음
                let section = NSCollectionLayoutSection(group: group)
                
                section.orthogonalScrollingBehavior = .continuous
                
                
                print("DEBUG: Section Setted")
                return section
            case .graph:
                return nil
                
            case .todo:
                return nil
            }
        }
    }
}

// MARK: NavigationBar 관련
extension OverviewViewController {
    
    private func configureNavigationBar() {
        let calendarButton = UIBarButtonItem(image: UIImage(systemName: "calendar.circle"), style: .plain, target: self, action: #selector(didNavigationBarCalendarButtonTapped))
        calendarButton.tintColor = .tint
        
        navigationItem.setLeftBarButton(calendarButton, animated: true)
    }
    
    @objc private func didNavigationBarCalendarButtonTapped() {
        viewModel.inputNavigationBarCalendarButtonTrigger.value = ()
    }
}

// MARK: collectionView 이벤트 관련
extension OverviewViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dateDay = dataSource.itemIdentifier(for: indexPath) else {
            // TODO: 에러 처리
            return
        }
//        viewModel.inputDidSelectItemAtTrigger.value = (dateDay)
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
