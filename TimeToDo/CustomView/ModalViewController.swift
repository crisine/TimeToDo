//
//  ModalViewController.swift
//  TimeToDo
//
//  Created by Minho on 3/14/24.
//

import UIKit

class ModalViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = [.medium()]
        }
    }
}
