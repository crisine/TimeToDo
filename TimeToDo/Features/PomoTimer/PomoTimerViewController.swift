//
//  PomoTimerViewController.swift
//  TimeToDo
//
//  Created by Minho on 3/7/24.
//

final class PomoTimerViewController: BaseViewController {
    
    private let mainView = PomoTimerView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("PomoTimerViewController viewWillAppear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureView() {
        
    }
    
}
