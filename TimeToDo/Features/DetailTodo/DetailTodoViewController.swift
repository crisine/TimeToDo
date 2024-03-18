//
//  DetailTodoViewController.swift
//  TimeToDo
//
//  Created by Minho on 3/7/24.
//

import UIKit

final class DetailTodoViewController: BaseViewController {
    
    enum PomodoroDashboardSection: Int, Hashable, CaseIterable {
        case today
        case week
        case alltime
    }
    
    enum PomodoroSectionItem: Hashable {
        case today(PomodoroStat)
        case week(PomodoroStat)
        case alltime(PomodoroStat)
    }
    
    typealias PomodoroDashboardDataSource = UICollectionViewDiffableDataSource<PomodoroDashboardSection, PomodoroSectionItem>
    
    private var dataSource: PomodoroDashboardDataSource! = nil
    private let sections = PomodoroDashboardSection.allCases
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 32, weight: .medium)
        view.numberOfLines = 0
        view.textColor = .text
        
        return view
    }()
    private let titleLableUnderLineView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .systemGray4
        
        return view
    }()
    
    private let timerImageView: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(systemName: "alarm")?.withTintColor(.tint)
        view.tintColor = .tint
        
        return view
    }()
    private let estimatedPomodoroMinutesLabel: UILabel = {
        let view = UILabel()
        
        view.font = .boldSystemFont(ofSize: 24)
        view.textColor = .text
        
        return view
    }()
    
    private lazy var pomodoroDashboardCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = .systemGray6
        view.isScrollEnabled = false
        return view
    }()
    
    private let memoHolderLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 16)
        view.textColor = .systemGray3
        view.text = "Additional Description"
        
        return view
    }()
    private let memoTextView: UITextView = {
        let view = UITextView()
        
        view.font = .systemFont(ofSize: 14)
        view.isEditable = false
        view.isSelectable = false
        view.textColor = .text
        view.backgroundColor = .systemGray6
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        
        return view
    }()
    private let priorityLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 16)
        view.textColor = .text
        
        return view
    }()
    private let dueDateLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 14)
        view.textColor = .text
        
        return view
    }()
    
    let viewModel = DetailTodoViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.inputViewWillAppearTrigger.value = ()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pomodoroDashboardCollectionView.delegate = self
        
        transform()
        configureCollectionView()
        configureDataSource()
    }
    
    private func transform() {
        viewModel.outputViewWillAppearTrigger.bind { [weak self] pomodoroStatArray in
            guard let pomodoroStatArray else { return }
            self?.updateSnapShot(pomodoroStatArray)
        }
    }
    
    override func configureHierarchy() {
        [titleLabel, titleLableUnderLineView, timerImageView, estimatedPomodoroMinutesLabel, pomodoroDashboardCollectionView, memoHolderLabel, memoTextView, priorityLabel, dueDateLabel].forEach {
            view.addSubview($0)
        }
    }
    
    override func configureConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.lessThanOrEqualTo(80)
        }
        
        titleLableUnderLineView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(0.5)
        }
        
        timerImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLableUnderLineView.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.size.equalTo(32)
        }
        
        estimatedPomodoroMinutesLabel.snp.makeConstraints { make in
            make.top.equalTo(timerImageView.snp.top)
            make.leading.equalTo(timerImageView.snp.trailing).offset(4)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(timerImageView.snp.height)
        }
        
        memoHolderLabel.snp.makeConstraints { make in
            make.top.equalTo(estimatedPomodoroMinutesLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(20)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(memoHolderLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(160)
        }
        
        pomodoroDashboardCollectionView.snp.makeConstraints { make in
            make.top.equalTo(memoTextView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(100)
        }
        
        priorityLabel.snp.makeConstraints { make in
            make.top.equalTo(pomodoroDashboardCollectionView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        dueDateLabel.snp.makeConstraints { make in
            make.top.equalTo(priorityLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    override func configureView() {
        guard let todo = viewModel.selectedTodo else { return }
        
        // TODO: MVVM 기준으로 바뀌어야 할 듯?
        titleLabel.text = todo.title
        
        if let estimatedPomodoroMinutes = todo.estimatedPomodoroMinutes {
            estimatedPomodoroMinutesLabel.text = "\(estimatedPomodoroMinutes) min."
        }
        
        memoTextView.text = todo.memo
        priorityLabel.text = "\(todo.priority ?? 0)"
        dueDateLabel.text = todo.dueDate?.formatted()
        
        navigationController?.navigationBar.tintColor = .tint
        navigationController?.navigationBar.topItem?.title = ""
        
        
    }

}

// MARK: CollectionView 관련
extension DetailTodoViewController {
    
    private func configureCollectionView() {
        pomodoroDashboardCollectionView.register(PomodoroStatCollectionViewCell.self, forCellWithReuseIdentifier: PomodoroStatCollectionViewCell.identifier)
    }
    
    private func updateSnapShot(_ pomodoroStatArray: [PomodoroStat]) {
        var snapshot = NSDiffableDataSourceSnapshot<PomodoroDashboardSection, PomodoroSectionItem>()
        
        snapshot.appendSections(sections)
        
        snapshot.appendItems([
            .today(pomodoroStatArray[PomodoroDashboardSection.today.rawValue]),
            .week(pomodoroStatArray[PomodoroDashboardSection.week.rawValue]),
            .alltime(pomodoroStatArray[PomodoroDashboardSection.alltime.rawValue])])
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureDataSource() {
        dataSource = PomodoroDashboardDataSource(collectionView: pomodoroDashboardCollectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            
            let cell: PomodoroStatCollectionViewCell = self?.pomodoroDashboardCollectionView.dequeueReusableCell(withReuseIdentifier: PomodoroStatCollectionViewCell.identifier, for: indexPath) as! PomodoroStatCollectionViewCell
            
            var pomoStat: PomodoroStat
            
            switch itemIdentifier {
            case .today(let pomodoroStat):
                cell.titleLabel.text = "오늘"
                pomoStat = pomodoroStat
            case .week(let pomodoroStat):
                cell.titleLabel.text = "이번 주"
                pomoStat = pomodoroStat
            case .alltime(let pomodoroStat):
                cell.titleLabel.text = "전체"
                pomoStat = pomodoroStat
            }
            
            if pomoStat.totalPomodoroMinutes >= 60 {
                cell.totalTimeLabel.text = "\(pomoStat.totalPomodoroMinutes / 60)시간 \(pomoStat.totalPomodoroMinutes % 60)분"
            } else {
                cell.totalTimeLabel.text = "\(pomoStat.totalPomodoroMinutes)분"
            }
            
            cell.totalCountLabel.text = "\(pomoStat.totalPomodoroCount)회"
            
            return cell
        })
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1)))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.orthogonalScrollingBehavior = .none
            
            return section
        }
    }
}

// MARK: CollectionView Delegate 관련
extension DetailTodoViewController: UICollectionViewDelegate {
    
}
