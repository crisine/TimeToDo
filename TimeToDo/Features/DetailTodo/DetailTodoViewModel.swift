//
//  DetailTodoViewModel.swift
//  TimeToDo
//
//  Created by Minho on 3/11/24.
//

class DetailTodoViewModel {
  
    private let repository = Repository()
    
    var selectedTodo: Todo?
    
    var inputViewWillAppearTrigger: Observable<Void?> = Observable(nil)
    
    var outputViewWillAppearTrigger: Observable<[PomodoroStat]?> = Observable(nil)
    
    init() {
        inputViewWillAppearTrigger.bind { [weak self] _ in
            self?.fetchPomodoroStat()
            
        }
    }
    
    private func fetchPomodoroStat() {
        var pomodoroStat: [PomodoroStat] = []
        
        
        
        
        guard !pomodoroStat.isEmpty else { return }
        outputViewWillAppearTrigger.value = (pomodoroStat)
    }
}
