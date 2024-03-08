//
//  SettingViewController.swift
//  TimeToDo
//
//  Created by Minho on 3/7/24.
//

final class SettingViewController: BaseViewController {
    
    private let mainView = SettingView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("SettingViewController viewWillAppear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureView() {
        
    }
    
}
