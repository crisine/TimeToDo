//
//  OverViewController.swift
//  TimeToDo
//
//  Created by Minho on 3/7/24.
//

final class OverViewController: BaseViewController {
    
    private let mainView = OverView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("OverViewController viewWillAppear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func configureView() {
        
    }
    
}
