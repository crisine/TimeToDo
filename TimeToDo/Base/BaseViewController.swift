//
//  BaseViewController.swift
//  TimeToDo
//
//  Created by Minho on 3/7/24.
//

import UIKit
import Toast

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    func configureHierarchy() {}
    
    func configureConstraints() {}
    
    func configureView() {
        let imageView = UIImageView(image: UIImage(named: "NavLogo"))
        navigationItem.titleView = imageView
        
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 120, height: 64)
    }
    
    func showAlert(title: String, message: String, okTitle: String,
                   handler: @escaping (() -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okTitle, style: .default) { _ in
            handler()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func showToast(message: String) {
        view.makeToast(message)
    }
}
