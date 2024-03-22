//
//  MainTabBarViewController.swift
//  TimeToDo
//
//  Created by Minho on 3/7/24.
//

import UIKit

final class MainTabBarViewController: UITabBarController {
    
    private let overViewVC = UINavigationController(rootViewController: OverviewViewController()) 
    private let pomoTimerVC = UINavigationController(rootViewController: PomoTimerViewController())
    private let settingVC = SettingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
        configureViewControllers()
    }
    
    private func configureTabBar() {
        self.tabBar.tintColor = .tint
    }
    
    private func configureViewControllers() {
        overViewVC.tabBarItem = UITabBarItem(title: "overview_tab_bar_title".localized(), image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house_fill"))
        
        pomoTimerVC.tabBarItem = UITabBarItem(title: "pomotimer_tab_bar_title".localized(), image: UIImage(systemName: "timer"), selectedImage: UIImage(systemName: "timer_fill"))
        
        // 1.0기준 설정 뷰 제외
//        settingVC.tabBarItem = UITabBarItem(title: "setting_tab_bar_title".localized(), image: UIImage(systemName: "gear"), selectedImage: UIImage(systemName: "gear_fill"))
        
        setViewControllers([overViewVC, pomoTimerVC], animated: false)
    }
    
}
