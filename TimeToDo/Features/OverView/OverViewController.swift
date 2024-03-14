//
//  OverViewController.swift
//  TimeToDo
//
//  Created by Minho on 3/7/24.
//

import UIKit
import RealmSwift
import SnapKit
import DGCharts

final class OverviewViewController: BaseViewController {
    
    enum OverviewSection: Int, Hashable, CaseIterable {
        case calendar
        case graph
        case todo
    }

    enum OverviewSectionItem: Hashable {
        case calendar(DateDay)
        case graph(Int)
        case todo(Todo)
    }
    
    lazy var mainCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        return view
    }()
    
    let viewModel = OverviewViewModel()
    
    typealias OverviewDataSource = UICollectionViewDiffableDataSource<OverviewSection, OverviewSectionItem>
    
    var dataSource: OverviewDataSource! = nil
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
        configureCollectionView()
        configureDataSource()
    }
    
    func transform() {
        viewModel.outputDateDayList.bind { [weak self] _ in
            self?.updateSnapshot()
        }
        
        viewModel.outputTodoList.bind { [weak self] _ in
            self?.updateSnapshot() // TODO: 임시방편 (Todo 셀에 변화가 있을때마다 이쪽도 호출됨)
            self?.reconfigureSnapshotItems()
        }
        
        viewModel.outputDidSelectItemAt.bind { [weak self] todo in
            guard let todo else { return }
            
            let vc = DetailTodoViewController()
            vc.todo = todo
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func configureHierarchy() {
        [mainCollectionView].forEach { subview in
            view.addSubview(subview)
        }
    }
    
    override func configureConstraints() {
        mainCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        
    }
    
}


// MARK: collectionView 관련
extension OverviewViewController {
    
    private func configureCollectionView() {
        // mainCollectionView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.identifier)
        // GraphCell, TodoCell, ...
        mainCollectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
        mainCollectionView.register(ChartCollectionViewCell.self, forCellWithReuseIdentifier: ChartCollectionViewCell.identifier)
        mainCollectionView.register(TodoCollectionViewCell.self, forCellWithReuseIdentifier: TodoCollectionViewCell.identifier)
    }
    
    func updateSnapshot() {
        print("updateSnapshot")
        var snapshot = NSDiffableDataSourceSnapshot<OverviewSection, OverviewSectionItem>()
        
        snapshot.appendSections([.calendar, .graph, .todo])
        viewModel.outputDateDayList.value?.forEach { snapshot.appendItems([.calendar($0)], toSection: .calendar) }
        
        // TODO: Todo 데이터를 전달하여 각 Bar에서 날짜별로 판단하게 해야 함..
        [1, 10, 100, 1000].forEach { snapshot.appendItems([.graph($0)], toSection: .graph) }
        
        // TODO: Todo 끌어와서 표시해보기
        viewModel.outputTodoList.value?.forEach { snapshot.appendItems([.todo($0)], toSection: .todo) }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // 이미 존재하는 셀에서 내용이 바뀐 경우 -> 아예 셀을 새로이 재활용해서 그리는 함수
    // 현재 문제는 Hashable 하지 않는 투두 값으로 인해서 초기화가 안 되는 문제!!
    func reconfigureSnapshotItems() {
        var snapshot = dataSource.snapshot()
        
        viewModel.outputTodoList.value?.forEach { snapshot.reconfigureItems([.todo($0)]) }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureDataSource() {
        
        dataSource = OverviewDataSource(collectionView: mainCollectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            
            // 아이템 구분에 따라서 셀 다르게 설정해주기
            switch itemIdentifier {
            case .calendar(let dateDay):
                
                let cell: CalendarCollectionViewCell = self?.mainCollectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as! CalendarCollectionViewCell
                
                cell.dayLabel.text = dateDay.weekday
                cell.dayNumberImageView.image = UIImage(systemName: "\(dateDay.dayNumber).square.fill")
                return cell
                
            case .graph(let number):
                let cell = self?.mainCollectionView.dequeueReusableCell(withReuseIdentifier: ChartCollectionViewCell.identifier, for: indexPath) as! ChartCollectionViewCell
                
                // MARK: 잠깐만.. 이대로면 계속 barChartEntry가 생겨서 마지막 데이터만 들어가겠는데..? 해결 방법 필요!!
//                var barChartEntry = [BarChartDataEntry]()
//                
//                let value = BarChartDataEntry(x: Double(number), y: Double(Int.random(in: 1...3)))
//                barChartEntry.append(value)
//                
//                let bar = BarChartDataSet(entries: barChartEntry, label: "완료한 할 일")
//                bar.colors = [NSUIColor.tint]
//                
//                let data = BarChartData(dataSet: bar)
//                cell.barChartView.data = data
                
                return cell
            case .todo(let todo):
                let cell = self?.mainCollectionView.dequeueReusableCell(withReuseIdentifier: TodoCollectionViewCell.identifier, for: indexPath) as! TodoCollectionViewCell
                
                let titleText = todo.isCompleted == true ? todo.title.strikeThrough() : NSAttributedString(string: todo.title)
                cell.todoTitleLabel.attributedText = titleText
                
                let doneButtonImageName = todo.isCompleted == true ? "checkmark.circle.fill" : "circle"
                cell.doneButton.setImage(UIImage(systemName: doneButtonImageName), for: .normal)
                print(doneButtonImageName)
                
                let gesture = TodoDoneButtonGestureRecognizer(target: self, action: #selector(self?.didTodoDoneButtonTapped))
                gesture.id = todo.id
                
                cell.doneButton.addGestureRecognizer(gesture)
                
                return cell
            }
        })
    }
    
    // 각 섹션 - 그룹 - 셀의 레이아웃 잡는 부분
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnviornment in
            
            guard let self else { return nil }
            
            guard let section = OverviewSection(rawValue: sectionIndex) else { return nil }
            
            switch section {
            case .calendar:
                // MARK: fractionalWidth, Height로 비율 정하기
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                // MARK: layoutSize에서 width, height의 값은 고정 70pt 씩 정사각형으로 줌
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(70), heightDimension: .absolute(70)), subitems: [item])
                
                // MARK: item을 group에 넣고, group을 section에 넣음
                let section = NSCollectionLayoutSection(group: group)
                
                section.orthogonalScrollingBehavior = .continuous

                return section
            case .graph:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.25)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                
                section.orthogonalScrollingBehavior = .groupPaging
                
                return section
                
            case .todo:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.075)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                
                section.interGroupSpacing = 8
                section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
                
                return section
            }
        }
    }
}

// MARK: NavigationBar 관련
extension OverviewViewController {
    
    private func configureNavigationBar() {
        let calendarBarButton = UIBarButtonItem(image: UIImage(systemName: "calendar.circle"), style: .plain, target: self, action: #selector(didCalendarBarButtonTapped))
        calendarBarButton.tintColor = .tint
        
        let addTodoBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(didAddTodoBarButtonTapped))
        addTodoBarButton.tintColor = .tint
        
        navigationItem.setLeftBarButton(calendarBarButton, animated: true)
        navigationItem.setRightBarButton(addTodoBarButton, animated: true)
    }
    
    @objc private func didCalendarBarButtonTapped() {
        viewModel.inputCalendarBarButtonTrigger.value = ()
    }
    
    @objc private func didAddTodoBarButtonTapped() {
        let vc = AddTodoViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: collectionView 이벤트 관련
extension OverviewViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let data = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        switch data {
        case .calendar(let dateDay):
            showToast(message: dateDay.dayNumber)
        case .todo(let todo):
            let vc = DetailTodoViewController()
            vc.todo = todo
            navigationController?.pushViewController(vc, animated: true)
        default:
            print("")
        }
        
        
        
//        guard let dateDay = dataSource.itemIdentifier(for: indexPath) else {
//            // TODO: 에러 처리
//            return
//        }
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
    
    @objc private func didTodoDoneButtonTapped(gesture: TodoDoneButtonGestureRecognizer) {
        guard let id = gesture.id else { return }
        print("gesture catched")
        viewModel.inputTodoDoneButtonTrigger.value = (id)
    }
}

class TodoDoneButtonGestureRecognizer: UITapGestureRecognizer {
    var id: ObjectId?
}
